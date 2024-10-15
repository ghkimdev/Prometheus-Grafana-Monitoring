#!/bin/bash

BLACKBOX_EXPORTER_VERSION=0.25.0
BLACKBOX_EXPORTER_HOME=/opt/blackbox_exporter
BLACKBOX_EXPORTER_CONFIG=${BLACKBOX_EXPORTER_HOME}/blackbox.yml

cd /opt
wget https://github.com/prometheus/blackbox_exporter/releases/download/v${BLACKBOX_EXPORTER_VERSION}/blackbox_exporter-${BLACKBOX_EXPORTER_VERSION}.linux-amd64.tar.gz
tar -xvf blackbox_exporter-${BLACKBOX_EXPORTER_VERSION}.linux-amd64.tar.gz
mv blackbox_exporter-${BLACKBOX_EXPORTER_VERSION}.linux-amd64 blackbox_exporter
rm blackbox_exporter-${BLACKBOX_EXPORTER_VERSION}.linux-amd64.tar.gz
mkdir -p ${BLACKBOX_EXPORTER_HOME}/logs

cat <<EOF > ${BLACKBOX_EXPORTER_HOME}/startup.sh
#!/bin/bash

nohup ${BLACKBOX_EXPORTER_HOME}/blackbox_exporter --config.file=${BLACKBOX_EXPORTER_CONFIG} > ${BLACKBOX_EXPORTER_HOME}/logs/blackbox_exporter.log 2>&1 &
echo "\$!" > ${BLACKBOX_EXPORTER_HOME}/blackbox_exporter.pid
EOF

cat <<EOF > ${BLACKBOX_EXPORTER_HOME}/shutdown.sh
#!/bin/bash

pkill -F ${BLACKBOX_EXPORTER_HOME}/blackbox_exporter.pid
rm -f ${BLACKBOX_EXPORTER_HOME}/blackbox_exporter.pid
EOF


chmod +x ${BLACKBOX_EXPORTER_HOME}/startup.sh
chmod +x ${BLACKBOX_EXPORTER_HOME}/shutdown.sh
