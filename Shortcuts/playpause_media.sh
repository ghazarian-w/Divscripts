#!/bin/bash

source $scriptsFolder/SharedFunctions
control_status=$(cat $scriptsFolder/Video_watch/pseudocontrols.txt)


# Check if MPlayer is running
if pgrep -x "mplayer" >/dev/null; then

    # Check if pseudocontrols is empty or contains "play"
    if [ -z "$control_status" ] || [ "$control_status" == "play" ]; then
        echo "pause" > /tmp/mplayer-control
        echo "pause" > $scriptsFolder/Video_watch/pseudocontrols.txt
    else
        echo "play" > /tmp/mplayer-control
        echo "play" > $scriptsFolder/Video_watch/pseudocontrols.txt
    fi
fi

# Check if Audacious is running
if pgrep -x "audacious" >/dev/null; then

        # Check if pseudocontrols is empty or contains "play"
    if [ -z "$control_status" ] || [ "$control_status" == "play" ]; then
         audtool --playback-pause
         echo "pause" > $scriptsFolder/Video_watch/pseudocontrols.txt
    else
         audtool --playback-play
         echo "play" > $scriptsFolder/Video_watch/pseudocontrols.txt
    fi
fi


# Check if MPV is running
if pgrep -x "mpv" >/dev/null; then

        # Check if pseudocontrols is empty or contains "play"
    if [ -z "$control_status" ] || [ "$control_status" == "play" ]; then
        xdotool search --limit 1 --class mpv windowactivate && sleep 1 && xdotool key space
        echo "pause" > $scriptsFolder/Video_watch/pseudocontrols.txt
    else
        xdotool search --limit 1 --class mpv windowactivate && sleep 1 && xdotool key space
        echo "play" > $scriptsFolder/Video_watch/pseudocontrols.txt
    fi
fi
                