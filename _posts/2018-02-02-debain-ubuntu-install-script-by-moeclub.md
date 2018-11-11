---
layout: post
title:  Debian(Ubuntu)网络安装/重装系统一键脚本 | 转自萌咖
category: tech
tags: network
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

原文地址：<https://moeclub.org/2017/03/25/82/?v=552>

# 背景

	适用于由GRUB引导的CentOS,Ubuntu,Debian系统.
	使用官方发行版去掉模板预装的软件.
	同时也可以解决内核版本与软件不兼容的问题。
	只要有root权限,还您一个纯净的系统。

# 注意

	全自动安装默认root密码:`Vicer`,安装完成后请立即更改密码.
	请使用 `passwd root` 命令更改密码.
	**特别注意:_`OpenVZ`构架不适用._**

# 需要

	1.`Debian/Ubuntu/CentOS` 系统(由`GRUB`引导)；
	2.`wget` 用来下载文件，获取公网IP;
	3.`ip` 获取网关，掩码等;
	4.`sed awk grep` 处理文本流；
	5.`VNC` 安装系统(此项为可选)。

# 确保安装了所需软件

		#Debian/Ubuntu:
		apt-get update
		apt-get install  -y  gawk sed grep
		
		#RedHat/CentOS:
		yum update
		yum install  -y  gawk sed grep

# 一键下载及使用

		wget  --no-check-certificate  -qO DebianNET.sh  'https://moeclub.org/attachment/LinuxShell/DebianNET.sh'  &&  chmod  a+x  DebianNET.sh
		
		Usage:
		
		        bash DebianNET.sh -d/--debian  [dist-name]
		                                -u/--ubuntu  [dist-name]
		                                -v/--ver  [32/i386|64/amd64]
		                                -apt/--mirror
		                                -dd/--image
		                                -a/-m

# 全自动/非全自动示例
# 全自动/非全自动示例

	全自动安装:
	
		bash DebianNET.sh  -d  wheezy  -v  i386  -a
	
	VNC手动安装:
	
		bash DebianNET.sh  -d  wheezy  -v  i386  -m

# 使用示例

	【默认】安装Debian 7 x32：
	
		bash DebianNET.sh  -d  wheezy  -v  i386
		bash DebianNET.sh  -d  7  -v  32
	
	安装Debian 8 x64：
	
		bash DebianNET.sh  -d  jessie  -v  amd64
		bash DebianNET.sh  -d  8  -v  64
	
	安装Debian 9 x64：
	
		bash DebianNET.sh  -d  stretch  -v  amd64
		bash DebianNET.sh  -d  9  -v  64
	
	安装Ubuntu 14.04 x64：
	
		bash DebianNET.sh  -u  trusty  -v  64
	
	安装Ubuntu 16.04 x64：
	
		bash DebianNET.sh  -u  xenial  -v  64
	
	安装Ubuntu 18.04 x64：
	
		bash DebianNET.sh  -u  bionic  -v  64

# 【默认】预览

	![](https://cdn.kelu.org/blog/2018/02/InstallOS.jpg)
