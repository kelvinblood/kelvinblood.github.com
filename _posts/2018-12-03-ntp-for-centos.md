---
layout: post
title: centos 7 使用阿里云 ntp 服务器
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

# 背景

最近开了几台机器做集群玩，在运行etcd的时候发现两台时间相差超过1分钟！系统日志中一直出现错误告警。遂安装了 NTP 服务器将机器时间同步。

本文部分参考了这篇文章——[《如何在 CentOS 中设置 NTP 服务器 - linux.cn》](https://linux.cn/article-5581-1.html)

# NTP是什么

网络时间协议(NTP)用来同步网络上不同主机的系统时间。你管理的所有主机都可以和一个指定的被称为 NTP 服务器的时间服务器同步它们的时间。而另一方面，一个 NTP 服务器会将它的时间和任意公共 NTP 服务器，或者你选定的服务器同步。由 NTP 管理的所有系统时钟都会同步精确到毫秒级。

由于制造工艺多种多样，所有的(非原子)时钟并不按照完全一致的速度行走。有一些时钟走的比较快而有一些走的比较慢。因此经过很长一段时间以后，一个时钟的时间慢慢的和其它的发生偏移，这就是常说的 “时钟漂移” 或 “时间漂移”。为了将时钟漂移的影响最小化，使用 NTP 的主机应该周期性地和指定的 NTP 服务器交互以保持它们的时钟同步。

在不同的主机之间进行时间同步对于计划备份、[入侵检测](http://xmodulo.com/how-to-compile-and-install-snort-from-source-code-on-ubuntu.html)记录、[分布式任务调度](http://xmodulo.com/how-to-install-hdfs-and-hadoop-using.html)或者事务订单管理来说是很重要的事情。它甚至应该作为日常任务的一部分。

# NTP 的层次结构

NTP 时钟以层次模型组织。层级中的每层被称为一个 *stratum（阶层）*。stratum 的概念说明了一台机器到授权的时间源有多少 NTP 跳。

![img](https://dn-linuxcn.qbox.me/data/attachment/album/201506/06/214034n7w7j89jy87hiz9j.jpg)

Stratum 0 由没有时间漂移的时钟组成，例如原子时钟。这种时钟不能在网络上直接使用。Stratum N (N > 1) 层服务器从 Stratum N-1 层服务器同步时间。Stratum N 时钟能通过网络和彼此互联。

NTP 支持多达 15 个 stratum 的层级。Stratum 16 被认为是未同步的，不能使用的。

# 步骤

1. 安装

   ```
   yum install ntp
   systemctl start ntpd.service
   systemctl enable ntpd.service
   ```

2. 修改配置

   修改为阿里云ntp服务器

   ```
   vim /etc/ntp.conf

   # Use public servers from the pool.ntp.org project.
   # Please consider joining the pool (http://www.pool.ntp.org/join.html).
   #server 0.centos.pool.ntp.org iburst
   #server 1.centos.pool.ntp.org iburst
   #server 2.centos.pool.ntp.org iburst
   #server 3.centos.pool.ntp.org iburst
   server ntp.aliyun.com iburst
   server ntp1.aliyun.com iburst
   server ntp2.aliyun.com iburst
   server ntp3.aliyun.com iburst
   server ntp4.aliyun.com iburst
   server ntp5.aliyun.com iburst
   ```

   ​

3. 验证服务

   ```
   # 以下是示例
   # ntpq -p

       remote           refid      st t when poll reach   delay   offset  jitter
   ============================================================

   +news.neu.edu.cn 202.118.1.46     2 u   14  128  377   44.480    2.868  31.310
   *202.118.1.130   202.118.1.46     2 u   63  128  377   41.726    1.631  21.462
    LOCAL(0)        .LOCL.          10 l    9   64  377    0.000    0.000   0.001
   ```

   说明：*表示目前正在使用的上层NTP，+表示已连线,可提供时间更新的候补服务器

4. 确认已进行同步

   ```
   ntpstat

   synchronised to NTP server (202.118.1.130) at stratum 3
      time correct to within 60 ms
      polling server every 128 s
   ```

   ​

# 参考资料

* [CentOS搭建NTP服务器 - 51CTO](http://blog.51cto.com/msiyuetian/1712561)

