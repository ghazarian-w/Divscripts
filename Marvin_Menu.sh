#!/bin/bash

source $scriptsFolder/SharedFunctions

selection=$(zenity --list "Marvin Menu" "Timer Menu" "Sync menu" "URL Menu" --column "" --text "$(fortune -s)" --title="Menu Menu" --height=450)
case "$selection" in
"Marvin Menu")
    selection=$(zenity --list "Ajouter une série de tâches" "Ajouter une liste de tâches" "Ajouter une liste de tâches similaires" "Remettre les compteurs de tri à 0" --column "" --text "Select" --title="Marvin Menu" --height=400)
    case "$selection" in
        "Ajouter une série de tâches")
        bash $scriptsFolder/Marvin/Addtask.sh -p
        ;;
        "Ajouter une liste de tâches")
        bash $scriptsFolder/Marvin/Addtask.sh -l
        ;;
        "Ajouter une liste de tâches similaires")
        bash $scriptsFolder/Marvin/Addtask.sh -L
        ;;
        "Remettre les compteurs de tri à 0")
        echo 0 > $scriptsFolder/Sortedvideocount.txt
        echo 0 > $scriptsFolder/Sortedmusiccount.txt
        ;;
    esac
;;
"Timer Menu")
    selection=$(zenity --list "Fusioner le compteur temporaire" "Modify count (hours)" "Modify count (seconds)" "Comptabiliser les jeux en fin de mois" "Relancer les timers" "Tuer les timers" "Put timer aside" "Afficher les timers" --column "" --text "Select" --title="Timer Menu" --height=400)
    case "$selection" in
        "Fusioner le compteur temporaire")
            bash $scriptsFolder/ModifyCounts.sh -t
            ;;
        "Modify count (hours)")
            bash $scriptsFolder/ModifyCounts.sh -h
            ;;
        "Modify count (seconds)")
            bash $scriptsFolder/ModifyCounts.sh -s
            ;;
        "Comptabiliser les jeux en fin de mois")
            bash $scriptsFolder/ModifyCounts.sh -m
            ;;
        "Relancer les timers")
            restart_timer
            ;;
        "Tuer les timers")
            kill_timer
            ;;
        "Put timer aside")
            bash $scriptsFolder/ModifyCounts.sh -a
            ;;
        "Afficher les timers")
            bash $scriptsFolder/showcount.sh
            ;;
    esac
;;
"Sync menu")
check_internet
if $connected; then
    xfce4-terminal -H --maximize -x bash $scriptsFolder/Rsync_server.sh
fi
;;
"URL Menu")
    selection=$(zenity --list "Editer liste d'urls" "Télécharger en temps que musique" "Télécharger en temps que vidéos" "Télécharger avec wget" --column "" --text "Select" --title="URL list menu")
    case "$selection" in
    "Editer liste d'urls")
    codium $scriptsFolder/URLs.txt
    ;;
    "Télécharger en temps que musique")
    xfce4-terminal -H --maximize -x bash $scriptsFolder/Treat_URLs.sh -m &
    ;;
    "Télécharger en temps que vidéos")
    xfce4-terminal -H --maximize -x $scriptsFolder/Treat_URLs.sh -v &
    ;;
    "Télécharger avec wget")
    xfce4-terminal -H --maximize -x bash $scriptsFolder/Treat_URLs.sh -w &
    ;;
    esac
;;
esac
