#!/bin/bash

# --- Configuration ---
apt_file="apt-to-install.txt"

# --- Functions ---
ask_user() {
    # Usage: ask_user "Question?" "Command to run"
    echo "-------------------------------------------------"
    read -p "$1 (y/N): " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        echo ">> Executing..."
        eval "$2"
    else
        echo ">> Skipped."
    fi
    echo ""
}

# initial steps
# make all scripts executable
chmod +x scripts/*.sh

update_system() {
    sudo apt update && sudo apt upgrade -y
}

install_apt_software() {
    for apt_software in $(cat "$apt_file")
    do
	    sudo apt install "$apt_software" -y
    done
    sudo apt install -y $APT_PACKAGES
}

cleanup() {
    sudo apt autoremove -y
}

# --- Main Execution ---

echo "=== Debian GNOME Setup Script ==="

ask_user "Update and Upgrade System?" update_system

ask_user "Set non-free repositories?" sudo ./scripts/set-non-free-repositories.sh

ask_user "Install apt software in $apt_file?" install_apt_software

ask_user "Install texlive packages?" ./scripts/install-texlive.sh

ask_user "Install R-related packages?" ./scripts/install-R-related.sh

ask_user "Install Python related packages?"  ./scripts/install-python-related.sh

ask_user "Install vscode?" sudo ./scripts/install-vscode.sh

ask_user "Configure git username and email?" ./scripts/configure-git.sh

ask_user "Install zsh and oh-my-zsh?"  sudo ./scripts/install-zsh.sh

ask_user "Install Docker?" sudo ./scripts/install_config_docker.sh

ask_user "Install Nvidia related drivers?" sudo ./scripts/install-nvidia-drivers.sh

ask_user "Customize Gnome desktop?"  sudo ./scripts/customize-desktop.sh

ask_user "Install Insync (Google Drive client)?" sudo ./scripts/install-insync.sh

ask_user "Run System Cleanup?" cleanup

echo "=== Setup Complete! ==="
echo "Please restart your session to apply GNOME changes."