#!/bin/bash

# Update apt cache.
sudo apt-get update

# Install NFS and mount share
sudo apt-get install -y nfs-common
sudo mkdir -p /mount/$1/webshare
sudo mount -t nfs $1.privatelink.file.core.windows.net:/$1/webshare /mount/$1/webshare -o vers=4,minorversion=1,sec=sys

# Install NGINX
sudo apt-get install -y nginx

# Change the NGINX configuration to use file share for webcontent
sudo sed -i 's+/var/www/html+/mount/$1/webshare+g' /etc/nginx/sites-available/default

# Restart NGINX
sudo systemctl restart nginx