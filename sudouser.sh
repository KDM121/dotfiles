#!/bin/bash

# Prompt for the new user's name and password
read -p "Enter the new user's name: " username
adduser $username

# Add the new user to the sudo group
sudo usermod -aG sudo $username

echo "New sudo user '$username' has been created."
