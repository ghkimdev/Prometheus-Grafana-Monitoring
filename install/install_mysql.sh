#!/bin/bash

sudo apt update -qq && sudo apt install -y mysql-server
sudo mysql -e "CREATE USER 'exporter'@'localhost' IDENTIFIED BY 'Passw0rd' WITH MAX_USER_CONNECTIONS 3;"
sudo mysql -e "GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'localhost';"


