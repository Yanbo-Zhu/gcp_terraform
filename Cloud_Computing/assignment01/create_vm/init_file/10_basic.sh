!/bin/bash
############################
# Update the apt package index and install packages to allow apt to use a repository over HTTPS
############################
apt install software-properties-common -y # The software-properties-common package includes utilities like add-apt-repository, 
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update && sudo apt upgrade

############################
# ssh configuration
############################

# Append the desired configuration to the file
sudo tee -a /etc/ssh/sshd_config > /dev/null <<EOL

# Custom SSH KeepAlive Settings
TCPKeepAlive no
ClientAliveInterval 1800
ClientAliveCountMax 1800
EOL

# Restart the SSH service to apply the changes
sudo systemctl restart sshd

####################################
# install package
####################################

###### Apache2
# Install apache2
sudo apt -y install apache2
echo "<!doctype html><html><body><h1>Hello world from $(hostname) $(hostname -i)</h1></body></html>" | sudo tee /var/www/html/index.html

# restart apache2
#Startet den apache2 Service nach dem Installieren der PHP Abhängigkeiten neu.
sudo systemctl restart apache2


#### other packages
# Install other packages
sudo apt -y install unzip  

#sudo apt install apt-transport-https ca-certificates curl software-properties-common
