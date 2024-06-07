#!/bin/bash

# Select folder using Zenity
folder=$(zenity --file-selection --directory --title="Select a folder")

# Check if user pressed cancel
if [[ $? -eq 1 ]]; then
    exit
fi

# Loop through each file in folder
for file in "$folder"/*; do
    # Check if file is a regular file
    if [[ -f "$file" ]]; then
        # Create a folder with the same name as the file (excluding extension)
        mkdir "${file%.*}"
        # Move file into the folder
        mv "$file" "${file%.*}/"
    fi
done

# Show message box when finished
zenity --info --text="Done"
