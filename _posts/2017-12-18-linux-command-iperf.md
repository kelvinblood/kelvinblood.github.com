---
layout: post
title: linux网络测速命令 iperf
category: tech
tags: linux linux-command
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

iperf命令是一个网络性能测试工具，用来测试TCP和UDP带宽质量，它可以报告带宽，延迟抖动和数据包丢失。利用iperf这一特性，可以用来测试一些网络设备如路由器，防火墙，交换机等的性能。


## 安装

centos直接使用yum安装：

	sudo yum install -y iperf3

也可以源码安装<http://code.google.com/p/iperf/downloads/list>：

	gunzip -c iperf.tar.gz | tar -xvf - 
	cd iperf
	./configure 
	make 
	make install

## UDP模式 

服务器端：

	iperf -u -s 

客户端： 

	iperf -u -c 192.168.1.1 -b 100M -t 60  		# 100Mbps发送速率，60秒。 
	iperf -u -c 192.168.1.1 -b 5M -P 30 -t 60 	# 30个连接线程，5Mbps 
	iperf -u -c 192.168.1.1 -b 100M -d -t 60 	# 100Mbps发送速率，上下行带宽测试。60秒

## TCP模式 

服务器端： 

	iperf -s 

客户端： 

	iperf -c 192.168.1.1 -t 60 在
	iperf -c 192.168.1.1 -P 30 -t 60 
	iperf -c 192.168.1.1 -d -t 60 
