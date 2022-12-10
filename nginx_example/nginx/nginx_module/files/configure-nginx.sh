#!/bin/bash

# Update apt cache.
sudo apt-get update

# Install NFS and mount share
sudo apt-get install -y nfs-common
sudo mkdir -p /mount/$1/webshare
sudo mount -t nfs $1.privatelink.file.core.windows.net:/$1/webshare /mount/$1/webshare -o vers=4,minorversion=1,sec=sys

# Install Nginx.
sudo apt-get install -y nginx

# Set the home page.
echo "<html><body><h2>Welcome to Azure! My name is $(hostname).</h2></body></html>" | sudo tee -a /var/www/html/index.html