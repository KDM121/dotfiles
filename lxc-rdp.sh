#!/bin/bash

sudo apt install xfce4 -y
sudo apt install xrdp -y
dpkg -L xrdp
sudo systemctl restart xrdp
echo "configure xrdp"
echo "select option 3"
sudo update-alternatives --config x-session-manager

sudo systemctl restart xrdp

echo "xrdp is setup with xfce4 on your Debian 12 lxc"
