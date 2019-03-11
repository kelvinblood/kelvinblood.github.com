---
layout: post
title: calico 入门
category: tech
tags: network calico
---

![](https://cdn.kelu.org/blog/tags/network.jpg)

### 1. 配置安装 docker 参数

修改文件 `/etc/docker/daemon.json` ，需要添加 `cluster-store` 参数，支持多节点网络：

```
{
  "cluster-store": "etcd://172.17.8.100:2379"
}
```

然后重启 docker 服务，比如 `systemctl restart docker`，保证 docker 正常运行。

### 2. 下载 calicoctl 命令行

calico 提供的 `calicoctl` 命令行工具：

```
set -e;
mkdir -p /etc/calico/
cp calicoctl.cfg /etc/calico/calicoctl.cfg

cd /usr/bin
wget https://github.com/projectcalico/calicoctl/releases/download/v3.4.0/calicoctl
chmod +x calicoctl

echo "alias cc=\"calicoctl\"" >> ~/.bashrc
echo "alias ccnode=\"calicoctl get nodes -owide\"" >> ~/.bashrc
echo "alias ccstatus=\"calicoctl node status\"" >> ~/.bashrc
```

在这里我加上了 cc 的缩写，方便命令行使用。



### 2. 配置calicoctl 文件

calico 提供的 `calicoctl` 命令行工具。运行的 calico 需要和 etcd 进行交互，因此要事先配置 etcd 的地址以便 calicoctl 使用。calicoctl 有一个配置文件 `/etc/calico/calicoctl.cfg`，往里面写入如下内容，etcd 地址根据需求更改：

```
# cat /etc/calico/calicoctl.cfg 
apiVersion: v1
kind: calicoApiConfig
metadata:
spec:
  datastoreType: "etcdv2"
  etcdEndpoints: "http://172.17.8.100:2379"
```

### 

上述命令下载的是 1.6.1 版本，如果需要其他版本请按照[官方指导](https://github.com/projectcalico/calicoctl/releases)下载。

### 5. 配置 calicoctl 文件

运行的 calico 需要和 etcd 进行交互，因此要事先配置 etcd 的地址以便 calicoctl 使用。calicoctl 有一个配置文件 `/etc/calico/calicoctl.cfg`，往里面写入如下内容，etcd 地址根据需求更改：

```
# cat /etc/calico/calicoctl.cfg 
apiVersion: v1
kind: calicoApiConfig
metadata:
spec:
  datastoreType: "etcdv2"
  etcdEndpoints: "http://172.17.8.100:2379"
```

### 6. 运行 calico 节点容器

calicoctl 会运行一个 docker 容器来运行 calico，容器镜像默认放在 `quay.io/calico/node:latest` 上面，在国内需要代理访问，也可以自行创建维护镜像或者事先下载好，这样的话就要把容器镜像指向自己维护的版本：

```
[root@localhost ~]# calicoctl node run --ip=172.17.8.101 --name node01 --node-image 172.16.1.41:5000/calico/node:v2.6.0
Running command to load modules: modprobe -a xt_set ip6_tables
Enabling IPv4 forwarding
Enabling IPv6 forwarding
Increasing conntrack limit
Removing old calico-node container (if running).
Running the following command to start calico-node:

docker run --net=host --privileged --name=calico-node -d --restart=always -e CALICO_LIBNETWORK_ENABLED=true -e IP=172.17.8.101 -e ETCD_ENDPOINTS=http://172.17.8.100:2379 -e NODENAME=node01 -e CALICO_NETWORKING_BACKEND=bird -v /var/log/calico:/var/log/calico -v /var/run/calico:/var/run/calico -v /lib/modules:/lib/modules -v /run:/run -v /run/docker/plugins:/run/docker/plugins -v /var/run/docker.sock:/var/run/docker.sock 172.16.1.41:5000/calico/node:v2.6.0

Image may take a short time to download if it is not available locally.
Container started, checking progress logs.

Skipping datastore connection test
Using IPv4 address from environment: IP=172.17.8.101
IPv4 address 172.17.8.101 discovered on interface enp0s8
No AS number configured on node resource, using global value
Created default IPv4 pool (192.168.0.0/16) with NAT outgoing true. IPIP mode: off
Created default IPv6 pool (fd80:24e2:f998:72d6::/64) with NAT outgoing false. IPIP mode: off
Using node name: node01
Starting libnetwork service
Calico node started successfully
```

运行的命令指定了三个参数：

- `--ip`：集群内节点用来互相通信的 IP 地址，如果要多个网卡或者网卡有多个 ip 地址最好手动指定。calicoctl 默认会自动选择这个 IP 地址，要实现自动化可以参考它的 IP 选择配置
- `--name`：唯一标识该节点的字符串，如果没有提供会使用 hostname，因此**务必要保证 hostname 的唯一性**
- `--node-image`：calico node 的镜像地址，默认会从 `quay.io` 下载最新版本，如果想使用特定版本或者其他地址的镜像，需要手动指定

从命令的输出可以看到，calicoctl 在运行容器之前还做了很多初始化的工作，比如加载需要的模块、配置系统参数、删除已经运行的 calico 容器（如果存在的话）；然后还会打印出来要运行的容器命令，所以理论上也可以手动执行这个命令；最后是运行使用的参数说明。



# 参考资料

* [docker容器网络方案：calico网络模型](http://cizixs.com/2017/10/19/docker-calico-network/)
