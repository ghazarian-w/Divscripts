#!/bin/bash

source $scriptsFolder/SharedFunctions

###functions

seconds_playing="$(audtool current-song-output-length-seconds)" 
fpath="$(audtool current-song-filename)"
playlist_pos="$(audtool playlist-position)"
playlistn="$(audtool --current-playlist)"
#This is in milliseconds
notifDuration=9000
remMessage="REMOVED"
delMessage="DELETED"

removeFromList(){
    audtool playlist-delete "$playlist_pos"
    echo $[$(cat $musicCount) + 1] > $musicCount
    addToTemp $scoreMus
    audtool --playback-play
    current
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
    for list in {0..4}; do
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
    echo "Sorted as lvl $lvl : $fpath" >> $logAudacious
    echo "$fpath" > "$ressoucesFolder/Last.log"
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
        -4)
            lvl=4
            lvlSet
            ;;
        -F) favorite ;;
        -D) deleting ;;
        -C) current ;;
    esac
fi

if [[ -z "$1" ]]; then
    # Reverse the playlist and pause playback
    savedSongName="$(audtool current-song)"
    audtool --playlist-reverse
    audtool --playback-pause

    fpath="$(audtool current-song-filename)"
    playlist_pos="$(audtool playlist-position)"
    playlistn="$(audtool --current-playlist)"

    # Prompt user with Zenity dialog
    # Different dialog for Lyrics mode


        selection=$(zenity --list "0" "1" "2" "3" "4" "DELETE" "RESTORE LAST" "RÉÉCOUTER" --column="" --text="$(audtool --current-song && echo "" && fortune -s)" --title="Niveau de cette piste" $zenityTall)

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
        "4")
            lvl=4
            lvlSet
            ;;
        "DELETE")
            deleting
            ;;
        "RESTORE LAST")
            audtool select-playing playlist-addurl "$(cat $ressoucesFolder/Last.log)"
            audtool --playback-seek 0 --playback-play
            ;;
        "RÉÉCOUTER")
            # Resume playback from the beginning of the song
            audtool --playback-seek 0 --playback-play
            ;;
        esac
fi
