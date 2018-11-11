---
layout: post
title:  Traceroute 原理 | 转自wolfcstech
category: tech
tags: network
---
![](https://cdn.kelu.org/blog/tags/network.jpg)

原文地址：<https://www.wolfcstech.com/2017/04/13/Traceroute原理/>

**traceroute**，现代 Linux 系统上的 **tracepath**，还有Windows 系统上的 **tracert**，均是用于同一目的的网络调试工具。它们用于显示数据包在IP网络中经过的路由器的IP地址。

# 原理

这些程序是利用IP数据包的存活时间（TTL）值来实现其功能的。当一台计算机发送IP数据包时，会为数据包设置存活时间（TTL）值。每当数据包经过一个路由器，其存活时间值就会减 1。当存活时间减到 0 时，路由器将不再转发数据包，而是发送一个 ICMP TTL 数据包给最初发出数据包的计算机。

Traceroute 程序首先向目标主机发出 TTL 为 1 的数据包，发送数据包的计算机与目标主机之间的路径中的第一个路由器，在转发数据包时将数据包的 TTL 减 1，它发现 TTL 被减为了 0，于是向最初发出数据包的计算机发送一个 ICMP TTL 数据包，Traceroute 程序以此获得了与目标主机之间的路径上的第一个路由器的IP地址。后面 traceroute 程序依次向目标主机发送 TTL 为 2、3、4 . . . 的数据包，逐个探测出来与目标主机之间的路径上每一个路由器的 IP 地址。

# 实现

默认条件下，traceroute 首先发出 TTL = 1 的UDP 数据包，第一个路由器将 TTL 减 1 得 0 后就不再继续转发此数据包，而是返回一个 ICMP 超时报文，traceroute 从超时报文中即可提取出数据包所经过的第一个网关的 IP 地址。然后又发送了一个 TTL = 2 的 UDP 数据包，由此可获得第二个网关的 IP 地址。依次递增 TTL 便获得了沿途所有网关的 IP 地址。

需要注意的是，并不是所有网关都会如实返回 ICMP 超时报文。处于安全性考虑，大多数防火墙以及启用了防火墙功能的路由器缺省配置为不返回各种 ICMP 报文，其余路由器或交换机也可能被管理员主动修改配置变为不返回 ICMP 报文。因此 Traceroute 程序不一定能拿到所有的沿途网关地址。所以，当某个 TTL 值的数据包得不到响应时，并不能停止这一追踪过程，程序仍然会把 TTL 递增而发出下一个数据包。这个过程将一直持续到数据包发送到目标主机，或者达到默认或用参数指定的追踪限制（maximum_hops）才结束追踪。

依据上述原理，利用了 UDP 数据包的 Traceroute 程序在数据包到达真正的目的主机时，就可能因为该主机没有提供 [UDP](https://zh.wikipedia.org/wiki/UDP) 服务而简单将数据包抛弃，并不返回任何信息。为了解决这个问题，Traceroute 故意使用了一个大于 30000 的端口号，因 UDP 协议规定端口号必须小于 30000 ，所以目标主机收到数据包后唯一能做的事就是返回一个 “端口不可达” 的 ICMP 报文，于是主叫方就将端口不可达报文当作跟踪结束的标志。

# Wireshark 抓包分析

我们通过 Wireshark 抓包来看一下这个过程。我们追踪从我们的 PC 机到 `www.163.com` 之间的网络路径。打开 Wireshark，以如图所示的选项开始抓包：

![](https://cdn.kelu.org/blog/2018/02/1315506-640ab44e44f1cd0c.jpg)



然后我们在命令行执行 `traceroute` 程序：

	$ traceroute  www.163.com
	traceroute to www.163.com (183.131.124.101), 30 hops max, 60 byte packets
	 1  10.240.252.1 (10.240.252.1)  0.441 ms  0.530 ms  0.712 ms
	 2  10.247.0.1 (10.247.0.1)  0.459 ms  0.549 ms  0.739 ms
	 3  10.0.10.15 (10.0.10.15)  0.479 ms  0.481 ms  0.471 ms
	 4  * * *
	 5  10.163.4.53 (10.163.4.53)  1.092 ms 10.163.4.57 (10.163.4.57)  1.008 ms 10.163.4.53 (10.163.4.53)  1.005 ms
	 6  115.238.118.185 (115.238.118.185)  1.006 ms 115.238.118.177 (115.238.118.177)  1.112 ms  1.502 ms
	 7  115.238.120.85 (115.238.120.85)  1.769 ms 115.238.120.89 (115.238.120.89)  1.480 ms 115.238.120.85 (115.238.120.85)  1.918 ms
	 8  220.191.200.145 (220.191.200.145)  9.229 ms 220.191.200.101 (220.191.200.101)  9.074 ms 220.191.200.93 (220.191.200.93)  1.563 ms
	 9  61.175.73.130 (61.175.73.130)  7.294 ms * 61.175.73.146 (61.175.73.146)  7.810 ms
	10  60.191.177.122 (60.191.177.122)  26.955 ms 115.231.144.94 (115.231.144.94)  25.918 ms  26.634 ms
	11  * * *
	12  183.131.124.101 (183.131.124.101)  8.381 ms  7.120 ms  8.036 ms

这个过程中我们总共抓到了 67 个数据包。
![](https://cdn.kelu.org/blog/2018/02/1315506-65077453751b12a1.jpg)

我们选中第 1 号包，也就是用于探测路径中第一个网关的 UDP 包，在下方的数据包详情中，可以看到 `Time to live` 值为 1。我们再选中用于探测路径中第二个网关的 UDP 包，即第 5 号包，可以看到 `Time to live` 值为 2：
![](https://cdn.kelu.org/blog/2018/02/1315506-a302b370ce50360e.jpg)

同时还能看到数据包发送的源端口为 UDP `34341`，目的端口为 `33438`。

第 17 ～ 29 号包为中间路由节点发送回来的 TTL 超时 ICMP包。数据包被发送到目标主机时，目标主机将发回目标不可达的 ICMP 包，如下图：
![](https://cdn.kelu.org/blog/2018/02/1315506-e8c0c13cca0ab0d7.jpg)

第 62 ～ 64 号包即为目标主机发回的数据包。

# UDP 之外的选择

使用 UDP 的 traceroute，失败还是比较常见的。这常常是由于，在运营商的路由器上，UDP 与 ICMP 的待遇大不相同。为了利于 troubleshooting，ICMP ECHO Request/Reply 是不会封的，而 UDP 则不同。UDP 常被用来做网络攻击，因为 UDP 无需连接，因而没有任何状态约束它，比较方便攻击者伪造源 IP、伪造目的端口发送任意多的 UDP 包，长度自定义。所以运营商为安全考虑，对于 UDP 端口常常采用白名单 ACL，就是只有 ACL 允许的端口才可以通过，没有明确允许的则统统丢弃。比如允许 DNS/DHCP/SNMP 等。

UNIX/Linux 下的 traceroute 还提供了如下的选项：

	$ traceroute --help
	Usage:
	  traceroute [ -46dFITnreAUDV ] [ -f first_ttl ] [ -g gate,... ] [ -i device ] [ -m max_ttl ] [ -N squeries ] [ -p port ] [ -t tos ] [ -l flow_label ] [ -w waittime ] [ -q nqueries ] [ -s src_addr ] [ -z sendwait ] [ --fwmark=num ] host [ packetlen ]
	
	Options:
	  -4                          Use IPv4
	  -6                          Use IPv6
	  -d  --debug                 Enable socket level debugging
	  -F  --dont-fragment         Do not fragment packets
	  -f first_ttl  --first=first_ttl
	                              Start from the first_ttl hop (instead from 1)
	  -g gate,...  --gateway=gate,...
	                              Route packets through the specified gateway
	                              (maximum 8 for IPv4 and 127 for IPv6)
	  -I  --icmp                  Use ICMP ECHO for tracerouting
	  -T  --tcp                   Use TCP SYN for tracerouting (default port is 80)
	  -i device  --interface=device
	                              Specify a network interface to operate with
	  -m max_ttl  --max-hops=max_ttl
	                              Set the max number of hops (max TTL to be
	                              reached). Default is 30
	  -N squeries  --sim-queries=squeries
	                              Set the number of probes to be tried
	                              simultaneously (default is 16)
	  -n                          Do not resolve IP addresses to their domain names
	  -p port  --port=port        Set the destination port to use. It is either
	                              initial udp port value for "default" method
	                              (incremented by each probe, default is 33434), or
	                              initial seq for "icmp" (incremented as well,
	                              default from 1), or some constant destination
	                              port for other methods (with default of 80 for
	                              "tcp", 53 for "udp", etc.)
	. . . . . .
	  -U  --udp                   Use UDP to particular port for tracerouting
	                              (instead of increasing the port per each probe),
	                              default port is 53
	  -UL                         Use UDPLITE for tracerouting (default dest port
	                              is 53)
	  -D  --dccp                  Use DCCP Request for tracerouting (default port
	                              is 33434)
	  -P prot  --protocol=prot    Use raw packet of protocol prot for tracerouting
	  --mtu                       Discover MTU along the path being traced. Implies
	                              `-F -N 1'
	  --help                      Read this help and exit
	Arguments:
	+     host          The host to traceroute to
	      packetlen     The full packet length (default is the length of an IP
	                    header plus 40). Can be ignored or increased to a minimal
	                    allowed value
	

除了 UDP 之外，我们还可以用 TCP 或 ICMP 来探测网络路径。
除了 UDP 之外，我们还可以用 TCP 或 ICMP 来探测网络路径。

Traceroute 使用 TCP 探测网络路径的原理是，不断发出 TTL 逐渐增大的 TCP [SYN] 包，在收到目标主机发回的 TCP [SYN ACK] 或达到默认或设置的追踪限制（maximum_hops）时结束追踪。我们用这种方法来探测到 `www.qq.com` 的网络路径。适当修改 Wireshark 的抓包选项，并在命令行中执行：

	$ sudo traceroute -T www.qq.com
	traceroute to www.qq.com (182.254.34.74), 30 hops max, 60 byte packets
	 1  10.240.252.1 (10.240.252.1)  0.364 ms  0.486 ms  0.655 ms
	 2  10.247.0.1 (10.247.0.1)  0.340 ms  0.430 ms  0.511 ms
	 3  10.0.10.15 (10.0.10.15)  0.899 ms  0.888 ms  0.884 ms
	 4  * * *
	 5  10.163.4.53 (10.163.4.53)  1.629 ms 10.163.4.57 (10.163.4.57)  1.431 ms 10.163.4.53 (10.163.4.53)  1.434 ms
	 6  115.238.118.189 (115.238.118.189)  1.604 ms  0.988 ms 115.238.118.181 (115.238.118.181)  1.166 ms
	 7  124.160.191.101 (124.160.191.101)  6.100 ms 124.160.191.113 (124.160.191.113)  29.627 ms  29.747 ms
	 8  * 124.160.83.97 (124.160.83.97)  4.565 ms *
	 9  * * 219.158.21.17 (219.158.21.17)  27.960 ms
	10  221.4.0.114 (221.4.0.114)  37.392 ms  37.567 ms 221.4.0.90 (221.4.0.90)  32.138 ms
	11  * * *
	12  * * *
	13  * * *
	14  * * *
	15  * * *
	16  * * *
	17  * * *
	18  182.254.34.74 (182.254.34.74)  31.083 ms  33.926 ms *

我们将抓到如下的网络数据包：
![](https://cdn.kelu.org/blog/2018/02/1315506-2bb60646b32e08aa.jpg)

首先是一堆的 TCP [SYN] 包，然后是中间网关返回的 ICMP TTL 超时。最后收到目标主机发回的 TCP [SYN ACK] 结束整个探测过程：
![](https://cdn.kelu.org/blog/2018/02/1315506-35e347c0cc87d71e.jpg)

如图中的第 82 和 第 84 号 TCP [SYN ACK] 包。从第 71 号包，可以看到，数据包都被发向了目标主机的 80 端口。

如果我们以 `-I` 参数启动 `traceroute`，用 ICMP 来探测网络路径的话，抓到的包将如下面这样：
![](https://cdn.kelu.org/blog/2018/02/1315506-ab800063ade5ae0e.jpg)

这个过程将不断发送 TTL 递增的 ICMP ECHO Request (Ping) 的包，中间网关在发现数据包的 TTL 减到 0 时，向源主机发回 ICMP TTL 超时。

整个过程以收到 ICMP Echo reply结束：
![](https://cdn.kelu.org/blog/2018/02/1315506-276c7b5838866e8b.jpg)

如图中的第 87 ～ 93 号包。

总结一下，traceroute 主要利用 IP 数据包的 TTL 字段值 + ICMP 来实现，它发送的用于探测网络路径的数据包的 IP 之上的协议可以是 UDP、TCP或ICMP。不同模式下，探测过程中设计的数据包如下：

UDP 模式
UDP 探测数据包（目标端口大于 30000） + 中间网关发回 ICMP TTL 超时数据包 + 目标主机发回 ICMP Destination Unreachable 数据包

TCP 模式
TCP [SYN] 探测数据包（目标端口为 Web 服务的 80） + 中间网关发回 ICMP TTL 超时数据包 + 目标主机发回 TCP [SYN ACK] 数据包

ICMP 模式
ICMP Echo (ping) Request 探测数据包 + 中间网关发回 ICMP TTL 超时数据包 + 目标主机发回 ICMP Echo (ping) reply 数据包

# 参考文档
* [理解 TCP 和 UDP](https://www.gitbook.com/book/jerryc8080/understand-tcp-and-udp)
* [使用tracert命令时，在一个节点后所有的节点都没有数据，这是为什么？](https://www.zhihu.com/question/50220087)
* [联通的网络， traceroute 显示全是星号， tracert 什么都不显示，怎样才能跟踪路由？](https://www.v2ex.com/t/327276)
* [traceroute显示星号，但是wireshark抓包显示返回了icmp type 11](https://segmentfault.com/q/1010000002548654)
* [traceroute 全返回_*_，我的网络是怎么了？](https://www.v2ex.com/t/338930)
* [USG6680 V5R1C00 tracert 显示星号解决方法](http://support.huawei.com/enterprise/KnowledgebaseReadAction.action?contentId=KB1000086930&idAbsPath=7919710)
* [traceroute 命令](https://www.ibm.com/support/knowledgecenter/zh/ssw_aix_61/com.ibm.aix.performance/traceroute.htm)
