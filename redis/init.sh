#!/bin/bash
sudo apt-get -y install make
# 安装 gcc 相关编译工具
sudo apt-get install -y build-essential

sudo mkdir /opt/redis

cd /opt/redis
# Use latest stable 下载最新稳定版
sudo wget -q http://download.redis.io/redis-stable.tar.gz
sudo tar zxvf redis-stable.tar.gz

cd redis-stable
make
sudo make install
sudo mkdir -p /etc/redis
sudo mkdir /var/redis
sudo chmod -R 777 /var/redis

sudo cp -u /vagrant/redis.conf /etc/redis/6379.conf
sudo cp -u /vagrant/redis.init.d /etc/init.d/redis_6379
# 添加开机启动脚本
update-rc.d redis_6379 defaults

chmod a+x /etc/init.d/redis_6379
/etc/init.d/redis_6379 start

exit 0
