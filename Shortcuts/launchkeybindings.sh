#!/bin/bash

source $scriptsFolder/SharedFunctions

pkill xbindkeys ;
if [ "$(cat /etc/hostname)" = "gluttony" ]; then
    pkill xbindkeys ; xbindkeys -f $scriptsFolder/Shortcuts/.xbindkeysrc1 &
fi
if [ "$(cat /etc/hostname)" = "sloth" ]; then
    pkill xbindkeys ; xbindkeys -f $scriptsFolder/Shortcuts/.xbindkeysrc1 &
fi
if [ "$(cat /etc/hostname)" = "wrath" ]; then
    pkill xbindkeys ; xbindkeys -f $scriptsFolder/Shortcuts/.xbindkeysrc1 &
fi
