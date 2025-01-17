#!/bin/bash

# Prompt for the new user's name and password
read -p "Enter the new user's name: " username
read -s -p "Enter the new user's password: " password
echo

# Create the new user with the provided name
sudo useradd -m -s /bin/bash -c "$username" $username

# Set the new user's password 
echo "$username:$password" | sudo chpasswd

# Add the new user to the sudo group
sudo usermod -aG sudo $username

echo "New sudo user '$username' has been created."
