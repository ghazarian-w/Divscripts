#!/bin/bash

source $scriptsFolder/SharedFunctions

set -x  # enable debugging
#catch le deuxière argument pour pouvoir s'en servir dans une fonction.
currentFolder="$2"

dir_file="$ressoucesFolder/directory_list.txt"


eval $(cat $scriptsFolder/Video_watch/mplayer-with-status.sh)
source $scriptsFolder/Video_watch/mplayer-with-status.sh

NormalFolder() {
    if [ "$(cat /etc/hostname)" = "gluttony" ]; then
        videoFolder=/home/storage/INLET/Youtube/Videos
        archFolder=~/Archive_Vids
        wlFolder=/home/storage/INLET/Youtube/Later
    else
        videoFolder=~/Videos
        archFolder=~/Archive_Vids
        wlFolder=~/Later
    fi
}

LaterFolder() {
    if [ "$(cat /etc/hostname)" = "gluttony" ]; then
        videoFolder=/home/storage/INLET/Youtube/Later
        archFolder=~/Archive_Vids
        wlFolder=/home/storage/INLET/Youtube/Later
    else
        videoFolder=/home/$USER/Later
        archFolder=~/Archive_Vids
        wlFolder=/home/$USER/Later
    fi
}

SecondFolder() {
    if [ "$(cat /etc/hostname)" = "gluttony" ]; then
        videoFolder=/home/storage/INLET/Youtube/Videos
        archFolder=~/Archive_Vids
        wlFolder=/home/storage/INLET/Youtube/Later
    else
        videoFolder=/home/$USER/Watch
        archFolder=~/Archive_Vids
        wlFolder=~/Later
    fi
}

CurrentDirectory() {
    videoFolder="$currentFolder"
    archFolder="$currentFolder"
    wlFolder="$currentFolder"/Later
}

VideoFinding() {

    video=$(find "$videoFolder" -maxdepth 4 -type f \( -name '*.webm' -o -name '*.mp4' -o -name '*.mkv' -o -name '*.mov' -o -name '*.wmv'  -o -name '*.MOV'  -o -name '*.qt' \) -printf "%T@ %p\n" | sort -n | head -n 1 | awk '{gsub(/^[^ ]+ /,""); print}')
}

VideoFindingCurrent() {

    video=$(find "$videoFolder" -maxdepth 1 -type f \( -name '*.webm' -o -name '*.mp4' -o -name '*.mkv' -o -name '*.mov' -o -name '*.wmv'  -o -name '*.MOV'  -o -name '*.qt' \) -printf "%T@ %p\n" | sort -n | head -n 1 | awk '{gsub(/^[^ ]+ /,""); print}')
}

VideoFindingAlphabet(){
    # Find all directories and sort them alphabetically
    dirs=$(find "$videoFolder" -type d -mindepth 1 -maxdepth 4 | sort)

    if [ -n "$dirs" ]; then
        # Get the first directory
        first_dir=$(echo "$dirs" | head -n 1)

        # Find all video files in the first directory and sort them alphabetically
        results=$(find "$first_dir" -maxdepth 1 -type f \( -name '*.webm' -o -name '*.mp4' -o -name '*.mkv' -o -name '*.mov' -o -name '*.wmv'  -o -name '*.MOV'  -o -name '*.qt' \) | sort | head -n 1)

        if [ -n "$results" ]; then
            # Get the first video in the sorted list
            video="$results"
        else
            echo "No video files found in $first_dir"
        fi
    else
        echo "No directories found"
    fi
}

VideoFindingList(){
    # Read the first directory from the sorted file
    earliest_dir=$(head -n 1 "$dir_file")

    escaped_dir=$(printf '%q' "$earliest_dir")
    earliest_path=$(find "$videoFolder" -type d -name "$escaped_dir")

    video=$(find "$earliest_path" -maxdepth 1 -type f \( -name '*.webm' -o -name '*.mp4' -o -name '*.mkv' -o -name '*.mov' -o -name '*.wmv'  -o -name '*.MOV'  -o -name '*.qt' \) -print -quit)
}

VideoFindingListDelFirstLine(){
    # Remove the first line from the file for next time
    tail -n +2 "$dir_file" > temp_file && mv temp_file "$dir_file"
}

MappingArchival() {
    # Get all directories inside $archFolder into an array variable 'dirList'
    mapfile -t dirList < <(find "$archFolder" -maxdepth 1 -type d | sort)
}

