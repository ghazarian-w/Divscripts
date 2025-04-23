#!/bin/bash

#Determines what keybind config is used in function of the number at the end of the process
pgrep -a "xbindkeys" | sed 's/.*\(.\)/\1/'