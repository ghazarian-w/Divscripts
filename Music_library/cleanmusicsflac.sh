#!/bin/bash

#This version also removes flac and other formats to put on a device with minimal space

# Prompt user to select folder
folder=$(zenity --file-selection --directory --title="Select folder to clean")

# Exit if no folder is selected
if [ -z "$folder" ]; then
  exit
fi

# Delete unwanted files
find "$folder" \( -name '*.cue' -o -name '*.htm' -o -name '*.html' -o -name '*.ico' -o -name '*.ini' -o -name '*.kar' -o -name '*.log' -o -name '*.m3u' -o -name '*.mid' -o -name '*.nfo' -o -name '*.pdf' -o -name '*.sqlite' -o -name '*.torrent' -o -name '*.txt' -o -name '*.xml' -o -name '*.url' -o -name '*.zip' -o -name '*.mkv' -o -name '*.m4a' -o -name '*.flac' -o -name '*.wav' -o -name '*.ogg' -o -name '*.mp4' -o -name '*.wma' -o -name '*back*.jpg' -o -name '*Back*.jpg' -o -name '*booklet*.jpg' -o -name '*Booklet*.jpg' -o -name '*Card*.jpg' -o -name '*spine*.jpg' -o -name '*Spine*.jpg' -o -name '*scan*.jpg' -o -name '*Scan*.jpg' \) -delete

# Delete empty directories and unwanted directories
find "$folder" \( -name 'Scan*' -o -name 'scan*' -o -name 'BK' -o -name 'Booklet' \) -type d -print0 | xargs -0 /bin/rm -R
find "$folder" -empty -type d -delete
