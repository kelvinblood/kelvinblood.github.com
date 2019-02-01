---
layout: post
title: Linux强制下线已登录用户
category: tech
tags: linux linux-command
---

因为在用tmux的原因，使用lish登陆或者使用小窗口登陆终端后不下线，导致新开的全屏终端只能显示小小的一块，非常碍眼。所以这种时候需要强制让已登录的这些用户下线。

使用`w`或者`last`查看机器中登陆的用户

	# w

	16:29:02 up 2 days, 2:35, 5 users, load average: 0.03, 0.05, 0.01
	
	USER TTY FROM LOGIN@ IDLE JCPU PCPU WHAT
	
	root pts/1 :0.0 Tue15 2days 1:44 0.04s -bash
	
	root pts/2 :0.0 Tue15 46:42m 0.05s 0.05s bash
	

把pts/1踢掉（只有root才能去踢掉用户）

	# pkill -kill -t pts/1

 

查看是不是踢掉

	# w

一个有趣的现象是，root出了可以踢掉其他用户，还可以踢掉当前正在登陆的自己。