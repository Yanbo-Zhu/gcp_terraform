!/bin/bash

# Update the apt package index and install packages to allow apt to use a repository over HTTPS
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update && sudo apt upgrade

# Install apache2
sudo apt -y install apache2
echo "<!doctype html><html><body><h1>Hello world from $(hostname) $(hostname -i)</h1></body></html>" | sudo tee /var/www/html/index.html

# Install mariadb-server  
sudo apt -y install mariadb-server libapache2-mod-php php-gd php-mysql php-curl php-mbstring php-intl php-gmp php-bcmath php-xml php-imagick php-zip


# Install other packages
sudo apt -y install unzip  

#sudo apt install apt-transport-https ca-certificates curl software-properties-common
