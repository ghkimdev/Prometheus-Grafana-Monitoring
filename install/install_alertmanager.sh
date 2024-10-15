#!/bin/bash

ALERTMANAGER_VERSION=0.27.0
ALERTMANAGER_HOME=/opt/alertmanager
ALERTMANAGER_CONFIG=${ALERTMANAGER_HOME}/alertmanager.yml

cd /opt
wget https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz
tar -xvf alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz
mv alertmanager-${ALERTMANAGER_VERSION}.linux-amd64 alertmanager
rm alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz
mkdir -p ${ALERTMANAGER_HOME}/logs

cat <<EOF > ${ALERTMANAGER_HOME}/startup.sh
#!/bin/bash

nohup ${ALERTMANAGER_HOME}/alertmanager --config.file=${ALERTMANAGER_CONFIG} > ${ALERTMANAGER_HOME}/logs/alertmanager.log 2>&1 &
echo "\$!" > ${ALERTMANAGER_HOME}/alertmanager.pid
EOF

cat <<EOF > ${ALERTMANAGER_HOME}/shutdown.sh
#!/bin/bash

pkill -F ${ALERTMANAGER_HOME}/alertmanager.pid
rm -f ${ALERTMANAGER_HOME}/alertmanager.pid
EOF


chmod +x ${ALERTMANAGER_HOME}/startup.sh
chmod +x ${ALERTMANAGER_HOME}/shutdown.sh
