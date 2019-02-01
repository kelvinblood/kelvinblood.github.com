---
layout: post
title: VIRTUALBOX 宿主机 SSH 连接虚拟机
category: tech
tags: linux windows
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)



VirtualBox 安装好系统后，默认网络连接是“网络地址转换(NAT)”，可以访问外网和宿主机，但是宿主机无法访问。

目前需要对虚拟机进行访问，所以记录一下设置过程。



## 网络桥接

设置桥接网络即可。让路由也给虚拟机分配一个IP。

![](https://cdn.kelu.org/blog/2018/02/20180418154700.jpg)



## 查看ip

![](https://cdn.kelu.org/blog/2018/02/20180418154812.jpg)