# Golem Network Auto-Setup Script

This script automates the installation of the Golem Network environment on multiple PCs. By running this script, you can connect each PC to the Golem Network to rent out computing power and earn income.

## Prerequisites

1. **SSH Access**: Ensure SSH is enabled on each PC.
2. **Dependencies**: The script will install Docker if it’s not already installed.
3. **User Permissions**: Run the script with a user that has `sudo` privileges.

## Script Details

The `install_golem.sh` script will:
- Update system packages.
- Install Docker if it is not already installed.
- Install the Golem Network node (`yagna`) and initialize payment.

## Instructions

### Step 1: Download the Script

Save the script as `install_golem.sh`:

```bash
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
```
### Step 2: Automate Deployment

To deploy this script across multiple PCs, use `pssh` (parallel SSH) or `Ansible`.
<br>
Example with pssh

1. Install `pssh` if not already installed:
   ```bash
   sudo apt install pssh
   ```
2. Create a file called `hostfile.txt` with the IP addresses or hostnames of each PC.
3. Run the script across all PCs:
   ```bash
   pssh -h hostfile.txt -l username -A -i 'bash install_golem.sh'
   ```
   example of hostfile.txt
   ```plaintext
   user1@192.168.1.101:22
   user2@192.168.1.102:2222
   192.168.1.103  # Default user and port (optional)
   user3@192.168.1.104:2200
   ```
### Step 3: Verification


- After running the script, verify that each PC is connected to the Golem Network by checking the `yagna` service status.

   ```bash
  ps aux | grep yagna
   ```
### Troubleshooting

- `Docker Permissions`: If Docker requires root permissions, ensure that the user running the script is part of the Docker group.
- `SSH Access`: Ensure that each PC has SSH enabled and that you have the correct username and password or key for each system.
