#!/bin/bash

MANIFEST_FILE="config_manifest.json"
CONFIG_DIR="${HOME}/.config"
SRC_CONFIG_DIR="config"
BACKUP_TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Ensure jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: 'jq' is required to parse $MANIFEST_FILE. Please install 'jq'."
    exit 1
fi

# Function 1: Scans if any file for the specific program exists
check_program_files() {
    local program="$1"
    local items
    items=$(jq -r --arg prog "$program" '.[$prog][]' "$MANIFEST_FILE" 2>/dev/null)

    for item in $items; do
        if [[ -e "${CONFIG_DIR}/${program}/${item}" ]] || \
           [[ -e "${CONFIG_DIR}/hypr/${item}" ]] || \
           [[ -e "${CONFIG_DIR}/${item}" ]]; then
            return 0 # At least one file exists
        fi
    done

    return 1 # No files exist
}

# Function 2: Backs up only the files belonging to the specified program
backup_program_config() {
    local program="$1"
    local backup_dir="${CONFIG_DIR}/${program}_backup_${BACKUP_TIMESTAMP}"
    local items
    items=$(jq -r --arg prog "$program" '.[$prog][]' "$MANIFEST_FILE" 2>/dev/null)

    mkdir -p "$backup_dir"
    echo "  -> Backing up existing files to $backup_dir"

    for item in $items; do
        if [[ -e "${CONFIG_DIR}/${program}/${item}" ]]; then
            mv "${CONFIG_DIR}/${program}/${item}" "$backup_dir/"
        elif [[ -e "${CONFIG_DIR}/hypr/${item}" ]]; then
            mv "${CONFIG_DIR}/hypr/${item}" "$backup_dir/"
        elif [[ -e "${CONFIG_DIR}/${item}" ]]; then
            mv "${CONFIG_DIR}/${item}" "$backup_dir/"
        fi
    done
}

# Function 3: Deploys files belonging to the program
deploy_program_config() {
    local program="$1"
    local items
    items=$(jq -r --arg prog "$program" '.[$prog][]' "$MANIFEST_FILE" 2>/dev/null)

    for item in $items; do
        if [[ -e "${SRC_CONFIG_DIR}/${program}/${item}" ]]; then
            mkdir -p "${CONFIG_DIR}/${program}"
            cp -rf "${SRC_CONFIG_DIR}/${program}/${item}" "${CONFIG_DIR}/${program}/"
        elif [[ -e "${SRC_CONFIG_DIR}/hypr/${item}" ]]; then
            mkdir -p "${CONFIG_DIR}/hypr"
            cp -rf "${SRC_CONFIG_DIR}/hypr/${item}" "${CONFIG_DIR}/hypr/"
        elif [[ -e "${SRC_CONFIG_DIR}/${item}" ]]; then
            cp -rf "${SRC_CONFIG_DIR}/${item}" "${CONFIG_DIR}/"
        fi
    done
    echo "  -> Installed configuration for $program."
}

# Function 4: Prompts user and manages choice per program
handle_program_installation() {
    local program="$1"

    if check_program_files "$program"; then
        echo ""
        echo "There are some config files for $program program."
        read -p "Choose action for $program: [R]eplace / [B]ackup & Replace / [S]kip: " choice

        case "${choice^^}" in
            B|BACKUP)
                backup_program_config "$program"
                deploy_program_config "$program"
                ;;
            R|REPLACE)
                deploy_program_config "$program"
                ;;
            S|SKIP|*)
                echo "  -> Skipping $program installation."
                ;;
        esac
    else
        echo ""
        echo "No existing config found for $program. Installing..."
        deploy_program_config "$program"
    fi
}

# --- Main Script ---

# 1. Fonts Setup
read -p "Do you want to install Nerd Font and Font Awesome 5 for icons (Y/N)? " ANSWER 
case "${ANSWER^^}" in 
    Y|YES)
        mkdir -p ~/.local/share/fonts/
        cp -r fonts/* ~/.local/share/fonts/
        fc-cache -f
        echo "Installing fonts completed."
        ;;
    *)
        echo "Skipping installing fonts." 
        ;;
esac

# 2. Iterate programs from config_manifest.json
echo ""
echo "=== Processing Program Configurations ==="
programs=$(jq -r 'keys[]' "$MANIFEST_FILE")

for program in $programs; do
    handle_program_installation "$program"
done

# 3. Scripts Setup
echo ""
if [[ -d "scripts" ]]; then
    mkdir -p ~/.local/share/scripts
    cp -r scripts/* ~/.local/share/scripts/
    chmod +x ~/.local/share/scripts/*
    echo "Installing Scripts completed."
fi

echo ""
echo "Installation finished!"