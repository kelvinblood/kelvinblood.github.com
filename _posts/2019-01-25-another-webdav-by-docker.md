---
layout: post
title: 又一个 webdav 服务器
category: tech
tags: docker
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

# 背景

前几天记录了一篇关于 webdav 的文章，但那个 webdav 我始终无法解决写数据的问题。于是又找到了这个 webdav，虽然也有瑕疵，
不过总算满足了目前写文件的需求。

# 搭建 WebDAV

编辑 docker-compose.yml 文件：

```bash
version: '3.2'

  webdav-zotero:
    image: morrisjobke/webdav
    container_name: webdav-zotero
    environment:
      USERNAME: kelu
      PASSWORD: kelu
    volumes:
      - zotero:/var/webdav/zotero
    restart: always
    ports:
      - "8080:80"
```

用户名密码均为 kelu, 运行即可。

```bash
docker-compose up -d
```

使用 http://ip:8080/webdav 即可访问到服务。
