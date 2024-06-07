#!/bin/bash

fpath="$(variety --get-wallpaper)"
variety -f && variety -t
notify-send -t 1000 "FAVORITED: $fpath" 