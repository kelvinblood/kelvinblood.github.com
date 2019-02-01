---
layout: post
title: 使用 snmp 协议监控服务器
category: tech
tags: devops
---

![](https://cdn.kelu.org/blog/tags/snmp.jpg)

简单网络管理协议（SNMP）。该协议能够支持网络管理系统，用以监测连接到网络上的设备是否有任何引起管理上关注的情况。本文介绍 SNMP 代理程序 Net-SNMP 的安装过程。

# 编译安装

编译安装前先安装 perl 包(如果系统没有安装的话)

    apt-get install libperl-dev
    
下载源码：<https://jaist.dl.sourceforge.net/project/net-snmp/>

当前最新版是5.7.3 <https://jaist.dl.sourceforge.net/project/net-snmp/net-snmp/5.7.3/net-snmp-5.7.3.tar.gz>

    wget https://jaist.dl.sourceforge.net/project/net-snmp/net-snmp/5.7.3/net-snmp-5.7.3.tar.gz
    tar -xzvf net-snmp-5.7.3.tar.gz
    cd net-snmp-5.7.3 
    ./configure --prefix=/usr/local/snmp --with-mib-modules=ucd-snmp/diskio

接下来填写相关信息

* 安装版本
* 域名信息
* 服务器地址
* 日志文件地址
* 配置文件位置

接下来

    make 
    make install

# 设置验证

为了防止其它主机访问你的SNMP代理程序，我们需要在SNMP代理程序上加入身份验证机制。

SNMP支持不同的验证机制，这取决于不同的SNMP协议版本

* v2c版本的验证机制比较简单，它基于明文密码和授权IP来进行身份验证
* v3版本则通过用户名和密码的加密传输来实现身份验证

注意一点，SNMP协议版本和SNMP代理程序版本是两回事，v2c和v3是指SNMP协议的版本，Net-SNMP是用来实现SNMP协议的程序，目前它的最新版本是5.7.3。

打开配置文件：

    vi /usr/local/snmp/share/snmp/snmpd.conf

然后添加一个只读帐号（确保 SNMP 不运行):
    
    rouser kelu auth

>
“rouser”用于表示只读帐号类型，随后的“kelu”是指定的用户名，后边的“auth”指明需要验证。

添加创建用户的指令

    vi /var/net-snmp/snmpd.conf
    createUser kelu MD5 mypassword

>
创建一个名为“kelu”的用户，密码为“mypassword”，并且用MD5进行加密传输。

>
密码至少要有8个字节

>
一旦snmpd启动后，出于安全考虑，以上这行配置会被snmpd自动删除

# 启动SNMP代理程序

启动snmpd：

    /usr/local/snmp/sbin/snmpd
    
关闭：

    killall -9 snmpd

# iptable

如果有做防火墙设置的话，添加这两个配置：

    iptables -A INPUT -i eth0 -p udp -s xx.xx.xx.xx --dport 161 -j ACCEPT
    iptables -A INPUT -i eth0 -p udp -s xx.xx.xx.xx --dport 161 -j ACCEPT

# 测试是否启动成功

访问监控宝进行测试 [SNMP远程测试](http://www.jiankongbao.com/labs/snmp)


# 参考资料

* [net-snmp package Ubuntu| bugs 1322431](https://bugs.launchpad.net/ubuntu/+source/net-snmp/+bug/1322431)
* [监控宝文档](http://wiki.jiankongbao.com/doku.php/文档:安全指引#linux_snmp)
* [usr/bin/ld: cannot find -lxxx问题总结](http://eminzhang.blog.51cto.com/5292425/1285705)

