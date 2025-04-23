#!/bin/bash

#Main script for downloading content off Youtube and similar websites

source $scriptsFolder/SharedFunctions



prep() {
        
    # Ensure the output file is empty or does not exist
    > "$vids_file"

    while IFS= read -r channel
    do
        echo "$channel"
        yt-dlp -j --flat-playlist --socket-timeout 10 "$channel" | \
        jq -r '.id' | \
        sed 's_^_https://youtube.com/v/_' >> "$vids_file"
    done < "$channel_file"

    if [ $? -ne 0 ]; then
        echo "An error occurred while getting the video URLs."
        exit 1
    fi

    comm -23 <(sort "$vids_file") <(sort "$vids_archive") > "$diff_file"

    if [ $? -ne 0 ]; then
        echo "An error occurred while calculating the difference between the video URLs."
        exit 1
    fi

    cat $scriptsFolder/ytdl/diffs/diff_ENG.txt >> $scriptsFolder/ytdl/util/vidsurlsArchive.txt

}

download() {
    yt-dlp -cw --cookies cookies.txt --hls-prefer-native --write-description --write-link --write-thumbnail --ignore-errors --embed-chapters --embed-thumbnail --socket-timeout 10 --download-archive "$archive" --output "$dl_loc" -f "bestvideo[height<=480]+bestaudio/best[height<=480]" $(cat "$diff_file")


    if [ $? -ne 0 ]; then
        echo "An error occurred while downloading the videos."
        exit 1
    fi
}

set -e

echo "$open"

check_internet
if $connected; then
  case "$1" in
    -e) 
        open="Ce programme télécharge les vidéos en anglais."
        base_folder="/home/william/Videos/English/"
        dl_loc="/home/william/Videos/English/%(uploader)s/%(upload_date)s-%(title)s/%(title)s.%(ext)s"
        archive="$scriptsFolder/ytdl/archives/Archive.txt"
        channel_file="$scriptsFolder/ytdl/channel_lists/Channels_ENG.txt"
        vids_file="$scriptsFolder/ytdl/util/vidsurls_ENG.txt"
        vids_archive="$scriptsFolder/ytdl/util/vidsurlsArchive.txt"
        diff_file="$scriptsFolder/ytdl/diffs/diff_ENG.txt"
        close="Le programme pour les vidéos en anglais a terminé."
        ;;
    -f) 
        open="Ce programme télécharge les vidéos en français."
        base_folder="/home/william/Videos/Francais/"
        dl_loc="/home/william/Videos/Francais/%(uploader)s/%(upload_date)s-%(title)s/%(title)s.%(ext)s"
        archive="$scriptsFolder/ytdl/archives/Archive.txt"
        channel_file="$scriptsFolder/ytdl/channel_lists/Channels_FR.txt"
        vids_file="$scriptsFolder/ytdl/util/vidsurls_FR.txt"
        vids_archive="$scriptsFolder/ytdl/util/vidsurlsArchive.txt"
        diff_file="$scriptsFolder/ytdl/diffs/diff_FR.txt"
        close="Le programme pour les vidéos en français a terminé."
        ;;
    -a) 
        open="Ce programme télécharge les vidéos à archiver."
        base_folder="/home/storage/INLET/Youtube/Archivedchannels/"
        dl_loc="/home/storage/INLET/Youtube/Archivedchannels/%(uploader)s/%(upload_date)s-%(title)s/%(title)s.%(ext)s"
        archive="$scriptsFolder/ytdl/archives/Archive2.txt"
        channel_file="$scriptsFolder/ytdl/channel_lists/ArchivedChannels.txt"
        vids_file="$scriptsFolder/ytdl/util/vidsurlsarch.txt"
        vids_archive="$scriptsFolder/ytdl/util/vidsurlsArchive.txt"
        close="Le programme pour les vidéos archives a terminé."
        ;;
    -m) 
        open="Ce programme télécharge les vidéos à convertir en musique."
        base_folder="/home/storage/INLET/Youtube/Music/"
        dl_loc="/home/storage/INLET/Youtube/Music/%(uploader)s/%(upload_date)s-%(title)s/%(title)s.%(ext)s"
        archive="$scriptsFolder/ytdl/archives/Archive.txt"
        channel_file="$scriptsFolder/ytdl/channel_lists/MusicChannels.txt"
        vids_file="$scriptsFolder/ytdl/util/vidsurlsmusic.txt"
        vids_archive="$scriptsFolder/ytdl/util/vidsurlsArchive.txt"
        diff_file="$scriptsFolder/ytdl/diffs/diffmusic.txt"
        close="Le programme pour les vidéos à convertir en musique a terminé."
        ;;
  esac
  case "$2" in
    -p) prep
        ;;
    -d) download
        ;;
  esac

fi

echo "$close"
