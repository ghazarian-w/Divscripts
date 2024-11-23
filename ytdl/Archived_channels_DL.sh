#!/bin/bash

source $scriptsFolder/SharedFunctions

echo "Ce programme télécharge les vidéos à archiver."

check_internet
if $connected; then

    # Ensure the output file is empty or does not exist
    > "$scriptsFolder/ytdl/util/vidsurlsarch.txt"

    while IFS= read -r channel
    do
        echo "$channel"
        yt-dlp -j --flat-playlist --socket-timeout 10 "$channel" | \
        jq -r '.id' | \
        sed 's_^_https://youtube.com/v/_' >> "$scriptsFolder/ytdl/util/vidsurlsarch.txt"
    done < "$scriptsFolder/ytdl/channel_lists/ArchivedChannels.txt"

    yt-dlp -cw --hls-prefer-native --write-description --write-link --write-thumbnail --ignore-errors --embed-chapters --embed-thumbnail --socket-timeout 10 --download-archive $scriptsFolder/ytdl/archives/Archive2.txt --output '/home/storage/INLET/Youtube/Archivedchannels/%(uploader)s/%(upload_date)s-%(title)s/%(title)s.%(ext)s' -f "bestvideo[height<=480]+bestaudio/best[height<=480]" $(cat $scriptsFolder/ytdl/util/vidsurlsarch.txt)

    yt-dlp -cw --hls-prefer-native --write-description --write-link --write-thumbnail --ignore-errors --embed-chapters --embed-thumbnail --socket-timeout 10 --download-archive $scriptsFolder/ytdl/archives/Archive2.txt --output '/home/storage/INLET/Youtube/Archivedchannels/%(uploader)s/%(upload_date)s-%(title)s/%(title)s.%(ext)s' -f "bestvideo[height<=480]+bestaudio/best[height<=480]" $(cat $scriptsFolder/ytdl/util/vidsurlsarch.txt)
fi

echo Archive Program has ended