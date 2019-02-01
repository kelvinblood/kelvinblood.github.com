---
layout: post
title: docker iptable 清空后如何重置容器网络
category: tech
tags: docker iptable
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

相信有人也遇到过，在做一些iptable 相关操作时，直接 `iptable -F`将其清空后的，容器网络无法使用的。

重建docker网络即可。具体步骤如下:

```
# 安装brctl 
apt-get install bridge-utils
yum install bridge-utils

# 停止docker服务
systemctl stop docker

# 重建 docker 网络
ifconfig docker0 down
brctl delbr docker0

# 重启docker服务
systemctl start docker
```

