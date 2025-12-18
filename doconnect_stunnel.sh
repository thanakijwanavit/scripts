SH Tunnel Start Script
# This script starts an SSH tunnel and keeps it running in the foreground

SERVER="127.0.0.1"
USER="proxyuser"
KEY_FILE="proxyuser_key"
PORT="1080"

echo "=========================================="
echo "  Starting SSH Tunnel"
echo "=========================================="
echo ""
echo "Server: $SERVER"
echo "User: $USER"
echo "SOCKS5 Port: $PORT"
echo "Key: $KEY_FILE"
echo ""

# Check if key file exists
if [ ! -f "$KEY_FILE" ]; then
    echo "❌ Error: Key file '$KEY_FILE' not found!"
    echo "   Make sure you're in the correct directory."
    exit 1
fi

# Check if port is already in use
if lsof -i:$PORT >/dev/null 2>&1; then
    echo "⚠️  Warning: Port $PORT is already in use!"
    echo ""
    echo "Current processes using port $PORT:"
    lsof -i:$PORT
    echo ""
    read -p "Kill existing processes? (y/n): " answer
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        echo "Killing processes on port $PORT..."
        lsof -ti:$PORT | xargs kill -9 2>/dev/null
        sleep 1
        echo "Done."
    else
        echo "Exiting. Please free port $PORT first."
        exit 1
    fi
fi

echo ""
echo "Starting tunnel..."
echo "Press Ctrl+C to stop the tunnel"
echo "=========================================="
echo ""

# Start SSH tunnel in foreground (no -f flag)
ssh -i "$KEY_FILE" \
    -o ServerAliveInterval=60 \
    -o ServerAliveCountMax=3 \
    -o ConnectTimeout=10 \
    -D $PORT \
    -C \
    -N \
		-p 2222 \
    "$USER@$SERVER"

echo ""
echo "=========================================="
echo "Tunnel stopped."
echo "=========================================="

