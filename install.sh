cp -r fonts/* ~/.local/share/fonts/
fc-cache -f
echo "Installing fonts completed"

cp -rf config/* ~/.config/
echo "Installing config files completed"

cp -r scripts ~/.local/share/
chmod +x ~/.local/share/scripts/*
echo "Installing Scripts completed"