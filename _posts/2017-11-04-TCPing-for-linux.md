---
layout: post
title: Linux 下的 TCPing
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

以前写了一篇 [《禁ping也能ping的工具:tcping》](/software/2017/04/26/windows-ping-tools-over-tcping.html)，介绍了由 Eli Fulkerson 编写的 Windows 下的 tcping 这个工具， ping 那些不允许 ping 的主机。

今天介绍 Linux 下的 TCPing，来自 richard。

# 什么是 TCPing

tcping 是模仿 icmp 协议下的 ping 命令，不一样的是 tcping 走的是 tcp 协议。所以 TCPing 还支持监听具体某个端口的状态。

因此，即使服务器禁止 Ping，也可以通过 TCPing 来测试与服务器的连接。


# 安装

使用 richard 的 tcpping 首先要安装好 tcptraceroute：

	sudo apt-get install tcptraceroute bc

```
cd /usr/local/bin
sudo wget http://www.vdberg.org/~richard/tcpping
sudo chmod 755 tcpping
```
我给 tcping 也做了一个备份：<https://cdn.kelu.org/blog/2017/11/tcpping>，可以在我网站下载。

# 用法

tcpping v1.7 Richard van den Berg <richard@vdberg.org>

Usage: tcpping [-d] [-c] [-C] [-w sec] [-q num] [-x count] ipaddress [port]

        -d   print timestamp before every result
        -c   print a columned result line
        -C   print in the same format as fping's -C option
        -w   wait time in seconds (defaults to 3)
        -r   repeat every n seconds (defaults to 1)
        -x   repeat n times (defaults to unlimited)

也可以使用`man tcptraceroute`查看用法。

例如：

	tcpping xxx.com
	
	tcpping xxx.com 12345

![](https://cdn.kelu.org/blog/2017/11/tcpping.jpg)

# 参考资料

* [TCPing 工具介绍](http://tookdes.org/geek/archives/tcping-intro.html)