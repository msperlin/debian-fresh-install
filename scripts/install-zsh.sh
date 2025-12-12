#!/bin/bash

theme_name="gnzh"
plugin_list=("command-not-found")

# Exit immediately if a command exits with a non-zero status.
set -e

sudo apt install curl

# Helper function for logging
log() {
    echo "INFO: $1"
}

warn() {
    echo "WARN: $1"
}

error() {
    echo "ERROR: $1" >&2
    exit 1
}

# 1. Check for dependencies (zsh, git, curl/wget)
log "Checking for dependencies..."

# Check for zsh
if ! command -v zsh &>/dev/null; then
    log "zsh not found. Attempting to install..."
    if command -v apt-get &>/dev/null; then
        sudo apt-get update && sudo apt-get install -y zsh
    elif command -v yum &>/dev/null; then
        sudo yum install -y zsh
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y zsh
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm zsh
    elif command -v brew &>/dev/null; then
        brew install zsh
    else
        error "Could not find a package manager to install zsh. Please install it manually."
    fi
else
    log "zsh is already installed."
fi

# Check for git
if ! command -v git &>/dev/null; then
    log "git not found. Attempting to install..."
    if command -v apt-get &>/dev/null; then
        sudo apt-get update && sudo apt-get install -y git
    elif command -v yum &>/dev/null; then
        sudo yum install -y git
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y git
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm git
    elif command -v brew &>/dev/null; then
        brew install git
    else
        error "Could not find a package manager to install git. Please install it manually."
    fi
else
    log "git is already installed."
fi

# Check for curl or wget
if ! command -v curl &>/dev/null && ! command -v wget &>/dev/null; then
    log "curl or wget not found. Attempting to install curl..."
    if command -v apt-get &>/dev/null; then
        sudo apt-get update && sudo apt-get install -y curl
    elif command -v yum &>/dev/null; then
        sudo yum install -y curl
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y curl
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm curl
    elif command -v brew &>/dev/null; then
        brew install curl
    else
        error "Could not find a package manager to install curl. Please install it manually."
    fi
else
    log "curl or wget is already installed."
fi

# 2. Install Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    log "Oh My Zsh is already installed in $HOME/.oh-my-zsh"
else
    log "Installing Oh My Zsh..."
    # The installer may try to run zsh, so we temporarily unset ZSH
    export ZSH=""
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log "Oh My Zsh installed successfully."
fi

# 3. Prompt for theme
ZSHRC_FILE="$HOME/.zshrc"
if [ ! -f "$ZSHRC_FILE" ]; then
    warn "Could not find $ZSHRC_FILE. A new one might have been created as .zshrc.pre-oh-my-zsh."
    # Oh My Zsh install script *should* create this. If not, something is wrong.
    error "Cannot find .zshrc to configure."
fi

# Read theme name
#read -p "Enter the name of the theme you want to use (e.g., 'agnoster', 'robbyrussell'): " theme_name

if [ -n "$theme_name" ]; then
    log "Setting ZSH_THEME to '$theme_name' in $ZSHRC_FILE..."
    # Use sed to find the ZSH_THEME line and replace its value
    # This works on both Linux and macOS
    sed -i.bak "s/^ZSH_THEME=.*$/ZSH_THEME=\"$theme_name\"/" "$ZSHRC_FILE"
    log "Theme updated."
else
    log "No theme name entered. Skipping theme update."
fi

# 4. Prompt for extensions (plugins)
#read -p "Enter a space-separated list of plugins you want to add (e.g., 'git docker kubectl'): " plugin_list

if [ -n "$plugin_list" ]; then
    # Add the default 'git' plugin if it's not already in the user's list,
    # as it's the default and users often forget it.
    if [[ ! " $plugin_list " =~ " git " ]]; then
        plugin_list="git $plugin_list"
    fi
    
    plugin_string="plugins=($plugin_list)"
    log "Setting plugins to '($plugin_list)' in $ZSHRC_FILE..."
    
    # Use sed to find the plugins= line and replace it
    sed -i.bak "s/^plugins=.*$/$plugin_string/" "$ZSHRC_FILE"
    log "Plugins updated."
else
    log "No plugins entered. Skipping plugin update."
fi

# 5. Set zsh as default shell (if not already)
if [ "$SHELL" != "/bin/zsh" ] && [ "$SHELL" != "/usr/bin/zsh" ]; then
    log "Attempting to set zsh as your default shell. This may require your password."
    if chsh -s "$(command -v zsh)"; then
        log "Default shell changed to zsh."
    else
        warn "Could not automatically change the default shell. Please run 'chsh -s $(command -v zsh)' manually."
    fi
else
    log "zsh is already your default shell."
fi

# install zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

log "All done!"
log "Please log out and log back in, or start a new 'zsh' session for changes to take effect."
