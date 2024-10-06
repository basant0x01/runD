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
TIME_TAKING_WARNING="It may take time, so grab your coffee!"
TASK_COMPLETED="The script has completed the task - runD"

# Function to check for root privileges
function check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "This script must be run as root. Please use 'sudo' or run as root user."
        exit 1
    fi
}

function task_completed() {
    echo -e "$TASK_COMPLETED"
}

function rampage_on_port80() {
    bash exploit_port_80.sh
    task_completed
}

function rampage() {
    : << 'RAMPAGE'
[ a course of violent, riotous, or reckless action or behavior ]
Rampage (R): In the context of a network scanner and exploiter, "Rampage" 
could refer to a scanning phase where the tool aggressively looks for vulnerabilities and weaknesses 
in the target network. This might involve port scanning, service enumeration, 
and identifying potential entry points.
RAMPAGE

    echo "Running: fping"
    mkdir -p runD
    fping -a -g $TARGET 2>/dev/null | tee > runD/all_hosts.txt

    echo "Running: masscan"

    my_ports=("80") # "21" "22" "23" Open ports according to your requirements

    # Create a folder to store open ports files
    mkdir -p runD/open_juicy_ports

    for port in "${my_ports[@]}"; do
        output_file="runD/open_port${port}.txt"
        ips_file="runD/ips_port${port}.txt"
        port_folder="runD/open_juicy_ports/$port"

        # Run masscan and save the output to the specified file
        masscan -iL runD/all_hosts.txt -p $port --output-format grepable --output-filename "$output_file" > /dev/null 2>&1

        # Extract and save IPs using grep and awk
        grep -o 'Host:.*' "$output_file" | awk '{print $2}' > "$ips_file"

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
    echo "###################################################"
    echo "#------------------Welcome to RUN-D --------------#"
    echo "###################################################"
    echo "#----- Scripted/Developed - by basant0x01 --------#"
    echo "###################################################"
    echo -e "Selected Target: $TARGET"
    rampage
}

# Main execution starts here
check_root  # Check for root privileges
userInput
# ----------------------------------------
# NOTE: "IT MAY ACT LIKE A NETWORK PT BOT"
# ----------------------------------------
