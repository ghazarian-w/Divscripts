#!/bin/bash

#Another way to quickly test multiple itterations of a script. Just put it on a keybind

xfce4-terminal -H --maximize -x bash $(xclip -selection clipboard -o) &
