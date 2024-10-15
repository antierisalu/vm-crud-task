#!/bin/bash
# checkNodeNpm.sh

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
        
        npm install -g pm2
        
        echo "Npm installed successfully: $(npm -v)"
    else
        echo "Node.js installation failed."
        exit 1
    fi
fi

exit 0
