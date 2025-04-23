#!/bin/bash

#Used to find and remake a playlist with an old playlist whose files have been moved around. Still pretty basic.

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
    echo "$similar_files"
    file_count=$(echo "$similar_files" | wc -l)
    if [[ -z "$similar_files" ]]; then
      timestamp=$(date +"%Y-%m-%d")
      log_file="$scriptsFolder/missing_files_${timestamp}.log"
      echo "File not found: $file" >> "$log_file"
      echo "Logged missing file: $file"
    elif [ $file_count -gt 1 ]; then
      echo "More than one file with the name '$basename' was found in '$folder'."
      mapfile -t options < <(find "$folder" -type f -name "$basename")
      options=("${options[@]/%_/\"}")
      selected=$(zenity --list "${options[@]}" --title "Choose the correct file" --text "File not found: $file. Select the correct path below:" --column "")
           if [[ $selected ]]; then
               sed -i "s|$file|$selected|" "$playlist"
           fi
    else
      echo "Only one file found"
      selected="$similar_files"
      sed -i "s|$file|$selected|" "$playlist"
    fi
    echo "Handled: $file -> $selected"
  fi
done < "$playlist"
