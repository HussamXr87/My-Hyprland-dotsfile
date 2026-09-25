#!/usr/bash

echo "Do you want to install Nerd Font and Font Awesome for icons [y/n]?"

read UserAnswer

case "${UserAnswer^^}" in 

    Y|YES)
        cp -r fonts/* ~/.local/share/fonts/
        fc-cache -f
        echo "Installing fonts completed"
    ;;
    N|NO)
        echo "OK"



cp -rf config/* ~/.config/
echo "Installing config files completed"

cp -r scripts ~/.local/share/
chmod +x ~/.local/share/scripts/*
echo "Installing Scripts completed"