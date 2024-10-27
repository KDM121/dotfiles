#!/bin/bash

# Install dialog if not already installed
apt-get install dialog -y

menu() {
    dialog --separate-output --checklist "Select tasks to perform:" 15 50 8 \
    1 "Update and Upgrade" off \
    2 "Enable Automatic Updates" off \
    3 "Install curl and sudo" off \
    4 "Create a new non-sudo user" off \
    5 "Create a new sudo user" off \
    6 "Install Podman" off \
    7 "Set dotfiles" off \
    8 "Disable root user" off 2>results

    while read -r task; do
        case $task in
            1)
                echo "Updating and upgrading..."
                apt update
                apt upgrade -y
                apt dist-upgrade -y &&
                apt autoremove -y &&
                apt autopurge -y
                ;;
            2)
                echo "Enabling automatic updates..."
                sudo apt install unattended-upgrades -y
                sudo dpkg-reconfigure --priority=low unattended-upgrades
                distro_codename=$(lsb_release -c -s)
                sudo tee -a /etc/apt/apt.conf.d/50unattended-upgrades << EOF
    "origin=Debian,codename=${distro_codename}-security";
    "origin=Debian,codename=${distro_codename}-updates";
EOF
                sudo systemctl enable --now unattended-upgrades
                ;;
            3)
                echo "Installing curl and sudo..."
                sudo apt install curl -y && sudo apt install sudo -y
                ;;
            4)
                read -p "Enter the username for the new non-sudo user: " username1
                sudo adduser $username1
                ;;
            5)
                read -p "Enter the username for the new sudo user: " username2
                sudo adduser $username2
                sudo usermod -aG sudo $username2
                ;;
            6)
                echo "Installing Podman..."
                sudo apt-get -y install podman
                sudo systemctl --user enable --now podman.socket
                sudo apt install podman-compose -y
                ;;
            7)
                read -p "Enter the username for setting dotfiles: " username
                wget -O /home/$username/.bashrc https://github.com/KDM121/dotfiles/blob/main/server-bashrc
                wget -O /etc/ssh/ssh_config.d https://github.com/KDM121/dotfiles/blob/main/server-ssh-config-d
                wget -O /home/$username/.inputrc https://github.com/KDM121/dotfiles/blob/main/server-inputrc
                ;;
            8)
                echo "Disabling root user..."
                sudo passwd -l root
                ;;
            *)
                echo "Invalid option."
                ;;
        esac
    done <results
    rm results
}

menu
