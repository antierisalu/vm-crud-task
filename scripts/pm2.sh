#!/bin/bash

echo "ARGUMENT:$1"

BILLING_DIR=/vagrant/billing
INVENTORY_DIR=/vagrant/inventory
GATEWAY_DIR=/vagrant/api-gateway

case "$1" in
    "billing")
        SERVICE_NAME="billing"
        PROJECT_DIR="$BILLING_DIR"
        ;;
    "inventory")
        SERVICE_NAME="inventory"
        PROJECT_DIR="$INVENTORY_DIR"
        ;;
    "gateway")
        SERVICE_NAME="gateway"
        PROJECT_DIR="$GATEWAY_DIR"
        ;;
    *)
        echo "Error: Unknown service '$1'. Supported services are: billing, inventory, gateway"
        exit 1
        ;;
esac

if [ -z "$PROJECT_DIR" ]; then
    echo "Error: PROJECT_DIR is not set. Make sure the corresponding environment variable is defined."
    exit 1
fi

cd "$PROJECT_DIR" || exit 1

pm2 start npm --name "$SERVICE_NAME" -- start
pm2 save
sudo pm2 startup systemd -u vagrant --hp /home/vagrant
pm2 save
