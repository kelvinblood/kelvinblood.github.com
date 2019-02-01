---
layout: post
title: 使用vnc/xrdp连接你的Debian
category: tech
tags: linux
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

前言：vnc的配置非常简单，简单到虽然界面显示很挫，依然因为惰性而懒得换。嘛，先记录一下再换Orz

## 安装

安装x11窗口管理器(jwm)，该窗口下的终端(xterm)，以及vnc服务器(vnc4server)。

	apt-get install jwm xterm vnc4server iceweasel
	

JWM是一个简洁实用的X11窗口管理器，Puppy发行版默认的窗口管理器就是用的jwm。使用C语言编写，最小化编译可以仅使用Xlib库，代码精炼，目标文件小巧（只有130多K），足以说明作者的功底。
JWM是一个简洁实用的X11窗口管理器，Puppy发行版默认的窗口管理器就是用的jwm。使用C语言编写，最小化编译可以仅使用Xlib库，代码精炼，目标文件小巧（只有130多K），足以说明作者的功底。
项目主页：http://joewing.net/programs/jwm/index.shtml

XTerm是一个X Window System上的终端模拟器，用来提供多个独立的SHELL输入输出。

Virtual Network Computing(VNC)是进行远程桌面控制的一个软件。客户端的键盘输入和鼠标操作通过网络传输到远程服务器，控制服务器的操作。服务器的图形界面通过网络传输会客户端显示给用户。给你的感觉就像直接在操作本地计算机一样，只是所有的程序和命令都是在服务器端执行。

iceweasel，你可以当成firefox浏览器。
安装flash，

    tar -xzvf xxx.tar.gz
    cp libflashplayer.so /usr/lib/mozilla/plugins/libflashplayer.so
    cp -r usr/* /usr/
## 简单配置vnc

	vi /etc/bin/vncserver
	$vncPort = 5900 + $displayNumber

新建一个vncserver，默认会在5900的基础上+N。新建vncserver是如果不指定vnc号码，就按照1,2,3的顺序依次递增，端口也就是5901,5902,5903递增。可以按照需求改掉

	.vnc/xstartup
	#!/bin/sh
	
	temp=$(ps aux | grep [f]irefox-bin | awk '{print $2}')
	[ -n "$temp" ] && kill $temp > /dev/null 2>&1
	firefox --display=:1 > /dev/null 2>&1
	gnome-session& # 启动桌面

## 给iptables添加规则

	-A INPUT -p tcp --dport 5901:XXXX -j ACCEPT
	-A INPUT -p tcp --dport 5801:XXXX -j ACCEPT
	# 要和vnc的配置文件保持一致。

## 客户端连接

![image](https://cdn.kelu.org/blog/2015/01/vnc-connect.jpg)

## 使用windows自带的远程连接

	apt-get install xrdp

在本地就使用Mircosoft Remote Desktop，windows自带，Mac在应用商店也可以免费下载。

![xrdp.jpg](https://cdn.kelu.org/blog/2015/01/xrdp.jpg)

## 安装firefox

首先把iceweasel卸载

### 1. 添加APT源地址

我们需要在/etc/apt/sources.list添加下面的源地址：

	deb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main

除了使用编辑器外我们还可以通过下面的命令操作来轻松完成：

	echo -e "\ndeb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main" | sudo tee -a /etc/apt/sources.list > /dev/null

### 2. 导入密钥Key

	sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com C1289A29

### 3. 更新APT源列表

	sudo apt-get update

### 4. 安装软件

	# 安装FireFox
	sudo apt-get install firefox-mozilla-build
	# 安装ThunderBird
	sudo apt-get install thunderbird-mozilla-build
	# 安装SeaMonkey
	sudo apt-get install seamonkey-mozilla-build

### 5.一些可能有用的安装tips

    dpkg: error processing firefox-mozilla-build (--configure):
     package firefox-mozilla-build is not ready for configuration
     cannot configure (current status `half-installed')
    Errors were encountered while processing:
     firefox-mozilla-build
    E: Sub-process /usr/bin/dpkg returned an error code (1)
    
    apt-get install --reinstall firefox-mozilla-build
