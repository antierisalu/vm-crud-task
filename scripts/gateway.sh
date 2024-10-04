#!/bin/bash
#gateway.sh

# Run the Node.js and npm check script
if  /vagrant/scripts/checkNodeNpm.sh; then
    echo "hello"
    # Navigate to the project directory
    cd /vagrant/api-gateway || exit

    # Check if local dependencies are installed
    if [ -d "node_modules" ]; then
        echo "Local dependencies probably installed."
    else
        echo "Installing local dependencies..."
        npm install  # Install local dependencies defined in package.json
    fi

    # Check if global dependencies are installed
    if ! npm list -g --depth=0 | grep -q -E 'express|axios|dotenv'; then
        echo "Installing global dependencies..."
        npm install -g express axios dotenv
    else
        echo "Global dependencies are already installed."
    fi

    # Start the server
    echo "Starting gateway..."
    npm start &
else
    echo "Node.js and npm check failed."
    exit 1
fi







