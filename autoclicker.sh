#!/bin/bash

LOCK_FILE="/tmp/autoclicker.lock"

start_autoclicker() {
    echo "Starting autoclicker..."
    xdotool click --repeat 10000 --delay 0 1 &
    echo $! > "$LOCK_FILE"
    echo "Autoclicker started."
}

stop_autoclicker() {
    echo "Stopping autoclicker..."
    if [ -f "$LOCK_FILE" ]; then
        PID=$(cat "$LOCK_FILE")
        kill "$PID" 2>/dev/null
        rm "$LOCK_FILE"
        echo "Autoclicker stopped."
    else
        echo "Autoclicker was not running."
    fi
}

if [ -f "$LOCK_FILE" ]; then
    stop_autoclicker
else
    start_autoclicker
fi
