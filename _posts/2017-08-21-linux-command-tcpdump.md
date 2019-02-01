---
layout: post
title: Linux命令之tcpdump
category: tech
tags: linux linux-command
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

# 简介

tcpdump是非常强大的网络安全分析工具，可以将网络上截获的数据包保存到文件以备分析。可以定义过滤规则，只截获感兴趣的数据包，以减少输出文件大小和数据包分析时的装载和处理时间。

tcpdump可以将网络中传送的数据包的“头”完全截获下来提供分析。它支持针对网络层、协议、主机、网络或端口的过滤，并提供and、or、not等逻辑语句来帮助你去掉无用的信息。

我在文章[Linux 网络监控与统计实例](/tech/2017/04/13/linux-network-monitor-and-stats-example.html)有过一些例子。这篇文章做一个简单的介绍。详细的内容可以参考文末的参考资料。


# 用法

	tcpdump [-adeflnNOpqRStuvxX] [ -c count ] [ -C file_size ]
	                 [ -F file ] [ -i interface ] [ -r file ] [ -s snaplen ]
	                 [ -T type ] [ -U user ] [ -w file ] [ -E algo:secret ] [ expression ]

		-c 捕获指定数量的报文 
		-F使用文件作为过滤表达式的源 
		-i 使用可选网络接口捕获报文 
		-p 禁止在杂凑模式下捕获
		- r读取捕获文件而非网络接口 
		-w保存原始报文到文件中

# **实用命令实例**

	tcpdump

普通情况下，直接启动tcpdump将监视第一个网络接口上所有流过的数据包。

### 1.1、过滤主机

*   抓取所有经过eth1，目的或源地址是192.168.1.1的网络数据

		tcpdump -i eth1 host 192.168.1.1

*   指定源地址

		tcpdump -i eth1 src host 192.168.1.1

*   指定目的地址

		tcpdump -i eth1 dst host 192.168.1.1

### 1.2、过滤端口

*   抓取所有经过eth1，目的或源端口是25的网络数据

		tcpdump -i eth1 port 25

*   指定源端口

		tcpdump -i eth1 src port 25

*   指定目的端口

		tcpdump -i eth1 dst port 25

* 有些版本的tcpdump允许指定端口范围

		tcpdump tcp portrange 20-24

### 1.3、网络过滤

	tcpdump -i eth1 net 192.168
	tcpdump -i eth1 src net 192.168
	tcpdump -i eth1 dst net 192.168

### 1.4、协议过滤

	tcpdump -i eth1 arp
	tcpdump -i eth1 ip
	tcpdump -i eth1 tcp
	tcpdump -i eth1 udp
	tcpdump -i eth1 icmp

### 1.5、常用表达式

	非 : ! or "not" (去掉双引号)  
	且 : && or "and"  
	或 : || or "or"

*   抓取所有经过eth1，目的地址是192.168.1.254或192.168.1.200端口是80的TCP数据

		tcpdump -i eth1 '((tcp) and (port 80) and ((dst host 192.168.1.254) or (dst host 192.168.1.200)))'

*   抓取所有经过eth1，目标MAC地址是00:01:02:03:04:05的ICMP数据

		tcpdump -i eth1 '((icmp) and ((ether dst host 00:01:02:03:04:05)))'

*   抓取所有经过eth1，目的网络是192.168，但目的主机不是192.168.1.200的TCP数据

		tcpdump -i eth1 '((tcp) and ((dst net 192.168) and (not dst host 192.168.1.200)))'

# 其他

`-c`参数对于运维人员来说也比较常用，因为流量比较大的服务器，靠人工CTRL+C还是抓的太多，甚至导致服务器宕机，于是可以用`-c`参数指定抓多少个包。

	time tcpdump -nn -i eth0 'tcp[tcpflags] = tcp-syn' -c 10000 > /dev/null

上面的命令计算抓10000个SYN包花费多少时间，可以判断访问量大概是多少。

# 参考资料

* [Linux tcpdump命令详解](http://www.cnblogs.com/ggjucheng/archive/2012/01/14/2322659.html)
* [tcpdump详细用法](http://blog.csdn.net/cclsoft/article/details/4476673)
* [tcpdump使用技巧](http://linuxwiki.github.io/NetTools/tcpdump.html)
* [linuxwiki](https://github.com/linuxwiki)/[SourceWiki](https://github.com/linuxwiki/SourceWiki)