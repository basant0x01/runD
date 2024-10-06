#!/bin/bash

# Coder: basant0x01 (Basant Karki)
# Usage: Network Scanner & Exploiter

# Tool Requirements:
    # fping
    # masscan
    # WebShot
    # Httpx


# GLOBAL VARIABLES
TARGET=""
TIME_TAKING_WARRNING="It may take time, so grab your coffee!"
TASK_COMPLETED="The script has completed the task - runD"


function task_completed(){
    echo -e "$TASK_COMPLETED"
}

function rampage_on_port80(){

# Print a separator line for better visibility in the terminal output
echo -e "------------------------------------------------"

# Notify the user that the screenshot folder is being created
echo "Creating Screenshot Folder"

# Create a directory to store screenshots from targets on port 80
mkdir -p runD/open_juicy_ports/80/screenshots

# Inform the user that the script is resolving live IP addresses
echo "Resolving Live IP Address.."

# Read IP addresses from the specified file, pass them to httpx for resolution,
# and save the output (live IPs) to another file
cat runD/open_juicy_ports/80/ips_port80.txt | ./httpx | tee runD/open_juicy_ports/80/live_ips_port80.txt

# Notify the user that the exploit is being run on port 80
echo "Running Exploit on: port 80"
# Pause for half a second before proceeding
sleep 0.5
# Indicate that screenshots are being taken
echo "Taking Screenshots..!"

# Define variables for input and output files
port80_targets="runD/open_juicy_ports/80/ips_port80.txt"
live_port80_targets="runD/open_juicy_ports/80/live_ips_port80.txt"
port80_folder="runD/open_juicy_ports/80/screenshots"

# Display a warning message about time consumption (assuming $TIME_TAKING_WARRNING is defined elsewhere)
echo -e "$TIME_TAKING_WARRNING"

# Execute the screenshot script with the live targets and output folder,
# redirecting output to /dev/null to suppress it
node WebShot/screenshot.js -f "$live_port80_targets" -o "$port80_folder" > /dev/null 2>&1

# Indicate that the task has been completed
task_completed


}

function rampage(){
: << 'RAMPAGE'
[ a course of violent, riotous, or reckless action or behavior ]
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
echo "Running: masscan"

my_ports=("80") #"21" "22" "23"

# Create a folder to store open ports files
mkdir -p runD/open_juicy_ports

for port in "${my_ports[@]}"; do
    output_file="runD/open_port${port}.txt"
    ips_file="runD/ips_port${port}.txt"
    port_folder="runD/open_juicy_ports/$port"
    
    # Run masscan and save the output to the specified file
    masscan -iL runD/all_hosts.txt -p $port --output-format grepable --output-filename "$output_file" > /dev/null 2>&1

    # Extract and save IPs using grep and awk
    cat "$output_file" | grep -o 'Host:.*' | awk '{print $2}' > "$ips_file"

    # Create a folder for the port if it doesn't exist
    mkdir -p "$port_folder"

    # Move files to the respective folders
    mv "$ips_file" "$port_folder/"

    # Delete the previous open_port${port}.txt file
    rm -f "$output_file"
done

rampage_on_port80

}

function userInput() {
    clear
    read -p "Enter your Target (Example: *.*.*.*/*): " ip

    # validate CIDR using regex
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
    echo "###################################################"
    echo "#------------------Welcome to RUN-D --------------#"
    echo "###################################################"
    echo "#----- Scripted/Developed - by basant0x01 --------#"
    echo "###################################################"
    echo -e "Selected Target: "$TARGET
    rampage
}

# Main execution starts here
userInput
# ----------------------------------------
# NOTE: "IT MAY ACT LIKE A NETWORK PT BOT"
# ----------------------------------------
