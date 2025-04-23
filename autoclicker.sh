#!/bin/bash

#Meant to be used with a keybind. Starts and stops a fast autoclicker.

LOCK_FILE="/tmp/autoclicker.lock"

start_autoclicker() {
    echo "Starting autoclicker..."
    xdotool click --repeat 1000000 --delay 0 1 &
    echo $! > "$LOCK_FILE"
    echo "Autoclicker started."
}

stop_autoclicker() {
    echo "Stopping autoclicker..."
    PID=$(cat "$LOCK_FILE")
    kill "$PID" 2>/dev/null
    rm "$LOCK_FILE"
    echo "Autoclicker stopped."
}

if [ -f "$LOCK_FILE" ]; then
    stop_autoclicker
else
    start_autoclicker
fi
