#!/bin/bash

#Uses the number of the keybind config to beep the same number of times

source $scriptsFolder/SharedFunctions

beeeeep() {
    # Launch MPlayer with appropriate playback options
    mplayer -really-quiet -nolirc -vo null -ao alsa "$sound_file"
}

if [[ "$keybind" =~ ^-?[0-9]+$ ]]; then
    for (( i=0; i<"$keybind"; i++ )); do
        beeeeep
    done

else
  echo "'$keybind' is NOT an integer."
fi
