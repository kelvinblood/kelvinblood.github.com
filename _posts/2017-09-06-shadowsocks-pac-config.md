---
layout: post
title: Shadowsocks 代理修改 PAC 与 user-rule 文件
category: tech
tags: shadowsocks proxy
---
![](https://cdn.kelu.org/blog/tags/proxy.jpg)

# 什么是PAC

代理自动配置（英语：Proxy auto-config，简称PAC）是一种网页浏览器技术，用于定义浏览器该如何自动选择适当的代理服务器来访问一个网址。

# PAC的好处

PAC自动代理属于智能判断模式，它的优点有：

1.  不影响国内网站的访问速度
2.  节省Shadowsocks服务的流量，节省服务器资源

这里不讲太深入的，直接讲如何配置。

# windows

软件所在的同级目录下有 pac.txt 和 user-rule.txt 的文件。

![](https://cdn.kelu.org/blog/2017/09/proxy1.jpg)


![](https://cdn.kelu.org/blog/2017/09/proxy2.jpg)

依葫芦画瓢，把你想要自定义的网址填进去，可以在 pac.txt 上改，也可以在 user-rule.txt上改：

![](https://cdn.kelu.org/blog/2017/09/proxy3.jpg)

![](https://cdn.kelu.org/blog/2017/09/proxy4.jpg)

# Mac

Mac 下直接如下图在『编辑用户自定义规则』里进行修改，

![](https://cdn.kelu.org/blog/2017/09/proxy5.jpg)

![](https://cdn.kelu.org/blog/2017/09/proxy6.jpg)

比如我想把 bt.byr.cn python.org 这两个网站收录进自定义规则里，那么我应该填入

	||bt.bty.cn^
	||python.org^

注意末尾不要忘记 `^` 符号

# 参考资料

* [浅析PAC，教你动手修改你的PAC文件及user-rule文件实现自动代理](http://www.cnblogs.com/edward2013/p/5560836.html)
