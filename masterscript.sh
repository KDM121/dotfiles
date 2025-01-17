#!/bin/bash

# Check if running as root
if [ "$(id -u)" != "0" ]; then
  echo "Error: This script must be run with root privileges."
  echo "Please run with sudo or as the root user."
  exit 1
fi

# Create a log file
log_file="/var/log/masterscript.log"
exec > >(tee -a "$log_file") 2>&1
echo "Started logging"

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
echo "created temp dir"
temp_dir=$(mktemp -d)

# loop through the selected choices
echo "looping through selections"
for choice in $(echo "$choices" | tr -d '\"'); do
    case $choice in
      1) # Update and upgrade script
        wget -O "$temp_dir/update.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/update.sh
        echo "Downloaded update.sh"
        chmod +x "$temp_dir/update.sh"
        echo "Running update.sh"
        bash "$temp_dir/update.sh"
        ;;
      2) # Enable automatic upgrades
        wget -O "$temp_dir/autoupdate.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/autoupdate.sh
        echo "Downloaded autoupdate.sh"
        chmod +x "$temp_dir/autoupdate.sh"
        echo "Running autoupdate.sh"
        bash "$temp_dir/autoupdate.sh"
        ;;
      3) # Install curl and sudo
        wget -O "$temp_dir/sudocurl.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/sudocurl.sh
        echo "Downloaded sudocurl.sh"
        chmod +x "$temp_dir/sudocurl.sh"
        echo "Running sudocurl.sh"
        bash "$temp_dir/sudocurl.sh"
        ;;
      4) # Create new user
        wget -O "$temp_dir/user.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/user.sh
        echo "Downloaded user.sh"
        chmod +x "$temp_dir/user.sh"
        echo "Running user.sh"
        bash "$temp_dir/user.sh"
        ;;
      5) # Create new sudo user
        wget -O "$temp_dir/sudouser.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/sudouser.sh
        echo "Downloaded sudouser.sh"
        chmod +x "$temp_dir/sudouser.sh"
        echo "Running sudouser.sh"
        bash "$temp_dir/sudouser.sh"
        ;;
      6) # Install docker
        wget -O "$temp_dir/docker.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/docker.sh
        echo "Downloaded docker.sh"
        chmod +x "$temp_dir/docker.sh"
        echo "Running docker.sh"
        bash "$temp_dir/docker.sh"
        ;;
      7) # Set dotfiles for all users on system
        wget -O "$temp_dir/set-dotfiles.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/set-dotfiles.sh
        echo "Downloaded set-dotfiles.sh"
        chmod +x "$temp_dir/set-dotfiles.sh"
        echo "Running set-dotfiles.sh"
        bash "$temp_dir/set-dotfiles.sh"
        ;;
      8) # Set IP address
        wget -O "$temp_dir/ip.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/ip.sh
        echo "Downloaded ip.sh"
        chmod +x "$temp_dir/ip.sh"
        echo "Running ip.sh"
        bash "$temp_dir/ip.sh"
        ;;
      9) # Install nala
        wget -O "$temp_dir/nalainstall.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/nalainstall.sh
        echo "Downloaded nalainstall.sh"
        chmod +x "$temp_dir/nalainstall.sh"
        echo "Running nalainstall.sh"
        bash "$temp_dir/nalainstall.sh"
        ;;
      10) # Enable RDP
        wget -O "$temp_dir/lxc-rdp.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/lxc-rdp.sh
        echo "Downloaded lxc-rdp.sh"
        chmod +x "$temp_dir/lxc-rdp.sh"
        echo "Running lxc-rdp.sh"
        bash "$temp_dir/lxc-rdp.sh"
        ;;
      11) # Disable Root
        wget -O "$temp_dir/disable-root.sh" https://github.com/KDM121/dotfiles/raw/refs/heads/main/disable-root.sh
        echo "Downloaded disable-root.sh"
        chmod +x "$temp_dir/disable-root.sh"
        echo "Running disable-root.sh"
        bash "$temp_dir/disable-root.sh"
        ;;
    esac
done
echo "ran all selected scripts"
# Cleanup temporary directory
rm -rf "$temp_dir"
echo "deleted temp dir"