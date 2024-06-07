#!/bin/bash

source ~/Ressources/Divscripts/timersVariables

sleep 0.1
addToTemp 20
pkill xbindkeys
xdotool key --clearmodifiers ctrl+w
bash $scriptsFolder/Shortcuts/launchkeybindings.sh
