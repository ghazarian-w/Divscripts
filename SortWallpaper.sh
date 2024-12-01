#!/bin/bash

# Define variables
dest_folder="/home/$USER/Ressources/PhoneWallpapers/"
source="/home/$USER/Ressources/PhoneWallpapers/PSFW"

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

    # Choose a random wallpaper from the destination folder
    new_wallpaper=$(find "$source" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n1)
    while [[ -f "$new_wallpaper" && "$new_wallpaper" == "$fpath" ]]; do
        new_wallpaper=$(find "$source" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n1)
        notify "Oups... running again"
    done
    
    if [[ -f "$new_wallpaper" ]]; then
        xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorDP-0/workspace0/last-image -s "$new_wallpaper"
        notify "New wallpaper set to: $new_wallpaper"
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
        if mv "$fpath" "$destination"; then
            notify "Moved: $fpath to $destination"
        else
            notify "Failed to move: $fpath to $destination"
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