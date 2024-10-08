#!/bin/bash
#gateway.sh

if /vagrant/scripts/checkNodeNpm.sh; then

    cd $GATEWAY_DIR || exit

    if [ -d "node_modules" ]; then
        echo "Local dependencies probably installed."
    else
        echo "Installing local dependencies..."
        npm install  # Install local dependencies defined in package.json
    fi

    # Check if global dependencies are installed
    if ! npm list -g --depth=0 | grep -q -E 'express|axios|dotenv|nodemon'; then
        echo "Installing global dependencies..."
        npm install -g express axios dotenv nodemon
    else
        echo "Global dependencies are already installed."
    fi

else
    echo "Node.js and npm check failed."
    exit 1
fi
