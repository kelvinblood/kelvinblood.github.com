---
layout: post
title: 一个简单的局域网服务器互联案例(3.5) —— 使用说明
category: tech
tags: linux
style: summer
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

接上篇。这是一篇使用手册。

经过前三篇文章的操作后，已经可以将环境交付给开发人员使用了。这是一篇简单的使用说明。分为管理员篇和开发人员篇。

# 管理员

所有的操作统一在100机器上进行。

## 添加用户

例如我们需要添加以为名叫`keluTest`的用户，使用

	./addUser.sh keluTest

即可在4台机器上生成该用户，初始密码是`Qweewq`，密钥所在位置为 `/home/keluTest/.ssh/keluTest`

## 删除用户

	./delUser.sh keluTest

即可在四台机器上同步删除用户。

# 开发人员

使用管理员提供的密钥和密码进行登陆，例如开发人员为`keluTest`，登陆方式为

	ssh keluTest@10.37.231.228:10100
	ssh keluTest@10.37.231.228:10101
	ssh keluTest@10.37.231.228:10102
	ssh keluTest@10.37.231.228:10103

在开发机上简单使用
	
	ssh 100
	ssh 101
	ssh 102
	ssh 103

即可访问。

本地Windows上使用putty或其它工具登陆。其它工具可以直接使用密钥登陆，putty需要生成自用密钥，生成方式参照这篇文章：[《一个简单的局域网服务器互联案例 1》](/tech/2017/10/10/build-a-local-area-network.html)putty大概如下图配置即可：

![](https://cdn.kelu.org/blog/2017/10/lan6.jpg)

![](https://cdn.kelu.org/blog/2017/10/lan7.jpg)
