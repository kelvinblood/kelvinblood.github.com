---
layout: post
title: Linux 更改主机名
category: tech
tags: linux
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

更改主机名一般我们都使用 `hostname xxx`, 这样做是没问题，不过需要重启服务器才能生效。

在ubuntu官网论坛上看到有这个快速的办法，用户重新登录即可，不需要重启服务器。同时适合debian系和centos系

    hostnamectl set-hostname xxx
    
# 参考资料

* [How do I change the hostname without a restart?](http://askubuntu.com/questions/87665/how-do-i-change-the-hostname-without-a-restart)
