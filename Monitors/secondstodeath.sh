#!/bin/bash

source $scriptsFolder/SharedFunctions

#Calculate time before death
target_date="2027-05-11 00:00:00"
current_timestamp=$(date +%s)
seconds_translate=$(( $(date -d "$target_date" +%s) - current_timestamp ))

transform_seconds

# Output the result
echo "${days} d ${hours} h ${minutes} m ${seconds} s"
