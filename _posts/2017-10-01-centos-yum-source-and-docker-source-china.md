---
layout: post
title: CentOS 源与 Docker 源加速的设置
category: tech
tags: linux docker
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

最近接触了一些 CentOS 和 Docker，对基本的操作还不太了解。记录一下。

# CentOS 源

yum 的配置文件分为两部分: main 和repository

*   main 部分定义了全局配置选项，整个yum 配置文件应该只有一个main。常位于/etc/yum.conf 中。
*   repository 部分定义了每个源/服务器的具体配置，可以有一到多个。常位于/etc/yum.repo.d 目录下的各文件中。

yum.conf 文件一般位于/etc目录下，一般其中只包含main部分的配置选项。

`/etc/yum.repos.d/`下有若干个文件，也可以新建文件添加自定义的源。

* CentOS-Base.repo 是yum 网络源的配置文件
* CentOS-Media.repo 是yum 本地源的配置文件

# Docker 源

通过 Docker 官方镜像加速，中国区用户能够快速访问最流行的 Docker 镜像。

修改 /etc/docker/daemon.json 文件并添加上 registry-mirrors 键值。

```
{  
	"registry-mirrors": ["https://registry.docker-cn.com"]
}
```
也可以使用阿里云的源：

	https://7bezldxe.mirror.aliyuncs.com

修改保存后重启 Docker 生效。


# 参考资料

* [CentOS yum 源的配置与使用](http://www.cnblogs.com/mchina/archive/2013/01/04/2842275.html)
* [Docker 中国官方镜像加速](https://www.docker-cn.com/registry-mirror)


