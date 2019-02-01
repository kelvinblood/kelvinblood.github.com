---
layout: post
title: Docker 新手上路（后记）
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

从 Docker 安装到使用，渊源等了解之后，对 Docker 有了比较全面的认识。在后记里着重于 Docker 生态圈的记录以及技术选型。

# 集群管理

随着要管理的容器越来越多，容器的集群管理平台就成了刚需。目前主流的容器管理平台包括Swarm，Kubernetes，Mesos。

### Docker Swarm

Swarm是Docker公司在2014年12月初新发布的容器集群管理工具。它可以把多个主机变成一个虚拟的Docker主机来管理。Swarm使用Go语言开发，并且开源，在github上可以找到它的全部source code。Swarm使用标准的Docker API，给Docker用户带来无缝的集群使用体验。2016年7月， Swarm已经被整合进入Docker Engine。

1. 特点

Docker Swarm的特点是配置和架构都很简单，使用Docker原生的API，可以很好的融合Docker的生态系统。

2. 功能

Docker Swarm提供API 和CLI来在管理运行Docker的集群，它的功能和使用本地的Docker并没有本质的区别。但是可以通过增加Node带来和好的扩展性。理论上，你可以通过增加节点（Node）的方式拥有一个无限大的Docker主机。
Swarm并不提供UI，需要UI的话，可以安装UCP，不过这个UCP是收费的!!!

相关资料：

