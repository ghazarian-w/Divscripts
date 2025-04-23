#!/bin/bash

#Removes subfolders without music in them.

# Choose folder with Zenity
folder=$(zenity --file-selection --directory --title="Choose a folder to check for music files")
if [[ -z "$folder" ]]; then
    exit 1
fi

# Check for music files in each subdirectory
while read -d $'\0' dir; do
    if [[ $(find "$dir" -type f -iregex '.*\.\(mp3\|flac\|wav\|ogg\|aac\m4a\)$' -print -quit) ]]; then
        echo "$dir has music files"
    else
        echo "$dir does not have music files - deleting"
        rm -rf "$dir"
    fi
done < <(find "$folder" -type d -print0)

# Delete empty directories
find "$folder" -type d -empty -delete
