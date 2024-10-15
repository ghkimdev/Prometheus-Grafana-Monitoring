#!/bin/bash

# Install Prometheus
PROMETHEUS_VERSION=2.53.2
PROMETHEUS_HOME=/opt/prometheus
PROMETHEUS_CONFIG=${PROMETHEUS_HOME}/prometheus.yml

cd /opt
wget -q https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
tar -xzf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
mv prometheus-${PROMETHEUS_VERSION}.linux-amd64 prometheus
rm prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz

mkdir -p ${PROMETHEUS_HOME}/logs

cat <<EOF > ${PROMETHEUS_HOME}/startup.sh >> /dev/null
#!/bin/bash
nohup ${PROMETHEUS_HOME}/prometheus --config.file ${PROMETHEUS_CONFIG} > ${PROMETHEUS_HOME}/logs/prometheus.log &
echo "\$!" > ${PROMETHEUS_HOME}/prometheus.pid
EOF

cat <<EOF > ${PROMETHEUS_HOME}/shutdown.sh >> /dev/null
#!/bin/bash
pkill -F ${PROMETHEUS_HOME}/prometheus.pid
rm -f ${PROMETHEUS_HOME}/prometheus.pid
EOF

chmod +x ${PROMETHEUS_HOME}/startup.sh
chmod +x ${PROMETHEUS_HOME}/shutdown.sh

