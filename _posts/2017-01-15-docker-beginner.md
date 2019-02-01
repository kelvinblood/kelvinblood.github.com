---
layout: post
title: Docker 新手上路(一)
category: tech
tags: docker devops tutorial
---

![](https://cdn.kelu.org/blog/tags/docker.jpg)

新学习了 [docker][docker_gitbook]。记录一下。这个系列一共分为5篇，是我初次接触 Docker 的总结。

* [Docker 新手上路(一)](/tech/2017/01/15/docker-beginner.html)
* [Docker 新手上路（二）——Dockerfile](/tech/2017/01/18/docker-beginner-2.html)
* [Docker 新手上路（三）](/tech/2017/01/19/docker-beginner-3.html)
* [Docker 新手上路（前传）](/tech/2017/01/20/docker-beginner-prescript.html)
* [Docker 新手上路（后记）](/tech/2017/01/21/docker-beginner-postscript.html)

这几篇是一个很粗略的新手入门。并不足以了解全貌，不过可以让你短时间内了解 Docker 为何物以及一些简单的操作，可以一看。

Docker 是个划时代的开源项目，它彻底释放了计算虚拟化的威力，极大提高了应用的运行效率，降低了云计算资源供应的成本！ 使用 Docker，可以让应用的部署、测试和分发都变得前所未有的高效和轻松！

无论是应用开发者、运维人员、还是其他信息技术从业人员，都有必要认识和掌握 Docker，以在有限的时间内做更多有意义的事。

# 为什么要使用 Docker？

作为一种新兴的虚拟化方式，Docker 跟传统的虚拟化方式相比具有众多的优势。

### 更高效的利用系统资源

由于容器不需要进行硬件虚拟以及运行完整操作系统等额外开销，Docker 对系统资源的利用率更高。无论是应用执行速度、内存损耗或者文件存储速度，都要比传统虚拟机技术更高效。因此，相比虚拟机技术，一个相同配置的主机，往往可以运行更多数量的应用。

### 更快速的启动时间

传统的虚拟机技术启动应用服务往往需要数分钟，而 Docker 容器应用，由于直接运行于宿主内核，无需启动完整的操作系统，因此可以做到秒级、甚至毫秒级的启动时间。大大的节约了开发、测试、部署的时间。

### 一致的运行环境

开发过程中一个常见的问题是环境一致性问题。由于开发环境、测试环境、生产环境不一致，导致有些 bug 并未在开发过程中被发现。而 Docker 的镜像提供了除内核外完整的运行时环境，确保了应用运行环境一致性，从而不会再出现 _「这段代码在我机器上没问题啊」_ 这类问题。

### 持续交付和部署

对开发和运维（[DevOps](https://zh.wikipedia.org/wiki/DevOps)）人员来说，最希望的就是一次创建或配置，可以在任意地方正常运行。

使用 Docker 可以通过定制应用镜像来实现持续集成、持续交付、部署。开发人员可以通过 Dockerfile 来进行镜像构建，并结合 持续集成 系统进行集成测试，而运维人员则可以直接在生产环境中快速部署该镜像，甚至结合 持续部署 系统进行自动部署。

而且使用 `Dockerfile` 使镜像构建透明化，不仅仅开发团队可以理解应用运行环境，也方便运维团队理解应用运行所需条件，帮助更好的生产环境中部署该镜像。

### 更轻松的迁移

由于 Docker 确保了执行环境的一致性，使得应用的迁移更加容易。Docker 可以在很多平台上运行，无论是物理机、虚拟机、公有云、私有云，甚至是笔记本，其运行结果是一致的。因此用户可以很轻易的将在一个平台上运行的应用，迁移到另一个平台上，而不用担心运行环境的变化导致应用无法正常运行的情况。

### 更轻松的维护和扩展

Docker 使用的分层存储以及镜像的技术，使得应用重复部分的复用更为容易，也使得应用的维护更新更加简单，基于基础镜像进一步扩展镜像也变得非常简单。此外，Docker 团队同各个开源项目团队一起维护了一大批高质量的官方镜像，既可以直接在生产环境使用，又可以作为基础进一步定制，大大的降低了应用服务的镜像制作成本。

# 安装

先查看服务器的版本。`lsb_release -a`

    Distributor ID:	Debian
    Description:	Debian GNU/Linux 8.7 (jessie)
    Release:	8.7
    Codename:	jessie
    
### 添加源

按照教程的说法，`Debian 8 的内核默认为 3.16，仅仅满足基本的 Docker 运行条件。如果打算使用 overlay2 存储层驱动，或某些功能不够稳定希望升级到较新版本的内核，可以添加 backports 源，升级到新版本的内核。`
执行下面的命令添加 backports 源：

    $ echo "deb http://http.debian.net/debian jessie-backports main" | sudo tee /etc/apt/sources.list.d/backports.list
    
升级到 backports 内核：

    $ sudo apt-get update
    $ sudo apt-get -t jessie-backports install linux-image-amd64
    
### 配置存储驱动

升级到 backports 的内核之后，会因为 AUFS 内核模块不可用，而使用默认的 devicemapper 驱动，并且配置为 loop-lvm，这是不推荐的。因此，不要忘记安装 Docker 后，配置 overlay2 存储层驱动。（这一步我跳过了，待熟悉以后再看看存储驱动选择的问题）.

### 安装 Docker

在一切准备就绪后，就可以安装最新版本的 Docker 了，软件包名称为 docker-engine。将当前用户加入 docker 组，然后启动引擎。

    $ sudo apt-get install docker-engine
    // 如果没有这个包的话，源码安装 $ curl -sSL https://get.docker.com/ | sh
    $ sudo usermod -aG docker $USER
    $ sudo systemctl enable docker
    $ sudo systemctl start docker

![](https://cdn.kelu.org/blog/2017/01/20170119014613.jpg)


# 查看 docker 信息

    # 查看docker版本
    $docker version
		Client:
		 Version:      17.10.0-ce-rc2
		 API version:  1.33
		 Go version:   go1.8.3
		 Git commit:   af94197
		 Built:        Thu Oct 12 00:47:13 2017
		 OS/Arch:      linux/amd64
		
		Server:
		 Version:      17.10.0-ce-rc2
		 API version:  1.33 (minimum version 1.12)
		 Go version:   go1.8.3
		 Git commit:   af94197
		 Built:        Thu Oct 12 00:48:46 2017
		 OS/Arch:      linux/amd64
		 Experimental: false

    # 显示docker系统的信息
    $docker info
		Containers: 20
		 Running: 0
		 Paused: 0
		 Stopped: 20
		Images: 18
		Server Version: 17.10.0-ce-rc2
		Storage Driver: overlay
		 Backing Filesystem: xfs
		 Supports d_type: true
		Logging Driver: json-file
		Cgroup Driver: cgroupfs
		Plugins:
		 Volume: local
		 Network: bridge host macvlan null overlay
		 Log: awslogs fluentd gcplogs gelf journald json-file logentries splunk syslog
		Swarm: inactive
		Runtimes: runc
		Default Runtime: runc
		Init Binary: docker-init
		containerd version: 06b9cb35161009dcb7123345749fef02f7cea8e0
		runc version: 0351df1c5a66838d0c392b4ac4cf9450de844e2d
		init version: 949e6fa
		Security Options:
		 seccomp
		  Profile: default
		Kernel Version: 3.10.0-693.2.2.el7.x86_64
		Operating System: CentOS Linux 7 (Core)
		OSType: linux
		Architecture: x86_64
		CPUs: 8
		Total Memory: 15.54GiB
		Name: adsl-172-10-1-100.dsl.sndg02.sbcglobal.net
		ID: L4KV:FTZP:42FI:DVUS:3RJD:4ATZ:UMJ7:6UHH:I5ZW:3WYV:6OMI:XNZ3
		Docker Root Dir: /var/lib/docker
		Debug Mode (client): false
		Debug Mode (server): false
		Registry: https://index.docker.io/v1/
		Experimental: false
		Insecure Registries:
		 127.0.0.0/8
		Live Restore Enabled: false



# 获取镜像

[Docker Hub][docker_hub] 上有大量的高质量的镜像可以用。有可以直接拿来使用的服务类的镜像，如 nginx、redis、mongo、mysql、httpd、php、tomcat 等； 也有一些方便开发、构建、运行各种语言应用的镜像，如 node、openjdk、python、ruby、golang 等。 可以在其中寻找一个最符合我们最终目标的镜像为基础镜像进行定制。 如果没有找到对应服务的镜像，官方镜像中还提供了一些更为基础的操作系统镜像，如 ubuntu、debian、centos、fedora、alpine 等，这些操作系统的软件库为我们提供了更广阔的扩展空间。

>> Docker Hub提供API和云服务来发布基于Docker的应用程序。

获取镜像命令：

    docker pull [选项] [Docker Registry地址]<仓库名>:<标签>
    
    # 检索image
    $docker search image_name
    
    # 下载image
    $docker pull image_name
    
    # 列出镜像列表; -a, --all=false Show all images; --no-trunc=false Don't truncate output; -q, --quiet=false Only show numeric IDs
    $docker images
    
    # 显示一个镜像的历史; --no-trunc=false Don't truncate output; -q, --quiet=false Only show numeric IDs
    $docker history image_name

例如`docker pull debian`,安装完成后显示镜像列表`docker images`，如下

    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    debian              latest              19134a8202e7        4 weeks ago         123 MB

# 运行镜像

有了镜像后，我们就可以以这个镜像为基础启动一个容器来运行。

    $ docker run -it --rm debian bash
    $ docker run --name webserver -d -p 1644:80 nginx

![](http://7vigrt.com1.z0.glb.clouddn.com/blog/pic/201701/QQ%E6%88%AA%E5%9B%BE20170117000548.jpg)

    -it：这是两个参数，一个是 -i：交互式操作，一个是 -t 终端。我们这里打算进入 bash 执行一些命令并查看返回结果，因此我们需要交互式终端。
    --rm：这个参数是说容器退出后随之将其删除。默认情况下，为了排障需求，退出的容器并不会立即删除，除非手动 docker rm。
    debian：这是指用 debian 镜像为基础来启动容器。
    bash：放在镜像名后的是命令，这里我们希望有个交互式 Shell，因此用的是 bash。 
    最后 exit 退出容器。
    
    
# 新建/启动/唤醒/进入/终止/删除

    docker run ubuntu:14.04 /bin/echo 'Hello world' -d # 后台运行
    docker run -t -i ubuntu:14.04 /bin/bash  # -t分配一个伪终端， -i 标准输入保持打开。
    docker start ubuntu:14.04
    docker stop pid
    docker restart pid
    docker ps         # 命令来查看运行中的容器信息
    docker ps -a      # 包括终止的容器
    docker ps -l       # 最近一次启动的container
    docker attach pid    # 交互命令下 exit 命令退出 或 Ctrl+d进入后台运行
    docker rm xxx/pid
    docker rm $(docker ps -a -q) 清除所有终止状态的容器
   
也可以使用 nsenter 命令更方便地 attach docker 的界面。命令在debian 8中自带。下载 [.bashrc_docker][.bashrc_docker]，并放到 .bashrc 或者 .zshrc 中。

    wget -P ~ https://github.com/yeasy/docker_practice/raw/master/_local/.bashrc_docker;
    cd ~
    cat .bashrc_docker >> .bashrc
    source .bashrc
    
    docker ps
    docker-enter pid
    
# 保存和加载
    
    当需要把一台机器上的镜像迁移到另一台机器的时候，需要保存镜像与加载镜像。
    
    docker save image_name -o file_path # 保存镜像到一个tar包; -o, --output="" Write to an file
    docker load -i file_path # 加载一个tar包格式的镜像; -i, --input="" Read from a tar archive file
    
    $docker save image_name > /home/save.tar # 机器a
    
    # 使用scp将save.tar拷到机器b上，然后：
    $docker load < /home/save.tar
    
    
    docker login # 登陆registry server; -e, --email="" Email; -p, --password="" Password; -u, --username="" Username
    
    docker push new_image_name # 发布docker镜像
    
    
    
# Docker 命令行





| 功能划分  |  命令  | 用法 |
|---|---|---|
| 环境信息相关  | | |
|   | info| 本地的配置信息|
|   | version| 显示Docker，API，Git commit，Docker,Go的版本号。|
| 系统运维相关  | | |
| |attach| 挂载正在后台运行的容器|
| |build| 从源码构建新Image的命令|
| |commit| 把有修改的container提交成新的Image，官方不建议使用|
| |cp| 把容器內的文件复制到Host主机上|
| |diff| 列出3种容器内文件状态变化（A - Add, D - Delete, C - Change ）的列表清单。|
| |export| 把容器系统文件打包并导出来，方便分发给其他场景使用|
| |images| |
| |import / save / load| |
| |inspect| |
| |kill| |
| |port| |
| |pause / unpause| |
| |ps| |
| |rm| |
| |rmi| |
| |run| |
| |start / stop / restart| |
| |tag| |
| |top| |
| |wait| |
| 日志信息相关  | | |
| |events| |
| |history| |
| |logs| |
| Docker Hub服务相关  | | |
| |login| |
| |pull / push| |
| |search| |
 |





这篇就到这里。下一篇再写其他方面的。


参考资料：

* [docker_gitbook][docker_gitbook]
* [Docker教程中文版本](https://code.csdn.net/u010702509/docker)
* [PaaS时代幸福的程序员，利用Docker构建开发环境 - CSDN](http://www.csdn.net/article/2014-08-08/2820312-Docker-lxc-paas-virtualization)
* [Docker：分布式系统的软件工程革命（上）](http://cxwangyi.github.io/story/docker_revolution_1.md.html)
* [Docker学习笔记(2)--Docker常用命令](http://www.tuicool.com/articles/7V7vYn)
* [深入浅出Docker（二）：Docker命令行探秘](http://www.infoq.com/cn/articles/docker-command-line-quest)
* [10个日常Docker使用技巧](http://www.wanwuyun.com/pages/news/409.html)
* [Docker入门实战](http://blog.csdn.net/opensure/article/details/46490749)

[docker_gitbook]: https://www.gitbook.com/book/yeasy/docker_practice
[select_a_docker_storage_driver]: https://www.centos.bz/2016/12/select-a-docker-storage-driver
[docker_hub]: https://hub.docker.com
[docker_store]: https://store.docker.com
[.bashrc_docker]: https://github.com/yeasy/docker_practice/raw/master/_local/.bashrc_docker
