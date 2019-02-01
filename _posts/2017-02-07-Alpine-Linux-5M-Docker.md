---
layout: post
title: 转载 | Alpine Linux，一个只有5M的Docker镜像
category: tech
tags: docker linux
---

![](https://cdn.kelu.org/blog/tags/docker.jpg)

Alpine Linux Docker镜像基于Alpine Linux操作系统，后者是一个面向安全的轻型Linux发行版。不同于通常Linux发行版，Alpine Linux采用了musl libc和busybox以减小系统的体积和运行时资源消耗。在保持瘦身的同时，Alpine Linux还提供了自己的包管理工具apk，可以在其网站上[查询][alpine-packages]，或者直接通过apk命令查询和安装。

Alpine Linux Docker镜像也继承了Alpine Linux发行版的这些优势。相比于其他Docker镜像，它的容量非常小，仅仅只有5M，且拥有非常友好的包管理器。

下表是一些官方镜像的大小：

|镜像名称|大小（MB）|
|---|---|
|ubuntu:latest|187.9|
|debian:latest|125.1|
|centos:latest|196.6|
|alpine|4.794|

除了小，Alpine镜像的另外一大优势就是内置完整包管理器。相较于其他微型基础镜像（如busybox，基础镜像大小为1.113MB），拥有一个包管理器，可以快速构建应用镜像。例如这个dnsmasq镜像，Dockerfile非常简单，仅仅运行了Alpine提供的apk工具安装了dnsmasq包即可：

    FROM alpine:3.2
    RUN apk -U add dnsmasq
    EXPOSE 53 53/udp
    ENTRYPOINT ["dnsmasq", "-k"]
    
# 使用

由于Alpine Linux有完整的包管理器，其使用方式和其他的基础镜像类似，直接使用其包管理命令apk即可。

如README中例子，如果需要安装一个mysql客户端，只需要创建如下Dockerfile：

    FROM gliderlabs/alpine:3.3
    RUN apk add --no-cache mysql-client
    ENTRYPOINT ["mysql"]
    
然后通过docker build命令，即可构建出自己的mysql客户端。同样，基于Alpine Linux构建出来的镜像，有其空间上的巨大优势：

    docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    alpine/mysql        latest              edf988b8f4c8        58 seconds ago      35.74 MB
    
# 争论

对于Alpine Linux，Hacker News上争论还是比较激烈的。

首先是空间占用问题，小是Alpine Linux的最大优势，但是Docker的文件系统可以进行分层缓存，对于已经构建或者拉取过镜像的机器来说，每次的增量更新内容可能并不会很多。也就是说，如果所有镜像都使用相同的基础镜像，这个镜像在所有机器上都只会拉取一遍。

另外，Alpine Linux使用了musl，可能和其他Linux发行版使用的glibc实现会有所不同。在容器化中最可能遇到的是DNS问题，即musl实现的DNS服务不会使用resolv.conf文件中的search和domain两个配置，这对于一些通过DNS来进行服务发现的框架可能会遇到问题。

# 总结

Alpine Linux，一个只有5M的Docker镜像，它尽可能的简化了镜像的大小，易于分发，有着完善的包管理器和预编译的包。如果你需要一个干净、简洁的容器，开始尝试使用吧！

转载自 [infoQ][infoq]

[infoq]: http://www.infoq.com/cn/news/2016/01/Alpine-Linux-5M-Docker
[alpine-packages]: https://pkgs.alpinelinux.org/packages
