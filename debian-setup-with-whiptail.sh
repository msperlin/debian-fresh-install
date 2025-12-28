# --- Functions ---
# initial steps
# make all scripts executable
chmod +x scripts/*.sh
# --- Main Execution ---
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


# Check for whiptail
if ! command -v whiptail &> /dev/null; then
    echo "whiptail not found. Installing..."
    sudo apt install whiptail -y
fi

echo "=== Debian GNOME Setup Script ==="

CHOICES=$(whiptail --title "Debian GNOME Setup" --checklist \
"Select components to install (Space to select, Enter to confirm):" 22 78 14 \
"UPDATE" "Update and Upgrade System" ON \
"NONFREE" "Set non-free repositories" OFF \
"APT" "Install apt software in $apt_file" OFF \
"TEXLIVE" "Install texlive packages" OFF \
"R_PKG" "Install R-related packages" OFF \
"PYTHON" "Install Python related packages" OFF \
"VSCODE" "Install vscode" OFF \
"GIT" "Configure git username and email" OFF \
"ZSH" "Install zsh and oh-my-zsh" OFF \
"DOCKER" "Install Docker" OFF \
"NVIDIA" "Install Nvidia related drivers" OFF \
"GNOME" "Customize Gnome desktop" OFF \
"INSYNC" "Install Insync (Google Drive client)" OFF \
"CLEANUP" "Run System Cleanup" OFF \
3>&1 1>&2 2>&3)

if [ $? -eq 0 ]; then
    for CHOICE in $CHOICES; do
        case "$CHOICE" in
            '"UPDATE"') update_system ;;
            '"NONFREE"') sudo ./scripts/set-non-free-repositories.sh ;;
            '"APT"') install_apt_software ;;
            '"TEXLIVE"') ./scripts/install-texlive.sh ;;
            '"R_PKG"') ./scripts/install-R-related.sh ;;
            '"PYTHON"') ./scripts/install-python-related.sh ;;
            '"VSCODE"') sudo ./scripts/install-vscode.sh ;;
            '"GIT"') ./scripts/configure-git.sh ;;
            '"ZSH"') sudo ./scripts/install-zsh.sh ;;
            '"DOCKER"') sudo ./scripts/install_config_docker.sh ;;
            '"NVIDIA"') sudo ./scripts/install-nvidia-drivers.sh ;;
            '"GNOME"') sudo ./scripts/customize-desktop.sh ;;
            '"INSYNC"') sudo ./scripts/install-insync.sh ;;
            '"CLEANUP"') cleanup ;;
        esac
    done
    echo "=== Setup Complete! ==="
    echo "Please restart your session to apply GNOME changes."
else
    echo "Setup cancelled."
fi
