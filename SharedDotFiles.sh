#Makes symbolic links of some dotfiles to sync them with nextcloud

Nextcloud_dir=/home/$USER/Nextcloud/Files/Configuration_Files
target_locs=( "/home/$USER/Nextcloud/Files/Divscripts" "$Nextcloud_dir/mgba" "$Nextcloud_dir/marvin-cli.json")
link_locs=( "/home/$USER/Ressources/Divscripts" "/home/$USER/.config/mgba" "/home/$USER/.config/marvin-cli.json")

read -p "Sync xfce4 (y/n): " confirm
            if [[ $confirm == [yY] ]]; then
target_locs+=("$Nextcloud_dir/xfce4")
link_locs+=("/home/$USER/.config/xfce4")
fi

read -p "Sync zsh (y/n): " confirm
            if [[ $confirm == [yY] ]]; then
target_locs+=("$Nextcloud_dir/zsh/.zdirs" "$Nextcloud_dir/zsh/.zprofile" "$Nextcloud_dir/zsh/.zsh_history" "$Nextcloud_dir/zsh/.zshrc")
link_locs+=("/home/$USER/.zdirs" "/home/$USER/.zprofile" "/home/$USER/.zsh_history" "/home/$USER/.zshrc")
fi

read -p "Sync mplayer and mpv (y/n): " confirm
            if [[ $confirm == [yY] ]]; then
target_locs+=("$Nextcloud_dir/.mplayer" "$Nextcloud_dir/mpv")
link_locs+=("/home/$USER/.mplayer" "/home/$USER/.config/mpv")
fi

read -p "Sync audacious (y/n): " confirm
            if [[ $confirm == [yY] ]]; then
target_locs+=("$Nextcloud_dir/audacious")
link_locs+=("/home/$USER/.config/audacious")
fi

read -p "Sync thunar (y/n): " confirm
            if [[ $confirm == [yY] ]]; then
target_locs+=("$Nextcloud_dir/Thunar")
link_locs+=("/home/$USER/.config/Thunar")
fi

read -p "Sync VScodium (y/n): " confirm
            if [[ $confirm == [yY] ]]; then
rsync -auv "$Nextcloud_dir/VSCodium/" "/home/$USER/.config/VSCodium"
fi


if [[ ${#target_locs[@]} -ne ${#link_locs[@]} ]]; then
    echo "Error: The number of target directories and link directories must be the same."
    exit 1
fi

for i in "${!target_locs[@]}"; do
    target="${target_locs[$i]}"
    link="${link_locs[$i]}"

    # Check if the link is already a directory or a file (not a symlink)
    if [ -e "$link" ] && [ ! -L "$link" ]; then
        # Remove or backup the original file/directory if it's not a symlink
        read -p "The $link already exists. Should it be removed? (y/n): " confirm
        if [[ $confirm == [yY] ]]; then
            rm -rf "$link"
            ln -s "$target" "$link"
            echo "Link $link created successfully."
        else
            echo "Aborting link creation for $link."
        fi
    else
        # Create the symlink
        ln -s "$target" "$link"
        echo "Link $link created successfully."
    fi
done
