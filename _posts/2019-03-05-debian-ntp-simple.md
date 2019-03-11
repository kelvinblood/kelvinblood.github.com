---
layout: post
title: debian 下简单的时间同步
category: tech
tags: linux ntp
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

以前写过一个 CentOS 下的 ntp 时间同步，centos 一般公司的服务器会使用。就我个人还是比较习惯 Debian 系的，所以我Debian 系的一些文章都是相对简易的，主要目标就是 It Just Work 即可。

说一下写这篇的背景，我给自己服务器中安装了 Etcd 集群，使用集群的时候就有一个重要的前提——时钟一致。一般的做法是在集群中指定一台机器作为ntp服务器，由这台向远端同步，其它机器同步这台。

个人服务要求不高的话，可以在所有机器中按照如下方式实现:

1. 安装
    ```bash
    $ sudo apt-get update
    $ sudo apt-get install ntpdate -y
    ```
2. 同步

    ```bash
    ntpdate time.windows.com
    ```
    
    当然也可以用阿里的服务器 `ntp.aliyun.com`
    
3. 定时同步
    每小时同步一次

    ```bash
    $ sudo crontab -e

    在最后一行添加
    5 * * * * ntpdate time.windows.com > /dev/null 2>&1
    ```    