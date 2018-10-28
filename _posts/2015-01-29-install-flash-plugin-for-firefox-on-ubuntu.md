---
layout: post
title: Linux下手动安装Flash插件
category: software
tags: linux flash
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

Debian桌面需要安装Flash插件才能看视频，安装方法很简单。打开视频页面时会跳出安装请求，点击下载tar.gz包解压。解压之后会在当前目录得到`libflashplayer.so`、`readme.txt`文件和`usr`文件夹。

	cp libflashplayer.so /usr/lib/mozilla/plugins/
	# 如果是chrome则对应chrome的插件文件。
	
	cp -r usr/* /usr
	# 把usr放在用户目录下也ok