---
layout: post
title: 容器化 nfs 服务器安装
category: tech
tags: storage nfs
---
![](https://cdn.kelu.org/blog/tags/storage.jpg)

这篇文章记录如何安装和使用容器化的nfs，目前只是临时使用验证某个服务，只记录安装使用过程，不做过多描述。

# 什么是 nfs

它的主要功能是通过网络让不同的机器系统之间可以彼此共享文件和目录。

NFS服务器可以允许NFS客户端将远端NFS服务器端的共享目录挂载到本地的NFS客户端中。一般用来存储共享视频，图片等静态数据。

![](https://cdn.kelu.org/blog/2018/05/nfs_server_client.jpg)





# 安装

1. 加载内核模块 nfs

   ```
   modprobe nfs
   modprobe nfsd
   ```

2. 安装nfs-utils

   ```
   apt-get install nfs-common
   # 或者
   yum install nfs-utils
   ```

3. 安装docker

   ```
   curl -sSL https://get.docker.com/ | sh
   usermod -aG docker $USER
   systemctl enable docker
   systemctl start docker
   ```

3. 准备nfs配置文件

   例如：配置文件位于 /app/exports.txt

   ```
   /nfs        *(rw,fsid=0,sync,no_root_squash)
   ```

4. 运行服务器

   参考[ehough/docker-nfs-server - github](https://github.com/ehough/docker-nfs-server)

   ```
   docker run -d                                   \
     --name nfs                                    \
     -v /app/exports.txt:/etc/exports:ro           \
     -v /nfs:/nfs                                  \
     --cap-add SYS_ADMIN                           \
     -p 2049:2049                                  \
     erichough/nfs-server:latest
   ```

   将主机 /nfs 文件夹作为共享根目录，2049端口开放。

5. 客户端连接

   服务器ip为 172.10.1.100 ，将共享目录挂载到客户端的 /kelu 目录下

   ```
   mount -o nfsvers=4 172.10.1.100:/ /kelu
   ```

# 参考资料

* [Not starting NFS kernel #3](https://github.com/cpuguy83/docker-nfs-server/issues/3)
* [在Kubernetes集群中用Helm托管安装Ceph集群并提供后端存储](https://www.kubernetes.org.cn/3896.html)
* [ehough/docker-nfs-server - github](https://github.com/ehough/docker-nfs-server) 