# !/bin/bash

# Docker pull 加速
echo 'DOCKER_OPTS="--registry-mirror=https://registry.docker-cn.com"' >> /etc/default/docker
service docker restart

# Docker Jenkins
docker run \
  -u root \
  --name jenkins-blueocean \
  --rm \
  -d \
  -p 7070:7070 \
  -v jenkins-data:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkinsci/blueocean

sleep 15
# Jenkins 初始密码
docker logs jenkins-blueocean

exit 0
