#!/bin/bash

source $scriptsFolder/SharedFunctions

cat $scriptsFolder/Currentlyplaying.txt
echo "Time : $timeDisplayNicer | M: $(cat $musicCount) | V: $(cat $videoCount) | KB:$keybind		"
bash $scriptsFolder/Monitors/secondstodeath.sh