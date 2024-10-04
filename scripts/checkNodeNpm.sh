#!/bin/bash

# checkNodeNpm.sh

# Function to check if a command is installed
check_command() {
    command -v "$1" >/dev/null 2>&1
}

# Check for Node.js
if check_command node; then
    echo "Node.js is already installed: $(node -v)"
else
    echo "Node.js is not installed. Installing..."
    curl -sL https://deb.nodesource.com/setup_22.x | bash -
    apt update
    apt install -y nodejs

    if check_command node; then
        echo "Node.js installed successfully: $(node -v)"
    else
        echo "Node.js installation failed."
        exit 1
    fi
fi

# Check for npm
if check_command npm; then
    echo "npm is already installed: $(npm -v)"
else
    echo "npm is not installed. Installing..."
    apt install -y npm

    if check_command npm; then
        echo "npm installed successfully: $(npm -v)"
        # Install necessary npm packages if npm is installed
    else
        echo "npm installation failed."
        exit 1
    fi
fi

exit 0
