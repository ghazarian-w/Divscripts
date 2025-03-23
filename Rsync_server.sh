#!/bin/bash

selection=$(zenity --list "Ordinateur -> Serveur" "Serveur -> Ordinateur" --column "" --text "Select" --title="Sync Menu")
case "$selection" in
"Ordinateur -> Serveur")
rsync -aP --delete --update ~/Ressources/Tilde/ lord_vlad@tilde.town:~/
;;
"Serveur -> Ordinateur")
rsync -aP --delete --update lord_vlad@tilde.town:~/ ~/Ressources/Tilde
;;

esac
echo "done"
