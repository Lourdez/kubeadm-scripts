#!/bin/bash

set -e

echo "Updating packages..."
sudo apt update && sudo apt upgrade -y

echo "Installing dependencies..."
sudo apt install -y build-essential tcl curl

echo "Downloading Redis stable version..."
curl -O http://download.redis.io/redis-stable.tar.gz

echo "Extracting Redis..."
tar xzvf redis-stable.tar.gz
cd redis-stable

echo "Building Redis..."
make
make test
sudo make install

echo "Setting up Redis as a systemd service..."
sudo mkdir -p /etc/redis
sudo cp redis.conf /etc/redis

# Modify the config to allow Redis to run as a background daemon
sudo sed -i 's/^supervised no/supervised systemd/' /etc/redis/redis.conf
sudo sed -i 's|^dir ./|dir /var/lib/redis|' /etc/redis/redis.conf

# Create the systemd unit file
sudo tee /etc/systemd/system/redis.service > /dev/null <<EOF
[Unit]
Description=Redis In-Memory Data Store
After=network.target

[Service]
User=redis
Group=redis
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecStop=/usr/local/bin/redis-cli shutdown
Restart=always

# Set memory limits (optional)
LimitNOFILE=10032

[Install]
WantedBy=multi-user.target
EOF

echo "Creating Redis user and directories..."
sudo adduser --system --group --no-create-home redis
sudo mkdir -p /var/lib/redis
sudo chown redis:redis /var/lib/redis
sudo chmod 770 /var/lib/redis

echo "Starting Redis..."
sudo systemctl daemon-reexec
sudo systemctl enable redis
sudo systemctl start redis

echo "Redis installation complete."
redis-cli ping