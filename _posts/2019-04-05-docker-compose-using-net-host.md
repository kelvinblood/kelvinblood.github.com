---
layout: post
title: 在 docker-compose 中使用 network:host
category: tech
tags: docker
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

参考docker官方文档： <https://docs.docker.com/compose/compose-file/#net>

平时使用 docker run 命令可以简单使用 --net=host 方式使用主机网络模式，这篇文章记录下在 docker-compose 下如何使用。

### network_mode

在集群模式下无法使用。单机模式下使用如下：

```yaml
network_mode: "bridge"
network_mode: "host"
network_mode: "none"
network_mode: "service:[service name]"
network_mode: "container:[container name/id]"
```

例如：

```yaml
version:  '3.2'
  abc:
    image: abc/edf
    container_name: abc
    restart: always
    network_mode: "host"
```

# 参考资料

* [Docker compose, running containers in net:host](https://stackoverflow.com/questions/35960452/docker-compose-running-containers-in-nethost)

* [Compose file version 3 reference](<https://docs.docker.com/compose/compose-file/#network_mode>)