# Aufgabe 1: Prometheus Instanz auf einer neuen VM einrichten

Erstelle eine neue VM mit einem Linux-Betriebssystem.
Öffne den Port 9090 (Standardport von Prometheus) in der Firewall

Aktualisiere die Paketliste und installiere erforderliche Paket.

Lade die neueste Version von Prometheus herunter.

Entpacke das Prometheus-Archive.

Erstelle eine Konfigurationsdatei prometheus.yml oder passe die bestehende an.

Erstelle eine Systemd-Service-Datei: /etc/systemd/system/prometheus.service

```
[Unit]
Description=Prometheus
After=network.target

[Service]
User=prometheus
ExecStart=/path/to/prometheus --config.file=/path/to/prometheus.yml
Restart=always

[Install]
WantedBy=multi-user.target
```


Setze Prometheus als Dienst auf:
- sudo systemctl daemon-reload
- sudo systemctl enable prometheus
- sudo systemctl start Prometheus

# Aufgabe 2 Node Exporter installieren

Lade Node Exporter herunter:
- wget https://github.com/prometheus/node_exporter/releases/latest/download/node_exporter-*.linux-amd64.tar.gz
- tar xvf node_exporter-*.linux-amd64.tar.gz
- sudo mv node_exporter-*.linux-amd64/node_exporter /usr/local/bin/

Node Exporter als Dienst einrichten
- Erstelle eine Systemd-Service-Datei
- Starte und aktiviere den Dienst





# Aufgabe 3 Apache Exporter installieren

Lade Apache Exporter herunter

Apache Exporter konfigurieren: Stelle sicher, dass Apache2 mod_status aktiviert hat:
- sudo a2enmod status

Bearbeite /etc/apache2/mods-enabled/status.conf, um Zugriff auf die Statusseite zu erlauben

Starte Apache neu.

Apache Exporter als Dienst einrichten

Erstelle eine Systemd-Service-Datei /etc/systemd/system/apache_exporter.service:

Starte den Dienst:

Firewall anpassen



# Aufgabe 4 Nextcloud Exporter installieren

Es gibt keinen offiziellen Nextcloud Exporter von Prometheus.

Nehmt eine Open Source Lösung (Google oder ChatGPT helfen)