#!/bin/bash

source $scriptsFolder/SharedFunctions

kill_timer ; bash $timerScript &
echo "Timer has been relaunched." >> $timerLog

# kill_timer ; bash ~/Ressources/Divscripts/timerneg.sh &
# echo "Negative timer has been relaunched." >> $timerLog