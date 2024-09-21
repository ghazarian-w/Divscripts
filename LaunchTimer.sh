#!/bin/bash

source $scriptsFolder/SharedFunctions

kill_timer ; bash $timerScript -n &
echo "Timer has been relaunched." >> $timerLog