---
layout: post
title: 在 Docker 中运行 dropbox 客户端
category: tech
tags: docker linux
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

# 背景

最近给服务器组件全部用上了容器化，为了统一管理，参考 dropbox 命令行脚本做了一个容器化的客户端。

# 方案

Dropbox命令行脚本可参考原先我记录的文章——[《在Linux上使用dropbox》](/tech/2015/10/09/set-up-dropbox-on-your-linux.html)。

我已经创建好了镜像，两步便可成功：

1. 启动容器：

   映射两个文件夹即可，一个是内容文件夹，一个是配置文件夹：

   ```
   docker run --name=dropbox -d \
     -v /root/Dropbox:/root/Dropbox \
     -v /root/.dropbox:/root/.dropbox \
     kelvinblood/dropbox
   ```

2. 关联账号

   ```
   docker logs -f dropbox
   ```

   查看容器的日志，然后浏览器访问认证链接：

   ```
   This computer isn't linked to any Dropbox account...
   Please visit https://www.dropbox.com/cli_link_nonce?nonce=e184433d7baeda90883461fecf1f3b8e to link this device.
   ```

   访问链接即可。

在运行过程中，可以直接使用命令行查看同步情况：

```
docker exec dropbox python /dropbox.py status
```

# 实现细节

我已经放到github上去了，可以直接参考：[kelvinblood/**docker-dropbox**](https://github.com/kelvinblood/docker-dropbox)

dockerfile：

```
FROM python:2-slim-jessie

ADD src/* /

RUN apt-get update \
    && apt-get install -y wget \
    && wget "https://www.dropbox.com/download?plat=lnx.x86_64" \
    && mv download\?plat=lnx.x86_64 dropbox.tgz \
    && tar xzf dropbox.tgz \
    && rm dropbox.tgz

WORKDIR /root
ENTRYPOINT ["/.dropbox-dist/dropboxd"]
```

# 参考资料

* [《在Linux上使用dropbox》](/tech/2015/10/09/set-up-dropbox-on-your-linux.html)

