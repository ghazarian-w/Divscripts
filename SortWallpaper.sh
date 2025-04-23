#!/bin/bash

#Main script to sort my walpapers in a binary fashion

source $scriptsFolder/SharedFunctions

# Define variables
dest_folder="/home/$USER/Ressources/PhoneWallpapers/"
source="/home/$USER/Ressources/ImagesWallpapers"

# Function to send notifications
notify() {
    notify-send -t 3000 "$1"
}

# Function to extract current wallpaper paths (handles multiple wallpapers)
get_wallpaper_path() {
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorDP-0/workspace0/last-image
}

set_new_wallpaper() {
    local new_wallpaper

    if (( $(find "$source" -type f | wc -l) <= 1 )); then
        notify "Not enough wallpapers in $source to set as new wallpaper."
        return
    fi

    # Choose a random wallpaper from the destination folder. Not the one that is already displayed.
    new_wallpaper=$(find "$source" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n1)
    while [[ -f "$new_wallpaper" && "$new_wallpaper" == "$fpath" ]]; do
        new_wallpaper=$(find "$source" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n1)
        notify "Oups... running again"
    done
    
    if [[ -f "$new_wallpaper" ]]; then
        xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorDP-0/workspace0/last-image -s "$new_wallpaper"
        notify "New wallpaper set to: $new_wallpaper"
        addToTemp 20 
    else
        notify "No wallpapers found in $source to set as new wallpaper."
    fi
}

delete_wallpaper() {
    if [[ -f "$fpath" ]]; then
        set_new_wallpaper
        if rm "$fpath"; then
            notify "DELETED: $fpath"
        else
            notify "Failed to delete: $fpath"
        fi
    else
        notify "File does not exist: $fpath"
    fi
}

move_wallpaper() {
    local destination="$dest_folder"

    if [[ -f "$fpath" ]]; then
        if [[ ! -d "$destination" ]]; then
            mkdir -p "$destination"
        fi

        set_new_wallpaper

        # Extract the filename from the path
        local filename=$(basename "$fpath")
        local dest_file="$destination/$filename"

        if [[ -e "$dest_file" ]]; then
            # Generate a new unique filename to avoid overwriting
            local base="${filename%.*}"
            local ext="${filename##*.}"
            local counter=1
            local new_filename="${base}_${counter}.${ext}"

            # Keep incrementing the counter until a unique filename is found
            while [[ -e "$destination/$new_filename" ]]; do
                ((counter++))
                new_filename="${base}_${counter}.${ext}"
            done

            dest_file="$destination/$new_filename"
        fi

        # Move the file to the destination
        if mv "$fpath" "$dest_file"; then
            notify "Moved: $fpath to $dest_file"
        else
            notify "Failed to move: $fpath to $dest_file"
        fi
    else
        notify "File does not exist: $fpath"
    fi
}

# Function to count wallpapers in the directory
count_wallpapers() {
    if [[ -n "$fpath" ]]; then
        ls -1A "$(dirname "$fpath")" | wc -l
    else
        notify "Path not found in configuration."
    fi
}

# Main script logic
fpath=$(get_wallpaper_path)
        if [[ -z "$fpath" ]]; then
            notify "Current wallpaper path not found."
            exit 1
        fi

case "$1" in
    -d)
        delete_wallpaper "$fpath"
        ;;
    -m)
        move_wallpaper "$fpath"
        ;;
    -c)
        count_wallpapers "$fpath"
        ;;
    *)
        echo "Usage: $0 {-d | -m | -c}"
        exit 1
        ;;
esac