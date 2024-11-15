#!/bin/bash

echo "Update and Upgrading"
apt update
apt upgrade -y
apt dist-upgrade -y
apt autoremove -y
apt autopurge -y