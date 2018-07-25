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
  -p 7070:8080 \
  -v jenkins-data:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkinsci/blueocean

# Jenkins 初始密码
sh -c 'docker logs -f jenkins-blueocean | { sed "/-->/q" && kill $$ ;}'

echo -e "\033[32m Success: ---------------------------------------------------- \033[0m"
echo -e "\033[32m Success:     Vagrat Docker Jenkins Started Successfully! \033[0m"
echo -e "\033[32m Success: ---------------------------------------------------- \033[0m"

exit 0
