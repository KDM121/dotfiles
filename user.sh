#!/bin/bash

# Prompt for the new user's name and password
read -p "Enter the new user's name: " username
adduser $username


echo "New user '$username' has been created."
