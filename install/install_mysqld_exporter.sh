#!/bin/bash

MYSQLD_EXPORTER_VERSION=0.15.1
MYSQLD_EXPORTER_HOME=/opt/mysqld_exporter
MYSQLD_EXPORTER_CONFIG=${MYSQLD_EXPORTER_HOME}/mysqld_exporter.cnf

cd /opt
wget -q https://github.com/prometheus/mysqld_exporter/releases/download/v${MYSQLD_EXPORTER_VERSION}/mysqld_exporter-${MYSQLD_EXPORTER_VERSION}.linux-amd64.tar.gz
tar -xzf mysqld_exporter-${MYSQLD_EXPORTER_VERSION}.linux-amd64.tar.gz
mv mysqld_exporter-${MYSQLD_EXPORTER_VERSION}.linux-amd64 mysqld_exporter
rm mysqld_exporter-${MYSQLD_EXPORTER_VERSION}.linux-amd64.tar.gz
mkdir -p ${MYSQLD_EXPORTER_HOME}/logs

cat <<EOF > ${MYSQLD_EXPORTER_CONFIG} 
[client]
host=localhost
port=3306
user=exporter
password=Passw0rd
EOF

cat <<EOF > ${MYSQLD_EXPORTER_HOME}/startup.sh
#!/bin/bash

nohup ${MYSQLD_EXPORTER_HOME}/mysqld_exporter --config.my-cnf ${MYSQLD_EXPORTER_CONFIG} > ${MYSQLD_EXPORTER_HOME}/logs/mysqld_exporter.log 2>&1 &
echo "\$!" > ${MYSQLD_EXPORTER_HOME}/mysqld_exporter.pid
EOF

cat <<EOF > ${MYSQLD_EXPORTER_HOME}/shutdown.sh
#!/bin/bash

pkill -F ${MYSQLD_EXPORTER_HOME}/mysqld_exporter.pid
rm -f ${MYSQLD_EXPORTER_HOME}/mysqld_exporter.pid
EOF


chmod +x ${MYSQLD_EXPORTER_HOME}/startup.sh
chmod +x ${MYSQLD_EXPORTER_HOME}/shutdown.sh
