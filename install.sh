cp -r fonts/* ~/.local/share/fonts/
fc-cache -f
echo "Installing fonts completed"
cp -r hypr ~/.config/.
cp -r kitty ~/.config/.
cp -r waybar ~/.config/.
cp -r wlogout ~/.config/.
echo "Root premetion is needed for installing rofi theme to this folder [/usr/share/rofi/themes]"
sudo cp -r rofi/themes/* /usr/share/rofi/themes/
cp -r rofi/config.rasi ~/.config/rofi/
cp -r rofi/rofi-wallpaper-selector-theme.rasi ~/.config/rofi/

cp -r scripts ~/.local/share/
chmod +x ~/.local/share/scripts/*
echo "Installing config files completed"
