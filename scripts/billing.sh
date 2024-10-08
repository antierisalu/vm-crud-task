#!/bin/bash
#billing.sh

if ! /vagrant/scripts/checkPostgres.sh; then
    echo "PostgreSQL check failed."
    exit 1
fi

if /vagrant/scripts/checkNodeNpm.sh; then
    cd $BILLING_DIR || exit

    if [ -d "node_modules" ]; then
        echo "Local dependencies probably installed."
    else
        echo "Installing local dependencies..."
        npm install express amqplib dotenv
    fi
else
    echo "Node.js and npm check failed."
    exit 1
fi

# Check for RabbitMQ
if command -v rabbitmqctl >/dev/null 2>&1; then
        echo "RabbitMQ installed successfully: $(rabbitmqctl --version)"
else
    echo "RabbitMQ is not installed. Installing..."
    curl -fsSL https://dl.rabbitmq.com/DEB-RabbitMQ.asc | sudo apt-key add -
echo "deb https://dl.bintray.com/rabbitmq/debian focal main" | sudo tee /etc/apt/sources.list.d/rabbitmq.list
    sudo apt-get update
    sudo apt-get install -y rabbitmq-server
    sudo systemctl enable rabbitmq-server
    sudo systemctl start rabbitmq-server
    
    # Verify installation
    if command -v rabbitmq-server >/dev/null 2>&1; then
        echo "RabbitMQ installed successfully: $(rabbitmq-server --version)"
    else
        echo "RabbitMQ installation failed."
        exit 1
    fi
fi










