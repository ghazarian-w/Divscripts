#!/bin/bash

#Launch keybinding at startup or restart the whatever is already launched

source $scriptsFolder/SharedFunctions
pkill xbindkeys ; xbindkeys -f $scriptsFolder/Shortcuts/.xbindkeysrc1 &
