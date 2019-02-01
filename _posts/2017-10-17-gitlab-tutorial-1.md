---
layout: post
title: gitlab 入门（一）—— 安装
category: tech
tags: git gitlab docker
---
![](https://cdn.kelu.org/blog/tags/gitlab.jpg)

这一篇讲 GitLab 的安装，可以参照官方文档查看，可能要注意一下时效性。<https://docs.gitlab.com/ee/install/README.html>

其他 Gitlab 文档的相关文章可以看这里  ——  [《gitlab 入门》](/tech/2017/10/16/gitlab-tutorial.html)。

# 安装要求

### 1. 系统要求

	* 仅支持以下系统：
	
		*   Ubuntu
		*   Debian
		*   CentOS
		*   Red Hat Enterprise Linux (please use the CentOS packages and instructions)
		*   Scientific Linux (please use the CentOS packages and instructions)
		*   Oracle Linux (please use the CentOS packages and instructions)
	
	* 不支持以下系统：
	
		*   Arch Linux
		*   Fedora
		*   FreeBSD
		*   Gentoo
		*   macOS
		*   Windows

### 2. ruby版本

	* Ruby (MRI) 2.3

### 3. 存储

	* 越大越好
	* 支持NFS
	* 7200 RPM 以上的机械硬盘或固态硬盘，可以明显提升性能。

### 4. CPU

	*   1 core supports up to 100 users。但是会明显变慢。
	*   **2 cores** is the **recommended** number of cores and supports up to 500 users
	*   4 cores supports up to 2,000 users
	*   8 cores supports up to 5,000 users
	*   16 cores supports up to 10,000 users
	*   32 cores supports up to 20,000 users
	*   64 cores supports up to 40,000 user

### 5. 内存

	*   **4GB RAM** is the **recommended** memory size for all installations and supports up to 100 users
	*   8GB RAM supports up to 1,000 users
	*   16GB RAM supports up to 2,000 users
	*   32GB RAM supports up to 4,000 users
	*   64GB RAM supports up to 8,000 users
	*   128GB RAM supports up to 16,000 users
	*   256GB RAM supports up to 32,000 users

	即使服务器的内存已经够大，也推荐至少要包含2G的交换空间。这样可以有效降低进行内存进行更改时发生错误的概率。

### 6. 数据库

	*  至少要包含5-10G的数据库空间。
	*  PostgreSQL (强烈建议)
	* MySQL/MariaDB (强烈不建议，因为他们不支持Gitlab的一些特性)
		*  Gitlab 9.3 版本后不支持 subgroups 特性。[issue #30472](https://gitlab.com/gitlab-org/gitlab-ce/issues/30472) 
		*  不支持 GitLab Geo
		*  不支持 Zero downtime migrations
		*  不支持负载均衡
		*  不支持dashboard events（使用 PostgreSQL LATERAL JOINs 实现的）
		*  不支持 SQL 的某些优化
		*  期待还有更多信息添加进来（ps: 总之我们就是不喜欢Oracle统治下的MySQL，Oracle 去shi）

### 7. PostgreSQL
	
	* GitLab 10.0 后只支持 PostgreSQL 9.6，所以更低版本就不要用了。
	* `pg_trgm`插件一定要在每一个GitLab数据库中开启。

		```
		CREATE EXTENSION pg_trgm;
		```

	某些系统里你可能还要安装一些额外包 (e.g. `postgresql-contrib`) 才能使`pg_trgm`插件生效。

### 8.  Unicorn Workers

	背景: Unicorn 用来实现并发的一个东西。

	* 推荐使用内核个数+1个unicorn workers.
	* 推荐 2GB或更高的内存下最少也使用3个 unicorn workers

### 9. Redis 和 Sidekiq

	背景: _Sidekiq _是一个多线程的后台任务处理系统。

	*  Redis存储所有用户会话和后台任务队列。
	*  每个用户大约占用 25kB redis存储。
	*  Sidekiq 进程初始占用 200M+的内存，动态增加，在非常活跃的机器(10,000活跃用户)上占用大概1G内存。

### 10. Prometheus

	在 Omnibus GitLab 9.0 后默认开启了 Prometheus。默认配置大概消耗200M内存。

### 11. GitLab Runner 

	*  强烈建议不要在 GitLab 机器上部署GitLab Runner。因为我们要实现 CI 的一些机制原因，Gitlab Runner会很吃内存，所以不要在同一台机器上部署两个应用。
	*  也建议不要在同一台机器上部署几个GitLab Runner应用。同样是因为内存的原因。另外这个也不符合系统避免单点故障的安全要求。
	*  所以，如果你需要使用 GitLab Runner 的 CI 功能，请把他们独立部署在单独的机器上。
	
### 12. 浏览器支持

	支持下列浏览器的最新和主流版本：
	
	*  Firefox
	*  Chrome/Chromium
	*  Safari 
	*  Microsoft Edge
	*  Internet Explorer 11

# 安装

安装前请看后文的安装要求

*   [Omnibus packages安装](https://about.gitlab.com/downloads/) （推荐）
*   [源码安装](https://docs.gitlab.com/ee/install/installation.html)，适用于在 BSD 等不支持的系统来安装。
*   [Docker 安装](https://docs.gitlab.com/ee/install/docker.html)
*   [在 Kubernetes 上安装](https://docs.gitlab.com/ee/install/kubernetes/index.html) 
*   [在 OpenShift 上安装](https://docs.gitlab.com/ee/articles/openshift_and_gitlab/index.html)
*   通过 [GitLab-Mesosphere integration](https://about.gitlab.com/2016/09/16/announcing-gitlab-and-mesosphere/) [在 DC/OS 上安装](https://mesosphere.com/blog/gitlab-dcos/) 
*   [在 Azure 上安装](https://docs.gitlab.com/ee/install/azure/index.html)
*   [在 Google Cloud Platform 上安装](https://docs.gitlab.com/ee/install/google_cloud_platform/index.html)
*   [在 AWS 上安装](https://about.gitlab.com/aws/)
*   _测试用!_ [DigitalOcean and Docker Machine](https://docs.gitlab.com/ee/install/digitaloceandocker.html) 
*   [GitLab Pivotal Tile](https://docs.gitlab.com/ee/install/pivotal/index.html)

鉴于目前容器化是一个越来越快的趋势，我就直接从容器化 docker 开始安装使用。其他安装方式我就不看了。

# 使用 Docker 安装

<https://docs.gitlab.com/omnibus/docker/README.html>

如何使用 Docker 不在本篇的介绍范围，下面直接说过程：

	docker pull gitlab/gitlab-ce:latest
	
	sudo docker run --detach \
	    --hostname gitlab.example.com \
	    --publish 443:443 --publish 80:80 --publish 22:22 \
	    --name gitlab \
	    --restart always \
	    --volume /srv/gitlab/config:/etc/gitlab \
	    --volume /srv/gitlab/logs:/var/log/gitlab \
	    --volume /srv/gitlab/data:/var/opt/gitlab \
	    gitlab/gitlab-ce:latest

我预计大概率会报冲突：

	docker: Error response from daemon: driver failed programming external connectivity on endpoint gitlab (4a9645ff2d304610abefa6c4d7138c8f0b228122157b9e318648e2f585ccdc41): Error starting userland proxy: listen tcp 0.0.0.0:22: bind: address already in use.

这是ssh默认端口冲突了。练手阶段可以把 22:22 去掉。副作用就是不能用 ssh 的方式clone项目了，只能走 https 协议。

![](https://cdn.kelu.org/blog/2017/10/gitlab1.jpg)

以上步骤后，gitlab就完整跑起来了。

![](https://cdn.kelu.org/blog/2017/10/gitlab3.jpg)

默认用户名是root，密码会在登陆这个界面的时候自动输入。另外我还在用本地host 做了一个映射，所以你能看到我访问的网址是 http://gitlab.example.com/

# 参考资料

* [Bind address already in use (introduced in 1.3) ](https://github.com/moby/moby/issues/8714)
* <https://docs.gitlab.com/ce/install/docker.html>
* <https://docs.gitlab.com/omnibus/docker/README.html>
* [用Docker安装Gitlab](http://www.jianshu.com/p/24959481340e)