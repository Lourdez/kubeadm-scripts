#!/bin/bash

set -e

echo "Updating package list..."
apt update

echo "Installing dependencies..."
apt install -y curl gnupg apt-transport-https

echo "Adding Erlang and RabbitMQ signing keys..."
curl -fsSL https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | apt-key add -
curl -fsSL https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey | apt-key add -

echo "Adding Erlang and RabbitMQ repositories..."
echo "deb https://packages.erlang-solutions.com/ubuntu $(lsb_release -cs) contrib" > /etc/apt/sources.list.d/erlang.list
echo "deb https://packagecloud.io/rabbitmq/rabbitmq-server/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/rabbitmq.list

echo "Updating package list again..."
apt update

echo "Installing Erlang and RabbitMQ..."
apt install -y erlang-base \
                erlang-asn1 erlang-crypto erlang-eldap erlang-ftp \
                erlang-inets erlang-mnesia erlang-os-mon erlang-parsetools \
                erlang-public-key erlang-runtime-tools erlang-snmp \
                erlang-ssl erlang-syntax-tools erlang-tools erlang-xmerl \
                rabbitmq-server

echo "Enabling RabbitMQ service..."
systemctl enable rabbitmq-server

echo "Cleaning up..."
apt clean
rm -rf /var/lib/apt/lists/*

echo "RabbitMQ installation completed."