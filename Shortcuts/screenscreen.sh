#!/bin/bash

#Screenshots the whole screen for keybinding
maim --hidecursor -i $(xdotool getactivewindow) ~/Screens/screenshot_$(date +%F-%T).png