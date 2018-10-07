# !/bin/bash

set -e
set -x

# 配置各节点 http 代理科学上网
cat /vagrant/http_proxy.cfg >> /etc/profile && source /etc/profile
echo $http_proxy

# 禁用防火墙
systemctl stop firewalld

# 临时关闭 selinux（不需要重启主机）
# setenforce 0 : 设置SELinux 成为 permissive 模式
# setenforce 1 : 设置SELinux 成为 enforcing 模式
setenforce 0

# 永久关闭 selinux（需要重启主机才能生效）
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# 临时禁用 swap 分区（不需要重启主机）
swapoff -a

# 永久禁用 swap 交换分区（重启主机后 swap 分区不会自动挂载）
sed -i '/swap/s/^/#/g' /etc/fstab

# 调整内核网络参数
cp /vagrant/sysctl_k8s.conf /etc/sysctl.d/k8s.conf
modprobe br_netfilter
sysctl -p /etc/sysctl.d/k8s.conf

# 配置 docker 和 kubeadm、kubelet、kubectl 软件源
curl -sS -o /etc/yum.repos.d/docker-ce.repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
cp /vagrant/kubernetes.repo /etc/yum.repos.d
yum clean all && yum makecache

# 安装 docker
yum install --nogpgcheck -y yum-utils device-mapper-persistent-data lvm2
yum install --nogpgcheck -y docker-ce
systemctl enable docker
systemctl start docker
set +e
groupadd docker
usermod -aG docker vagrant
set -e

# 安装 kubelet kubeadm kubectl
yum install --nogpgcheck -y kubelet kubeadm kubectl

exit 0
