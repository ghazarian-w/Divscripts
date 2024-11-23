#!/bin/bash

source $scriptsFolder/SharedFunctions

#kill_timer ; bash $timerScript -n &
kill_timer ; bash $timerScript &
echo "Timer has been relaunched." >> $timerLog