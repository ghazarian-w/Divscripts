#!/bin/bash

#Various ways to change the timer Count, reserveCount and temporaryCount files.

source $scriptsFolder/SharedFunctions

kill_timer
case $1 in
    "-t")
        newCount=$(($timeReserve + $timeTemp))
        error_handle "Error: Unable to read count or tempCount."
        echo "$newCount" > $reserveCount
        error_handle "Error: Unable to change reserveCount."
        # Log the change in count
        echo "Added temporary counter to reserve : $timeTemp : $newCount at $(date)" >> $timerLog
        # Reset tempCount to 0
        echo "0" > $tempCount
        ;;
    "-a")
        newCount=$(($timeCount + $timeTemp + $timeReserve))
        error_handle "Error: Unable to read count, tempCount or reserveCount."
        echo "$newCount" > $reserveCount
        # Log the change in count
        echo "Put count aside : 0 ($newCount) at $(date)" >> $timerLog
        # Reset counts to 0
        echo "0" > $countFile
        echo "0" > $tempCount
        ;;
    "-h")
        hours=$(zenity --entry --title="Timer" --text="Enter a duration for the increase in hours.")
        error_handle "Error: User cancelled input dialog."
        newCount=$(( timeReserve + (hours * 3600) ))
        error_handle "Error: Unable to read count file or invalid input."
        echo "$newCount" > $reserveCount
        # Log the change in count
        echo "ADDED $((hours * 3600)) : $newCount (Reserve) at $(date)" >> $timerLog
        ;;
    "-s")
        seconds=$(zenity --entry --title="Timer" --text="Enter a duration for the increase in seconds.")
        error_handle "Error: User cancelled input dialog."
        newCount=$(( timeReserve + seconds ))
        error_handle "Error: Unable to read count file or invalid input."
        echo "$newCount" > $reserveCount
        # Log the change in count
        echo "ADDED $seconds : $newCount (Reserve) at $(date)" >> $timerLog
        ;;
    "-10")
        # Display a warning message to the user
        zenity --warning --width=500 --title="Ultimatum : Limite de temps atteinte" --text="10 heures de watch time seront retirées au compteur."
        # Subtract 10 hours from count file
        newCount=$(( timeReserve - 36000 ))
        error_handle "Error: Unable to read count file."
        echo "$newCount" > $reserveCount
        echo "Lost 36000 : $newCount (Reserve) at $(date)" >> $timerLog
        ;;
    "-100")
        # Display a warning message to the user
        zenity --warning --width=500 --title="Ultimatum : Limite de temps atteinte" --text="100 heures de watch time seront retirées au compteur."
        # Subtract 10 hours from count file
        newCount=$(( timeReserve - 360000 ))
        error_handle "Error: Unable to read count file."
        echo "$newCount" > $reserveCount
        echo "Lost 360000 : $newCount (Reserve) at $(date)" >> $timerLog
        ;;
    "-m")
        while true; do
            hours=$(zenity --entry --title="Enter Hours" --text="Enter hours (leave empty or press Cancel to finish):")
            
            # Check if the user left the "hour" field empty or pressed cancel
            if [ -z "$hours" ]; then
                break
            fi
            
            minutes=$(zenity --entry --title="Enter Minutes" --text="Enter minutes:")
            
            # Convert hours and minutes to seconds and add to the total
            hours_seconds=$((hours * 3600))
            minutes_seconds=$((minutes * 60))
            total_seconds=$((total_seconds + hours_seconds + minutes_seconds))
        done
        newCount=$(( timeReserve - total_seconds ))
        error_handle "Error: Unable to read count file."
        echo "$newCount" > $reserveCount
        echo "REMOVED $total_seconds : $newCount (Reserve) at $(date)" >> $timerLog
        ;;
esac

restart_timer
