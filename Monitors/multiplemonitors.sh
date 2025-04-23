#!/bin/bash

#This script is used to display a few things at all times in the bottom corner of my screen.

source $scriptsFolder/SharedFunctions

cat $scriptsFolder/Currentlyplaying.txt
echo "Time : $timeDisplayNicer | M: $(cat $musicCount) | V: $(cat $videoCount) | KB:$keybind		"
bash $scriptsFolder/Monitors/secondstodeath.sh