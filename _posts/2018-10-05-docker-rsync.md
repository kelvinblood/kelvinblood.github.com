---
layout: post
title: 在 Docker 中运行 rsync 服务端和客户端
category: tech
tags: docker linux rsync
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

# 背景

最近给服务器组件全部用上了容器化，为了统一管理，也使用了 rsync 的容器化版本。我在早前的文章里——[《搭建 rsync 服务器》](/tech/2017/10/05/rsync-server.html)也有介绍过 rsync，只不过我是用的是常用的二进制安装的版本。

# 什么是 rsync

**rsync命令**是一个远程数据同步工具，可通过LAN/WAN快速同步多台主机间的文件。rsync使用“rsync算法”来使本地和远程两个主机之间的文件达到同步，这个算法只传送两个文件的不同部分，而不是每次都整份传送，因此速度相当快。

# 方案

rsync包括两个部分：服务端和客户端。下面我分别介绍两者的容器化方案，均为网上开源的项目，我仅在使用的时候做了少量修改。

## 服务端

[axiom](https://hub.docker.com/u/axiom/)/[rsync-server](https://hub.docker.com/r/axiom/rsync-server/)

自定义很强的服务端，从官方的readme中也体现出来了。根据我的需要，我做了一个简单的调整，在需要同步的文件夹下运行如下 docker run 命令，便运行一个 rsync 服务端。需要注意的是将防火墙上相应的端口打开。

```
!/bin/bash

docker run -d --name=rsync-server-$(basename $(pwd)) \
    -v $(pwd):/backup \
    -e VOLUME=/backup \
    -v /root/.ssh/authorized_keys:/root/.ssh/authorized_keys \
    -p 10022:22 \
    axiom/rsync-server
```

在上面的命令中，我启动了一个主机端口映射为10022的rsync-server的容器。

## 客户端

参考了掘金的这篇文章[《通过Docker中运行rsync备份服务器》](https://juejin.im/entry/5ae2a4686fb9a07aac242e5b)，将相关参数写到了docker-compose文件里，事先定义好ssh登陆密钥和config文件，在同级目录下运行 `docker-compose up -d`即可。

ssh配置:

```
Host    cdn
  HostName        backup1.kelu.org
  Port            10022
  User            root
  IdentityFile    ~/.ssh/db
Host    db
  HostName        backup1.kelu.org
  Port            10023
  User            root
  IdentityFile    ~/.ssh/db
```

在ssh的配置中，我定义了一个db和一个cdn的连接，并指定端口和登陆密钥。端口为上文中定义好的10022端口和10023端口。



docker-compose.yml:

```
version:  '3.2'
services:
  rsync:
    image: instrumentisto/rsync-ssh
    restart: always
    volumes:
      - ${HOME}/.ssh:/root/.ssh
      - /backup:/backup
    entrypoint:
      - /bin/sh
      - -c
      - |
        function log() {
          echo -e "`date -d @$$((\`date +%s\`+3600*8)) '+%Y-%m-%d %H:%M:%S'` $$@"
        }

        # backup <备份名> <服务器地址>
        function backup() {
          log "============================"
          log "begin: $$1"
          rsync -az --timeout=3600 -P --partial --delete -e ssh $$2:/backup /backup/$$2
          log "end: $$1"
        }

        while true
        do
          backup "cdn" cdn
          backup "db" db
          sleep 3000
        done
```

使用以下命令运行客户端：

```
docker-compose up -d
```

可以使用 docker logs -f xxx 命令来查看同步日志。

整个过程还是非常顺利的，没有遇到特别的问题。

# 参考资料

* [axiom](https://hub.docker.com/u/axiom/)/[rsync-server - github](https://hub.docker.com/r/axiom/rsync-server/)
* [通过Docker中运行rsync备份服务器](https://juejin.im/entry/5ae2a4686fb9a07aac242e5b)
* [搭建 rsync 服务器](/tech/2017/10/05/rsync-server.html)

