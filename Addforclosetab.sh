#!/bin/bash

#Bodge to make ctrl+w both close tabs and execute a function once per press

source $scriptsFolder/SharedFunctions

sleep 0.1
addToTemp 20
pkill xbindkeys
xdotool key --clearmodifiers ctrl+w
bash $scriptsFolder/Shortcuts/launchkeybindings.sh
