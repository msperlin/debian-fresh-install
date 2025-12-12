#!/bin/bash

# 1. Install necessary extensions via apt (Requires Sudo)
echo "Installing Dash to Dock and AppIndicator extensions..."
if command -v apt &> /dev/null; then
    sudo apt update
    sudo apt install -y gnome-shell-extension-dash-to-dock gnome-shell-extension-appindicator
else
    echo "Error: 'apt' not found. Are you on Debian/Ubuntu?"
    exit 1
fi

# 2. Apply Dark Theme (GNOME 42+)
echo "Applying Dark Theme..."
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
# Legacy support for older apps
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

# 3. Enable the extensions
# Note: On a fresh install, you might need to logout/login for the shell 
# to see the new extensions before they can be enabled via CLI.
echo "Enabling extensions..."
gnome-extensions enable dash-to-dock@micxgx.gmail.com
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com

# 4. Configure Dash to Dock (Center & Hover)
echo "Configuring Dock settings..."
SCHEMA="org.gnome.shell.extensions.dash-to-dock"

# Dock at bottom
gsettings set $SCHEMA dock-position 'BOTTOM'

# Center the dock (disable extending to edges)
gsettings set $SCHEMA extend-height false

# Enable Auto-hide (Appear on hover)
gsettings set $SCHEMA dock-fixed false
gsettings set $SCHEMA intellihide true
gsettings set $SCHEMA autohide true
gsettings set $SCHEMA require-pressure-to-show false
gsettings set $SCHEMA show-dock-urgent-notify true

echo "Done! If extensions didn't activate, please logout and login, then run this script again."
