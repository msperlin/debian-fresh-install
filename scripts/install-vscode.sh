#!/bin/bash

echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections


# Install VS Code
sudo apt update
sudo apt install -y code