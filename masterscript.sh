#!/bin/bash

# Update and Upgrade
while true; do
read -p "Do you want update and upgrade? (y/n) " yn

case $yn in
        [yY] ) echo "updated and upgraded";
                apt update
                apt upgrade -y
                apt dist-upgrade -y
                apt autoremove -y
                apt autopurge -y
                break;;
        [nN] )  echo skipping install of sudo and curl;
                break;;
        *)      echo "invalid response";;
esac
done

# Automatic Update and Upgrade
while true; do
read -p "Do you want enable auto update? (y/n) " yn

case $yn in
        [yY] ) echo "enabling auto updates";
                apt install unattended-upgrades -y
                dpkg-reconfigure --priority=low unattended-upgrades
                distro_codename=$(lsb_release -c -s)
                sudo tee -a /etc/apt/apt.conf.d/50unattended-upgrades << EOF
                "origin=Debian,codename=${distro_codename}-security";
                "origin=Debian,codename=${distro_codename}-updates";
EOF
                sudo systemctl enable --now unattended-upgrades
                break;;
        [nN] )  echo skipping install of sudo and curl;
                break;;
        *)      echo "invalid response";;
esac
done

# Install prereqs
while true; do
read -p "Do you want to install curl and sudo? (y/n) " yn

case $yn in
        [yY] ) echo "installing curl and sudo";
                apt install curl -y
                apt install sudo -y
                break;;
        [nN] )  echo skipping install of sudo and curl;
                break;;
        *)      echo "invalid response";;
esac
done

# create new non-admin user
while true; do
read -p "Do you want to create a new non-sudo user? (y/n) " yn

case $yn in
        [yY] ) echo "creating new user";
                read -p "Enter the username: " username1;
                echo "creating user $username1";
                adduser $username1;
                break;;
        [nN] )  echo "skipping creation of new user";
                break;;
        *)      echo "invalid response";;
esac
done

# create new admin user
while true; do
read -p "Do you want to create a new sudo user? (y/n) " yn

case $yn in
        [yY] ) echo "creating new user";
                read -p "Enter the username: " username2;
                echo "creating user $username2";
                adduser $username2;
                echo "add user to sudo group";
                usermod -aG sudo $username2;
                break;;
        [nN] )  echo "skipping creating user";
                break;;
        *)      echo "invalid response";;
esac
done

# install podman
while true; do
read -p "Do you want to install podman? (y/n) " yn

case $yn in
        [yY] ) echo "installing podman";
                apt-get -y install podman
                systemctl --user enable --now podman.socket
                apt install podman-compose -y
                break;;
        [nN] )  echo "skipping disabling root";
                break;;
        *)      echo "invalid response";;
esac
done

# set dotfiles
while true; do
read -p "Do you want to set dotfiles? (y/n) " yn

case $yn in
        [yY] ) echo "setting dotfiles";
                wget -O /home/$username1/.bashrc https://github.com/KDM121/dotfiles/blob/main/server-bashrc
                wget -O /home/$username2/.bashrc https://github.com/KDM121/dotfiles/blob/main/server-bashrc
                wget -O /etc/ssh/ssh_config.d https://github.com/KDM121/dotfiles/blob/main/server-ssh-config-d
                wget -O /home/$username1/.inputrc https://github.com/KDM121/dotfiles/blob/main/server-inputrc
                wget -O /home/$username2/.inputrc https://github.com/KDM121/dotfiles/blob/main/server-inputrc
                break;;
        [nN] )  echo "skipping disabling root";
                break;;
        *)      echo "invalid response";;
esac
done

# disable root
while true; do
read -p "Do you want to create a new sudo user? (y/n) " yn

case $yn in
        [yY] ) echo "disabling root user";
                passwd -l root
                break;;
        [nN] )  echo "skipping disabling root";
                break;;
        *)      echo "invalid response";;
esac
done
