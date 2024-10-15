#!/bin/bash

NODE_EXPORTER_VERSION=1.8.2
NODE_EXPORTER_HOME=/opt/node_exporter
NODE_EXPORTER_CONFIG=${NODE_EXPORTER_HOME}/node_exporter.yml

cd /opt
wget -q https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
tar -xzf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
mv node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64 node_exporter
rm node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
mkdir -p ${NODE_EXPORTER_HOME}/logs

cat <<EOF > ${NODE_EXPORTER_HOME}/startup.sh
#!/bin/bash

nohup ${NODE_EXPORTER_HOME}/node_exporter --config.file=${NODE_EXPORTER_CONFIG} > ${NODE_EXPORTER_HOME}/logs/node_exporter.log 2>&1 &
echo "\$!" > ${NODE_EXPORTER_HOME}/node_exporter.pid
EOF

cat <<EOF > ${NODE_EXPORTER_HOME}/shutdown.sh
#!/bin/bash

pkill -F ${NODE_EXPORTER_HOME}/node_exporter.pid
rm -f ${NODE_EXPORTER_HOME}/node_exporter.pid
EOF


chmod +x ${NODE_EXPORTER_HOME}/startup.sh
chmod +x ${NODE_EXPORTER_HOME}/shutdown.sh
