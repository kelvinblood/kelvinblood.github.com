---
layout: post
title: Docker on Windows Operation not permitted
category: tech
tags: windows docker
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

先前分享了一个容器化的开发环境——[kelvinblood/**docker-lnmp**](https://github.com/kelvinblood/docker-lnmp)，在 mac 下运行无碍，可是跑到Windows下运行的时候，sock 的文件映射就出了问题：

```
2018/09/17 02:39:54 [crit] 6#6: *2 connect() to unix:/sock/www.sock failed (2: No such file or directory) while connecting to upstream, client: 10.0.75.1, server: , request: "GET / HTTP/1.1", upstream: "fastcgi://unix:/sock/www.sock:", host: "10.0.75.2:8000"
```

让我疑惑的是，我还有很多的映射，都是ok的，比如log，怎么单单就这个 sock 出了问题？

谷歌了一番，发现 **mongo** 项目里也有很多人吐槽这个情况，看来并不是我一个人的问题。众多issue里发现了这个靠谱的中文答案：[win10下部署报错:Operation not permitted, terminating #7](https://github.com/easy-mock/easy-mock-docker/issues/7#issuecomment-399405207)

```
windows下只能使用volume，不能直接bind磁盘。

创建volume
docker volume create mongodata
docker volume create redisdata
docker volume create logsdata


将docker-compose.yml修改如下
version: "3.3"
...
    image: redis:4.0.6
    command: redis-server --appendonly yes
    volumes:
      - type: volume
        source: redisdata
        target: /data
...

# 一定要声明volumes
volumes:
  redisdata:
    external:
      name: redisdata
      
      
删除production.js中的db配置
运行docker-compose up -d
```

确实如此。我的修改在这个提交里可以参考：

[[bugfix\] use sock must use bind type for windows mount volume in dock…](https://github.com/kelvinblood/docker-lnmp/commit/8a45d278ac431f491bc719d6946dc6f5fa69f2d6)

![](https://cdn.kelu.org/blog/2018/09/18141034.jpg)