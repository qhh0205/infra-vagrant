# !/bin/bash

docker run --detach \
    --hostname localhost \
    --publish 443:443 --publish 80:80 \
    --name gitlab \
    --restart always \
    --volume gitlab_config:/etc/gitlab \
    --volume gitlab_logs:/var/log/gitlab \
    --volume gitlab_data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest

exit 0
