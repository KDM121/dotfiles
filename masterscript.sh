#!/bin/bash


while true; do
read -p "Do you want to update? (y/n) " yn

case $yn in
        [yY] )  echo "Update and Upgrading"
                # Update and Upgrade
                apt update
                apt upgrade -y
                apt dist-upgrade -y
                apt autoremove -y
                apt autopurge -y
                break;;
        [nN] )  echo "skipping";
                break;;
        *)      echo "invalid response";;
esac
done


while true; do
read -p "Do you want to enable Automatic Update and Upgrade? (y/n) " yn

case $yn in
        [yY] )  echo "Automatic Update and Upgrade"
                # Automatic Update and Upgrade
                echo "enabling auto updates"
                apt install unattended-upgrades -y
                dpkg-reconfigure --priority=low unattended-upgrades
                distro_codename=$(lsb_release -c -s)
                tee -a /etc/apt/apt.conf.d/50unattended-upgrades << EOF
        "origin=Debian,codename=${distro_codename}-security";
        "origin=Debian,codename=${distro_codename}-updates";
EOF
                sudo systemctl enable --now unattended-upgrades
                break;;
        [nN] )  echo "skipping";
                break;;
        *)      echo "invalid response";;
esac
done


while true; do
read -p "Do you want to install curl and sudo? (y/n) " yn

case $yn in
        [yY] )  echo "Install prereqs"
                # Install prereqs
                apt install curl -y
                apt install sudo -y
                break;;
        [nN] )  echo "skipping";
                break;;
        *)      echo "invalid response";;
esac
done


while true; do
read -p "Do you want to create a new user? (y/n) " yn

case $yn in
        [yY] )  echo "create new non-admin user"
                # create new non-admin user
                read -p "set username: " username1
                echo "creating user $username1";
                adduser "$username1";
                break;;
        [nN] )  echo "skipping";
                break;;
        *)      echo "invalid response";;
esac
done


while true; do
read -p "Do you want to create a new sudo user? (y/n) " yn

case $yn in
        [yY] )  echo "create sudo user"
                read -p "set sudo username: " username2
                echo "creating user $username2";
                adduser "$username2";

                echo "add user to sudo group";
                usermod -aG sudo "$username2"
                break;;
        [nN] )  echo "skipping";
                break;;
        *)      echo "invalid response";;
esac
done


while true; do
read -p "Do you want to install podman? (y/n) " yn

case $yn in
        [yY] )  echo "install podman"
                # install podman
                apt-get -y install podman
                systemctl --user enable --now podman.socket
                apt install podman-compose -y
                break;;
        [nN] )  echo "skipping";
                break;;
        *)      echo "invalid response";;
esac
done


while true; do
read -p "Do you want to set dotfiles? (y/n) " yn

case $yn in
        [yY] )  echo "set dofiles"
                # set dotfiles
                wget -O /home/"$username1"/.bashrc https://raw.githubusercontent.com/KDM121/dotfiles/refs/heads/main/server-bashrc
                wget -O /home/"$username2"/.bashrc https://raw.githubusercontent.com/KDM121/dotfiles/refs/heads/main/server-bashrc
                wget -O /etc/ssh/ssh_config.d https://github.com/KDM121/dotfiles/raw/refs/heads/main/server-ssh-config-d
                wget -O /home/"$username1"/.inputrc https://github.com/KDM121/dotfiles/raw/refs/heads/main/server-inputrc
                wget -O /home/"$username2"/.inputrc https://github.com/KDM121/dotfiles/raw/refs/heads/main/server-inputrc
                # Set correct ownership and permissions
                chown "$username1":"$username1" /home/"$username1"/.bashrc /home/"$username1"/.inputrc
                chown "$username2":"$username2" /home/"$username2"/.bashrc /home/"$username2"/.inputrc
                chmod 644 /home/"$username1"/.bashrc /home/"$username1"/.inputrc
                chmod 644 /home/"$username2"/.bashrc /home/"$username2"/.inputrc
                chmod 644 /etc/ssh/ssh_config.d/default.conf
                
                # Source the .bashrc files
                su - "$username1" -c "source /home/$username1/.bashrc"
                su - "$username2" -c "source /home/$username2/.bashrc"
                break;;
        [nN] )  echo "skipping";
                break;;
        *)      echo "invalid response";;
esac
done


while true; do
read -p "Do you want to disable root? (y/n) " yn

case $yn in
        [yY] )  echo "disabling root"
                # disable root
                passwd -l root
                break;;
        [nN] )  echo "skipping";
                break;;
        *)      echo "invalid response";;
esac
done