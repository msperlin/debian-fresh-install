#!/bin/bash

# 1. Ensure curl and gpg are installed
sudo apt-get install -y curl gpg

# 2. Add the Insync GPG key (handling the deprecated apt-key warning)
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://d2t3ff60b2tol4.cloudfront.net/repomd.xml.key | sudo gpg --dearmor -o /etc/apt/keyrings/insync-archive-keyring.gpg --yes

# 3. Add the Insync repository to sources.list.d
# Detects your Debian codename (e.g., bookworm, bullseye) automatically
DISTRO=$(lsb_release -cs)
echo "deb [signed-by=/etc/apt/keyrings/insync-archive-keyring.gpg] http://apt.insynchq.com/debian $DISTRO non-free contrib" | sudo tee /etc/apt/sources.list.d/insync.list

# 4. Update and Install Insync
sudo apt-get update
sudo apt-get install -y insync

# 5. Optional: Install File Manager Integration (Uncomment your desktop environment)
# GNOME (Default Debian):
sudo apt-get install -y insync-nautilus

# KDE (Plasma):
# sudo apt-get install -y insync-dolphin

# 6. Start Insync (this will trigger the login window if not headless)
echo "Installation complete. Starting Insync..."
insync start &