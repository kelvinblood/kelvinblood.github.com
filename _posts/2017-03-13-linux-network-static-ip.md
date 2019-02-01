---
layout: post
title: Linux 设定静态IP地址
category: tech
tags: linux
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

# 临时修改

    ifconfig eth0 10.192.147.241 netmask 255.255.255.0
    route add default gw 10.192.147.245

vi /etc/resolv.conf

    nameserver 192.168.0.1

# 永久修改

vi /etc/network/interfaces

    auto lo
    iface lo inet loopback
    auto eth0               # auto 开机自动连接网络 allow-hotplug 
    # iface eth0 inet dhcp # 设置成DHCP,动态ip
    iface eth0 inet static # static表示使用固定ip
    address 192.168.038
    netmask 255.255.255.0 # 子网掩码
    gateway 192.168.0.1

vi /etc/resolvconf/resolv.conf.d/base
    
    nameserver 8.8.8.8
    nameserver 8.8.4.4

# 常见问题

* stop: Job failed while stopping

    我使用 Ubuntu 14.4 版本时使用重启网络命名 `service networking restart`，显示这个错误。
    解决的办法是
        
        ifdown --exclude=lo -a && ifup --exclude=lo -a
        
* 在配置网络时auto与allow-hotplug的区别

    auto

        语法：
        auto <interface_name>
        含义：
        在系统启动的时候启动网络接口,无论网络接口有无连接(插入网线),如果该接口配置了DHCP,则无论有无网线,系统都会去执行DHCP,如果没有插入网线,则等该接口超时后才会继续。

    allow-hotplug

        语法:
        allow-hotplug <interface_name>

        含义：
        只有当内核从该接口检测到热插拔事件后才启动该接口。如果系统开机时该接口没有插入网线,则系统不会启动该接口,系统启动后,如果插入网线,系统会自动启动该接口。也就是将网络接口设置为热插拔模式。
    
# 参考资料

* [auto与allow-hotplug的区别](http://openwares.net/linux/interfaces_auto_allow-hotplug.html)
