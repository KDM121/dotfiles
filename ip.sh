#!/bin/bash

# Check if running as root
if [ "$(id -u)" != "0" ]; then
  echo "Error: This script must be run with root privileges."
  echo "Please run with sudo or as the root user."
  exit 1
fi

# Get the list of network interfaces
INTERFACES=$(ip link | grep -v "lo" | awk '{print $2}' | sed 's/://g')

# Use whiptail to present the list and get the user's selection
INTERFACE=$(whiptail --title "Network Interface Selection" --menu "Select a network interface:" 0 0 0 \
  $(for i in $INTERFACES; do echo "$i"; done) \
  3>&1 1>&2 2>&3)

# Exit on cancel in whiptail
if [ $? -ne 0 ]; then
  echo "Script cancelled by user."
  exit 0
fi


# Use whiptail to prompt the user to enter the IP address, gateway, and mask
while true; do
  IP_ADDRESS=$(whiptail --title "Enter IP Address" --inputbox "Enter the IP address for $INTERFACE (e.g. 192.168.1.100):" 0 0 3>&1 1>&2 2>&3)
  # Exit on cancel in whiptail
  if [ $? -ne 0 ]; then
    echo "Script cancelled by user."
    exit 0
  fi
  if [[ $IP_ADDRESS =~ ^[0-9.]+$ ]] && [ ${#IP_ADDRESS} -ge 8 ] && [ ${#IP_ADDRESS} -le 15 ] && [ $(echo "$IP_ADDRESS" | tr -cd '.' | wc -c) -eq 3 ]; then
    break
  else
    whiptail --title "Invalid Input" --msgbox "Invalid IP address. Please enter a valid IP address (e.g. 192.168.1.100)." 0 0 3>&1 1>&2 2>&3
  fi
done

while true; do
  GATEWAY=$(whiptail --title "Enter Gateway" --inputbox "Enter the gateway for $INTERFACE (e.g. 192.168.1.1):" 0 0 3>&1 1>&2 2>&3)
  # Exit on cancel in whiptail
  if [ $? -ne 0 ]; then
    echo "Script cancelled by user."
    exit 0
  fi
  if [[ $GATEWAY =~ ^[0-9.]+$ ]] && [ ${#GATEWAY} -ge 8 ] && [ ${#GATEWAY} -le 15 ] && [ $(echo "$GATEWAY" | tr -cd '.' | wc -c) -eq 3 ]; then
    break
  else
    whiptail --title "Invalid Input" --msgbox "Invalid gateway. Please enter a valid gateway (e.g. 192.168.1.1)." 0 0 3>&1 1>&2 2>&3
  fi
done

while true; do
  NETMASK=$(whiptail --title "Enter Netmask" --inputbox "Enter the netmask for $INTERFACE (e.g. 24):" 0 0 3>&1 1>&2 2>&3)
  # Exit on cancel in whiptail
  if [ $? -ne 0 ]; then
    echo "Script cancelled by user."
    exit 0
  fi
  if [[ $NETMASK =~ ^[0-9]+$ ]] && [ $NETMASK -ge 8 ] && [ $NETMASK -le 32 ]; then
    break
  else
    whiptail --title "Invalid Input" --msgbox "Invalid netmask. Please enter a valid netmask (e.g. 24)." 0 0 3>&1 1>&2 2>&3
  fi
done

# Use whiptail to confirm the changes
CONFIRM=$(whiptail --title "Confirm Changes" --yesno "Apply the following changes to $INTERFACE?\nIP Address: $IP_ADDRESS\nGateway: $GATEWAY\nNetmask: $NETMASK" 0 0 3>&1 1>&2 2>&3)
# Exit on cancel in whiptail
  if [ $? -ne 0 ]; then
    echo "Script cancelled by user."
    exit 0
  fi
	
# If the user confirms, apply the changes
if [ $? -eq 0 ]; then
  ip addr flush $INTERFACE
  ip addr add $IP_ADDRESS/$NETMASK brd + dev $INTERFACE
  ip route add default via $GATEWAY dev $INTERFACE
  ip -c address
  echo "Changes applied successfully!"
else
  echo "Changes cancelled."
fi
