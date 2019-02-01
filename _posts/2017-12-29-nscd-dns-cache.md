---
layout: post
title:  DNS缓存服务 — NSCD
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

偶然发现，自己的服务器上运行着一个叫 nscd 的服务。

所谓 nscd（Name Service Cache Daemon），是一种能够缓存 passwd、group、hosts 的本地缓存服务，分别对应三个源 `/etc/passwd`、`/etc/hosts`、`/etc/resolv.conf`。

每个源保存两份缓存，一份是找到记录的，一份是没有找到记录的。每一种缓存都保存有生存时间（TTL）。其作用就是在本当中增加cache ，加快如DNS的解析等的速度。

# 安装 

*   RHEL/CentOS

```
$ yum -y install nscd
```
缓存文件路径为`/var/db/nscd/`。

*   Debian/Ubuntu

```
$ apt-get install nscd
```
nscd 的缓存文件路径为`/var/cache/nscd/`。

![](https://cdn.kelu.org/blog/2017/12/20180127170534.jpg)

## 命令

nscd 服务默认是关闭的，通过`service nscd start`开启。

*   查看统计信息

```
$ nscd -g
```

*   清除缓存

```
# 当更改完域名指向后，清除dns缓存
$ nscd -i hosts

```

*   关闭服务

```
$ nscd -K
```
# 配置

阿里云的配置如下:
	
	#
	# /etc/nscd.conf
	#
	# An example Name Service Cache config file.  This file is needed by nscd.
	#
	# Legal entries are:
	#
	#	logfile			<file>
	#	debug-level		<level>
	#	threads			<initial #threads to use>
	#	max-threads		<maximum #threads to use>
	#	server-user             <user to run server as instead of root>
	#		server-user is ignored if nscd is started with -S parameters
	#       stat-user               <user who is allowed to request statistics>
	#	reload-count		unlimited|<number>
	#	paranoia		<yes|no>
	#	restart-interval	<time in seconds>
	#
	#       enable-cache		<service> <yes|no>
	#	positive-time-to-live	<service> <time in seconds>
	#	negative-time-to-live   <service> <time in seconds>
	#       suggested-size		<service> <prime number>
	#	check-files		<service> <yes|no>
	#	persistent		<service> <yes|no>
	#	shared			<service> <yes|no>
	#	max-db-size		<service> <number bytes>
	#	auto-propagate		<service> <yes|no>
	#
	# Currently supported cache names (services): passwd, group, hosts, services
	#
	
	#	logfile			/var/log/nscd.log
	#	threads			4
	#	max-threads		32
	#	server-user		nobody
	#	stat-user		somebody
		debug-level		0
	#	reload-count		5
		paranoia		no
	#	restart-interval	3600
	
		enable-cache		passwd		yes
		positive-time-to-live	passwd		600
		negative-time-to-live	passwd		20
		suggested-size		passwd		211
		check-files		passwd		yes
		persistent		passwd		yes
		shared			passwd		yes
		max-db-size		passwd		33554432
		auto-propagate		passwd		yes
	
		enable-cache		group		yes
		positive-time-to-live	group		3600
		negative-time-to-live	group		60
		suggested-size		group		211
		check-files		group		yes
		persistent		group		yes
		shared			group		yes
		max-db-size		group		33554432
		auto-propagate		group		yes
	
		enable-cache		hosts		yes
		positive-time-to-live	hosts		3600
		negative-time-to-live	hosts		20
		suggested-size		hosts		211
		check-files		hosts		yes
		persistent		hosts		yes
		shared			hosts		yes
		max-db-size		hosts		33554432
	
		enable-cache		services	yes
		positive-time-to-live	services	28800
		negative-time-to-live	services	20
		suggested-size		services	211
		check-files		services	yes
		persistent		services	yes
		shared			services	yes
		max-db-size		services	33554432
	
		enable-cache		netgroup	yes
		positive-time-to-live	netgroup	28800
		negative-time-to-live	netgroup	20
		suggested-size		netgroup	211
		check-files		netgroup	yes
		persistent		netgroup	yes
		shared			netgroup	yes
		max-db-size		netgroup	33554432
