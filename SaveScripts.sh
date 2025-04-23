#!/bin/bash

#Makes an archive of scripts in case of problem

targets=("/home/$USER/Ressources/Divscripts" "/home/$USER/Nextcloud/Files/Divscripts/")
destination="/home/$USER/standardnotes"
date=$(date +%Y-%m-%d)

archive_filename="scripts-$date.tar.gz"
cd "$destination"
tar -czf "$archive_filename" "${targets[@]}"

echo "Archive created: $destination/$archive_filename"