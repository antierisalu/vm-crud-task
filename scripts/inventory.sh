#!/bin/bash
#inventory.sh

if /vagrant/scripts/checkNodeNpm.sh; then

    cd $INVENTORY_DIR || exit

    if [ -d "node_modules" ]; then
        echo "Local dependencies probably installed."
    else
        echo "Installing local dependencies..."
        npm install  # Install local dependencies defined in package.json
    fi

    # Check if global dependencies are installed
    if ! npm list -g --depth=0 | grep -q -E 'express|sequelize|pg|pg-hstore|dotenv'; then
        echo "Installing global dependencies..."
        npm install -g express sequelize pg pg-hstore dotenv
    else
        echo "Global dependencies are already installed."
    fi

else
    echo "Node.js and npm check failed."
    exit 1
fi

# Check for PostgreSQL
if command -v psql >/dev/null 2>&1; then
        echo "PostgreSQL installed successfully: $(psql --version)"
else
    echo "PostgreSQL is not installed. Installing..."
    sudo apt install -y postgresql postgresql-contrib
    sudo systemctl enable --now postgresql

    # Verify installation
    if command -v psql >/dev/null 2>&1; then
        echo "PostgreSQL installed successfully: $(psql --version)"
    else
        echo "PostgreSQL installation failed."
        exit 1
    fi
fi

echo "PostgreSQL setup complete."







