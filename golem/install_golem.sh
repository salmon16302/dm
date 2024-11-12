#!/bin/bash

# Update system packages
sudo apt update -y && sudo apt upgrade -y

# Install Docker
if ! command -v docker &> /dev/null; then
    echo "Docker not found, installing Docker..."
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker $USER
    newgrp docker
fi

# Install Golem
if ! command -v ya-provider &> /dev/null; then
    echo "Installing Golem Network node (Yagna)..."
    sudo apt update -y
    sudo apt install -y gnupg
    mkdir -p ~/.local/share/yagna
    curl -sS https://get.golem.network | bash
    ~/.local/share/yagna/yagna service run & 
    sleep 10
    ~/.local/share/yagna/yagna payment init --driver=zksync --network=mainnet
fi

# Additional setup can go here for authentication or node configuration

echo "Golem setup complete on $(hostname)"
