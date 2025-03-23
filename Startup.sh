#!/bin/bash

source $scriptsFolder/SharedFunctions

sleep 5 ;
udiskie-mount -a &&
gnome-keyring-daemon -d &
restart_timer
bash $scriptsFolder/Shortcuts/launchkeybindings.sh &
check_internet

if [ "$hostname" = "greed" ]; then
    selection=$(zenity --list "" "Trier" "" "Écrire" "" "Coder" "" "Organisation" "" "Communiquer" "" "Surfer" "" "Musique" --column "" --column "" --text "Choisir session" --title="Démarrage" --checklist --multiple $zenityFS)

    execute_startup() {
        case $1 in
        "Trier")
            thunar /home/william/Tri/ &
        ;;
        "Écrire")
            standard-notes &
        ;; 
        "Coder")
            codium $ressoucesFolder/Ressources.code-workspace &
        ;;
        "Organisation")
            amazingmarvin &
        ;;
        "Communiquer")
            check_internet
            if $connected; then
                signal-desktop-beta &
            fi
        ;;
        "Surfer")
            check_internet
            if $connected; then
                librewolf &
                /usr/bin/keepassxc &
            fi
        ;;
        "Musique")
            audacious &
        ;;
        esac
    }

    # Split the input string on | character and process each action
    ACTION=($(echo "$selection" | awk -F'|' '{for(i=1;i<=NF;i++) print $i}'))
    # Execute commands for each action
    for act in "${ACTION[@]}"; do
        execute_startup $act
    done

    sleep 120 ;
    #xfce4-terminal -H --maximize -x bash $scriptsFolder/ytdl/Followed_channels_FR.sh &
    #xfce4-terminal -H --maximize -x bash $scriptsFolder/ytdl/Followed_channels_ENG.sh &
    #xfce4-terminal -H --maximize -x bash $scriptsFolder/ytdl/Followed_channels_music.sh &
    #xfce4-terminal -H --maximize -x bash $scriptsFolder/ytdl/Archived_channels_DL.sh &
fi

if [ "$hostname" = "gluttony" ]; then
    #/bin/bash -c "sleep 20 && /usr/bin/variety --profile ~/.config/variety/" &
    #audacious &
    tilda &
    transmission-qt &
    librewolf &
    signal-desktop-beta &
    standard-notes &
    amazingmarvin &
    ferdium &
    thunar &
    #xfce4-terminal -H --maximize -x rsync -auUv --delete /run/media/$USER/WiDe/Backupmaindisc &
fi

"/usr/bin/nextcloud" --background &