MappingVidFolders() {
    # Clear the file to start fresh
    touch "$dir_file"

    # Go to the directory where the language folders are located
    for lang_dir in "$videoFolder"/*; do
        for maker_dir in "$lang_dir"/*; do
            for video_dir in "$maker_dir"/*; do
                if [[ -d "$video_dir" ]]; then
                    # Write the directory name to the file
                    echo "$(basename "$video_dir")" >> "$dir_file"
                fi
            done
        done
    done

    # Sort the file in-place by the date part of the folder name
    sort -t' ' -k1,1 -n -o "$dir_file" "$dir_file"
}

CleanNonVideoFolders() {
    while read -d $'\0' dir; do
        if [[ ! $(find "$dir" -type f -maxdepth 4 -iregex '.*\.\(mp4\|webm\|mkv\|avi\)$' -print -quit) ]]; then
            echo "$dir does not have video files - deleting"
            gio trash -f "$dir"
        fi
    done < <(find "$videoFolder" -type d -print0)
}

CreateFolderIfNot() {
    mkdir -p "$videoFolder"
    mkdir -p "$archFolder"
    mkdir -p "$wlFolder"
}

Mplaying() {
    # Afficher la vidéo
    echo "Lecture de la vidéo : $video"
    playMediaFile "$video"
    mplayer_pid=$(getPID)
    
    # Periodically check if mplayer is still running then warn it's finished
    while ps -p "$mplayer_pid" > /dev/null; do
        sleep 0.3  # Adjust the sleep duration as needed
    done
    echo "MPlayer has finished playing the video."
}

Mpv_playing() {
    # Afficher la vidéo
    echo "Lecture de la vidéo : $video"
    mpv --no-terminal --fs "$video"
    echo "Finished playing the video."
}

NormalFolder
CreateFolderIfNot

if [ ! -e "$dir_file" ]; then
    NormalFolder
    CleanNonVideoFolders
    MappingVidFolders
fi

case "$1" in
    -n)
    NormalFolder
    VideoFindingList
    ;;
    -N)
    NormalFolder
    VideoFinding
    ;;
    -l)
    LaterFolder
    VideoFinding
    ;;
    -p)
    SecondFolder
    VideoFindingAlphabet
    ;;
    -d)
    CurrentDirectory
    VideoFindingCurrent
    ;;
esac

CreateFolderIfNot
MappingArchival

# Vérifier si une vidéo a été trouvée
if [[ -f "$video" ]]; then
    Mpv_playing

    # Demander à l'utilisateur s'il souhaite supprimer, déplacer la vidéo ou revoir
    choice=$(zenity --list "Supprimer la vidéo" "${dirList[@]}" "Voir plus tard" "Revoir la vidéo" --column "" --text "Que voulez-vous faire avec la vidéo ?\n$video" --title="Trieur de vidéos" $zenityTall)


    if [ ! -z "$choice" ]; then
        case $choice in
        "Supprimer la vidéo")
            gio trash "$video"
            echo "Suppression de la vidéo : $video"
            addToTemp $scoreVid
            echo $[$(cat $videoCount) + 1] > $videoCount
            if [ "$1" == "-n" ]; then
                VideoFindingListDelFirstLine
            fi
            ;;
        "Voir plus tard")
            # Check if the watch later folder exists and create it if not
            if [[ ! -d "$wlFolder" ]]; then
            mkdir -p "$wlFolder"
            fi
            # Move the video to the watch later folder
            mv "$video" "$wlFolder"
            echo "Vidéo déplacée dans le dossier : $wlFolder"
            if [ "$1" == "-n" ]; then
                VideoFindingListDelFirstLine
            fi
            ;;
        "Revoir la vidéo")
            # Restart the script, replaying the video
            echo "This does nothing."
            ;;
        *)
            # Move the video to the destination folder
            mv -- "$video" "${choice}/${video##*/}"
            echo "Vidéo déplacée dans le dossier : ${choice//\//\\/}"  # Escape forward slashes in output string
            addToTemp $scoreVid
            echo $[$(cat $videoCount) + 1] > $videoCount
            if [ "$1" == "-n" ]; then
                VideoFindingListDelFirstLine
            fi
            ;;
        esac
    fi
else
    case "$1" in
        -n)
        echo "Aucune vidéo trouvée dans le dossier listé, on relance avec une autre commande."
        exec bash $0 -N
        exit
        ;;
        -N)
        echo "Aucune vidéo trouvée dans le dossier, on relance avec le dossier à regarder plus tard."
        zenity --warning --text="Aucune vidéo trouvée dans le dossier, on relance avec le dossier à regarder plus tard."
        exec bash $0 -l
        exit
        ;;
        -d|-l|-p)
        echo "Aucune vidéo trouvée dans le dossier."
        zenity --warning --text="Aucune vidéo trouvée dans le dossier."
        ;;
    esac
fi

if [ ! -z "$choice" ]; then
exec bash $0 $1 $2
fi
