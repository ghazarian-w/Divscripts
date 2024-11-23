#!/bin/bash

source $scriptsFolder/SharedFunctions

check_internet
if $connected; then
    case "$1" in
        -w)
            folder=$(zenity --title "Folder name" --entry --text "Le nom du dossier")
            mkdir -p ~/Downloads/"$folder"
            cd ~/Downloads/"$folder"
            wget $(cat $scriptsFolder/URLs.txt)
        ;;
        -m)
            yt-dlp -cw --hls-prefer-native --write-description --write-link --write-thumbnail --embed-thumbnail --split-chapters --ignore-errors --socket-timeout 10 --add-metadata -x --audio-format mp3 --audio-quality 0 --download-archive $scriptsFolder/ytdl/archives/Archivemus.txt --output '~/Downloads/Musique/%(uploader)s/%(title)s.%(ext)s' $(cat $scriptsFolder/URLs.txt)

            cat $scriptsFolder/URLs.txt >> $scriptsFolder/ytdl/util/vidsurlsArchive.txt
        ;;
        -v)
            yt-dlp -cw --hls-prefer-native --write-description --write-link --write-thumbnail --ignore-errors --embed-chapters --embed-thumbnail --socket-timeout 10 --download-archive $scriptsFolder/ytdl/archives/Archive.txt --output '~/Downloads/Videos/%(uploader)s/%(title)s.%(ext)s' -f "bestvideo[height<=480]+bestaudio/best[height<=480]" $(cat $scriptsFolder/URLs.txt)

            cat $scriptsFolder/URLs.txt >> $scriptsFolder/ytdl/util/vidsurlsArchive.txt
        ;;
    esac
fi