* [身为一名极客，你竟然还不知道swarm集群？ - 恒生研发中心](http://rdc.hundsun.com/portal/article/609.html%EF%BC%9F=CSDN)
* [使用docker 1.12 搭建多主机docker swarm集群](http://www.lxy520.net/2016/07/02/shi-yong-docker-1-12-da-jian-duo-zhu-ji-docker-swarmji-qun/)
* [Docker Swarm入门教程](http://dockone.io/article/1237)


### Kubernetes
    
Kubernetes是Google开发的一套开源的容器应用管理系统，用于管理应用的部署，维护和扩张。利用Kubernetes能方便地管理跨机器运行容器化的应用。Kubernetes也是用Go语言开发的，在github上可以找到源代码。Kubernetes 源于谷歌公司的内部容器管理系统Borg，经过了多年的生产环境的历炼，所以功能非常强大。
    
1. 功能

* 使用Docker对应用程序包装(package)、实例化(instantiate)、运行(run)。
* 以集群的方式运行、管理跨机器的容器。
* 解决Docker跨机器容器之间的通讯问题。
* Kubernetes的自我修复机制使得容器集群总是运行在用户期望的状态。
* 应用的高可用和靠扩展
* 支持应用的在线升级（Rolling Update）
* 支持跨云平台（IaaS）的部署

2. 特点
    
    Kubernetes提供了很多应用级别的管理能力，包括高可用可高扩展，当然为了支持这些功能，它的架构和概念都比较复杂。

相关资料：

* [Google Kubernetes设计文档之网络 - CSDN](http://www.csdn.net/article/2014-12-29/2823320)


### Apache Mesos 

Mesos是为软件定义数据中心而生的操作系统，跨数据中心的资源在这个系统中被统一管理。Mesos的初衷并非管理容器，只是随着容器的发展，Mesos加入了容器的功能。Mesos可以把不同机器的计算资源统一管理，就像同一个操作系统，用于运行分布式应用程序。

Mesos的起源于Google的数据中心资源管理系统Borg。你可以从WIRED杂志的这篇文章中了解更多关于Borg起源的信息及它对Mesos影响。

1. 功能

Mesos的主要功能包括：

* 高度的可扩展和高可用
* 可自定义的两级调度
* 提供API进行应用的扩展
* 跨平台

2. 特点

Mesos相比Kubernetes和Swarm更为成熟，但是Mesos主要要解决的是操作系统级别的抽象，并非为了容器专门设计，如果用户出了容器之外，还要集成其它的应用，例如Hadoop，Spark，Kafka等，Mesos更为合适。Mesos是一个更重量级的集群管理平台，功能更丰富，当然很多功能要基于各种Framework。
Mesos的扩展性非常好，最大支持50000节点，如果对扩展性要求非常高的话么，Mesos是最佳选择。

相关资料：

* [Mesos高可用解决方案剖析 - 程序员](http://geek.csdn.net/news/detail/89372)


# Docker 与 大数据

## Docker 与 Hadoop

直接用机器搭建Hadoop集群是一个相当痛苦的过程，尤其对初学者来说。他们还没开始跑wordcount，可能就被这个问题折腾的体无完肤了。而且也不是每个人都有好几台机器对吧。 将Hadoop集群运行在Docker容器中，使Hadoop开发者能够快速便捷地在本机搭建多节点的Hadoop集群。

相关资料：

* [如何基于Docker快速搭建多节点Hadoop集群](http://bbs.jointforce.com/topic/17253)
* [使用Docker在本地搭建hadoop，spark集群](http://dockone.io/article/944)

## Docker 与 ELK

相关资料：
* [使用docker五步搭建ELK日志收集分析系统](http://www.zimug.com/333.html)
* [Elasticsearch2.3官方Dockerfile解析](http://www.zimug.com/330.html)

## Docker 与 TENSOFLOW

相关资料：
* [docker容器下tensoflow的cpu运行环境的构建](http://www.imaotao.cn/a/WZ052016833BR685)

# Docker 与 Jenkins

Jenkins是被广泛应用的持续集成、自动化测试、持续部署的框架，甚至有些项目组顺便将其用来做流程管理的工具。

相关资料：
* [Jenkins+Docker搭建持续集成测试环境](http://dockone.io/article/1464)
* [docker + jenkins + git + maven自动化构建与部署](http://www.lxy520.net/2016/04/16/docker-jenkins-git-mavenzi-dong-hua-gou-jian-yu-bu-shu/)

# Docker 与 Redis

相关资料：
* [Docker 搭建 redis 集群](http://www.lxy520.net/2015/10/20/docker/)
* [如何使用Docker实现Redis 3.0集群的一键部署交付？](http://www.yunweipai.com/archives/7794.html)

# Docker 与 Serverless

Serverless 不意味着没有服务器，而是从应用可以在一个抽象层上忽略它的存在，而只关注在功能实现上和自身的请求处理上；每一个功能实现在不是单纯的业务逻辑处理的代码，相反每个功能调用具有了 Server 的特质，进化成为了一个具有自省、自知和自治的工作负载单元；他们更像是能够衍生出其它新功能单元的生物体。这样整个 Serverless 应用架构之内，每个生命可以衍生下去，子子孙孙无穷匮也。

* [用 Docker 构建 Serverless 应用](http://www.youruncloud.com/blog/69.html)

# Docker 与 测试运维

* [快速部署Test-Driven Development/Debug环境](http://geek.csdn.net/news/detail/73432)
* [【大运维之一】自动化实践探索的最优路径](http://www.csdn.net/article/2015-08-05/2825387)
* [Docker + Jenkins 快速打造 PHP 持续集成服务器](https://laravel-china.org/topics/1416)
* [Docker监控技术原理和阿里云容器监控服务实践](https://yq.aliyun.com/articles/68393?utm_campaign=wenzhang&utm_medium=article&utm_source=QQ-qun&utm_content=m_9104)


# Docker 的实践案例

* [携程Docker实践](http://geek.csdn.net/news/detail/64295)
* [游戏研发与运营环境Docker化](http://geek.csdn.net/news/detail/64287)
* [雪球的Docker实践](http://www.infoq.com/cn/articles/docker-in-xueqiu)
* [Docker在Bilibili的实战：由痛点推动的容器化](http://www.tuicool.com/articles/Qneueaf)
* [架构师交流会 ： 来自沪江、滴滴、蘑菇街架构师的 DOCKER 实践分享](http://www.tuicool.com/articles/32EBrai)


# Docker 与其他

* [如何使用Docker快速配置数据科学开发环境？](http://codingpy.com/article/data-science-quickstart-with-docker/)
* [听说别人家公司都已经把系统Docker化了？](http://rdc.hundsun.com/portal/article/612.html?from=CSDN)
* [weekly.dockerone](http://weekly.dockerone.com/issues)

# 参考资料

* [容器集群管理平台的比较 - Oschina](https://my.oschina.net/taogang/blog/778136)
* [philo.top](http://www.philo.top/)
* [Docker专题汇总](http://www.zimug.com/360.html)
* [Docker暴露2375端口，引起安全漏洞](http://geek.csdn.net/news/detail/75236)

补充参考资料：
* [容器生态圈项目一览：引擎、编排、OS、Registry、监控](http://dockone.io/article/724)
* [容器，你还只用Docker吗？（下）](http://www.yunweipai.com/archives/10358.html) - 周晖 Pivotal 云计算首席架构师
* [Docker 生态圈指南](http://blog.liulantao.com/docker-ecosystem-guide.html) - Liu Lantao 环信 运维总监
