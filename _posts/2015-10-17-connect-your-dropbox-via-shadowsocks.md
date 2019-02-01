---
layout: post
title: ShadowSocks下Dropbox的同步问题
category: tech
tags: linux shadowsocks dropbox
---

虽然装了ShadowSocks，原理还是不太明白。Dropbox也没法同步。原本是要查如何在服务器上开socks同步的，发现不用了😄。直接在Dropbox的网络设置里设置代理服务器。代理首选项中选择 SOCKS5，服务器填 127.0.0.1:1080 即可，如下：

![image](https://cdn.kelu.org/blog/2015/10/blog_2015-10-17-1.43.30.jpg)