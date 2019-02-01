---
layout: post
title: gitlab 入门（四）—— 创建自己的镜像
category: tech
tags: git gitlab docker
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

这一篇主要来看如何创建自己的镜像.

# 安装Go

访问[下载地址](http://golang.org/dl/ "Go安装包下载")，32位系统下载go1.8.3.linux-386.tar.gz，64位系统下载go1.8.3.linux-amd64.tar.gz，以我这一次下载为例：

	wget https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz
	tar -C /usr/local -xzf go1.9.2.linux-amd64.tar.gz

	# 添加到系统路径
	ln -s /usr/local/go/bin/go /usr/local/bin/go

# build示例

以 [sameersbn](https://github.com/sameersbn)/**[docker-gitlab](https://github.com/sameersbn/docker-gitlab)** 作为示例项目进行创建。

	git clone https://github.com/sameersbn/docker-gitlab.git
	cd docker-gitlab
	docker build --tag="$USER/gitlab" .

build 很慢，耐心等等~

# dockerfile 详解

结合 gitlab 的项目

![](https://cdn.kelu.org/blog/2017/10/gitlab4.jpg)

以 <https://github.com/sameersbn/docker-gitlab/commit/711e4115b123f0dfc0c0c2e39879be51fc6f80b2> 作为学习版本。

### 镜像基本配置

基于父镜像构建其他docker镜像，父镜像：可以通过docker pull 命令获得，也可以自己制作

	FROM sameersbn/ubuntu:14.04.20171024

Dockerfile维护者

	MAINTAINER sameer@damagehead.com

gitlab依赖的版本配置，包括 

* gitlab
* ruby
* go
* gitlab shell
* gitlab workhorse
* gitlab page
* gitlab server

同时还有一些基础配置：

* git用户与家目录
* gitlab日志目录
* gitlab缓存目录
* redis和节点配置为生产环境。
	
		ENV GITLAB_VERSION=10.1.1 \
		    RUBY_VERSION=2.3 \
		    GOLANG_VERSION=1.8.3 \
		    GITLAB_SHELL_VERSION=5.9.3 \
		    GITLAB_WORKHORSE_VERSION=3.2.0 \
		    GITLAB_PAGES_VERSION=0.6.0 \
		    GITALY_SERVER_VERSION=0.43.1 \
		    GITLAB_USER="git" \
		    GITLAB_HOME="/home/git" \
		    GITLAB_LOG_DIR="/var/log/gitlab" \
		    GITLAB_CACHE_DIR="/etc/docker-gitlab" \
		    RAILS_ENV=production \
		    NODE_ENV=production

gitlab 的其他安装目录配置，包括：

* gitlab
* gitlab-shell
* gitlab-workhorse
* gitlab-pages
* gitaly
* gitlab数据目录
* gitlab build目录
* gitlab 运行时目录

		ENV GITLAB_INSTALL_DIR="${GITLAB_HOME}/gitlab" \
		    GITLAB_SHELL_INSTALL_DIR="${GITLAB_HOME}/gitlab-shell" \
		    GITLAB_WORKHORSE_INSTALL_DIR="${GITLAB_HOME}/gitlab-workhorse" \
		    GITLAB_PAGES_INSTALL_DIR="${GITLAB_HOME}/gitlab-pages" \
		    GITLAB_GITALY_INSTALL_DIR="${GITLAB_HOME}/gitaly" \
		    GITLAB_DATA_DIR="${GITLAB_HOME}/data" \
		    GITLAB_BUILD_DIR="${GITLAB_CACHE_DIR}/build" \
		    GITLAB_RUNTIME_DIR="${GITLAB_CACHE_DIR}/runtime"

### 镜像初始化

设置好基本信息后，解下来是镜像的必要软件的安装。

* 	添加 git-core 源

		RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E1DD270288B4E6030699E45FA1715D88E1DF1F24 \
		 && echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu trusty main" >> /etc/apt/sources.list \

* 添加 Brightbox 维护的 Ruby PPA 源		

		 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 80F70E11F0F0D5F10CB20E62F5DA5F09C3173AA6 \
		 && echo "deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main" >> /etc/apt/sources.list \

* 添加 nginx 源

		 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 8B3981E7A6852F782CC4951600A6F0A3C300EE8C \
		 && echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu trusty main" >> /etc/apt/sources.list \
	
* 添加 postgresql 源

		 && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
		 && echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' > /etc/apt/sources.list.d/pgdg.list \

* 添加 nodejs 源
	
		 && wget --quiet -O - https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
		 && echo 'deb https://deb.nodesource.com/node_8.x trusty main' > /etc/apt/sources.list.d/nodesource.list \

* 添加 js 包管理器 yarn 的源, yarn 是 Facebook 开源的

		 && wget --quiet -O - https://dl.yarnpkg.com/debian/pubkey.gpg  | apt-key add - \
		 && echo 'deb https://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list \

* 安装依赖包

	debian_frontend=noninteractive 使用非交互式安装。

		 && apt-get update \
		 && DEBIAN_FRONTEND=noninteractive apt-get install -y supervisor logrotate locales curl \
		      nginx openssh-server mysql-client postgresql-client redis-tools \
		      git-core ruby${RUBY_VERSION} python2.7 python-docutils nodejs yarn gettext-base \
		      libmysqlclient18 libpq5 zlib1g libyaml-0-2 libssl1.0.0 \
		      libgdbm3 libreadline6 libncurses5 libffi6 \
		      libxml2 libxslt1.1 libcurl3 libicu52 \

* 设置字符集

	LC_MESSAGES 提示信息的语言， “C”是系统默认的locale，”POSIX”是”C”的别名。所以当我们新安装完一个系统时，默认的locale就是C或POSIX。
	
		 && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX \
		 && locale-gen en_US.UTF-8 \
		 && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales \

* 安装 ruby 的包管理器 bundler
	
		 && gem install --no-document bundler \

* 清除 apt-get 的list
	
		 && rm -rf /var/lib/apt/lists/*
		
* 拷贝一些文件到 docker 容器，开始安装 gitlab

		COPY assets/build/ ${GITLAB_BUILD_DIR}/
		RUN bash ${GITLAB_BUILD_DIR}/install.sh
		
		COPY assets/runtime/ ${GITLAB_RUNTIME_DIR}/
		COPY entrypoint.sh /sbin/entrypoint.sh
		RUN chmod 755 /sbin/entrypoint.sh
	
* 端口映射 EXPOSE <host_port>:<container_port> 

	`EXPOSE` 仅仅是声明容器打算使用什么端口而已，并不会自动在宿主进行端口映射。主要用处是帮助镜像使用者理解这个镜像服务的守护端口，以方便配置映射。

	在使用 `docker run` 时，可以使用 `docker run -p <host_port>:<container_port>` 来固化端口
	
		EXPOSE 22/tcp 80/tcp 443/tcp
	
* 匿名卷

	容器运行时应该尽量保持容器存储层不发生写操作，对于数据库类需要保存动态数据的应用，其数据库文件应该保存于卷(volume)中，后面的章节我们会进一步介绍 Docker 卷的概念。为了防止运行时用户忘记将动态文件所保存目录挂载为卷，在 `Dockerfile` 中，我们可以事先指定某些目录挂载为匿名卷，这样在运行时如果用户不指定挂载，其应用也可以正常运行，不会向容器存储层写入大量数据。

		VOLUME ["${GITLAB_DATA_DIR}", "${GITLAB_LOG_DIR}"]

* 指定工作目录

	使用 `WORKDIR` 指令可以来指定工作目录（或者称为当前目录），以后各层的当前目录就被改为指定的目录，如该目录不存在，`WORKDIR` 会帮你建立目录。

	在dockerfile中，每一个 `RUN` 都是启动一个容器、执行命令、然后提交存储层文件变更。第一层 `RUN cd /app` 的执行仅仅是当前进程的工作目录变更，一个内存上的变化而已，其结果不会造成任何文件变更。而到第二层的时候，启动的是一个全新的容器，跟第一层的容器更完全没关系，自然不可能继承前一层构建过程中的内存变化。

		WORKDIR ${GITLAB_INSTALL_DIR}
	
* 容器启动时执行的命令

	一个Dockerfile中只有最后一条ENTRYPOINT生效，并且每次启动docker容器，都会执行ENTRYPOINT。
	ps： 这一个区别于 CMD，CMD 命令在启动时不一定会执行，ENTRYPOINT 一定会执行。

		ENTRYPOINT ["/sbin/entrypoint.sh"]

* 指定容器的默认执行的命令

		CMD ["app:start"]

	此命令会在容器启动且 docker run 没有指定其他命令时运行。
	1.  如果 docker run 指定了其他命令，CMD 指定的默认命令将被忽略。
	2.  如果 Dockerfile 中有多个 CMD 指令，只有最后一个 CMD 有效。


	
# RUN , CMD 和 ENTRYPOINT 的区别


可以参考这篇答案，讲得非常详细：<https://segmentfault.com/q/1010000000417103>，以下是转载：

运行时机不太一样。

RUN是在Build时运行的，先于CMD和ENTRYPOINT。Build完成了，RUN也运行完成后，再运行CMD或者ENTRYPOINT。

ENTRYPOINT和CMD的不同点在于执行docker run时参数传递方式，CMD指定的命令可以被docker run传递的命令覆盖，例如，如果用CMD指定：

```
...
CMD ["echo"]

```

然后运行

```
docker run CONTAINER_NAME echo foo

```

那么CMD里指定的echo会被新指定的echo覆盖，所以最终相当于运行`echo foo`，所以最终打印出的结果就是：

```
foo

```

而ENTRYPOINT会把容器名后面的所有内容都当成参数传递给其指定的命令（不会对命令覆盖），比如：

```
...
ENTRYPOINT ["echo"]

```

然后运行

```
docker run CONTAINER_NAME echo foo

```

则CONTAINER_NAME后面的`echo foo`都作为参数传递给ENTRYPOING里指定的echo命令了，所以相当于执行了

```
echo "echo foo"

```

最终打印出的结果就是：

```
echo foo

```

另外，在Dockerfile中，ENTRYPOINT指定的参数比运行docker run时指定的参数更靠前，比如：

```
...
ENTRYPOINT ["echo", "foo"]

```

执行

```
docker run CONTAINER_NAME bar

```

相当于执行了：

```
echo foo bar

```

打印出的结果就是：

```
foo bar

```

Dockerfile中只能指定一个ENTRYPOINT，如果指定了很多，只有最后一个有效。

执行docker run命令时，也可以添加-entrypoint参数，会把指定的参数继续传递给ENTRYPOINT，例如：

```
...
ENTRYPOINT ["echo","foo"]

```

然后执行：

```
docker run CONTAINER_NAME bar #注意没有echo

```

那么，就相当于执行了`echo foo bar`，最终结果就是

```
foo bar

```

我在[dockboard.org](http://www.dockboard.org/)上翻译了一篇[《15 Docker Tips in 15 Minutes》](http://www.dockboard.org/docker-15-tips/)，其中有讲到RUN、CMD和ENTRYPOINT的不同，你可以参考一下。

另外有一个Docker Quicktips系列，里面有一篇也是讲ENTRYPIONT的,你可以看一下，连接在这里：
[http://www.tech-d.net/2014/01/27/docker-quicktip-1-entrypoint/](http://www.tech-d.net/2014/01/27/docker-quicktip-1-entrypoint/)

这个系列的文章翻译我们马上也会添加到[dockboard.org](http://www.dockboard.org/)的，敬请关注一下哈。

另外这里有官方文档中对entrypoint的说明：[http://docs.docker.io/en/latest/reference/builder/#entrypoint](http://docs.docker.io/en/latest/reference/builder/#entrypoint)

转载结束。

于是本篇对创建镜像的介绍就到此为止了。

# 参考资料

* [build-web-application-with-golang](https://github.com/astaxie/build-web-application-with-golang)
* [docker 操作命令详解](http://www.simapple.com/docker-commandline)
* [docker build 命令-建立一个新的image](http://www.simapple.com/319.html)
* [Dockerfile配置文件说明文档详解](http://www.simapple.com/docker-dockerfile)
* [Yarn 的安装与使用](http://www.jackpu.com/yarn-facebook-kai-yuan-de-bao-guan-li-gong-ju/)
* [Linux中通过locale来设置字符集](http://www.linuxfly.org/post/424/)
* [Dockerfile里指定执行命令用ENTRYPOING和用CMD有何不同？](https://segmentfault.com/q/1010000000417103)
