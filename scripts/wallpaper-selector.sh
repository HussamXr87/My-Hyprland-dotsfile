#!/usr/bin/env bash

WALL_DIR="$HOME/Pictures/wallpapers"
ROFI_THEME="$HOME/.config/rofi/rofi-wallpaper-selector-theme.rasi"

if [ ! -d "$WALL_DIR" ]; then
    notify-send "Error" "Wallpaper directory not found."
    exit 1
fi

# Construct a list where each item passes its text name AND its absolute path as the icon asset
MENU_ITEMS=""
while IFS= read -r filepath; do
    file=$(basename filepath)
    if [[ "$file" =~ \.(png|jpg|jpeg|webp|gif)$ ]]; then
        # Format: DisplayName\0icon\x1f/Absolute/Path/To/Image
        MENU_ITEMS+="${file}\0icon\x1f${WALL_DIR}/${file}\n"
    fi
done < <( find "$WALL_DIR" -type f)

# Launch Rofi with the formatted list strings
SELECTED=$(echo -e "$MENU_ITEMS" | rofi -show-icons -theme "$ROFI_THEME" -dmenu -p "Select Wallpaper")

if [ -n "$SELECTED" ]; then
    filepath=$(find "$WALL_DIR" -type f -name "$SELECTED" | head -n 1)
    awww img "$filepath" --transition-type "outer" --transition-step 90
    notify-send "Wallpaper Changed" "Applied: $SELECTED"
fi