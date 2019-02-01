---
layout: post
title: Linux 禁止 ping 的几种方法
category: tech
tags: php laravel
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

# 系统层面

## 临时生效

	echo 1 >/proc/sys/net/ipv4/icmp_echo_ignore_all # 忽略所有 ping 指令

	echo 0 >/proc/sys/net/ipv4/icmp_echo_ignore_all # 恢复

## 永久生效

`vi /etc/sysctl.conf` 设置

	net.ipv4.icmp_echo_ignore_all=1

保存后

`sysctl -p`

或者输入以下命令
	
	echo net.ipv4.icmp_echo_ignore_all=1 >>/etc/sysctl.conf
	echo net.ipv4.icmp_echo_ignore_all=0 >>/etc/sysctl.conf

# iptable 丢弃ICMP包

	iptables -A INPUT -p icmp --icmp-type 8 -s 0/0 -j DROP

然后

	iptabels-save

关于 iptable 的用法可以参考我这篇文章。

[《Linux管理员应该了解的20条IPTables防火墙规则用法》](https://blog.kelu.org/tech/2017/04/07/iptables-firewall-rules-examples.html)
