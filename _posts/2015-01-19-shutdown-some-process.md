---
layout: post
title: 关闭一些无用的进程
category: tech
tags: linux
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

闲来无事`pstree -a`看了一下貌似好几个无用的进程。这几天也是装了很多软件，装一个玩一下又卸掉的节奏。小记录一下。

	sendmail，卸载。
	exim4，卸载。
	rpc也很可疑，跟NFS相关的平时也不用，service stop停掉。
	然后就是nfs-common也一样。
	除了停掉还要禁止开机启动，用`sysv-rc-conf`关掉。
	安装了iftop，一个流量的实时监控工具。
	安装了mutt msmtp，发邮件用的。
