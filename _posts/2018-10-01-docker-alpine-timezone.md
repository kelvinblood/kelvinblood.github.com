---
layout: post
title: Docker Alpine 镜像设置东八区
category: tech
tags: docker alpine
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

# 背景

最近做了一个alpine镜像，需要打印日志，发现打印出来的日志时间不对，需要对它进行时区设置。

镜像基于`postgres:9.4-alpine`

# 什么是 alpine

> Alpine Linux Docker 镜像基于 Alpine Linux操作系统，后者是一个面向安全的轻型Linux发行版。不同于通常Linux发行版，Alpine Linux采用了musl libc和busybox以减小系统的体积和运行时资源消耗。在保持瘦身的同时，Alpine Linux还提供了自己的包管理工具apk，可以在其网站上查询，或者直接通过apk命令查询和安装。
>
> Alpine Linux使用了musl，可能和其他Linux发行版使用的glibc实现会[有所不同](http://wiki.musl-libc.org/wiki/Functional_differences_from_glibc)。在容器化中最可能遇到的是[DNS问题](https://github.com/gliderlabs/docker-alpine/issues/8)，即musl实现的DNS服务不会使用resolv.conf文件中的search和domain两个配置，这对于一些通过DNS来进行服务发现的框架可能会遇到问题。

Alpine Linux Docker 镜像主要特点是容量非常小，只有5M，且拥有非常友好的包管理器。

# 方案

针对我的场景，为 alpine 设置TZ环境变量即可：

```
FROM postgres:9.4-alpine

ENV TZ=Asia/Shanghai
```

而相对于原生的alpine系统，可能需要更多的一些工作，例如安装tzdata，具体做法如下：

```
RUN apk update && apk add ca-certificates && update-ca-certificates && apk add --update tzdata
ENV TZ=Asia/Shanghai
RUN rm -rf /var/cache/apk/*
```

# 参考资料

* [How can I set the timezone please? #136 - github issue](https://github.com/gliderlabs/docker-alpine/issues/136)