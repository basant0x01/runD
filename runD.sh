#!/bin/bash

# GLOBAL VARIABLES
TARGET=""


function Unleash(){

# HTTP: 80
# HTTPS: 443
# FTP: 21
# SSH: 22
# TELNET: 23
# SMTP: 25
# DNS 53
# POP3: 110
# SFTP: 115
# IMAP: 143
# MSRPC: 135
# NETBIOS: 137
# NETBIOS: 139
# SMB: 445
# MYSQL: 3306
# MYSQL: 1433
# RDP: 3389

my_ports=("80" "21" "22" "23")

for ports in "${my_ports[@]}"; do
    masscan -iL runD/hosts.txt -p $ports 2>/dev/null | tee > runD/all_open_ports.txt
done

}

function rampage(){
echo "Running: fping"
mkdir runD
fping -a -g $TARGET 2>/dev/null | tee > runD/all_hosts.txt
Unleash
}


function userInput() {
    clear
    read -p "Enter your Target (Example: *.*.*.*/*): " ip

    # Validate CIDR using regex
    if [[ $ip =~ ^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/([0-9]+)$ ]]; then
        TARGET="$ip"
        echo "Valid input. Target: $TARGET"
        mainScreen
    else
        echo "Invalid input. Please enter a valid CIDR."
        sleep 1
        userInput
    fi
}

function mainScreen() {
    clear
    echo "Welcome to RUN-D"
    echo "Rampage Unleash Nuke and Damage"
    echo "-------------------------------"
    echo -e "Selected Target: "$TARGET
    rampage
}

# Main execution starts here
userInput

# Now you can use the $TARGET variable for further processing
