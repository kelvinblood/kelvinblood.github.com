---
layout: post
title: Docker Compose工具快速入门 | 转
category: tech
tags: git gitlab docker
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

# Docker Compose

译者注：[原文地址](http://docs.docker.com/compose/),本译文仅供学习参考，如有侵权请立即联系我，我会立即删除。

Compose是一个用于在Docker上定义并运行复杂应用的工具。通过Compose，你可以很容易地使用一个配置文件定义一个多容器的应用，然后使用一条指令安装这个应用的所有依赖，完成构建。

在开发环境、临时服务器、CI中使用Compose是非常合适的。但是，我们目前不建议你在生产环境中使用。

使用Compose需要三个基本步骤。

首先，你需要使用一个`Dockerfile`来定义你的应用的运行环境，这样你就可以在任何地方轻松地重建这个环境。

	FROM python:2.7
	WORKDIR /code
	ADD requirements.txt /code/
	RUN pip install -r requirements.txt
	ADD . /code
	CMD python app.py

然后，你需要在`docker-compose.yml`中确定你的应用所使用的服务，这样它们就可以在一个隔离环境中一起运行。

	web:
	 build: .
	 links:
	 - db
	 ports:
	 - "8000:8000"
	db:
	 image: postgres

最后，执行`docker-compose up`命令，然后Compose就会启动并运行你的整个应用。

Compose有一整套命令来对你的应用的整个生命周期进行管理。

*   启动、终止、重建服务。
*   查看运行中服务的状态。
*   将运行服务的日志输出整理成数据流。
*   对一个服务运行一次性指令(原文：Run a one-off command on a service)（译者注：这个没看懂）。

## Compose文档

*   [安装Compose](http://docs.docker.com/compose/completion/)
*   [命令行参考文档](http://docs.docker.com/compose/cli/)
*   [Yml文件参考文档](http://docs.docker.com/compose/yml/)
*   [Compose环境变量](http://docs.docker.com/compose/env/)
*   [Compose的命令行补全](http://docs.docker.com/compose/completion/)

### 快速开始

让我们完整地进行一套Compose的使用流程——在Compose上运行一个简单的Python的web应用。在这里我们假定你已有一点关于Python的知识，但是即使你不懂也没关系，下文中会出现的概念都很浅显易懂。

#### 安装并搭建Compose环境

首先，[安装Docker和Compose](http://docs.docker.com/compose/install/)。

然后，创建项目目录。

	$ mkdir composetest
	$ cd composetest

在目录中，创建`app.py`，这是一个使用Flask框架、用于递增Redis中的数据的简单应用。

	from flask import Flask
	from redis import Redis
	import os
	app = Flask(__name__)
	redis = Redis(host='redis', port=6379)
	
	@app.route('/')
	def hello():
	 redis.incr('hits')
	 return 'Hello World! I have been seen %s times.' % redis.get('hits')
	
	if __name__ == "__main__":
	 app.run(host="0.0.0.0", debug=True)


接下来，在`requirements.txt`中确定Python依赖：

	flask
	redis

#### 创建一个Docker镜像

现在，创建一个包含了你的应用所有依赖的Docker镜像。你需要在`Dockerfile`中确定你创建镜像的Docker命令：

	FROM python:2.7
	ADD . /code
	WORKDIR /code
	RUN pip install -r requirements.txt

这些命令会创建一个包含Python、你的代码、Python依赖的Docker镜像。想了解更多关于如何编写Dockerfile的信息，请看[Docker用户指南](https://docs.docker.com/userguide/dockerimages/#building-an-image-from-a-dockerfile)和[Dockerfile参考文档](https://docs.docker.com/userguide/dockerimages/#building-an-image-from-a-dockerfile)

#### 确定服务

接下来，在`docker-compose.yml`中定义你使用的服务的集合：
	
	web:
	 build: .
	 command: python app.py
	 ports:
	 - "5000:5000"
	 volumes:
	 - .:/code
	 links:
	 - redis
	redis:
	 image: redis

上文确定了两个服务：

*   web, 这个服务按照`Dockerfile`安装在当前目录。另外它在镜像中运行了`python app.py`命令。在镜像中，容器使用开放的5000端口连接宿主机的5000端口，同时访问Redis服务，并且将当前目录挂载到容器中，这样我们在代码上工作改进时就不需要重建镜像了。
*   `redis`,这个服务使用了公共镜像[redis](https://registry.hub.docker.com/_/redis/),这个进镜像可以从Docker中心注册镜像库(Docker Hub registry)上拉下来。

#### 使用Compose构建并运行你的应用

现在，当我们执行`docker-compose up`命令时，Compose就会自动拉下Redis镜像，按你的需求建立镜像，然后将环境和依赖部署好,并运行相关服务：

	$ docker-compose up
	Pulling image redis...
	Building web...
	Starting composetest_redis_1...
	Starting composetest_web_1...
	redis_1 | [8] 02 Jan 18:43:35.576 # Server started, Redis version 2.8.3
	web_1   |  * Running on http://0.0.0.0:5000/

这个web应用现在应该正在Docker守护进程上监听5000端口（如果你使用了Boot2docker工具，执行`boot2docker ip`可以显示它的地址）。

如果你希望后台运行这些服务，就在执行`docker-compose up`时传入`-d` 标志，执行 `docker-compose ps` 就可以看到现在正在运行的服务：
	
	$ docker-compose up -d
	Starting composetest_redis_1...
	Starting composetest_web_1...
	$ docker-compose ps
	 Name                 Command            State       Ports
	-------------------------------------------------------------------
	composetest_redis_1   /usr/local/bin/run         Up
	composetest_web_1     /bin/sh -c python app.py   Up      5000->5000/tcp

`docker-compose run`命令能够让你对服务执行一次性指令。比如，如果你想查看`web`服务的所有可用环境变量：

	$ docker-compose run web env

通过查看`docker-compose run web env`的回显能够查看其他可用命令。

如果你使用`docker-compose up -d`命令启动Compose，你可能需要这条指令来在运行应用结束后终止你需要的服务：
`$ docker-compose stop`

看完以上内容，你已经了解了使用Compose的基本过程。

# 参考资料

* [Docker Compose工具快速入门](http://cholerae.com/2015/04/13/-%E7%BF%BB%E8%AF%91-Docker-Compose%E5%B7%A5%E5%85%B7%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8/)

