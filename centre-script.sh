#!/bin/bash

# Check if running as root
if [ "$(id -u)" != "0" ]; then
  echo "Error: This script must be run with root privileges."
  echo "Please run with sudo or as the root user."
  exit 1
fi

# Selection Board
choices=$(whiptail --checklist "Select options" 20 40 11 \
  "1" "Update and Upgrade" on \
  "2" "Enable Automatic Updates " on \
  "3" "Install curl and sudo" on \
  "4" "Create a new user" off \
  "5" "Create a new sudo user" off \
  "6" "Install docker" off \
  "7" "Set dotfiles" on \
  "8" "Set IP address" off \
  "9" "Install Nala" off \
  "10" "Enable RDP" off \
  "11" "Disable Root" off 3>&1 1>&2 2>&3)

# exit if no choice selected
if [ $? -eq 0 ]; then
  echo "You selected: $choices"
else
  echo "No options selected."
  exit 1
fi

# Create a temporary directory to store downloaded scripts
temp_dir=$(mktemp -d)

# loop through the selected choices
for choice in $(echo "$choices" | tr -d '\"'); do
    case $choice in
      1) # Update and upgrade script
        wget -O "$temp_dir/update.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/update.sh
        echo "Downloaded update.sh"
        bash "$temp_dir/update.sh"
        echo "Running update.sh"
        ;;
      2) # Enable automatic upgrades
        wget -O "$temp_dir/autoupdate.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/autoupdate.sh
        bash "$temp_dir/autoupdate.sh"
        ;;
      3) # Install curl and sudo
        wget -O "$temp_dir/sudocurl.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/sudocurl.sh
        bash "$temp_dir/sudocurl.sh"
        ;;
      4) # Create new user
        wget -O "$temp_dir/user.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/user.sh
        bash "$temp_dir/user.sh"
        ;;
      5) # Create new sudo user
        wget -O "$temp_dir/sudouser.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/sudouser.sh
        bash "$temp_dir/sudouser.sh"
        ;;
      6) # Install docker
        wget -O "$temp_dir/docker.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/docker.sh
        bash "$temp_dir/docker.sh"
        ;;
      7) # Set dotfiles for all users on system
        wget -O "$temp_dir/set-dotfiles.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/set-dotfiles.sh
        bash "$temp_dir/set-dotfiles.sh"
        ;;
      8) # Set IP address
        wget -O "$temp_dir/ip.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/ip.sh
        bash "$temp_dir/ip.sh"
        ;;
      9) # Install nala
        wget -O "$temp_dir/nalainstall.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/nalainstall.sh
        bash "$temp_dir/nalainstall.sh"
        ;;
      10) # Enable RDP
        wget -O "$temp_dir/disable-root.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/lxc-rdp.sh
        bash "$temp_dir/lxc-rdp.sh"
        ;;
      11) # Disable Root
        wget -O "$temp_dir/lxc-rdp.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/disable-root.sh
        bash "$temp_dir/disable-root.sh"
        ;;
    esac
done

# Cleanup temporary directory
rm -rf "$temp_dir"
