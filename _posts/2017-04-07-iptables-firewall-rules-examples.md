---
layout: post
title: 转载 | Linux管理员应该了解的20条IPTables防火墙规则用法
category: tech
tags: linux
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

iptable是所有网站运维管理员都需要了解的一门技术。这一篇文章写得具体又简约，转载过来。

转载自[sysgeek.cn](https://www.sysgeek.cn/iptables-firewall-rules-examples/)

>
原文

管理网络流量是系统管理员必需处理的最棘手工作之一，我们必需规定连接系统的用户满足防火墙的传入和传出要求，以最大限度保证系统免受攻击。

很多用户把 Linux 中的 IPTables 当成一个防火墙，从严格意见上来说 IPTables 只是能够帮助管理员定义各种规则并与 Linux Kernel 进行沟通的一个命令行工具。它只是帮助管理员配置网络流量的传入、传出规则列表，具体的实现其实是在 Linux 内核当中。

IPTables 包括一组内置和由用户定义规则的「链」，管理员可以在「链」上附加各种数据包处理规则。

FILTER 默认过滤表，内建的链有：

* INPUT：处理流入本地的数据包
* FORWARD：处理通过系统路由的数据包
* OUTPUT：处理本地流出的数据包

NAT 实现网络地址转换的表，内建的链有：

* PREROUTING：处理即将接收的数据包
* OUTPUT：处理本地产生的数据包
* POSTROUTING：处理即将传出的数据包

MANGLE 此表用于改变数据包，共 5 条链：

* PREROUTING：处理传入连接
* OUTPUT：处理本地生成的数据包
* INPUT：处理报文
* POSTROUTING：处理即将传出数据包
* FORWARD：处理通过本机转发的数据包

接下来我们将由简入难介绍 25 条 Linux 管理员最常会用到的 IPTables 规则。

# 1、启动、停止和重启IPTables

虽然 IPTables 并不是一项服务，但在 Linux 中还是可以像服务一样对其状态进行管理。

基于SystemD的系统

    systemctl start iptables
    systemctl stop iptables
    systemctl restart iptables
    
基于SysVinit的系统

    /etc/init.d/iptables start
    /etc/init.d/iptables stop
    /etc/init.d/iptables restart
    
# 2、查看IPtables防火墙策略

你可以使用如下命令来查看 IPtables 防火墙策略：

    iptables -L -n -v
以上命令应该返回数据下图的输出：

    IPtables

以上命令是查看默认的 FILTER 表，如果你只希望查看特定的表，可以在 -t 参数后跟上要单独查看的表名。例如只查看 NAT 表中的规则，可以使用如下命令：

    iptables -t nat -L -v –n
    
    
# 3、屏蔽某个IP地址

如果你发布有某个 IP 向服务器导入攻击或非正常流量，可以使用如下规则屏蔽其 IP 地址：

    iptables -A INPUT -s xxx.xxx.xxx.xxx -j DROP
注意需要将上述的 XXX 改成要屏蔽的实际 IP 地址，其中的 -A 参数表示在 INPUT 链的最后追加本条规则。（IPTables 中的规则是从上到下匹配的，一旦匹配成功就不再继续往下匹配）

如果你只想屏蔽 TCP 流量，可以使用 -p 参数的指定协议，例如：

    iptables -A INPUT -p tcp -s xxx.xxx.xxx.xxx -j DROP
    
# 4、解封某个IP地址

要解封对 IP 地址的屏蔽，可以使用如下命令进行删除：

    iptables -D INPUT -s xxx.xxx.xxx.xxx -j DROP
其中 -D 参数表示从链中删除一条或多条规则。

# 5、使用IPtables关闭特定端口

很多时候，我们需要阻止某个特定端口的网络连接，可以使用 IPtables 关闭特定端口。

阻止特定的传出连接：

    iptables -A OUTPUT -p tcp --dport xxx -j DROP
阻止特定的传入连接：

    iptables -A INPUT -p tcp --dport xxx -j ACCEPT
    
# 6、使用Multiport控制多端口

使用 multiport 我们可以一次性在单条规则中写入多个端口，例如：

    iptables -A INPUT  -p tcp -m multiport --dports 22,80,443 -j ACCEPT
    iptables -A OUTPUT -p tcp -m multiport --sports 22,80,443 -j ACCEPT
    
# 7、在规则中使用 IP 地址范围

在 IPtables 中 IP 地址范围是可以直接使用 CIDR 进行表示的，例如：

    iptables -A OUTPUT -p tcp -d 192.168.100.0/24 --dport 22 -j ACCEPT
    
# 8、配置端口转发

有时我们需要将 Linux 服务器的某个服务流量转发到另一端口，此时可以使用如下命令：

    iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 25 -j REDIRECT --to-port 2525
    
上述命令会将所有到达 eth0 网卡 25 端口的流量重定向转发到 2525 端口。

# 9、屏蔽HTTP服务Flood攻击

有时会有用户在某个服务，例如 HTTP 80 上发起大量连接请求，此时我们可以启用如下规则：

    iptables -A INPUT -p tcp --dport 80 -m limit --limit 100/minute --limit-burst 200 -j ACCEPT
    
上述命令会将连接限制到每分钟 100 个，上限设定为 200。

# 10、禁止PING

对 Linux 禁 PING 可以使用如下规则屏蔽 ICMP 传入连接：

    iptables -A INPUT -p icmp -i eth0 -j DROP

# 11、允许访问回环网卡

环回访问（127.0.0.1）是比较重要的，建议大家都开放：

    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT
    
# 12、屏蔽指定MAC地址

使用如下规则可以屏蔽指定的 MAC 地址：

    iptables -A INPUT -m mac --mac-source 00:00:00:00:00:00 -j DROP
    
# 13、限制并发连接数

如果你不希望来自特定端口的过多并发连接，可以使用如下规则：

    iptables -A INPUT -p tcp --syn --dport 22 -m connlimit --connlimit-above 3 -j REJECT
以上规则限制每客户端不超过 3 个连接。

# 14、清空IPtables规则

要清空 IPtables 链可以使用如下命令：

    iptables -F
要清空特定的表可以使用 -t 参数进行指定，例如：

    iptables -t nat –F
    
# 15、保存IPtables规则

默认情况下，管理员对 IPtables 规则的操作会立即生效。但由于规则都是保存在内存当中的，所以重启系统会造成配置丢失，要永久保存 IPtables 规则可以使用 iptables-save 命令：

    iptables-save > ~/iptables.rules
保存的名称大家可以自己改。

# 16、还原IPtables规则

有保存自然就对应有还原，大家可以使用 iptables-restore 命令还原已保存的规则：

    iptables-restore < ~/iptables.rules
    
# 17、允许建立相关连接

随着网络流量的进出分离，要允许建立传入相关连接，可以使用如下规则：

    iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
允许建立传出相关连接的规则：

    iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT

# 18、丢弃无效数据包

很多网络攻击都会尝试用黑客自定义的非法数据包进行尝试，我们可以使用如下命令来丢弃无效数据包：

    iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

# 19、IPtables屏蔽邮件发送规则

如果你的系统不会用于邮件发送，我们可以在规则中屏蔽 SMTP 传出端口：

    iptables -A OUTPUT -p tcp --dports 25,465,587 -j REJECT

# 20、阻止连接到某块网卡

如果你的系统有多块网卡，我们可以限制 IP 范围访问某块网卡：

    iptables -A INPUT -i eth0 -s xxx.xxx.xxx.xxx -j DROP
    
源地址可以是 IP 或 CIDR。
