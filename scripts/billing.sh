#!/bin/bash
#billing.sh

# Run the Node.js and npm check script
if /vagrant/scripts/checkNodeNpm.sh; then
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
    if ! npm list -g --depth=0 | grep -q -E 'express|amqlib|dotenv'; then
        echo "Installing global dependencies..."
        npm install -g express amqplib dotenv
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

# Check for RabbitMQ
if command -v rabbitmq-server >/dev/null 2>&1; then
        echo "RabbitMQ installed successfully: $(rabbitmq-server --version)"
else
    echo "RabbitMQ is not installed. Installing..."
    curl -fsSL https://dl.rabbitmq.com/DEB-RabbitMQ.asc | sudo apt-key add -
echo "deb https://dl.bintray.com/rabbitmq/debian focal main" | sudo tee /etc/apt/sources.list.d/rabbitmq.list
    sudo apt-get update
    sudo apt-get install -y rabbitmq-server
    sudo systemctl enable --now rabbitmq-server

    # Verify installation
    if command -v rabbitmq-server >/dev/null 2>&1; then
        echo "RabbitMQ installed successfully: $(rabbitmq-server --version)"
    else
        echo "RabbitMQ installation failed."
        exit 1
    fi
fi

echo "RabbitMQ setup complete."









