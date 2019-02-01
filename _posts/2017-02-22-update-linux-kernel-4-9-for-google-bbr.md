---
layout: post
title: 更新Linux内核至4.9
category: tech
tags: linux 
---
![](https://cdn.kelu.org/blog/tags/github.jpg)

	aptitude install initramfs-tools
	apt-get install --reinstall grub
	
	mkdir /boot/grub
	
	Searching for GRUB installation directory ... found: /boot/grub
	Probing devices to guess BIOS drives. This may take a long time.
	Unknown partition table signature
	Unknown partition table signature
	Searching for default file ... Generating /boot/grub/default file and setting the default boot entry to 0
	Searching for GRUB installation directory ... found: /boot/grub
	Testing for an existing GRUB menu.lst file ...
	
	
	Generating /boot/grub/menu.lst
	Searching for splash image ... none found, skipping ...
	Found kernel: /boot/vmlinuz-4.10.0-041000-generic
	Found kernel: /boot/vmlinuz-3.16.0-4-amd64
	Updating /boot/grub/menu.lst ... done



# 参考资料

* [shields.io][shields.io]
* [kcptun][kcptun]
* [gitter.im][gitter.im]
* [Go_Report_Card][Go_Report_Card]
* [microbadger][microbadger]
* [travis-ci][travis-ci]

[shields.io]: http://shields.io
[kcptun]: https://github.com/xtaci/kcptun/blob/master/README-CN.md
[gitter.im]: https://gitter.im
[Go_Report_Card]: https://goreportcard.com
[microbadger]: https://microbadger.com
[travis-ci]: https://travis-ci.org/getting_started
