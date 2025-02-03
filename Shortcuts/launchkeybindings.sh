#!/bin/bash

source $scriptsFolder/SharedFunctions
pkill xbindkeys ; xbindkeys -f $scriptsFolder/Shortcuts/.xbindkeysrc1 &
