#!/bin/bash

# Step 2: Change Root User's Shell
sudo sed -i 's/bash/nologin/' /etc/passwd

# Step 3: Disable Root Login via SSH
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# Step 4: Restart SSH Service
sudo systemctl restart ssh

echo "Root user has been disabled."
