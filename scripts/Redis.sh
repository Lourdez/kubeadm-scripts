#!/bin/bash

set -e

echo "Updating package list..."
apt update

echo "Installing Redis server..."
apt install -y redis-server

echo "Enabling Redis to start on boot..."
systemctl enable redis-server

# Optional: Tweak Redis config if needed
# sed -i 's/^supervised .*/supervised systemd/' /etc/redis/redis.conf

echo "Cleaning up..."
apt clean
rm -rf /var/lib/apt/lists/*

echo "Redis installation completed."