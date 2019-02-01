---
layout: post
title: Windows 下安装 Docker
category: tech
tags: windows docker
---

![](https://cdn.kelu.org/blog/tags/docker.jpg)

平时都是直接在 Linux 服务器上使用 Docker，原以为 Windows 下应该也差不多，没想到最终还是一波三折。还是得记录一下。

#  使用 docker toolbox 安装 docker

docker toolbox是一个工具集，它主要包含以下一些内容：

* Docker CLI 客户端，用来运行docker引擎创建镜像和容器
* Docker Machine. 可以让你在windows的命令行中运行docker引擎命令
* Docker Compose. 用来运行docker-compose命令
* Kitematic. 这是Docker的GUI版本
* Docker QuickStart shell. 这是一个已经配置好Docker的命令行环境
* Oracle VM Virtualbox. 虚拟机

Docker引擎的守护进程使用的是Linux的内核，需要运行Docker Machine 命令 docker-machine， 在你的机器上创建和获得一个Linux虚拟机，用这个虚拟机才可以在你的windows系统上运行Docker引擎

要想在 Windows 上使用 Docker，Windows 还必须满足以下几个条件：

* Win 7 或以上的版本
* 64 位操作系统
* 必须支持硬件虚拟化技术(Hardware Virtualization Technology)并且已被启用
    可以在任务管理器的 性能 -> CPU 一栏查看系统的虚拟化是否启用
    
    
    
# 安装Docker Toolbox

进入官网下载： [下载地址](https://www.docker.com/products/docker-toolbox)

Docker Toolbox 将会安装以下几个软件：

* Windows版的Docker客户端
* Docker Toolbox管理工具和ISO镜像
* Virtualbox
* Git MSYS-git Unix 工具

如果电脑已经装了Virtualbox，在安装的时候取消勾选就可以了

# Docker 初始化配置

安装完成后，系统的开始菜单中会生成两个快捷方式

* Docker Quickstart Terminal
* Kitematic (Alpha)

双击第一个进行配置。

然后你会收到docker去github上下载iso文件，然后就是下载失败的警告。。

嗯，主要是。。。中国人。。。会遇到这个问题。

因为，Docker 源是被墙的。。。。

没关系，下一步再切换源，目前出现的原因是下载最新的boot2docker.iso。实际上我们在安装 Docker Toolbox 时安装目录已经存在了 iso 文件了。将它拷贝到 docker-machine 的缓存文件夹中。各人的文件位置可能不一样，比如我的：

    C:\Users\kelu\.docker\machine\cache

所以下一步是切换源。

# 切换 Docker 源

docker machine 默认的配置文件名为 default，所以首先我们要进入它的环境修改配置：

    docker-machine ssh default
    vi /var/lib/boot2docker/profile
    
界面还蛮好看的2333333，大大的鲸鱼logo，下面跟着一行boot2docker。    

在EXTRA_ARGS中配置地址：
    
      EXTRA_ARGS='
      --label provider=virtualbox
      --registry-mirror http://XXX.m.daocloud.io
      '

daocloud和阿里云都有各自的源。xxx是你注册daocloud时系统分配的[地址](https://www.daocloud.io/mirror#accelerator-doc)。

如果打算新建docker-machine，应该使用这个：

    docker-machine create -d virtualbox --engine-registry-mirror=http://XXX.m.daocloud.io new-machine

# 结束

接下来，就可以按照linux下的使用习惯操作docker了。

# 参考资料

* [Windows10下的docker安装与入门 （一）使用docker toolbox安装docker](http://www.cnblogs.com/linjj/p/5606687.html)
