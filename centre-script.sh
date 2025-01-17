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
  "2" "Enable Automatic Update and Upgrade" on \
  "3" "Install curl and sudo" on \
  "4" "Create a new user" off \
  "5" "Create a new sudo user" off \
  "6" "Install docker" off \
  "7" "Set dotfiles" on \
  "8" "Set IP address" off \
  "9" "Install Nala" off \
  "10" "Disable Root" off \
  "11" "Enable RDP" off 3>&1 1>&2 2>&3)

# exit if no choice selected
if [ $? -eq 0 ]; then
  echo "You selected: $choices"
else
  echo "No options selected."
  exit 1
fi

# loop through the selected choices
for choice in $(echo "$choices" | tr -d '\"'); do
    case $choice in
      1) #Update and upgrade script
        wget -O- https://github.com/KDM121/dotfiles/raw/refs/heads/main/update.sh | bash
        ;;
      2) #Enable automatic upgrades
        wget -O- https://github.com/KDM121/dotfiles/raw/refs/heads/main/autoupdate.sh | bash
        ;;
      3) #Install curl and sudo
        wget -O- https://github.com/KDM121/dotfiles/raw/refs/heads/main/sudocurl.sh | bash
        ;;
      4) #Create new user
        wget -O- https://github.com/KDM121/dotfiles/raw/refs/heads/main/user.sh| bash
        ;;
      5) #Create new sudo user
        wget -O- https://github.com/KDM121/dotfiles/raw/refs/heads/main/sudouser.sh| bash
        ;;
      6) #Install docker
        wget -O- https://github.com/KDM121/dotfiles/raw/refs/heads/main/docker.sh | bash
        ;;
      7) #Set dotfiles for all users on system?
        wget -O- https://github.com/KDM121/dotfiles/raw/refs/heads/main/set-dotfiles.sh| bash
        ;;
	    8) #Set IP address
        wget -O- https://github.com/KDM121/dotfiles/raw/refs/heads/main/ip.sh | bash
	      ;;
	    9) #Install nala
        wget -O- https://github.com/KDM121/dotfiles/raw/refs/heads/main/nalainstall.sh | bash
	      ;;
      10) #Disable Root
        wget -O- https://github.com/KDM121/dotfiles/raw/refs/heads/main/disable-root.sh | bash
        ;;
      11) #Enable RDP
        wget -O- https://github.com/KDM121/dotfiles/raw/refs/heads/main/lxc-rdp.sh | bash
        ;;

    esac
done
