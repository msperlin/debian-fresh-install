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

install_insync() {
    sudo ./scripts/install-insync.sh
}

customize_desktop() {
    # Installs extension packages and enables them
    sudo ./scripts/customize-desktop.sh
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

ask_user "Customize Gnome desktop?" customize_desktop

ask_user "Install Insync (Google Drive client)?" install_insync

ask_user "Run System Cleanup?" cleanup

echo "=== Setup Complete! ==="
echo "Please restart your session to apply GNOME changes."