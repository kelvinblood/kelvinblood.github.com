---
layout: post
title: 记录使用Docker时的一些问题
category: tech
tags: docker
---

![](https://cdn.kelu.org/blog/tags/docker.jpg)

# 无法启动Docker服务

运行 `service docker start` 时报错

    Redirecting to /bin/systemctl start docker.service Job for docker.service failed because the control process exited with error code. See "systemctl status docker.service" and "journalctl -xe" for details.
    
解决问题的办法就是清空 `/var/lib/docker` 下的所有文件。要注意这样会导致你所有的Docker数据都会丢失。   

来自 [docker service failed to start #25913 | github issues](https://github.com/docker/docker/issues/25913)

# docker 主机的 iptables 设置

* iptables failed - No chain/target/match by that name

    一个bug，重启dockers服务就好了。

        mv /var/lib/docker/network/files /tmp/docker-iptables-err
        systemctl restart docker
    
    * [docker issues - github](https://github.com/docker/docker/issues/16816)
    * [docker run実行時のiptablesエラー](http://qiita.com/miwato/items/9770a2a757d3f5e369a4)
    
* iptable filter

    使用 Docker PPTP 的 iptable 例子

        *nat 
        -A POSTROUTING -s 10.99.99.0/24 -o eth0 -j MASQUERADE

        * filter
        -A FORWARD -d 10.99.99.0/24 -j ACCEPT
        -A FORWARD -s 10.99.99.0/24 -j ACCEPT

    这个 issue 是我提的。提完之后自己就找到答案了。
    
来自[iptable filter - github](https://github.com/mobtitude/docker-vpn-pptp/issues/12)

# can't modprobe af_key in debian8
    
这个与主机提供商有关了。主机在使用 docker 时某些项目需要使用 IPsec NETKEY 内核模块，其它主机不了解，linode的默认内核是修改过的，所以没有这个内核模块。如果想启用的话需要在后台配置里将默认启动内核改为 GRUB 2 模式。

来自[docker issue - github](https://github.com/hwdsl2/docker-ipsec-vpn-server/issues/2)



