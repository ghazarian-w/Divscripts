#!/bin/bash

source $scriptsFolder/SharedFunctions

sleep 5 ;
udiskie-mount -a &&
gnome-keyring-daemon -d &
restart_timer
bash $scriptsFolder/Shortcuts/launchkeybindings.sh &
check_internet
/usr/bin/keepassxc &
"/usr/bin/nextcloud" --background &


if [ "$hostname" = "gluttony" ]; then
    /bin/bash -c "sleep 20 && /usr/bin/variety --profile ~/.config/variety/" &
    #audacious &
    firefox &
    signal-desktop-beta &
    standard-notes &
    amazingmarvin &
    ferdium &
    thunar &
    tilda &
    #xfce4-terminal -H --maximize -x rsync -auUv --delete /run/media/$USER/WiDe/Backupmaindisc &
    #transmission-qt &
fi

if [ "$hostname" = "sloth" ]; then
    selection=$(zenity --list "Coder" "Surfer sur le web" "Organisation" "Communiquer" "Trier des fonds d'écran" --column "" --text "Choisir session" --title="Démarrage" $zenityFS)
    case "$selection" in
    "Coder")
        amazingmarvin &
        codium &
    ;;
    "Surfer sur le web")
        check_internet
        if $connected; then
            firefox &
            amazingmarvin &
            standard-notes &
        fi
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
    "Trier des fonds d'écran")
        geeqie /home/$USER/Tri/WP &
    ;;
    esac
    sleep 120 ;
    #xfce4-terminal -H --maximize -x bash $scriptsFolder/ytdl/Followed_channels_FR.sh &
    #xfce4-terminal -H --maximize -x bash $scriptsFolder/ytdl/Followed_channels_ENG.sh &
    #xfce4-terminal -H --maximize -x bash $scriptsFolder/ytdl/Followed_channels_music.sh &
    #xfce4-terminal -H --maximize -x bash $scriptsFolder/ytdl/Archived_channels_DL.sh &
fi

if [ "$hostname" = "wrath" ]; then
    thunar /home/$USER/Desktop/Watch &
    sleep 120 ;
    transmission-qt &
fi