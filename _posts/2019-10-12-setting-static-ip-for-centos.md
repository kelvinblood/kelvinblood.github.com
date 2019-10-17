---
layout: post
title: 为 Centos 7 设置静态IP
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/centos.jpg)

1. 编辑 ifcfg-eth0 

   ```
   vi /etc/sysconfig/network-scripts/ifcfg-eth0
   ```

2. 增加/修改设置

   ```
   BOOTPROTO="static" # dhcp改为static 
   ONBOOT="yes" # 开机启用本配置
   IPADDR=192.168.7.106 # 静态IP
   GATEWAY=192.168.7.1 # 默认网关
   NETMASK=255.255.255.0 # 子网掩码
   DNS1=192.168.7.1 # DNS 配置
   ```

3. 重启网络

   ```
   service network restart
   ```
