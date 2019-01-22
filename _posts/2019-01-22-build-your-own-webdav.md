---
layout: post
title: 搭建个人 webdav 服务器
category: tech
tags: docker
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

# 背景

对于技术飞速发展的今天来说， webdav 算是一个相对古老的协议，可能一些人也只是瞥过这个单词，并不知道是用来做什么的。由于我iPad上的一个软件 “Document”  的服务中有这样一个协议（还有Dropbox/google drive/SMB/ftp等），想起以前曾经用过 OmniFocuse 这类的应用，也支持自定义的 WebDAV协议，临时起意也起一个自己的 WebDAV 服务。接下来介绍如何使用容器搭建。

# 什么是 WebDAV

首先要了解HTTP协议。 HTTP协议定义了几种请求: GET, POST,PUT等用来下载文件上传数据。

WebDAV 则在标准的HTTP协议上扩展了特有的请求方式: PROPFIND, MOVE, COPY等。 然后用这些请求，操作web服务器上的磁盘，我们可以将其当作网盘来使用。

WebDAV 标准得到了广泛的成功，所有的现代操作系统拥有内置的对普通 WebDAV 的支持，许多流行的应用程序也可以使用 WebDAV，如 Microsoft Office，Dreamweaver 和 Photoshop。

# 搭建 WebDAV

这么成熟的协议docker社区肯定已经有很多相关的镜像了。我使用的是这个镜像： [jgeusebroek/docker-webdav](https://github.com/jgeusebroek/docker-webdav) 。这个镜像基于 alpine并内置了一个轻量的 httpd 服务，已经相当的够用了。

按照作者的描述，简单使用如下命令就可以运行起来了。

```
docker run --restart=always -d
	-p 0.0.0.0:80:80 \
	--hostname=webdav \
	--name=webdav \
	-v /<host_directory_to_share>:/webdav \
	jgeusebroek/webdav
```

默认的账号密码是 webdav/vadbew。当然这样非常不安全。

以下是我的一些自定义配置，可以跟着我往下配置。

在这里我是重写了账号密码（debian系）：

```
#!/bin/bash

apt-get install apache2-utils
htpasswd -c htpasswd kelu
```

我使用 htpasswd 命令创建了一个用户名为 kelu 的 htpasswd 文件，按照提示输入密码，便完成了认证文件的创建。创建一个config文件夹，并将它移入文件夹中：

```
mkdir config
mv htpasswd config
cd config
wget https://github.com/jgeusebroek/docker-webdav/raw/master/files/webdav.conf
```

最后我把默认的webdav的http配置也放到了配置文件夹中。

最后创建 docker-compose.yml 文件：

```
version: '3.2'

services:
  webdav:
    image: jgeusebroek/webdav
    container_name: webdav
    environment:
#      USER_UID: 0
      USER_GID: 50
      READWRITE: 'true'
    volumes:
      - /var/local/document:/webdav
      - ./config:/config
    ports:
      - '39989:80'
    restart: always
```

我将 `/var/local/document` 文件夹作为webdav的主目录，运行：

```
docker-compose up -d
```

便完成了服务的搭建，在 WebDAV 客户端中输入服务器/ip/端口/账号/密码即可访问。



# 参考资料

*  [jgeusebroek/docker-webdav](https://github.com/jgeusebroek/docker-webdav) 