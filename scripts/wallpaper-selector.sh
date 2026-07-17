#!/usr/bin/env bash

WALL_DIR="$HOME/Pictures/Wallpapers"

if [ ! -d "$WALL_DIR" ]; then
    notify-send "Error" "Wallpaper directory not found."
    exit 1
fi

# Turquoise Theme Layout
ROFI_STYLE="
configuration {
    show-icons: true;
}
window {
    width: 65%;
    location: south;
    anchor: south;
    y-offset: -50px;
    border-radius: 12px;
    border: 2px;
    border-color: #14B8A6;
    background-color: #0d1517cc;
}
element {
    orientation: vertical;
    padding: 15px;
    border-radius: 8px;
}
element-icon {
    size: 160px;
    horizontal-align: 0.5;
}
element-text {
    horizontal-align: 0.5;
    color: #E2F5F3;
}
"

# Construct a list where each item passes its text name AND its absolute path as the icon asset
MENU_ITEMS=""
while IFS= read -r file; do
    if [[ "$file" =~ \.(png|jpg|jpeg|webp|gif)$ ]]; then
        # Format: DisplayName\0icon\x1f/Absolute/Path/To/Image
        MENU_ITEMS+="${file}\0icon\x1f${WALL_DIR}/${file}\n"
    fi
done < <(ls "$WALL_DIR")

# Launch Rofi with the formatted list strings
SELECTED=$(echo -e "$MENU_ITEMS" | rofi -dmenu -theme-str "$ROFI_STYLE" -p "Select Wallpaper")

if [ -n "$SELECTED" ]; then
    awww img "$WALL_DIR/$SELECTED" --transition-type "outer" --transition-step 90
    notify-send "Wallpaper Changed" "Applied: $SELECTED"
fi