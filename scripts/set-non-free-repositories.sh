#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run as root."
  exit 1
fi

SOURCE_FILE="/etc/apt/sources.list"
BACKUP_FILE="/etc/apt/sources.list.bak.$(date +%F_%T)"

# Check if sources.list exists
if [ ! -f "$SOURCE_FILE" ]; then
    echo "Error: $SOURCE_FILE not found."
    exit 1
fi

echo "Creating backup at $BACKUP_FILE..."
cp "$SOURCE_FILE" "$BACKUP_FILE"

echo "Adding components to $SOURCE_FILE..."

# Function to append a component if it's missing from a 'main' line
add_component() {
    local component=$1
    # Use sed to find lines starting with 'deb' or 'deb-src' that contain 'main'
    # but DO NOT contain the requested component.
    # Then append the component to the end of that line.
    sed -i -E "/^deb.*main/ { /$component/! s/$/ $component/ }" "$SOURCE_FILE"
}

# Add standard non-free and contrib
add_component "contrib"
add_component "non-free"

# Check for Debian 12 (Bookworm) or newer/Sid to add 'non-free-firmware'
# Debian 12 split firmware out of 'non-free' into its own component.
if grep -qE "bookworm|trixie|sid" /etc/os-release; then
    echo "Debian 12+ detected. Adding 'non-free-firmware'..."
    add_component "non-free-firmware"
fi

echo "Repositories updated."
echo "Running apt update..."

sudo apt update
sudo apt upgrade

echo "Done!"
