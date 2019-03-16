---
layout: post
title: linux 命令 ip
category: tech
tags: linux command
typora-copy-images-to: 22
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

`ip` 命令跟 `ifconfig` 命令有些类似，但要强力的多，它有许多新功能。

ifconfig 是 net-tools 中已被废弃使用的一个命令，许多年前就已经没有维护了。iproute2 套件里提供了许多增强功能的命令，ip 命令是其中之一。

![Net tools vs Iproute2](D:\GitHub\kelvinblood.github.com\_posts\22\003404uy9l1t5zayzllylm.png)

假设我们服务器的网卡名为 enp0s3。

# 网卡 ip link

检查网卡的诸如 IP 地址，子网等网络信息，使用 `ip addr show` 命令：

```bash
$ ip a
```

这会显示系统中所有可用网卡的相关网络信息，不过如果你想查看某块网卡的信息，则命令为：

```
$ ip addr show eth0
```

这里 `eth0` 是网卡的名字。

启用/禁用网卡：

使用 `ip` 命令来启用一个被禁用的网卡：

```
$ ip link set enp0s3 up
```

而要禁用网卡则使用 `down` 触发器：

```
$ ip link set enp0s3 down
```

# IP ip addr

要为网卡分配 IP 地址，我们使用下面命令：

```
$ ip addr add 192.168.0.50/255.255.255.0 dev eth0
$ ip addr add 192.168.0.193/24 dev eth0
```

也可以使用 `ip` 命令来设置广播地址。默认是没有设置广播地址的，设置广播地址的命令为：

```
$ ip addr add broadcast 192.168.0.255 dev enp0s3
```

我们也可以使用下面命令来根据 IP 地址设置标准的广播地址， `brd` 代替 `broadcast` 来设置广播地址：

```
$ ip addr add 192.168.0.10/24 brd + dev enp0s3
```

若想从网卡中删掉某个 IP，使用如下 `ip` 命令：

```
$ ip addr del 192.168.0.10/24 dev enp0s3
```

添加别名，即为网卡添加不止一个 IP，执行下面命令：

```
$ ip addr add 192.168.0.20/24 dev enp0s3 label enp0s3:1
```

ipv6

```
$ ip -6 addr show [dev <接口名>]
```

# 路由表 ip route

查看路由信息会给我们显示数据包到达目的地的路由路径。要查看网络路由信息，执行下面命令：

```
$ ip route show
```

在上面输出结果中，我们能够看到所有网卡上数据包的路由信息。我们也可以获取特定 IP 的路由信息，方法是：

```
$ ip route get 192.168.0.1
```

我们也可以使用 IP 来修改数据包的默认路由。方法是使用 `ip route` 命令：

```
$ ip route add default via 192.168.0.150/24
```

这样所有的网络数据包通过 `192.168.0.150` 来转发，而不是以前的默认路由了。若要修改某个网卡的默认路由，执行：

```
$ ip route add 172.16.32.32 via 192.168.0.150/24 dev enp0s3
```

要删除之前设置的默认路由，打开终端然后运行：

```
$ ip route del 192.168.0.150/24
```

**注意：** 用上面方法修改的默认路由只是临时有效的，在系统重启后所有的改动都会丢失。要永久修改路由，需要修改或创建 `route-enp0s3` 文件。将下面这行加入其中：

```
$ vi /etc/sysconfig/network-scripts/route-enp0s3172.16.32.32 via 192.168.0.150/24 dev enp0s3
```

保存并退出该文件。

若你使用的是基于 Ubuntu 或 debian 的操作系统，则该要修改的文件为 `/etc/network/interfaces`，然后添加 `ip route add 172.16.32.32 via 192.168.0.150/24 dev enp0s3` 这行到文件末尾。

# ARP ip neigh 

ARP，是地址解析协议Address Resolution Protocol的缩写，用于将 IP 地址转换为物理地址（也就是 MAC 地址）。所有的 IP 和其对应的 MAC 明细都存储在一张表中，这张表叫做 ARP 缓存。

要查看 ARP 缓存中的记录，即连接到局域网中设备的 MAC 地址，则使用如下 ip 命令：

```
$ ip neigh
```

删除 ARP 记录的命令为：

```
$ ip neigh del 192.168.0.106 dev enp0s3
```

若想往 ARP 缓存中添加新记录，则命令为：

```
$ ip neigh add 192.168.0.150 lladdr 33:1g:75:37:r3:84 dev enp0s3 nud perm
```

这里 `nud` 的意思是 “neghbour state”（网络邻居状态），它的值可以是：

- `perm` - 永久有效并且只能被管理员删除
- `noarp` - 记录有效，但在生命周期过期后就允许被删除了
- `stale` - 记录有效，但可能已经过期
- `reachable` - 记录有效，但超时后就失效了

清空ARP表(不影响永久条目)

```
ip neigh flush all
```

# 查看网络信息

通过 `ip` 命令还能查看网络的统计信息，比如所有网卡上传输的字节数和报文数，错误或丢弃的报文数等。使用 `ip -s link` 命令来查看：

```
$ ip -s link
```

# 监控netlink消息

也可以使用ip命令查看netlink消息。monitor选项允许你查看网络设备的状态。比如，所在局域网的一台电脑根据它的状态可以被分类成REACHABLE或者STALE。使用下面的命令：

```
$ ip monitor all
```



# 参考资料

* [试试Linux下的ip命令，ifconfig已经过时了](https://linux.cn/article-3144-1.html)
* [12 个 ip 命令范例](https://linux.cn/article-9230-1.html)
* [ip命令用法归纳](https://zhuanlan.zhihu.com/p/28155886)