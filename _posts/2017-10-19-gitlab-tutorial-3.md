---
layout: post
title: gitlab 入门（三）—— gitlab与postgresl redis
category: tech
tags: git gitlab docker
---
![](https://cdn.kelu.org/blog/tags/gitlab.jpg)

参照前几篇文章，对gitlab也有了个大致的了解。这一篇将 gitlab 相关的服务全部 docker 化——gitlab postgresql 和 redis 。具体过程可以参考 [sameersbn](https://github.com/sameersbn)/**[docker-gitlab](https://github.com/sameersbn/docker-gitlab)**， 涉及到的容器有：

* **[docker-gitlab](https://github.com/sameersbn/docker-gitlab)**
* **[docker-postgresql](https://github.com/sameersbn/docker-postgresql)**
* **[docker-redis](https://github.com/sameersbn/docker-redis)**

# docker-compose

创建一个容器，我们可以通过 Dockerfile 模板文件对镜像进行创建并按照配置要求启动。

然而，一般项目往往需要多个容器相互配合才能完成某项任务，比如说在一个web项目中，除了web服务容器，往往还需要后端的数据库服务容器，甚至还需要负载均衡容器等。

使用Compose，你可以在一个文件中定义一个多容器应用，然后使用一条命令来启动你的应用，完成一切准备工作。

## docker-compose 安装

有很多种方式可以安装。这里介绍 pip(python) 方式。

	yum -y install epel-release 
	yum -y install python-pip

确认版本

	pip --version
	pip 7.1.0 from /usr/lib/python2.7/site-packages (python 2.7)

安装

	pip install docker-compose
	docker-compose version

		docker-compose version 1.16.1, build 6d1ac219
		docker-py version: 2.5.1
		CPython version: 2.7.5
		OpenSSL version: OpenSSL 1.0.1e-fips 11 Feb 2013

# 修改内核参数

允许系统给进程的内存大小超过实际可用的内存，对内存申请来者不拒。

	vm.overcommit_memory = 1
	sysctl -p

这个设置主要是为了 redis 使用。防止后台运行时内存不足。

# 快速开始

	wget https://raw.githubusercontent.com/sameersbn/docker-gitlab/master/docker-compose.yml

修改`docker-compose.yml`文件的一些配置：

	# 修改时区。修改参数可以参照 <http://api.rubyonrails.org/classes/ActiveSupport/TimeZone.html>

	- TZ=Asia/Shanghai
	- GITLAB_TIMEZONE=Asia/Shanghai

	# 设置一些 key， 64位长度

	- GITLAB_SECRETS_DB_KEY_BASE=BRW6rHLKLnw5W3X8qFDHjbVdk4v3tb6RhTbq9MHvGDzZ7jpP2vlxZ9VPMVJLM3cK
	- GITLAB_SECRETS_SECRET_KEY_BASE=H3rpHVjwGcK5SVXHVFlnnNFDvVDkPhcgsxGZGlbjcVXTBb2tFqPR5GG6dNgmnSKc
	- GITLAB_SECRETS_OTP_KEY_BASE=zSjwt8lz4sG89Mp2zCWJ7MLSSR3kMctqKLjc5xCVZXCb9XTfRpHL6CbvBFqrqcgl
	
可以使用 `pwgen -Bsv1 64` 命令生成随机64位密钥。

如果你的服务器开启了SELinux，那么你需要进行下面的操作：
	
	mkdir -p /srv/docker/gitlab/gitlab
	sudo chcon -Rt svirt_sandbox_file_t /srv/docker/gitlab/gitlab
	mkdir -p /srv/docker/gitlab/postgresql
	sudo chcon -Rt svirt_sandbox_file_t /srv/docker/gitlab/postgresql

接下来只需要再 yaml 文件同目录下运行

	docker-compose up

就可以看到系统启动起来啦。此时访问服务器上地10080端口，即可看到 gitlab 的页面了。

![](https://cdn.kelu.org/blog/2017/10/docker-compose.jpg)

# 问题定位

在我设置的时候，中间一度出现`Configuring gitlab : database ..........................................`的错误，参照文末的参考资料，这是 gitlab 无法连接 postgresql 的原因导致。解决的办法很多。因为操作了很多次，我索性删除docker images 配置重新跑一遍流程，即可：

	systemctl stop docker.server
	rm -rf /var/lib/docker
	docker-compose up

# 后续学习

目前已经可以将所有应用容器化了。接下来我会往这几个方向深入：

* docker build创建自己的镜像
* 容器的高可用策略
* 与Rancher搭配使用

# 参考资料

* [理解LINUX的MEMORY OVERCOMMIT](http://linuxperf.com/?p=102)
* [Configuring gitlab : database ...... ](https://github.com/sameersbn/docker-gitlab/issues/999)
* [使用Docker Compose管理多个容器](http://dockone.io/article/834)
* [使用docker-compose实现容器编排](https://www.centos.bz/2017/08/docker-compose-container-choreography/)
* [Docker Compose 项目](http://www.dockerinfo.net/docker-compose-%e9%a1%b9%e7%9b%ae)
* [使用Docker-Compose编排容器](https://www.hi-linux.com/posts/12554.html)
* [docker-compose up](https://docs.docker.com/compose/reference/up/)
* [Feature request: add scale parameter in yml](https://github.com/docker/compose/issues/1661)
* [Use Compose in production](https://docs.docker.com/compose/production/)