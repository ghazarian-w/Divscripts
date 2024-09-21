#!/bin/bash

# Specify the folder path where the files are located
folder_path="/home/william/Videos"

# Specify the output file for storing the video file names
video_list_file="video_list.txt"

# Function to recursively list video file names without extensions
list_video_files() {
  local dir="$1"
  local output_file="$2"

  # Process each file in the directory
  for file in "$dir"/*; do
    if [[ -f "$file" ]]; then
      local extension="${file##*.}"

      # Check if the file is a video file
      if [[ $extension == "mp4" || $extension == "webm" || $extension == "mkv" ]]; then
        local filename=$(basename "$file")
        local video_name="${filename%.*}"
        echo "$video_name" >> "$output_file"
      fi
    elif [[ -d "$file" ]]; then
      # Recursively process subdirectories
      list_video_files "$file" "$output_file"
    fi
  done
}

# Function to recursively delete files except those in the video list
delete_estranged_files() {
  local dir="$1"
  local video_list_file="$2"

  # Process each file in the directory
  for file in "$dir"/*; do
    if [[ -f "$file" ]]; then
      local filename=$(basename "$file")
      local file_name="${filename%.*}"

      # Check if the file name is in the video list
      if ! grep -q "^$file_name$" "$video_list_file"; then
        # Delete the file if it doesn't match any video file name
        gio trash -f "$file"
        echo "Deleted estranged file: $file"
      fi
    elif [[ -d "$file" ]]; then
      # Recursively process subdirectories
      delete_estranged_files "$file" "$video_list_file"
    fi
  done
}

# Check if the folder exists
if [[ -d "$folder_path" ]]; then
  echo "Folder $folder_path exists."

  # Create an empty video list file
  > "$video_list_file"

  # List video file names without extensions
  list_video_files "$folder_path" "$video_list_file"

  # Start deleting estranged files in the folder
  delete_estranged_files "$folder_path" "$video_list_file"

  echo "Completed deleting estranged files in $folder_path."
else
  echo "Folder $folder_path does not exist."
fi
