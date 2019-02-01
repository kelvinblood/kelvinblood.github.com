---
layout: post
title: 备份你的Linux ——tar 打包和 rsync 同步
category: tech
tags: linux rsync
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

做好系统备份对系统管理员来说是件很重要的事情。可使用两种方法进行备份系统。一种是直接打tar包备份，另一种是使用增量备份工具，下面我来记录一下。

## 1. tar打包备份

tar打包备份很简单，就是一条tar命令。为了增强备份文件的可读性，我们将备份的时间设置为备份文件名。

	#!/bin/bash
	
	function bksys() {
	    filename=`date --date="-24 hour" +%Y-%m-%d_%H-%M`;
	    tar cvpzf /kelu/Backup/$filename.tar.gz --exclude=/proc --exclude=/tmp --exclude=/lost+found --exclude=/mnt --exclude=/sys --exclude=/kelu/Backup/ --exclude=/pub /;
	}
	
	bksys 2>&1 | tee -a /var/log/bksys.log

其中tar的-p的意思在man中的解释是：
-p 恢复字段到它们的原始方式，忽略现有的用户权限屏蔽位（umask)。 setuid、setgid 和 tacky 位许可权也恢复给拥有 kelu 用户权限的用户。这个标志恢复文件到其原始方式，但不恢复目录到其原始方式。

意思也就是说打包时保持该文件夹的相关属性，使解压的时候得以恢复。

## 2. rsync备份

rsync 是一个快速增量文件传输工具，它可以用于在同一主机备份内部的备份，我们还可以把它作为不同主机网络备份工具之用。本文主要讲述的是如何自架rsync服务器，以实现文件传输、备份和镜像。相对tar和wget来说，rsync 也有其自身的优点，比如速度快、安全、高效。

### 安装

debian安装使用`apt-get  install  rsync`安装。有的是系统自带的，自带的话就自己建好文件夹`/etc/rsyncd`，在文件夹里添加几个文件`rsyncd.motd`  `rsyncd.password`  `rsyncd.secrets`。
这三个文件的内容分别是：

	YUKI.N> cat rsyncd.motd
	+++++++++++++++++++++++++++
	+     kelu.org  2015      +
	+++++++++++++++++++++++++++
	YUKI.N> cat rsyncd.password
	12345678
	YUKI.N> cat rsyncd.secrets
	kelu:12345678

secrets和password的权限必须设为600，不然备份时候也会提醒也会拒绝备份= =
secrets是用户密码文件，password是为了方便自动化备份时的密码文件。交互式地备份的话会提醒你输入密码。

### 配置

配置rsyncd.conf

	# Distributed under the terms of the GNU General Public License v2
	# Minimal configuration file for rsync daemon
	# See rsync(1) and rsyncd.conf(5) man pages for help
	
	# This line is required by the /etc/init.d/rsyncd script
	pid file = /var/run/rsyncd.pid
	port = 873
	# 你的IP地址！
	address = 12.34.56.78 
	#uid = nobody
	#gid = nobody
	uid = kelu
	gid = kelu
	
	use chkelu = yes
	read only = yes
	
	#limit access to private LANs 注意要把自己的IP添加进去！
	hosts allow=192.168.1.0/255.255.255.0 10.0.1.0/255.255.255.0 
	hosts deny=*
	
	max connections = 5
	# motd文件，欢迎语来着，在里面随便写点东西。当用户登录时会看到这个信息。
	motd file = /etc/rsyncd/rsyncd.motd
	
	#This will give you a separate log file
	log file = /var/log/rsync.log
	
	#This will log every file transferred - up to 85,000+ per user, per sync
	transfer logging = yes
	
	log format = %t %a %m %f %b
	syslog facility = local3
	timeout = 300
	
	# 模块定义啦
	[模块名称]
	path = /
	list=yes
	ignore errors
	auth users = kelu
	secrets file = /etc/rsyncd/rsyncd.secrets
	comment = YUKI.N>
	exclude = proc/ tmp/ lost+found/ mnt/ sys/ kelu/Backup/ pub/


​	
做完这些，已经可以开始同步数据了。由于是本机备份，所以我没有看得很仔细，以后需要了再来看啦。

	/usr/bin/rsync --daemon 				# 启动服务
	rsync --list-only kelu@kelu.org:: 		# 备份信息
	rsync -avzP kelu@kelu.org::kelu.org /kelu/Dropbox/kelu.org/
											# 备份

写一个脚本，方便自动化。要记得chmod +x哦	
											
	#!/bin/sh
	# /usr/bin/rsync --daemon;
	# 全量备份
	# rsync -avzP --password-file=/etc/rsyncd/rsyncd.secrets kelu@kelu.org::kelu.org /kelu/Dropbox/kelu.org/$(date + '%m-%d-%y')
	rsync -avzP --password-file=/etc/rsyncd/rsyncd.password kelu@kelu.org::kelu.org /kelu/Dropbox/kelu.org/											

## 3. 自动化

	crontab -e

按照提示添加就好了。比如：

	# To define the time you can provide concrete values for
	# minute (m), hour (h), day of month (dom), month (mon),
	# and day of week (dow) or use '*' in these fields (for 'any').#
	# Notice that tasks will be started based on the cron's system
	# daemon's notion of time and timezones.
	
	# For example, you can run a backup of all your user accounts
	# at 5 a.m every week with:
	# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
	
	40 2 * * * rsync -avzP --password-file=/etc/rsyncd/rsyncd.password kelu@kelu.org::kelu.org /kelu/Dropbox/kelu.org/

或者你也可以按照系统的方法，新建一个自动化运行的文件夹，定时运行文件夹中的文件。

	10 4 * * * /usr/bin/run-parts   /etc/cron.daily.kelu    1> /dev/null
