#!/bin/bash

#Makes Marvin show up whether it's running already or not

if pgrep -x "amazingmarvin" >/dev/null; then
    # Marvin is running, bring it to the foreground
    xdotool search --name "Amazing Marvin" windowactivate
else
    # Marvin is not running, open it
    amazingmarvin &
fi
