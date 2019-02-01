---
layout: post
title:  Linux 测试端口通不通
category: tech
tags:  linux windows
---
![](https://cdn.kelu.org/blog/tags/network.jpg)

说到端口通不通，大部分人第一反应都是 ping。可惜ping命令是不能够测试端口的，只是测试网络联接状况以及信息包发送和接收状况。

我们需要用 telnet 命令。telnet 是 windows 标准服务，可以直接用；如果是 linux 机器，需要安装 telnet.

	用法: telnet ip port

1）先用telnet连接不存在的端口

	[root@localhost ~]# telnet 10.0.250.3 80
	Trying 10.0.250.3...
	telnet: connect to address 10.0.250.3: Connection refused #直接提示连接被拒绝

2）再连接存在的端口

	[root@localhost ~]# telnet localhost 22
	Trying ::1...
	Connected to localhost. #看到Connected就连接成功了
	Escape character is '^]'.
	SSH-2.0-OpenSSH_5.3
	a
	Protocol mismatch.
	Connection closed by foreign host.
