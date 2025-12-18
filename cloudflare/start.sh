#!/usr/bin/env bash
set -Eeuo pipefail

HOST="${HOST:-capybaras}"
PORT="${PORT:-1080}"
BIND="${BIND:-127.0.0.1}"

log() { printf "[capyproxy] %s\n" "$*" >&2; }
die() { log "ERROR: $*"; exit 1; }

# Return PIDs listening on PORT (LISTEN only)
pids_on_port() {
  lsof -nP -iTCP:"${PORT}" -sTCP:LISTEN -t 2>/dev/null || true
}

kill_pids() {
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

  # Wait briefly for graceful exit
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
  local code=$?
  if [ -n "${SSH_PID:-}" ] && kill -0 "$SSH_PID" 2>/dev/null; then
    log "Stopping SSH (PID $SSH_PID)"
    kill -TERM "$SSH_PID" 2>/dev/null || true
    wait "$SSH_PID" 2>/dev/null || true
  fi
  exit "$code"
}

trap cleanup INT TERM
trap 'die "Command failed at line $LINENO"' ERR

# Sanity checks
command -v ssh >/dev/null || die "ssh not found"
command -v lsof >/dev/null || die "lsof not found"

# Free the port
kill_pids

log "Starting SOCKS5 proxy on ${BIND}:${PORT} via '${HOST}'"
log "Press Cmd+C to stop"
log "Test: curl --proxy socks5h://${BIND}:${PORT} https://ifconfig.me"

ssh -N -D "${BIND}:${PORT}" \
  -o ExitOnForwardFailure=yes \
  -o ServerAliveInterval=30 \
  -o ServerAliveCountMax=3 \
  -o TCPKeepAlive=yes \
  "${HOST}" &
SSH_PID=$!

sleep 0.2
if ! kill -0 "$SSH_PID" 2>/dev/null; then
  wait "$SSH_PID" || true
  die "SSH failed to start (check Cloudflare Access + ssh capybaras)"
fi

wait "$SSH_PID"
