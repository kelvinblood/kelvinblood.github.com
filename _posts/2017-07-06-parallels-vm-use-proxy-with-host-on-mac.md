---
layout: post
title: Mac 下 Parallels 虚拟机使用宿主机的 Shadowsocks 代理
category: tech
tags: mac shadowsocks proxy vm
---
![](https://cdn.kelu.org/blog/tags/proxy.jpg)

环境:

    宿主：Mac
    VM: Debian (linux系统都可以吧

步骤

* 在宿主机的 shadowsocks 设置监听地址为 0.0.0.0 (默认是127.0.0.1)

![](https://cdn.kelu.org/blog/2017/07/2017-07-07-12.29.23.jpg)

![](https://cdn.kelu.org/blog/2017/07/2017-07-07-12.29.38.jpg)


* 使用桥接方式运行虚拟机（使得虚拟机与宿主处于同一个局域网）

* 进入linux系统，在 `~/.bashrc` 或者 `~/.zshrc` 设置代理：

        export ALL_PROXY=socks5://172.20.10.5:1086  # IP设置是你 Mac 的内网 IP 地址
        
        alias checkip="curl -i http://ip.cn"        # 查看本机外网 IP 归属地。
    
* 测试是否成功。在命令行里运行下面的命令查看是否设置成功。

        checkip
    
