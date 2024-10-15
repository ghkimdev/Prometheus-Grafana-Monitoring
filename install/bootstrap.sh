#!/bin/bash

# Set hosts file
sed -i "/127.0.2.1/d" /etc/hosts

cat <<EOF | tee -a /etc/hosts > /dev/null
172.16.2.101 monitor01.example.com monitor01
172.16.2.102 monitor02.example.com monitor02
172.16.2.103 monitor03.exampll.com monitor03
172.16.2.111 db01.example.com db01
172.16.2.112 db02.example.com db02
EOF

# Enable ssh password authentication
echo "Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd

apt install -qq sshpass

chown -R vagrant:vagrant /opt
