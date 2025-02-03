#!/bin/bash

source $scriptsFolder/SharedFunctions

listboard="/tmp/listboard.txt"

case "$1" in
"-c")
    echo $(xsel) >> $listboard 
;;
"-x")
    echo $(xsel) >> $listboard
    xdotool key Delete
;;
"-pl")
    sed -n '1p' $listboard | xclip -selection clipboard
    sed -i '1d' $listboard
;;
"-pa")
    cat $listboard | xclip -selection clipboard
    gio trash $listboard
    touch $listboard
;;
esac














