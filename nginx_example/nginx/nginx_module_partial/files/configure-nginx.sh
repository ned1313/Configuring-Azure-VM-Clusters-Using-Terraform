#!/bin/bash

# Update apt cache.
sudo apt-get update

# Install NFS and mount share
sudo apt-get install -y nfs-common
sudo mkdir -p /mount/$1/webshare
sudo mount -t nfs $1.privatelink.file.core.windows.net:/$1/webshare /mount/$1/webshare -o vers=4,minorversion=1,sec=sys

# Install NGINX
sudo apt-get install -y nginx

# Create index html file and copy to file share
if [ $2 = "true" ]
then
  if [ -f /mount/$1/webshare/index.html ]
  then
    echo "File already exists"
  else
    echo "<html><body><h2>NGINX on NFS successful! File created by $(hostname).</h2></body></html>" | sudo tee -a /mount/$1/webshare/index.html
  fi
fi

# Change the NGINX configuration to use file share for webcontent
sudo sed -i "s+/var/www/html+/mount/$1/webshare+g" /etc/nginx/sites-available/default

# Restart NGINX
sudo systemctl restart nginx
