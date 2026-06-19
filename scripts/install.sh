cp -r ../fonts/* ~/.local/share/fonts/
fc-cache -fv 
echo "Installing fonts completed"

cp -r ../hypr ~/.config/.
cp -r ../kitty ~/.config/.
cp -r ../waybar ~/.config/.
cp -r ../wlogout ~/.config/.
cp -r ../rofi ~/.config/.

echo "Installing config files completed"
