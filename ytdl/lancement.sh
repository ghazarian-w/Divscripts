#!/bin/bash


selection=$(zenity --list "FR" "ENG" "Musique" "Archive" "Tout" --column="" --text="Lancer quel ytdl" --title="YT-DL" --width=500 --height=300 --window-icon="~/Ressources/Icons/Systemicons/utilities-terminal_copie_2_.png" & sleep 0.3 && xdotool key Up)

case "$selection" in
	"FR")
		xfce4-terminal -H --maximize -x bash ~/Ressources/Divscripts/ytdl/Followed_channels_FR.sh &
	;;
	"ENG")
		xfce4-terminal -H --maximize -x bash ~/Ressources/Divscripts/ytdl/Followed_channels_ENG.sh &
	;;
	"Musique")
		xfce4-terminal -H --maximize -x bash ~/Ressources/Divscripts/ytdl/Followed_channels_music.sh &
	;;
	"Archive")
		xfce4-terminal -H --maximize -x bash ~/Ressources/Divscripts/ytdl/Archived_channels_DL.sh &
	;;
	"Tout")
		xfce4-terminal -H --maximize -x bash ~/Ressources/Divscripts/ytdl/Followed_channels_FR.sh &
		xfce4-terminal -H --maximize -x bash ~/Ressources/Divscripts/ytdl/Followed_channels_ENG.sh &
		xfce4-terminal -H --maximize -x bash ~/Ressources/Divscripts/ytdl/Followed_channels_music.sh &
		xfce4-terminal -H --maximize -x bash ~/Ressources/Divscripts/ytdl/Archived_channels_DL.sh &
	;;
esac


