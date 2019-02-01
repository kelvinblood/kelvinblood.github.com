---
layout: post
title:  Linux 安装 pstree
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

pstree是linux很有用的一个命令，用来打印系统当前各个进程父子关系：

![](https://cdn.kelu.org/blog/2018/02/linux_20180209134508.jpg)

然而linux下安装的软件包并不是叫 pstree：

	#On Mac OS  
	brew install pstree  
	
	#On Fedora/Red Hat/CentOS  
	yum install psmisc
	
	#On Ubuntu/Debian APT  
	apt-get install psmisc
