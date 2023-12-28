#!/bin/bash

# GLOBAL VARIABLES
TARGET=""


function damage(){



}


function nuke(){



}


function Unleash(){



}


function rampage(){

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
}

# Main execution starts here
mainScreen
userInput

# Now you can use the $TARGET variable for further processing
