#!/bin/bash

# Get the list of users with valid login shells
users=$(getent passwd | grep -E '/bin/bash|/bin/sh|/bin/dash|/bin/zsh' | cut -d: -f1)

wget -O /etc/ssh/ssh_config https://github.com/KDM121/dotfiles/raw/refs/heads/main/server-ssh-config
chmod 755 /etc/ssh/ssh_config


for user in $users; do
    echo "setting dotfiles for: $user"
    wget -O /home/"$user"/.bashrc https://raw.githubusercontent.com/KDM121/dotfiles/refs/heads/main/server-bashrc
    chown "$user":"$user" /home/"$user"/.bashrc
	chmod 644 /home/"$user"/.bashrc
done