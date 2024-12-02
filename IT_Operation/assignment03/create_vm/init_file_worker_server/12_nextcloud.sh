!/bin/bash

#### download and unpack Nextcloud Archiv
# Aktuellstes Nextcloud-Archiv herunterladen
wget https://download.nextcloud.com/server/releases/latest.zip -O /tmp/nextcloud-latest.zip

# Archiv entpacken
unzip /tmp/nextcloud-latest.zip -d /tmp/

# Verschieben in das Apache2-Basisverzeichnis
sudo mv /tmp/nextcloud /var/www/

# Aufräumen (entfernen des Archivs)
rm /tmp/nextcloud-latest.zip

# Eigentümer ändern, damit der Webserver Zugriff hat
sudo chown -R www-data:www-data /var/www/nextcloud

# Berechtigungen setzen
sudo chmod -R 750 /var/www/nextcloud


####  Apache Web server configuration for NextCloud
sudo bash -c 'cat > /etc/apache2/sites-available/nextcloud.conf <<EOF
Alias /nextcloud "/var/www/nextcloud/"

<VirtualHost *:80>
  DocumentRoot /var/www/nextcloud/
  ServerName  your.server.com

  <Directory /var/www/nextcloud/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews

    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>
EOF'

# Apache2 Konfiguration aktivieren
sudo a2ensite nextcloud.conf
sudo a2enmod rewrite headers env dir mime
sudo systemctl restart apache2


#### Datenverzeichnis für Nextcloud User
# Erstellt einen Ordner für die Daten der Nextcloud User in /mnt/nextcloud-data.

sudo mkdir -p /mnt/nextcloud-data
sudo chown -R www-data:www-data /mnt/nextcloud-data
sudo chmod 750 /mnt/nextcloud-data