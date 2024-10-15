#!/bin/bash

GRAFANA_VERSION=11.2.2
GRAFANA_HOME=/opt/grafana
GRAFANA_CONFIG=${GRAFANA_HOME}/grafana.yml

cd /opt
wget -q https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz
tar -zxf grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz
mv grafana-v${GRAFANA_VERSION} grafana
rm grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz
mkdir -p ${GRAFANA_HOME}/logs

cat <<EOF > ${GRAFANA_HOME}/startup.sh
#!/bin/bash

nohup ${GRAFANA_HOME}/bin/grafana server --config.file=${GRAFANA_CONFIG} > ${GRAFANA_HOME}/logs/grafana.log 2>&1 &
echo "\$!" > ${GRAFANA_HOME}/grafana.pid
EOF

cat <<EOF > ${GRAFANA_HOME}/shutdown.sh
#!/bin/bash

pkill -F ${GRAFANA_HOME}/grafana.pid
rm -f ${GRAFANA_HOME}/grafana.pid
EOF


chmod +x ${GRAFANA_HOME}/startup.sh
chmod +x ${GRAFANA_HOME}/shutdown.sh
