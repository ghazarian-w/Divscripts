#!/bin/bash

source $scriptsFolder/SharedFunctions

# Define the target date (11th May 2027)
target_date="2027-05-11 00:00:00"

# Get the current timestamp
current_timestamp=$(date +%s)

# Calculate the seconds remaining
seconds_translate=$(( $(date -d "$target_date" +%s) - current_timestamp ))

transform_seconds

# Output the result
echo "${days} d ${hours} h ${minutes} m ${seconds} s"
