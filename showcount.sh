#!/bin/bash

source $scriptsFolder/SharedFunctions

seconds_translate=$(($timeCount + $timeTemp + $timeReserve))
transform_seconds

# Display the contents of count file in a dialog box
zenity --info --text="Counter : $timeCount\nTemporary counter: $timeTemp\nReserve counter: $timeReserve\nTotal ${days} d ${hours} h ${minutes} m ${seconds} s" --timeout=10
