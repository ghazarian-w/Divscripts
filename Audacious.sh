#!/bin/bash

source $scriptsFolder/SharedFunctions

###functions

seconds_playing="$(audtool current-song-output-length-seconds)" 
fpath="$(audtool current-song-filename)"
playlist_pos="$(audtool playlist-position)"
playlistn="$(audtool --current-playlist)"
#This is in milliseconds
notifDuration=9000



if [[ "$1" == "-L" ]]; then
    remMessage="With Lyrics"
    delMessage="Without Lyrics"
else
    remMessage="REMOVED"
    delMessage="DELETED"
fi

removeFromList(){
    audtool playlist-delete "$playlist_pos"
    echo $[$(cat $musicCount) + 1] > $musicCount
    addToTemp $scoreMus
    audtool --playback-play
}

keep(){
    removeFromList
    notify-send -t $notifDuration "$remMessage : $fpath"
    echo "$remMessage : $fpath" >> $logAudacious
}
deleting(){
    removeFromList
    gio trash "$fpath"
    notify-send -t $notifDuration "$delMessage : $fpath" 
    echo "$delMessage : $fpath" >> $logAudacious
}
lvlSet(){
    for list in {0..3}; do
        if [ "$lvl" -ge "$list" ]; then
            if ! grep -Fxq "$fpath" "/home/william/Ressources/Level_$list.m3u"; then
                echo "$fpath" >> "/home/william/Ressources/Level_$list.m3u"
            fi
        else
            if grep -Fxq "$fpath" "/home/william/Ressources/Level_$list.m3u"; then
                sed -i "\|$fpath|d" "/home/william/Ressources/Level_$list.m3u"
            fi
        fi
    done
    notify-send -t $notifDuration "Sorted as lvl $lvl : $fpath" 
    removeFromList
}
current(){
    audtool --current-song > $scriptsFolder/Currentlyplaying.txt
}
favorite(){
    audtool --set-current-playlist 1 
    audtool --playlist-addurl "$fpath"
    audtool  --set-current-playlist "$playlistn"
    removeFromList
    notify-send -t $notifDuration "FAVORITED: $fpath" 
    echo FAVORITED: $fpath >> $logAudacious
}
favoriteConservative(){
    audtool --set-current-playlist 1 
    audtool --playlist-addurl "$fpath"
    audtool  --set-current-playlist "$playlistn"
    notify-send -t $notifDuration "FAVORITED: $fpath" 
    echo FAVORITED: $fpath >> $logAudacious
    audtool --playback-play --playback-seek "$seconds_playing"
    echo $[$(cat $musicCount) + 1] > $musicCount
    addToTemp $scoreMus
}

# Avoid accidentally deleting next song if pressed delete too late and it
# already advanced to the next song.
if [ $seconds_playing -gt 5 ]; then
    case "$1" in
        -0)
            lvl=0
            lvlSet
           ;;
        -1)
            lvl=1
            lvlSet
            ;;
        -2)
            lvl=2
            lvlSet
            ;;
        -3)
            lvl=3
            lvlSet
            ;;
        -F) favorite ;;
        -D) deleting ;;
        -C) current ;;
    esac
fi

if [[ -z "$1" || "$1" == "-L" ]]; then
    # Reverse the playlist and pause playback
    savedSongName="$(audtool current-song)"
    audtool --playlist-reverse
    audtool --playback-pause

    fpath="$(audtool current-song-filename)"
    playlist_pos="$(audtool playlist-position)"
    playlistn="$(audtool --current-playlist)"

    # Prompt user with Zenity dialog
    # Different dialog for Lyrics mode


    if [[ "$1" == "-L" ]]; then
        selection=$(zenity --list "Lyrics" "No Lyrics" "RÉÉCOUTER" --column="" --text="$(audtool --current-song && echo "" && fortune -s)" --title="Paroles ?" --timeout 5 $zenitySmall)
        case "$selection" in
        "Lyrics")
            keep
            ;;
        "No Lyrics")
            deleting
            ;;
        "RÉÉCOUTER")
            # Resume playback from the beginning of the song
            savedSongName="$(audtool current-song)"
            audtool --playback-seek 0 --playback-play
            ;;
        esac
    else
        selection=$(zenity --list "0" "1" "2" "3" "RÉÉCOUTER" --column="" --text="$(audtool --current-song && echo "" && fortune -s)" --title="Niveau de cette piste" $zenityTall)

        case "$selection" in
        "0")
            lvl=0
            lvlSet
            ;;
        "1")
            lvl=1
            lvlSet
            ;;
        "2")
            lvl=2
            lvlSet
            ;;
        "3")
            lvl=3
            lvlSet
            ;;
        "FAVORITE")
            favorite
            ;;
        "RÉÉCOUTER")
            # Resume playback from the beginning of the song
            audtool --playback-seek 0 --playback-play
            ;;
        esac
    fi
fi

if [[ "$1" == "-L" ]]; then
    sleep 1

    # Fonction pour jouer un extrait de X secondes
    play_segment() {
        local position=$1
        audtool playback-seek $position
        sleep 1
    }

    # Obtenir la longueur totale de la piste en secondes
    track_length=$(audtool current-song-length-seconds)

    if [ -z "$track_length" ]; then
        echo "Erreur : Impossible d'obtenir la longueur de la piste."
        exit 1
    fi

    echo "Longueur totale de la piste : $track_length secondes."

    # Nombre de segments souhaité
    segments=6

    # Calculer l'intervalle entre chaque segment
    interval=$(( track_length / segments ))

    echo "Intervalle entre chaque segment : $interval secondes."

    # Jouer X secondes à chaque Xème de la piste
    for i in $(seq 1 $segments); do
        if [ "$savedSongName" == "$(audtool current-song)" ]; then
            seconds_playing="$(audtool current-song-output-length-seconds)"
            position=$(( interval * i ))
            if [ $position -ge $track_length ]; then
                position=$(( track_length - 1 ))
            fi
            echo "Lecture à la position : $position secondes."
            if [ $position -ge $seconds_playing ]; then
                play_segment $position
            fi
        fi
    done
fi
