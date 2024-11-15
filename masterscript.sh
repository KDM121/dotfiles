#!/bin/bash

# Check if running as root
if [ "$(id -u)" != "0" ]; then
  echo "Error: This script must be run with root privileges."
  echo "Please run with sudo or as the root user."
  exit 1
fi

# Function to get user input for username
get_user_input() {
  username=$(whiptail --inputbox "Enter username" 10 30 --title "Username" 3>&1 1>&2 2>&3)
}

# Selection Board
choices=$(whiptail --checklist "Select options" 30 40 9 \
  "1" "Update and Upgrade" on \
  "2" "Enable Automatic Update and Upgrade" on \
  "3" "Install curl and sudo" on \
  "4" "Create a new user" off \
  "5" "Create a new sudo user" off \
  "6" "Install docker" off \
  "7" "Set dotfiles" on \
  "8" "Set IP address" off \
  "9" "Install Nala" off \
  "10" "Disable root" off 3>&1 1>&2 2>&3)


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
      1)
        wget -O- https://github.com/KDM121/dotfiles/raw/refs/heads/main/update.sh | bash
        ;;
      2)
        wget -O- https://github.com/KDM121/dotfiles/raw/refs/heads/main/autoupdate.sh | bash
        ;;
      3)
        wget -O- https://github.com/KDM121/dotfiles/raw/refs/heads/main/prereq.sh | bash
        ;;
      4)
        echo "Create new non-admin user"
        get_user_input
        username1=$username
        adduser "$username1"
        ;;
      5)
        echo "Create sudo user"
        get_user_input
        username2=$username
        adduser "$username2"
        usermod -aG sudo "$username2"
        ;;
      6)
        wget -O- https://github.com/KDM121/dotfiles/raw/refs/heads/main/docker.sh | bash
        ;;
      7)
		    users=("username1" "username2" "$(whoami)")
		    current_user="$(whoami)"
		    for user in "${users[@]}"; do
		      if [[ "$user" == "$current_user" ]]; then
		  
	    		echo "Set dotfiles"
		    	wget -O /home/"$user"/.bashrc https://raw.githubusercontent.com/KDM121/dotfiles/refs/heads/main/server-bashrc
		    	wget -O /etc/ssh/ssh_config.d https://github.com/KDM121/dotfiles/raw/refs/heads/main/server-ssh-config-d
		    	chown "$username1":"$user" /home/"$user"/.bashrc
		    	chmod 644 /home/"$user"/.bashrc
			    chmod 755 /etc/ssh/ssh_config.d/default.conf
			    su - "$user" -c "source /home/$user/.bashrc"
		      fi
		    done
        ;;
	    8)
		    wget -O- https://github.com/KDM121/dotfiles/raw/refs/heads/main/ip.sh | bash
		    ;;
	    9)
		    wget -O- https://github.com/KDM121/dotfiles/raw/refs/heads/main/nalainstall.sh | bash
		    ;;
      10)
        echo "Disabling root"
        passwd -l root
        ;;
    esac
  done
