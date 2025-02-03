#!/bin/bash

#echo "installing yay"
#sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

echo "make yay handle dev packages"
yay -Y --gendb
yay -Syu --devel
yay -Y --devel --save

sudo npm install -g npm@latest
sudo npm update
sudo npm install -g mpv-remote
mkdir -p "/home/$USER/.config/mpv/scripts" && cp -r "/usr/lib/node_modules/mpv-remote/mpvremote" "/home/$USER/.config/mpv/scripts"
ln -s "/usr/lib/node_modules/mpv-remote/remoteServer.js" "/home/$USER/.config/mpv/scripts/mpvremote/remoteServer.js"
mkdir -p "/home/$USER/.config/mpv/script-opts" && cp -r "/usr/lib/node_modules/mpv-remote/mpvremote.conf" "/home/$USER/.config/mpv/script-opts"
ln -s "/usr/lib/node_modules/mpv-remote/watchlisthandler.js" "/home/$USER/.config/mpv/scripts/mpvremote/watchlisthandler.js"
mpv --idle

yay -S nerd-dictation-git vibe-bin python-openai-whisper tenacity thunar-vcs-plugin qgit prusa-slicer pay-respects 

    # Remove any whitespace
    num=$(echo $num | tr -d ' ')