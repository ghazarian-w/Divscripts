#!/bin/bash

#Rename files based on the Exif date if it exists

for PIC in "$@" ; do
extn=${PIC##*.}
exval=$(exiftime -tg "$PIC" |grep Generated|awk '{print $3"_"$4}')
mv "$PIC" "${exval:?NO EXIF DATA FOUND IN "$PIC"}".$extn
done