!/bin/bash

# Update the apt package index and install packages to allow apt to use a repository over HTTPS
sudo apt-get update 

# Install apache2
sudo apt -y install apache2
echo "<!doctype html><html><body><h1>Hello world from $(hostname) $(hostname -i)</h1></body></html>" | sudo tee /var/www/html/index.html

#sudo apt install apt-transport-https ca-certificates curl software-properties-common
