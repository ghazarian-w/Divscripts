#!/bin/bash

playlist="/home/william/Musique/Level_0/test.m3u"
folder="/home/william/Musique/Level_0/"

if [ ! -f "$playlist" ]; then
  echo "Error: Source list file '$playlist' not found."
  exit 1
fi

while IFS= read -r file; do
  if [ -f "$file" ]; then
    echo "File exists: $file"
  else
    basename=$(basename "$file")
    similar_files=$(find "$folder" -type f -name "$basename")
    if [[ $similar_files != *"*" ]]; then
        chosen_file="$similar_files"
        #TODO : Check from here
        sed -i "/^$file$/c\\$chosen_file" "$playlist"
    else
        options=($(echo "$similar_files" | tr " " "\n"))
        selected=$(zenity --list "${options[@]}" --title "Choose the correct file" --text "File not found: $file. Select the correct path below:" --column "")
        if [[ $selected ]]; then
            chosen_file="$selected"
            sed -i "/^$file$/c\\$chosen_file" "$playlist"
        fi
    fi
    echo "Handled: $file -> $chosen_file"
  fi
done < "$playlist"
