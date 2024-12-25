#!/bin/bash

# Function to install a tool using apt if not already installed
install_tool() {
    local tool=$1
    local package=$2

    # Check if the tool is installed
    if ! command -v "$tool" &> /dev/null; then
        echo "$tool is not installed. Installing..."
        sudo apt-get update -y
        sudo apt-get install -y "$package"
    else
        echo "$tool is already installed."
    fi
}

# Function to download, extract, and move binary for a tool
install_binary_tool() {
    local tool_name=$1
    local tool_url=$2
    local tool_file=$3

    # Download the tool binary if not already downloaded
    if [ ! -f "$tool_file" ]; then
        echo "Downloading $tool_name..."
        wget -q "$tool_url"
    else
        echo "$tool_name is already downloaded."
    fi

    # Extract the archive (handle .zip or .tar.gz)
    if [[ "$tool_file" == *.zip ]]; then
        echo "Unzipping $tool_name..."
        unzip -q "$tool_file" -d "$tool_name"

        # Check if httpx binary exists and move it
        if [ -f "$tool_name/httpx" ]; then
            if [ -f "./httpx" ] || [ -d "./httpx" ]; then
                echo "httpx binary already exists in the current directory. Renaming the new binary."
                mv "$tool_name/httpx" "./httpx_new"
                chmod +x "./httpx_new"
                echo "$tool_name binary renamed to httpx_new and made executable."
            else
                mv "$tool_name/httpx" .
                chmod +x httpx
                echo "$tool_name binary moved to the current directory and made executable."
            fi
        fi
    elif [[ "$tool_file" == *.tar.gz ]]; then
        echo "Extracting $tool_name..."
        tar -xzf "$tool_file"

        # Check if the ffuf binary exists and move it
        if [ -f "$tool_name/ffuf" ]; then
            if [ -f "./ffuf" ] || [ -d "./ffuf" ]; then
                echo "ffuf binary already exists in the current directory. Renaming the new binary."
                mv "$tool_name/ffuf" "./ffuf_new"
                chmod +x "./ffuf_new"
                echo "$tool_name binary renamed to ffuf_new and made executable."
            else
                mv "$tool_name/ffuf" .
                chmod +x ffuf
                echo "$tool_name binary moved to the current directory and made executable."
            fi
        fi
    fi

    # Clean up: Remove the downloaded file
    rm -f "$tool_file"
    echo "Removed $tool_file."

    # Delete the folder after moving the binary (for httpx, ffuf, etc.)
    rm -rf "$tool_name"
    echo "Removed $tool_name folder."
}

# Download wordlist from the provided URL
download_wordlist() {
    local wordlist_url="https://raw.githubusercontent.com/danielmiessler/SecLists/refs/heads/master/Discovery/Web-Content/dirsearch.txt"
    local wordlist_file="dirsearch.txt"

    if [ ! -f "$wordlist_file" ]; then
        echo "Downloading wordlist from $wordlist_url..."
        wget -q "$wordlist_url" -O "$wordlist_file"
        echo "Wordlist downloaded and saved as $wordlist_file."
    else
        echo "Wordlist $wordlist_file already exists."
    fi
}

# Main Installation Procedure
echo "Installing framework requirements..."

# Install fping and masscan tools
install_tool "fping" "fping"
install_tool "masscan" "masscan"

# Install WebShot (npm dependencies)
echo "Installing port 80 exploit requirements (WebShot)..."
if [ ! -d "WebShot" ]; then
    echo "Cloning WebShot repository..."
    git clone https://github.com/ameyanekar/WebShot.git
else
    echo "WebShot already cloned."
fi

# Navigate to the WebShot directory and install npm dependencies
cd WebShot
echo "Installing npm dependencies for WebShot..."
if ! npm install; then
    echo "npm install failed. You might need to run with sudo if necessary."
    sudo npm install
fi
cd ..

# Install httpx and ffuf binaries
install_binary_tool "httpx" "https://github.com/projectdiscovery/httpx/releases/download/v1.6.9/httpx_1.6.9_linux_amd64.zip" "httpx_1.6.9_linux_amd64.zip"
install_binary_tool "ffuf" "https://github.com/ffuf/ffuf/releases/download/v2.1.0/ffuf_2.1.0_linux_amd64.tar.gz" "ffuf_2.1.0_linux_amd64.tar.gz"

# Download wordlist
download_wordlist

echo "All required tools have been installed."
