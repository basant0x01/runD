#!/bin/bash

# GLOBAL VARIABLES
TARGET=""


function rampage(){
: << 'RAMPAGE'
Rampage (R): In the context of a network scanner and exploiter, "Rampage" 
could refer to a scanning phase where the tool aggressively looks for vulnerabilities and weaknesses 
in the target network. This might involve port scanning, service enumeration, 
and identifying potential entry points.
RAMPAGE

echo "Running: fping"
mkdir runD
fping -a -g $TARGET 2>/dev/null | tee > runD/all_hosts.txt

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
# ... Add more ports as needed

my_ports=("80" "21" "22" "23")

for port in "${my_ports[@]}"; do
    output_file="runD/open_port${port}.txt"
    ips_file="runD/ips_port${port}.txt"
    
    # Run masscan and save the output to the specified file
    masscan -iL runD/all_hosts.txt -p $port --output-format grepable --output-filename "$output_file"

    # Extract and save IPs using grep and awk
    cat "$output_file" | grep -o 'Host:.*' | awk '{print $2}' > "$ips_file"

    # Delete the previous open_port${port}.txt file
    rm -f "$output_file"
done

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
