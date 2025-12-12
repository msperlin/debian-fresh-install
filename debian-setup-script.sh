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

set_non_free_repos() {
    sudo ./scripts/set-non-free-repositories.sh
}

install_apt_software() {
    for apt_software in $(cat "$apt_file")
    do
	    sudo apt install "$apt_software" -y
    done
    sudo apt install -y $APT_PACKAGES
}

install_texlive_full() {
    sudo apt install -y texlive-full
}

install_r() {
    ./scripts/install-R-related.sh
}

install_python(){
    ./scripts/install-python-related.sh
    }


install_zsh(){
    sudo ./scripts/install-zsh.sh
}

install_nvidia_drivers() {
    sudo ./scripts/install-nvidia-drivers.sh
}

install_docker() {
    sudo ./scripts/install_config_docker.sh
}

install_extensions() {
    # Installs extension packages and enables them
    sudo apt install -y $EXTENSION_PACKAGES
    
    # Note: GNOME often needs a session restart (Logout/Login) to see new system-wide extensions.
    echo ">> Extension packages installed. You may need to logout/login to enable them via Extensions app."
}

cleanup() {
    sudo apt autoremove -y
}

# --- Main Execution ---

echo "=== Debian GNOME Setup Script ==="

ask_user "Update and Upgrade System?" update_system
ask_user "Set non-free repositories?" set_non_free_repos
ask_user "Install apt software in $apt_file?" install_apt_software
ask_user "Install texlive-full?" install_texlive_full
ask_user "Install R-related packages?" install_r
ask_user "Install Python related packages?" install_python
ask_user "Install zsh and oh-my-zsh?" install_zsh
ask_user "Install Docker?" install_docker

ask_user "Install Nvidia related drivers?" install_nvidia_drivers

ask_user "Install GNOME Extensions (Dash to Dock, Tweaks, etc.)?" install_extensions
ask_user "4. Run System Cleanup?" cleanup

echo "=== Setup Complete! ==="
echo "Please restart your session to apply GNOME changes."