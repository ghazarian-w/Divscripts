#!/bin/bash

#Launch video sorting or restart whatever is already launched

source ~/Ressources/Divscripts/timersVariables

pkill -f mpv ; pkill -f Lecturevids.sh ; pkill -f Trieur ; bash $scriptsFolder/Video_watch/Lecturevids.sh -n &
