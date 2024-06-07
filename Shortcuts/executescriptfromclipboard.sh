#!/bin/bash

xfce4-terminal -H --maximize -x bash $(xclip -selection clipboard -o) &
