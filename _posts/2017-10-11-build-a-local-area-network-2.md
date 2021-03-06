---
layout: post
title: 一个简单的局域网服务器互联案例(2) —— 不同网段下的访问
category: tech
tags: linux
style: summer
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

接上篇。

# 背景

在上一篇我组建一个由4台服务器组成的局域网。然而这个局域网是有一个限制——必须要接入WiFi才能进行访问和开发。

由于这个局域网和开发人员不处在同一个网段内，每次访问都需要切换到WiFi所在的网络才能访问，非常繁琐，而且如果是在不同楼层，甚至不同地区的开发人员，基本就不能访问了。

所以这一篇的目标是在公司内网环境下可以自由接入该局域网开发环境。

# 搭建

![组网示意图](https://cdn.kelu.org/blog/2017/10/lan21.jpg)

# 过程

解决这样的需求有两种方式，一种是类似于花生壳的内网穿透技术，请求发送到外部服务器，外部再转发到内网里来。然而这并不是这次开发中需要的。二是在路由器上做端口映射，像aws一样配置路由即可。

![端口映射](https://cdn.kelu.org/blog/2017/10/lan22.jpg)

如上图配好映射后，同网段内的电脑访问开发机的方式变为：

	ssh root@xx.xx.xx.39:10100
	ssh root@xx.xx.xx.39:10101
	ssh root@xx.xx.xx.39:10102
	ssh root@xx.xx.xx.39:10103

今后每当服务器启动某些对外的服务时，通过路由器的这个设置，打开对应的端口映射即可。
