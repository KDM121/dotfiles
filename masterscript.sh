#!/bin/bash

# Function to get user input for username and password
get_user_input() {
  username=$(whiptail --inputbox "Enter username" 10 30 --title "Username" 3>&1 1>&2 2>&3)
  password=$(whiptail --passwordbox "Enter password" 10 30 --title "Password" 3>&1 1>&2 2>&3)
}

# Main loop
choices=$(whiptail --checklist "Select options" 25 50 8 \
  "1" "Update and Upgrade" on \
  "2" "Enable Automatic Update and Upgrade" on \
  "3" "Install curl and sudo" on \
  "4" "Create a new user" off \
  "5" "Create a new sudo user" off \
  "6" "Install podman" off \
  "7" "Set dotfiles" on \
  "8" "Disable root" off 3>&1 1>&2 2>&3)

if [ $? -eq 0 ]; then
  echo "You selected: $choices"
else
  echo "No options selected."
  exit 1
fi

for choice in $(echo $choices | tr -d '\"'); do
    case $choice in
      1)
        echo "Update and Upgrading"
        apt update
        apt upgrade -y
        apt dist-upgrade -y
        apt autoremove -y
        apt autopurge -y
        ;;
      2)
        echo "Automatic Update and Upgrade"
        apt install unattended-upgrades -y
        dpkg-reconfigure --priority=low unattended-upgrades
        distro_codename=$(lsb_release -c -s)
        tee -a /etc/apt/apt.conf.d/50unattended-upgrades << EOF
"origin=Debian,codename=${distro_codename}-security";
"origin=Debian,codename=${distro_codename}-updates";
EOF
        systemctl enable --now unattended-upgrades
        ;;
      3)
        echo "Install prereqs"
        apt install curl -y
        apt install sudo -y
        ;;
      4)
        echo "Create new non-admin user"
        get_user_input
        username1=$username
        password1=$password
        adduser "$username1"
        echo "$username1:$password1" | chpasswd
        ;;
      5)
        echo "Create sudo user"
        get_user_input
        username2=$username
        password2=$password
        adduser "$username2"
        echo "$username2:$password2" | chpasswd
        usermod -aG sudo "$username2"
        ;;
      6)
        echo "Install podman"
        apt-get -y install podman
        systemctl --user enable --now podman.socket
        apt install podman-compose -y
        ;;
      7)
        echo "Set dotfiles"
        # Download
        wget -O /home/"$username1"/.bashrc https://raw.githubusercontent.com/KDM121/dotfiles/refs/heads/main/server-bashrc
        wget -O /home/"$username2"/.bashrc https://raw.githubusercontent.com/KDM121/dotfiles/refs/heads/main/server-bashrc
        wget -O /etc/ssh/ssh_config.d https://github.com/KDM121/dotfiles/raw/refs/heads/main/server-ssh-config-d
        wget -O /home/"$username1"/.inputrc https://github.com/KDM121/dotfiles/raw/refs/heads/main/server-inputrc
        wget -O /home/"$username2"/.inputrc https://github.com/KDM121/dotfiles/raw/refs/heads/main/server-inputrc

        # Set permissions
        chown "$username1":"$username1" /home/"$username1"/.bashrc /home/"$username1"/.inputrc
        chown "$username2":"$username2" /home/"$username2"/.bashrc /home/"$username2"/.inputrc
        chmod 644 /home/"$username1"/.bashrc /home/"$username1"/.inputrc
        chmod 644 /home/"$username2"/.bashrc /home/"$username2"/.inputrc
        chmod 755 /etc/ssh/ssh_config.d/default.conf

        # Source bashrc
        su - "$username1" -c "source /home/$username1/.bashrc"
        su - "$username2" -c "source /home/$username2/.bashrc"
        ;;
      8)
        echo "Disabling root"
        passwd -l root
        ;;
    esac
  done
