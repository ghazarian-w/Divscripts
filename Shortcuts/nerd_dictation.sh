#!/bin/bash

#Launches and stops Nerd-Dictation with the same keybinding.

if  pgrep -f "nerd-dictation"; then
    nerd-dictation end
else
    if  [[ "$1" == "-en" ]]; then
        nerd-dictation begin --vosk-model-dir="/home/$USER/.config/nerd-dictation/vosk-model-en-us"
    else
        nerd-dictation begin --vosk-model-dir="/home/$USER/.config/nerd-dictation/vosk-model-fr"
    fi
fi