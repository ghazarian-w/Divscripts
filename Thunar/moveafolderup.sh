#!/bin/bash

file_select () {
# Dialog to select the files to move

while read -r line || [[ -n "$line" ]]; do
  if [[ "$SELECT_ALL" = "FALSE" ]]; then
      printf "FALSE\n$line\n"
  else
      printf "TRUE\n$line\n"
  fi
done < "$STORE" \
| yad --list --checklist --title "Move Files" --width 500 --height 500 --window-icon=gnome-folder \
  --text "Pick the files to move\nUncheck the folders you don't want to move\n Destination:\n${PWD}" \
  --separator "" --button="$(if [[ "$SELECT_ALL" = "TRUE" ]]; then echo Select None; else echo Select All; fi)!gtk-yes:3" --button="Destination!gnome-folder:2" \
  --button="gtk-ok:0" --button="gtk-cancel:1" \
  --print-column 2 --column "Pick" --column "Files" > $TEMP

ret=$?

if [[ $ret -eq 1 ]]; then
  rm -f $STORE
  rm -f $TEMP
  exit 0
fi

if [[ $ret -eq 2 ]]; then
  BACKUP="$PWD"
  PWD="$(yad --title 'Select Destination' --width=400 --height=500 --file-selection  --directory)"

  if [[ $? -ne 0 ]]; then
  PWD="$BACKUP"
  fi

  file_select
fi

if [[ $ret -eq 3 ]]; then
   if [[ "$SELECT_ALL" = "TRUE" ]]; then
     SELECT_ALL="FALSE"
   else
     SELECT_ALL="TRUE"
   fi
   file_select
fi

}
SELECT_ALL="TRUE"
# Working dir
PWD=$(pwd)

# Temp file to store the file names
STORE=$(mktemp /tmp/XXXXXXX)

# Gets selected dirs and writes to STORE
for dirs in "$@"
do
  # Finds files in the selected dirs
  find "${dirs}" -mindepth 1 -maxdepth 1 -type f -printf "%p\n"
done > $STORE

# If the file list is empty
if [[ ! -s "$STORE" ]]; then
  yad --text "No files found" --button=gtk-ok:0
  rm -f $STORE
  exit 0
fi

# Temp file to store the selected file names to move
TEMP=$(mktemp /tmp/XXXXXXX)

file_select

rm -f $STORE

# Number of selected files
TOTAL="$(wc -l "$TEMP" | cut -d' ' -f1)"

# Set counter
i=0

# Begin
# Reads from the $TEMP file calculates percentage
while read -r line || [[ -n "$line" ]]; do
  ((++i))
  PERCENT=$(($i*100/${TOTAL}))
  echo "#Moving $i/$TOTAL: ${line##*/}"

  sleep 0.2 # Pause between mv, comment out / decrease to speed up

  # If the file exists on the path, renames the destination
  # Else just moves the file
  if [[ -e "${PWD}/${line##*/}" ]] ; then
     a=1
     NAME=${line##*/}
     while [[ -e "${PWD}/${NAME}-$a" ]] ; do
        ((++a))
     done
     NAME="$NAME-$a"
     mv "${line}" "${PWD}/${NAME}"
  else
     mv "${line}" "${PWD}/${line##*/}"
  fi

  echo "$PERCENT"
done < "$TEMP" | yad --progress --title="Moving files" --width=400 --auto-close

rm -f $TEMP