---
layout: post
title: firewalld 用法小结
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

# 简介

firewalld 提供了支持网络 / 防火墙区域 (zone) 定义网络链接以及接口安全等级的动态防火墙管理工具。它支持 IPv4, IPv6 防火墙设置以及以太网桥接，并且拥有运行时配置和永久配置选项。它也支持允许服务或者应用程序直接添加防火墙规则的接口。以前的 iptables 防火墙是静态的，每次修改都要求防火墙完全重启。这个过程包括内核 netfilter 防火墙模块的卸载和新配置所需模块的装载等。而模块的卸载将会破坏状态防火墙和确立的连接。现在 firewalld 可以动态管理防火墙，firewalld 把 Netfilter 的过滤功能于一身.

以上引自[《使用 firewalld 构建 Linux 动态防火墙 - IBM》](https://www.ibm.com/developerworks/cn/linux/1507_caojh/index.html)

# 运行、停止、禁用、状态

	systemctl start  firewalld.service
	systemctl disable firewalld.service
	systemctl stop firewalld.service
	systemctl restart firewalld.service
	
	systemctl status firewalld.service
	firewall-cmd --state

# zone

还没有做任何配置，default zone和active zone都应该是public

	firewall-cmd --get-default-zone
	firewall-cmd --get-active-zones

# 查看规则


### 查看已打开的端口和服务

	firewall-cmd --zone=public --list-ports
	firewall-cmd --list-services

### 还有哪些服务可以打开

	firewall-cmd --get-services

# 添加规则

	firewall-cmd --permanent --add-service=IPSec // 换成想要开放的service
	firewall-cmd --zone=public --add-port=8080/tcp --permanent    （
	
	# --permanent永久生效，没有此参数重启后失效

然后更新规则

# 删除

	firewall-cmd --zone= public --remove-port=80/tcp --permanent

# 更新规则 

	firewall-cmd --reload

或者直接重启 firewall

	systemctl restart firewalld

# 开机自启动

	systemctl enable firewalld.service
	systemctl disable firewalld.service
	systemctl is-enabled firewalld.service

