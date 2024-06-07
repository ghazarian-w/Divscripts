#!/bin/bash

options=( "Inbox" "Organisation" "Menage" "Achats" "Administration" "Boulot" "Hobbys" "Slam" "Game_design" "Graphisme" "Brainshit" "Watchlist" "Bricolage" "Pyrotechnie" "Jeux_Videos" "Chanson" "Mangas" "Biblio" "Jobbing" "Medical" "Ordinateur" "Onglets" "Scripting" "Programming" "Installations" "Files" "Recherches" "Vente" "Soin")
selected=$(zenity --list "${options[@]}" --title "Choose the correct file" --text "File not found: $file. Select the correct path below:" --column "" $zenityTall)

echo "$selected"