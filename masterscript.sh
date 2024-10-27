#!/bin/bash

# Install dialog if not already installed
apt-get install dialog -y

# create menu
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

    # iterate through tasks
    while read -r task; do
        case $task in
            1)
                # Update and Upgrade
                apt update
                apt upgrade -y
                apt dist-upgrade -y
                apt autoremove -y
                apt autopurge -y
                ;;
            2)
                # Automatic Update and Upgrade
                echo "enabling auto updates";
                apt install unattended-upgrades -y
                dpkg-reconfigure --priority=low unattended-upgrades
                distro_codename=$(lsb_release -c -s)
                tee -a /etc/apt/apt.conf.d/50unattended-upgrades << EOF
        "origin=Debian,codename=${distro_codename}-security";
        "origin=Debian,codename=${distro_codename}-updates";
EOF
                sudo systemctl enable --now unattended-upgrades
                ;;
            3)
                # Install prereqs
                apt install curl -y
                apt install sudo -y
                ;;
            4)
                # create new non-admin user
                read -p "Enter the username: " username1;
                echo "creating user $username1";
                adduser $username1;
                ;;
            5)
                read -p "Enter the username: " username2;
                echo "creating user $username2";
                adduser $username2;
                echo "add user to sudo group";
                usermod -aG sudo $username2
                ;;
            6)
                # install podman
                apt-get -y install podman
                systemctl --user enable --now podman.socket
                apt install podman-compose -y
                ;;
            7)
                # set dotfiles
                wget -O /home/$username1/.bashrc https://raw.githubusercontent.com/KDM121/dotfiles/refs/heads/main/server-bashrc
                wget -O /home/$username2/.bashrc https://raw.githubusercontent.com/KDM121/dotfiles/refs/heads/main/server-bashrc
                wget -O /etc/ssh/ssh_config.d https://github.com/KDM121/dotfiles/raw/refs/heads/main/server-ssh-config-d
                wget -O /home/$username1/.inputrc https://github.com/KDM121/dotfiles/raw/refs/heads/main/server-inputrc
                wget -O /home/$username2/.inputrc https://github.com/KDM121/dotfiles/raw/refs/heads/main/server-inputrc
                ;;
            8)
                # disable root
                passwd -l root
                ;;
            *)
                echo "Invalid option."
                ;;
        esac
    done <results
    rm results
}

menu
