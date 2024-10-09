#!/bin/bash
#inventory.sh

# Run PostgreSQL check and setup for inventory

$SCRIPT_DIR/checkPostgres.sh inventory

if $SCRIPT_DIR/checkNodeNpm.sh; then

    cd $INVENTORY_DIR || exit

    if [ -d "node_modules" ]; then
        echo "Local dependencies probably installed."
    else
        echo "Installing local dependencies..."
        npm install express sequelize pg pg-hstore dotenv
    fi

else
    echo "Node.js and npm check failed."
    exit 1
fi








