---
layout: post
title: docker 清除无用资源
category: tech
tags: docker
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

# 背景

在开发机上运行一段时间的容器后，你能看到有很多的无用容器、磁盘、镜像、网络等，其实大部分都是无用的。这篇文章记录下如何删除无用的资源，以节省磁盘空间。

下文转自：<https://gist.github.com/bastman/5b57ddb3c11942094f8d0a97d461b430>

# 步骤

## 删除磁盘

```
// 参考 https://github.com/chadoe/docker-cleanup-volumes

$ docker volume rm $(docker volume ls -qf dangling=true)
$ docker volume ls -qf dangling=true | xargs -r docker volume rm
```

## 删除网络

```
$ docker network ls  
$ docker network ls | grep "bridge"   
$ docker network rm $(docker network ls | grep "bridge" | awk '/ / { print $1 }')
```

## 删除镜像

```
// 参考 http://stackoverflow.com/questions/32723111/how-to-remove-old-and-unused-docker-images

$ docker images
$ docker rmi $(docker images --filter "dangling=true" -q --no-trunc)

$ docker images | grep "none"
$ docker rmi $(docker images | grep "none" | awk '/ / { print $3 }')
```

## 删除容器

```
// 参考 http://stackoverflow.com/questions/32723111/how-to-remove-old-and-unused-docker-images

$ docker ps
$ docker ps -a
$ docker rm $(docker ps -qa --no-trunc --filter "status=exited")
```

## 整体清除

```
docker system prune -a
```



# 参考资料

* [Prune unused Docker objects](https://docs.docker.com/config/pruning/)