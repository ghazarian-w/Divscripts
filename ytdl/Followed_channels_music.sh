#!/bin/bash

source ~/Ressources/Divscripts/timersVariables

echo "Ce programme télécharge les vidéos à convertir en musique."

set -e

check_internet
if $connected; then
    yt-dlp -j --flat-playlist --socket-timeout 10 $(cat $scriptsFolder/ytdl/channel_lists/MusicChannels.txt) | jq -r '.id' | sed 's_^_https://youtube.com/v/_' > $scriptsFolder/ytdl/util/vidsurlsmusic.txt

    if [ $? -ne 0 ]; then
        echo "An error occurred while getting the video URLs."
        exit 1
    fi

    comm -23 <(sort $scriptsFolder/ytdl/util/vidsurlsmusic.txt) <(sort $scriptsFolder/ytdl/util/vidsurlsArchive.txt) > $scriptsFolder/ytdl/diffs/diffmusic.txt

    if [ $? -ne 0 ]; then
        echo "An error occurred while calculating the difference between the video URLs."
        exit 1
    fi

    yt-dlp -cw --hls-prefer-native --write-description --write-link --write-thumbnail --embed-thumbnail --split-chapters --ignore-errors --socket-timeout 10 --add-metadata -x --audio-format mp3 --audio-quality 0 --download-archive $scriptsFolder/ytdl/archives/Archivemus.txt --output '/home/storage/INLET/Youtube/Music/%(uploader)s/%(title)s.%(ext)s' $(cat $scriptsFolder/ytdl/diffs/diffmusic.txt)


    if [ $? -ne 0 ]; then
        echo "An error occurred while downloading the videos."
        exit 1
    fi
fi

cat $scriptsFolder/ytdl/diffs/diffmusic.txt >> $scriptsFolder/ytdl/util/vidsurlsArchive.txt && echo Music Program has ended