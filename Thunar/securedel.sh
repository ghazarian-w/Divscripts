#!/bin/bash

#Securely deletes provided files.

if dialog=`zenity --question --title="Secure Delete" --no-wrap --text="Are you sure you want to securely delete:\n\n     $1\n\nand any other files and folders selected? File data will be overwritten and cannot be recovered."`
then /usr/bin/shred -fuz "$@"| zenity --progress --pulsate --text="File deletion in progress..." --title="Secure Delete" --auto-close
fi