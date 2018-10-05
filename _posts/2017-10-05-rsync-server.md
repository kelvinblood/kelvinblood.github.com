---
layout: post
title: 搭建 rsync 服务器
category: tech
tags: linux rsync
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

# 介绍

rsync是用 “rsync 算法”提供了一个客户机和远程文件服务器的文件同步的快速方法，而且可以通过ssh方式来传输文件，这样其保密性也非常好，另外它还是免费的软件。

　　rsync 包括如下的一些特性：

1. 能更新整个目录和树和文件系统；
2. 有选择性的保持符号链链、硬链接、文件属于、权限、设备以及时间等；
3. 对于安装来说，无任何特殊权限要求；
4. 对于多个文件来说，内部流水线减少文件等待的延时；
5. 能用rsh、ssh 或直接端口做为传输入端口；
6. 支持匿名rsync 同步文件，是理想的镜像工具。



# 安装

###  源码编译

下载地址：[https://rsync.samba.org/](http://rsync.samba.org/)

	tar xvf rsync-3.1.1.tar.gz
	cd rsync-3.1.1
	./configure --prefix=/usr/local
	make && make install

### 软件包安装

	apt-get install rsync

# 配置

由官方文档可以看出来 rsync 有三个主要文件：

* rsyncd.conf 是rsync服务器主要配置文件。
* rsyncd.secrets是登录rsync服务器的密码文件。
* rsyncd.motd是定义rysnc 服务器信息的，也就是用户登录信息。

rsync的操作有两种
1、启动rsync守护进程的
2、使用remote shell处理的

我选择了第二种情况，特别简单，只需要写好配置文件即可。

	mkdir -p /etc/rsyncd
	cd /etc/rsyncd
	vi rsyncd.conf

修改配置文件rsyncd.conf

	address = 172.104.xx.xx # 本机地址
	uid = root
	gid = root
	use chroot = yes
	read only = yes
	hosts allow=*
	max connections = 5
	motd file = /etc/rsyncd/rsyncd.motd
	log file=/var/log/rsyncd.log
	pid file = /var/run/rsyncd.pid
	lock file=/var/run/rsync.lock
	#transfer logging = yes
	log format = %t %a %m %f %b
	syslog facility = local3
	timeout = 300
	
	[cdn]   # 需要同步的文件夹，按照自己的需要写
	path = /var/local/cdn
	ignore errors
	comment =  cdn

# 运行

服务端运行

	rsync  --daemon --config=/etc/rsyncd/rsyncd.conf

建议客户端以下面这种 ssh 的方式运行，可以避免输入密码，更好地自动化

	rsync -vzrtopg --delete --progress root@xxx:/var/local/cdn/ /var/local/cdn

客户端结合 cron，就可以达到定时同步的效果了。

# 参考资料

* [rsync服务器搭建](https://my.oschina.net/yearnfar/blog/509089) 
* [ssh密匙登录方法及rsync加密传输同步文件设置](https://www.b9go.com/blog/myweishanli/article/443)
* [Rsync（远程同步）：10 Linux中Rsync命令的实际示例](https://www.howtoing.com/rsync-local-remote-file-synchronization-commands/)
