---
layout: post
title: Docker 新手上路（前传）
category: tech
tags: docker devops tutorial
---

![](https://cdn.kelu.org/blog/tags/docker.jpg)

这个系列一共分为5篇，是我初次接触 Docker 的总结。

* [Docker 新手上路(一)](/tech/2017/01/15/docker-beginner.html)
* [Docker 新手上路（二）——Dockerfile](/tech/2017/01/18/docker-beginner-2.html)
* [Docker 新手上路（三）](/tech/2017/01/19/docker-beginner-3.html)
* [Docker 新手上路（前传）](/tech/2017/01/20/docker-beginner-prescript.html)
* [Docker 新手上路（后记）](/tech/2017/01/21/docker-beginner-postscript.html)

这几篇是一个很粗略的新手入门。并不足以了解全貌，不过可以让你短时间内了解 Docker 为何物以及一些简单的操作，可以一看。

今晚将 [CSDN][docker_csdn] 上所有的 Docker 的文章浏览了一遍(53页,将近523篇文章)。

在学习了基本的 Docker 部署的知识和简单应用后，回过头来从源头开始，再来看看 Docker 这项技术，大有收获。

# 何为 Docker

Docker 是 PaaS 提供商 dotCloud 开源的一个基于 LXC 的高级容器引擎， 源代码托管在 Github 上, 基于go语言并遵从Apache2.0协议开源。 Docker容器可以封装任何有效负载，几乎可以在任何服务器之间进行一致性运行。换句话说，开发者构建的应用只需一次构建即可多平台运行。运营人员只需配置他们的服务，即可运行所有的应用。

Docker的常用案例包括：

* 自动打包和部署应用
* 创建轻量、私有的PaaS环境
* 自动化测试和持续集成/部署
* 部署并扩展Web应用、数据库和后端服务器

![](https://cdn.kelu.org/blog/2017/01/docker_vm.jpg)

#  Docker 的组成

* Docker Client : Docker提供给用户的客户端。Docker Client提供给用户一个终端，用户输入Docker提供的命令来管理本地或者远程的服务器。
* Docker Daemon : Docker服务的守护进程。每台服务器（物理机或虚机）上只要安装了Docker的环境，基本上就跑了一个后台程序Docker Daemon，Docker Daemon会接收Docker Client发过来的指令,并对服务器的进行具体操作。
* Docker Images : 俗称Docker的镜像，这个可难懂了。你暂时可以认为这个就像我们要给电脑装系统用的系统CD盘，里面有操作系统的程序，并且还有一些CD盘在系统的基础上安装了必要的软件，做成的一张 “只读” 的CD。
* Docker Registry : 这个可认为是Docker Images的仓库，就像git的仓库一样，用来管理Docker镜像的，提供了Docker镜像的上传、下载和浏览等功能，并且提供安全的账号管理可以管理只有自己可见的私人image。就像git的仓库一样，docker也提供了官方的Registry，叫做[Dock Hub](http://hub.Docker.com)
* Docker Container : 俗称Docker的容器，这个是最关键的东西了。Docker Container是真正跑项目程序、消耗机器资源、提供服务的地方，Docker Container通过Docker Images启动，在Docker Images的基础上运行你需要的代码。 

![](https://cdn.kelu.org/blog/2017/01/5d04473994d0b4730f9d03f63f617058.jpg)

#  Docker 的技术

* LinuX Containers(LXC). 提供一个共享kernel的 OS 级虚拟化方法，在执行时不用重复加载Kernel, 且container的kernel与host共享，因此可以大大加快container的 启动过程，并显著减少内存消耗。
* AUFS(chroot) – 用来建立不同的操作系统和隔离运行时的硬盘空间
* Namespace – 用来隔离Container的执行空间, 其中pid, net, ipc, mnt, uts 等namespace将container的进程, 网络, 消息, 文件系统和hostname 隔离开。
* Cgroup – 分配不同的硬件资源
* SELinux – 用来保护linux的网络安全
* Netlink – 用来让不同的Container之间的进程保持通信

简单说来，Docker = LXC + AUFS。

![](https://cdn.kelu.org/blog/2017/01/docker-filesystems-busyboxrw.jpg)

(AUFS)


# 其他知识

### 云计算

云计算，通常被称为云，是指在 Internet 上按需交付计算资源（从应用程序到数据，到硬件、软件，甚至数据中心），并按使用付费。此外，云计算可以包括快速、动态地对 IT 资源进行配置，然后取消配置的能力、自助服务式 IT 方法（而不是让用户通过 IT 部门获取 IT 资源），以及通过广泛共享资源并以非常细粒度的增量提供这些资源来实现业务效率。通过服务模型来划分，可以分为 IaaS, Paas, Saas.

在当今云计算环境当中，IaaS是非常主流的，无论是Amazon EC2还是Linode或者Joyent等，都占有一席之地，但是随着Google的App Engine，Salesforce的Force.com还是微软的Windows Azure等PaaS平台的推出，使得PaaS也开始崭露头角。


### IaaS

    基础架构即服务：Infrastructure as a service(IaaS) 以自助服务和按使用付费的方式为用户提供基本的计算资源，这些资源包括服务器、网络、存储和数据中心空间。IaaS 通常称为云计算的基础层。在典型的 IaaS 云模型中，提供给用户的基本计算资源要么是裸机 （专用），要么是虚拟化的 （共享）。

### PaaS

    平台即服务：Platform as a service(PaaS) 构建在 IaaS 之上，提供基础架构和平台软件的组合；这通常是指基于云的应用程序开发、中间件、数据库软件，以及相应的硬件环境。 这种服务模式专门面向应用程序的开发人员、测试人员、部署人员和管理员。谷歌应用引擎（GAE）、新浪SAE也属于PaaS范畴。最大的好处在于免运维，对开发人员是个莫大的吸引力。

### SaaS

    软件即服务：Software as a service (SaaS) 对在云中运行的应用程序提供基于网络的访问。通常，在 SaaS 解决方案中，许多客户都共享对云交付的软件和数据库的访问。常见的 SaaS 应用包括客户关系管理（CRM）系统、企业资源规划（ERP）系统，Gmail也是一种SaaS，谷歌是提供商，我们大众则是消费者。
有争论的部分

### Docker的争议

* 能否彻底隔离

在超复杂的业务系统中，单OS到底能不能实现彻底隔离，一个程序的崩溃/内存溢出/高CPU占用到底会不会影响到其他容器或者整个系统?很多人对Docker能否在实际的多主机的生产环境中支持关键任务系统还有所怀疑。 注* 就像有人质疑Node.JS单线程快而不稳，无法在复杂场景中应用一样。

* GO语言还没有完全成熟

Docker由Go语言开发，但GO语言对大多数开发者来说比较陌生，而且还在不断改进，距离成熟还有一段时间。此半git、半包管理的方式让一些人产生不适。

* 被私有公司控制

Docker是一家叫Dotcloud的私有公司设计的，公司都是以营利为目的，比如你没有办法使用源代码编绎Docker项目，只能使用黑匣子编出的Docker二进制发行包，未来可能不是完全免费的。 目前Docker已经推出面向公司的企业级服务(咨询、支持和培训)。

### Docker VS OpenStack

OpenStack和Docker之间是很好的互补关系。Docker的出现能让IaaS层的资源使用得更加充分，因为Docker相对虚拟机来说更轻量，对资源的利用率会更加充分。

Docker主要针对Paas平台，是以应用为中心。OpenStack主要针对Iaas平台，以资源为中心，可以为上层的PaaS平台提供存储、网络、计算等资源。





参考资料：

* [Docker Getting Start: Related Knowledge - Tie Wei][docker_getting_start]
* [大白话Docker入门（一） - 云栖社区](https://yq.aliyun.com/articles/63035?utm_campaign=wenzhang&utm_medium=article&utm_source=QQ-qun&utm_content=m_7549)
* [用Docker之后还需要OpenStack吗？ - ustack](https://www.ustack.com/blog/do-i-need-docker-also-with-openstack/)
* [IBM 云技术：它们如何结合在一起 - IBM](http://www.ibm.com/developerworks/cn/cloud/library/cl-cloud-technology-basics/)
* [容器不会取代OpenStack，但二者如何深度整合？](http://www.csdn.net/article/2015-05-20/2824734)

[docker_getting_start]: http://tiewei.github.io/cloud/Docker-Getting-Start/
[docker_csdn]: http://docker.csdn.net/m/zone/docker/news?&amp;page=53