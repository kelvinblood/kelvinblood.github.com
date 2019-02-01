---
layout: post
title: 安装 mkfs.ntfs 安装包
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

有的 Linux 机器没有安装 ntfs 安装包，就无法挂载 NTFS 格式的硬盘。连格式化该硬盘都无法做到。 然而 ntfs 的安装包不叫 ntfs，很有趣吧666666 我第一次尝试安装 `apt-get install ntfs` 就显示没有这个包Orz

![](https://cdn.kelu.org/blog/2017/10/ntfs1.jpg)

遇到这种情况有两种办法。

1. `apt-cache search ntfs`

	好吧，我的第一反应打了 `apt-get search`，没想到也是不对的。

	![](https://cdn.kelu.org/blog/2017/10/ntfs3.jpg)

	看介绍也可以找到 `ntfs-3g`，应该就是这个了。

1. 谷歌

	![](https://cdn.kelu.org/blog/2017/10/ntfs2.jpg)
	
	于是找到了这个包的名字叫`ntfs-3g`

