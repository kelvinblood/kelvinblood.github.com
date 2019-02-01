---
layout: post
title: docker 时间同步
category: tech
tags: docker
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

使用 Docker 有一段时间了，经常会遇到 Docker 容器的时间和宿主机时间不同步的问题。造成这个问题的主要原因是 Docker 并没有进行时间设置，默认为格林尼治时间，与我们所在的东八区相隔了 8 个小时。

目前解决这个问题有以下两种思路：

- docker run 时指定启动参数，自动挂载localtime文件到容器内

```
 docker run --name <name> -v /etc/localtime:/etc/localtime:ro  .... 
```

- 在 Dockerfile 中设置

```
ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone
```

# 参考资料

* [如何解决Docker容器和宿主机时间同步问题](https://yq.aliyun.com/articles/30987)
