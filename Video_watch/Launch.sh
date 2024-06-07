#!/bin/bash

source ~/Ressources/Divscripts/timersVariables

pkill -f mpv ; pkill -f Lecturevids.sh ; pkill -f Trieur ; bash $scriptsFolder/Video_watch/Lecturevids.sh -n &
