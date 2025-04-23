#!/bin/bash

### SOURCES/VARIABLES ###

source $scriptsFolder/SharedFunctions
source $scriptsFolder/Video_watch/mplayer-with-status.sh 

# List of applications to check
apps=("switch15684" "mgba" " - youtube" "slot: " "SevTech")

### FUNCTIONS ####

isNegative(){
    [ "$timeCount" -le 0 ] && [ "$1" != "-n" ]
}

incrementCount() {
# Update the count and log the action every 60 seconds
echo $(($timeCount-$freq)) > $countFile
if (($timeCount % 60 == 0)); then
    echo "Count: $timeDisplay removed 60 for $displayApp at $(date)" >> $timerLog
fi
if isNegative "$1"; then
    if [ "$timeReserve" -ge 3600 ]; then
    echo $(($timeCount+3600)) > $countFile
    #the following line avoids closure if and when count is taken off reserve
    timeCount=3600
    echo $(($timeReserve-3600)) > $reserveCount
    else
    # Increment count and exit the loop
    exec bash $scriptsFolder/ModifyCounts.sh -h
    fi
fi
}

closeTrackedApp(){
if isNegative "$1"; then
    xdotool search --limit 1 --name "$app" windowactivate
    zenity --warning --width=300 --title="Limite de temps atteinte" --text="Vous ne pouvez plus utiliser $displayApp" --timeout=10
    case "$app" in
        "switch15684"|" - youtube")
            xdotool search --limit 1 --name "$app" windowkill
        ;;
        "mplayer"|"mpv")
            xdotool search --limit 1 --class "$app" windowactivate && sleep 1 && xdotool key q
        ;;
    esac
fi
}


### MAIN CODE ###

# Sleep for specified frequency
sleep $freq

#xdotool detected apps
for app in "${apps[@]}"; do
    # If the application is found, take appropriate action and exit the loop
    if xdotool search --onlyvisible --limit 1 --name "$app" getwindowpid &>/dev/null; then
        case "$app" in
            "switch15684")
                displayApp=Switch
                ;;
            "mgba")
                displayApp=mGBA
                ;;
            " - youtube")
                displayApp=Youtube
                ;;
            "slot: ")
                displayApp=Pcsx2
                ;;
            "SevTech")
                displayApp=Minecraft
                ;;
        esac
        incrementCount "$1"
        closeTrackedApp "$1"
    fi
done
#mplayer (detects if it plays)
if pgrep mplayer >/dev/null; then
    if ! isPaused; then
        app=mplayer
        displayApp=Mplayer
        incrementCount "$1"
        closeTrackedApp "$1"
    fi
fi
#mpv (detects if it plays)
if xdotool search --onlyvisible --limit 1 --name "- mpv" getwindowpid &>/dev/null; then
    pause_status=$(echo '{ "command": ["get_property", "pause"] }' | socat - /tmp/mpvsocket | jq -r '.data')
    if [[ "$pause_status" == "false" ]]; then
        app=mpv
        displayApp=Mpv
        incrementCount "$1"
        closeTrackedApp "$1"
    fi
fi

exec bash $0 $1
