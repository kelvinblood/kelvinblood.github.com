---
layout: post
title: docker 查看最近日志
category: tech
tags: docker
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

# 背景

使用容器时常常需要看日志，但是有些日志刷了很多，这时候单纯用 `docker logs -f`会刷很多日志，而没办法停止。解决的问题其实使用 tail 标志就可以了：



```
docker logs -f --tail 20 <container-id>
```