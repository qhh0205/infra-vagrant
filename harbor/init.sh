# !/bin/bash

set -e

# Docker pull 加速
echo 'DOCKER_OPTS="--registry-mirror=https://registry.docker-cn.com --insecure-registry=192.168.7.11"' >> /etc/default/docker

service docker restart
sleep 30

# 安装 Docker Compose
wget https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -O /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# 安装 Harbor
mkdir -p /opt/harbor
cd /opt/harbor
wget https://storage.googleapis.com/harbor-releases/harbor-offline-installer-v1.5.2.tgz
tar zxvf harbor-offline-installer-v1.5.2.tgz
rm -f harbor-offline-installer-v1.5.2.tgz
cd harbor

# Harbor 存储配置: S3 存储
cat << EOF > common/templates/registry/config.yml
version: 0.1
log:
  level: info
  fields:
    service: registry
storage:
  cache:
    layerinfo: inmemory
  s3:
    accesskey: *****
    secretkey: *****************
    region: us-west-1
    regionendpoint: *********
    bucket: *********
    encrypt: false
    chunksize: 5242880
    multipartcopymaxconcurrency: 100
    rootdirectory: /harbor
  maintenance:
    uploadpurging:
      enabled: false
  delete:
    enabled: true
http:
  addr: :5000
  secret: placeholder
  debug:
    addr: localhost:5001
auth:
  token:
    issuer: harbor-token-issuer
    realm: $public_url/service/token
    rootcertbundle: /etc/registry/root.crt
    service: harbor-registry
notifications:
  endpoints:
  - name: harbor
    disabled: false
    url: $ui_url/service/notifications
    timeout: 3000ms
    threshold: 5
    backoff: 1s
EOF

# Harbor hostname 配置
sed -i 's/^hostname.*/hostname = 192.168.7.11/g' harbor.cfg

# 启动 Harbor
./install.sh

exit 0
