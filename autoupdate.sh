#!/bin/bash

echo "Automatic Update and Upgrade"
apt install unattended-upgrades -y
dpkg-reconfigure --priority=low unattended-upgrades
distro_codename=$(lsb_release -c -s)
tee -a /etc/apt/apt.conf.d/50unattended-upgrades << EOF
"origin=Debian,codename=${distro_codename}-security";
"origin=Debian,codename=${distro_codename}-updates";
EOF
systemctl enable --now unattended-upgrades