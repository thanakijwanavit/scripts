#!/usr/bin/env bash
set -u  # don't use -e; we handle errors intentionally in a loop
set -o pipefail

HOST="${HOST:-capybaras}"
PORT="${PORT:-1080}"
BIND="${BIND:-127.0.0.1}"

# Reconnect tuning
MIN_UPTIME="${MIN_UPTIME:-3}"      # seconds: if ssh dies before this, count as "instant fail"
BACKOFF_START="${BACKOFF_START:-1}" # seconds
BACKOFF_MAX="${BACKOFF_MAX:-30}"    # seconds

log() { printf "[capyproxy] %s\n" "$*" >&2; }
die() { log "ERROR: $*"; exit 1; }

pids_on_port() {
  lsof -nP -iTCP:"${PORT}" -sTCP:LISTEN -t 2>/dev/null || true
}

free_port_1080() {
  local pids
  pids="$(pids_on_port)"
  [ -z "$pids" ] && return 0

  log "Port ${PORT} busy, killing listeners:"
  for pid in $pids; do
    local cmd
    cmd="$(ps -p "$pid" -o comm= 2>/dev/null || echo unknown)"
    log " - kill PID $pid ($cmd)"
    kill -TERM "$pid" 2>/dev/null || true
  done

  # Wait a bit
  for _ in 1 2 3 4 5 6 7 8 9 10; do
    sleep 0.1
    [ -z "$(pids_on_port)" ] && return 0
  done

  log "Force killing remaining listeners on ${PORT}"
  for pid in $(pids_on_port); do
    kill -KILL "$pid" 2>/dev/null || true
  done

  [ -z "$(pids_on_port)" ] || die "Could not free port ${PORT}"
}

cleanup() {
  log "Stopping (Ctrl/Cmd+C)"
  # If an ssh child exists, terminate it
  if [ -n "${SSH_PID:-}" ] && kill -0 "${SSH_PID}" 2>/dev/null; then
    kill -TERM "${SSH_PID}" 2>/dev/null || true
    wait "${SSH_PID}" 2>/dev/null || true
  fi
  exit 0
}

trap cleanup INT TERM

command -v ssh >/dev/null || die "ssh not found"
command -v lsof >/dev/null || die "lsof not found"

free_port_1080

log "SOCKS5 will listen on ${BIND}:${PORT}"
log "Egress via SSH host '${HOST}' (over Cloudflare via your ~/.ssh/config ProxyCommand)"
log "Test: curl --proxy socks5h://${BIND}:${PORT} https://ifconfig.me"
log "Press Cmd+C to stop."

backoff="$BACKOFF_START"
attempt=0

while :; do
  attempt=$((attempt + 1))
  start_ts="$(date +%s)"

  log "Connecting (attempt ${attempt})..."
  ssh -N -D "${BIND}:${PORT}" \
    -o ExitOnForwardFailure=yes \
    -o ServerAliveInterval=30 \
    -o ServerAliveCountMax=3 \
    -o TCPKeepAlive=yes \
    -o ConnectTimeout=10 \
    "${HOST}" &
  SSH_PID=$!

  # If it dies immediately, catch it before waiting forever
  sleep 0.3
  if ! kill -0 "${SSH_PID}" 2>/dev/null; then
    wait "${SSH_PID}" 2>/dev/null
    rc=$?
    log "SSH exited immediately (rc=${rc}). Likely Cloudflare Access/session/network issue."
  else
    # Wait until it drops
    wait "${SSH_PID}"
    rc=$?
    log "SSH disconnected (rc=${rc})."
  fi

  end_ts="$(date +%s)"
  uptime=$((end_ts - start_ts))

  # Backoff logic:
  # - if it was up "long enough", reset backoff
  # - if it dies instantly, increase backoff up to max
  if [ "$uptime" -ge "$MIN_UPTIME" ]; then
    backoff="$BACKOFF_START"
  else
    # increase backoff (1,2,4,8...) capped
    backoff=$((backoff * 2))
    [ "$backoff" -gt "$BACKOFF_MAX" ] && backoff="$BACKOFF_MAX"
  fi

  log "Reconnecting in ${backoff}s (uptime=${uptime}s)"
  sleep "$backoff"
done
