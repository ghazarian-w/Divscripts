#!/bin/bash

fpath="$(variety --get-wallpaper)"
variety -t
notify-send -t 1000 "DELETED: $fpath" 