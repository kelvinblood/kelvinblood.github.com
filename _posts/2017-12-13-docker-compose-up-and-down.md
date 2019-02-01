---
layout: post
title: docker compose 的 up 与 down
category: tech
tags: docker
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

相关详细内容可以参考官方文档：<https://docs.docker.com/compose/reference/up/>,<https://docs.docker.com/compose/reference/down/>

这一篇文章记录的这个命令，是在主要是在 docker-compose 结束时将镜像也清除掉，避免修改 Dockerfile 也不会重新build 镜像。

	docker-compose up -d
	docker-compose down --rmi 'all'

# 参考资料

* [Docker-compose down doesn’t remove images](https://forums.docker.com/t/docker-compose-down-doesnt-remove-images/22778)
