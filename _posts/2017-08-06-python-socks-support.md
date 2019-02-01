---
layout: post
title: python "Missing dependencies for SOCKS support” 
category: tech
tags:  python
---
![](https://cdn.kelu.org/blog/tags/python.jpg)

目前来说，我的解决办法很简单就是 ，不用 socks 代理 2333333333

因为需要 自动化下载一些国外资料，所以本地用了 shadowsocks 来代理终端的连接：

	export ALL_PROXY=socks5://127.0.0.1:1086

然而 Python 当前的包没有支持 socks 代理的。于是我选择了最简单的办法，用 http 代理，而不是 socks 代理：

	export ALL_PROXY=https://127.0.0.1:1087

# 参考资料

* [Python's requests “Missing dependencies for SOCKS support” when using SOCKS5 from Terminal](https://stackoverflow.com/questions/38794015/pythons-requests-missing-dependencies-for-socks-support-when-using-socks5-fro)
