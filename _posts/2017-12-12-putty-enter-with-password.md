---
layout: post
title: PuTTY登录时自动输入密码
category: tech
tags: windows
---
![](https://cdn.kelu.org/blog/tags/windows.jpg)

	putty.exe 用户名@服务器地址 -pw 密码
	putty.exe 服务器地址 -l 用户名-pw 密码

使用 ssh，加上`-ssh`参数。指定一个端口，加上`-P 端口号码` 参数。

其他一些用得着的参数在[这个链接](https://link.jianshu.com/?t=https://the.earth.li/~sgtatham/putty/0.67/htmldoc/Chapter3.html#using-general-opts)。

使用方法示例：

![](https://cdn.kelu.org/blog/2017/12/putty.jpg)

# 参考资料

* [让PuTTY登录时自动输入密码 - 简书](https://www.jianshu.com/p/bd61e8b7118b)