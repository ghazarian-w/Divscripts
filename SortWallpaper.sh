#!/bin/bash

dest_folder="/home/william/Ressources/PhoneWallpapers/"
config_file="/home/william/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"

# Extract the file path from the XML configuration
fpath=$(sed -n '114s/.*value="\([^"]*\)".*/\1/p' "$config_file")

notify() {
    notify-send -t 1000 "$1"
}

handle_file() {
    if [ -z "$fpath" ]; then
        notify "Path not found in file."
        return 1
    elif [ ! -f "$fpath" ]; then
        notify "File does not exist: $fpath"
        return 1
    fi
    return 0
}

case "$1" in
    -d)
        if handle_file; then
            if rm "$fpath"; then
                notify "DELETED: $fpath"
            else
                notify "Failed to delete: $fpath"
            fi
        fi
        ;;
    -m)
        if handle_file; then
            if [ ! -d "$dest_folder" ]; then
                mkdir -p "$dest_folder"
            fi
            if mv "$fpath" "$dest_folder"; then
                notify "Moved: $fpath to $dest_folder"
            else
                notify "Failed to move: $fpath to $dest_folder"
            fi
        fi
        ;;
    -c)
        if [ -n "$fpath" ]; then
            ls -1A "$(dirname "$fpath")" | wc -l
        else
            notify "Path not found in file."
        fi
        ;;
    *)
        echo "Usage: $0 {-d | -m | -c}"
        ;;
esac
