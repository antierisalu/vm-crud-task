#!/bin/bash

service="$1"
PROJECT_DIR="/vagrant/$service"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Unknown service '$service'. Directory /vagrant/$service does not exist."
    exit 1
fi

cd "$PROJECT_DIR" || exit 1

if [ "$service" = "billing" ]; then
    pm2 start consumer.js --name "consumer" -- start
    pm2 start server.js --name "billing" -- start
else
    pm2 start npm --name "$service" -- start
fi

pm2 save
