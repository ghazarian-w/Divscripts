#!/bin/bash

source ~/Ressources/Divscripts/timersVariables

beeeeep() {
    mplayer -really-quiet -nolirc -vo null -ao alsa "$sound_file"
}

# Assuming $keybind contains either 1 or 2
# Launch MPlayer with appropriate playback options
if [ "$keybind" -eq 1 ]; then
    beeeeep
elif [ "$keybind" -eq 2 ]; then
    beeeeep && beeeeep
else
    echo "Invalid value for \$keybind. Use 1 or 2."
fi
