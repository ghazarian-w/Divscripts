#!/bin/bash

source ~/Ressources/Divscripts/timersVariables
control_status=$(cat $scriptsFolder/Video_watch/pseudocontrols.txt)

# Check if MPlayer is running
if pgrep -x "mplayer" >/dev/null; then
    echo "stop" > /tmp/mplayer-control
fi
# Check if Audacious is running
if pgrep -x "audacious" >/dev/null; then
   audtool --playback-stop
fi
# Check if MPV is running
if pgrep -x "mpv" >/dev/null; then
    xdotool search --limit 1 --class mpv windowactivate && sleep 1 && xdotool key Shift+q
fi