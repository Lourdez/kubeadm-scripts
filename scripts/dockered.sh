#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Updating existing list of packages..."
sudo apt-get update -y

echo "Installing prerequisite packages..."
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

echo "Adding Docker’s official GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "Setting up the Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating package index with Docker packages..."
sudo apt-get update -y

echo "Installing Docker Engine, CLI, containerd..."
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

echo "Docker installation complete."

echo "Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Adding current user to docker group (you may need to log out and back in)..."
sudo usermod -aG docker $USER

echo "Verifying Docker installation..."
docker --version