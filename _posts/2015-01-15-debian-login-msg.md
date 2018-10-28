---
layout: post
title: debian登陆信息修改
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

一般我们ssh登陆debian会出现以下的信息。

	Linux kelu.org 3.18.1-x86_64-linode50 #1 SMP Tue Jan 6 12:14:10 EST 2015 x86_64
	
	The programs included with the Debian GNU/Linux system are free software;
	the exact distribution terms for each program are described in the
	individual files in /usr/share/doc/*/copyright.
	
	Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
	permitted by applicable law.
	Last login: Thu Jan 15 23:16:37 2015 from xxx.xxx.xxx.xxx




修改和添加的方法很多。在此记录一下。

登陆前提示信息文件是/etc/issue和/etc/issue.net.登陆前的信息我们不管了，就来看登陆后的信息好了。

	##start########未知23333333333#######################
	Linux kelu.org 3.18.1-x86_64-linode50 #1 SMP Tue Jan 6 12:14:10 EST 2015 x86_64
	##end###############################################
	
	##start########以下是/etc/motd#######################
	The programs included with the Debian GNU/Linux system are free software;
	the exact distribution terms for each program are described in the
	individual files in /usr/share/doc/*/copyright.
	##end###############################################
	
	##start########以下是/etc/ssh/sshd_config############
	######################PrintLastLog##################
	Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
	permitted by applicable law.
	Last login: Thu Jan 15 23:16:37 2015 from xxx.xxx.xxx.xxx
	##end###############################################

接下来是

/etc/ssh/sshrc ssh登陆之后会加载里面的内容。

/etc/bash.bashrc
值得注意的是，`screen`时候也会加载这个文件。

在/etc中的配置文件，会对所有用户生效。如果只希望对当前用户做自定义的配置，就在用户目录下进行配置。


