---
layout: post
title:  Fiddler 让 Win10 自带日历客户端连接谷歌账户
category: tech
tags: google windows
---
![](https://cdn.kelu.org/blog/tags/google.jpg)

作为软件开发者，连接google几乎是我们的必备生存技能。然而在使用win10自带的日历，由于Metro Apps是运行在被隔离的App Containers环境中，该环境阻止了网络流量发送到本机，所以即使有Shadowsock也是连不上的233333(使用vpn则是没有问题的，然而vpn比ss速度毕竟慢一个等级，而且也不能使用pac)。

所以目标是在ss下让Metro Apps连上互联网。虽然没有除了vpn外的直接的办法，可以使用 Fiddler 进行迂回战术达到我们的效果。

* 下载安装Fiddler —— ​<http://www.fiddler2.com/fiddler2>
* 打开Tools —— Win8 Lookback Exemptions
* 可以Exemption All —— Save Changes

![](https://cdn.kelu.org/blog/2017/03/fiddler.jpg)

# 参考资料

* [Windows 10 自带邮件和日历客户端连接谷歌账户](http://blog.sina.com.cn/s/blog_67de9c540102wfxt.html)
* [Revisiting Fiddler and Win8+ Immersive applications](https://blogs.msdn.microsoft.com/fiddler/2011/12/10/revisiting-fiddler-and-win8-immersive-applications)
* [关于 Fiddler](http://www.jianshu.com/p/99b6b4cd273c)
