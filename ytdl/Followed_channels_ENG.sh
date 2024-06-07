#!/bin/bash

source ~/Ressources/Divscripts/timersVariables

echo "Ce programme télécharge les vidéos en Anglais."

set -e

check_internet
if $connected; then
    yt-dlp -j --flat-playlist --socket-timeout 10 $(cat $scriptsFolder/ytdl/channel_lists/Channels_ENG.txt) | jq -r '.id' | sed 's_^_https://youtube.com/v/_' > $scriptsFolder/ytdl/util/vidsurls_ENG.txt

    if [ $? -ne 0 ]; then
        echo "An error occurred while getting the video URLs."
        exit 1
    fi

    comm -23 <(sort $scriptsFolder/ytdl/util/vidsurls_ENG.txt) <(sort $scriptsFolder/ytdl/util/vidsurlsArchive.txt) > $scriptsFolder/ytdl/diffs/diff_ENG.txt

    if [ $? -ne 0 ]; then
        echo "An error occurred while calculating the difference between the video URLs."
        exit 1
    fi

    yt-dlp -cw --hls-prefer-native --write-description --write-link --write-thumbnail --ignore-errors --embed-chapters --embed-thumbnail --socket-timeout 10 --download-archive $scriptsFolder/ytdl/archives/Archive.txt --output '/home/storage/INLET/Youtube/Videos/English/%(uploader)s/%(upload_date)s-%(title)s/%(title)s.%(ext)s' -f "bestvideo[height<=480]+bestaudio/best[height<=480]" $(cat $scriptsFolder/ytdl/diffs/diff_ENG.txt)


    if [ $? -ne 0 ]; then
        echo "An error occurred while downloading the videos."
        exit 1
    fi

    yt-dlp -cw --hls-prefer-native --write-description --write-link --write-thumbnail --ignore-errors --embed-chapters --embed-thumbnail --socket-timeout 10 --download-archive $scriptsFolder/ytdl/archives/Archive.txt --output '/home/storage/INLET/Youtube/Videos/English/%(uploader)s/%(upload_date)s-%(title)s/%(title)s.%(ext)s' -f "bestvideo[height<=480]+bestaudio/best[height<=480]" $(cat $scriptsFolder/ytdl/diffs/diff_ENG.txt)

    if [ $? -ne 0 ]; then
        echo "An error occurred while downloading the videos (retry)."
        exit 1
    fi
fi

cat $scriptsFolder/ytdl/diffs/diff_ENG.txt >> $scriptsFolder/ytdl/util/vidsurlsArchive.txt && echo Videos Program has ended