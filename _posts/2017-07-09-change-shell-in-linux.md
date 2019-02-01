---
layout: post
title:  Linux 下 PAM authentication failed 问题
category: tech
tags:  linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

出现这个问题时，基本上所有敏感操作都会请求输入密码，而且密码都是不对的。

很有可能是  Shell 的设置有问题。打开文件`/etc/passwd`查看 root 用户的 Shell 是不是正确的：

	root:x:0:0:root:/root:/bin/bash
	daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
	bin:x:2:2:bin:/bin:/usr/sbin/nologin
	sys:x:3:3:sys:/dev:/usr/sbin/nologin
	sync:x:4:65534:sync:/bin:/bin/sync
	...

注意 root 的 Shell 一定是`/bin/bash`。多半可能是中途某个地方将它改错了，改回来就好了。

改错的情况下还会出现很头疼的问题——无法登录。

附修改默认 Shell 命令

	chsh -s /bin/zsh

