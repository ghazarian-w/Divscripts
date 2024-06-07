#! /bin/bash

selection=$(zenity --list "OUI" "NON" --column="" --title="Le walpaper est-il bien ?" --text="blabla")

case "$selection" in
"OUI")variety --move-to-favorites && variety -n;;
"NON")variety -t;;
esac

bash ~/Ressources/Divscripts/Wallpaperlike.sh