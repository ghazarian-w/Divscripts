#!/bin/bash

source ~/Ressources/Divscripts/timersVariables

if [ "$(cat /etc/hostname)" = "gluttony" ]; then
    cat $scriptsFolder/Currentlyplaying.txt
    echo "Time : $timeDisplayNicer | M: $(cat $musicCount) | V: $(cat $videoCount) | KB:$keybind		"
    bash $scriptsFolder/Monitors/secondstodeath.sh
else
    if [ "$(cat /etc/hostname)" = "sloth" ]; then
        echo "Time : $timeDisplayNicer | M: $(cat $musicCount)  | V: $(cat $videoCount) | KB:$keybind"
    else
        echo "$timeDisplayNicer | $keybind"
    fi
fi