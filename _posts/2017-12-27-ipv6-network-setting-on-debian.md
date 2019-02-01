---
layout: post
title:  Debian 下 ipv6 网络设置
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

CentOS 下的设置与 Debian 颇不同。目前不需要，也就不写了。

Debian 下设置示例如下：

	vi /etc/network/interfaces
	

	source /etc/network/interfaces.d/*
	
	auto lo
	iface lo inet loopback
	
	auto ens3
	iface ens3 inet static
	        address xxx.xxx.xxx.xxx
	        netmask 255.255.254.0
	        gateway xxx.xxx.xxx.1
	        # dns-* options are implemented by the resolvconf package, if installed
	        dns-nameservers xxx.xxx.xxx.10 xxx.xxx.xxx.11
	        dns-search xxx.jp
	
	iface ens3 inet6 static
	        address 2001:xxxx:12
	        netmask 64
	        gateway xxxx::1
	        dns-nameservers 2001:xxxx::2

设置完成后重启网络：

	service network restart
