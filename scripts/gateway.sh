#!/bin/bash
#gateway.sh

if $SCRIPT_DIR/checkNodeNpm.sh; then

    cd $GATEWAY_DIR || exit

    if [ -d "node_modules" ]; then
        echo "Local dependencies probably installed."
    else
        npm install express axios dotenv http-proxy-middleware
        echo "Global dependencies are already installed."
    fi

else
    echo "Node.js and npm check failed."
    exit 1
fi
