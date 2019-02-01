---
layout: post
title: bbb自动挂载硬盘
category: tech
tags: linux BeagleBone-Black mount disk
---

好久没有更新blog了。也是这几天刚把bbb给捡起来继续用了。猛然间发现挂载硬盘貌似好麻烦啊。于是这一篇记录了如何使得bbb自动挂载硬盘。

## 查看uuid

	ls -all /dev/disk/by-uuid
	
	显示如下：
	lrwxrwxrwx 1 root root  10 Apr 23  2014 0965f450-ff46-3429-8447-e050ee9750f0 -> ../../sda2
	lrwxrwxrwx 1 root root  15 Apr 23  2014 0E05-07AD -> ../../mmcblk0p1
	lrwxrwxrwx 1 root root  10 Apr 23  2014 67E3-17ED -> ../../sda1
	lrwxrwxrwx 1 root root  15 Apr 23  2014 b61c2377-7063-46c7-9dc4-4623c582b054 -> ../../mmcblk0p2
	lrwxrwxrwx 1 root root  10 Apr 23  2014 caed9236-d400-35cb-a16e-0298d648aaa9 -> ../../sda3



## 编辑fstab

	vi /etc/fstab
	
在文件中添加如下信息，要用到刚才对应的uuid的代号

	UUID=0965f450-ff46-3429-8447-e050ee9750f0 /mnt/Elements hfsplus rw,force,noatime,umask=000 0 0
	UUID=caed9236-d400-35cb-a16e-0298d648aaa9 /mnt/Animation hfsplus rw,force,noatime,umask=000 0 0

## 一些问题

1、中途有过即使如此操作还是会产生read-ONLY的问题，看一下dmsg：

	dmesg|tail
	
	[ 4842.317034] hfs: Filesystem was not cleanly unmounted, running fsck.hfsplus is recommended.  mounting read-only.
	
于是check一下硬盘	
	
	fsck.hfsplus -f /dev/sda2

之后再重新挂载硬盘，就成功了。

2、注意一下对应的硬盘参数：

	W95 FAT32 ,W95 FAT16 -> vfat 
	NTFS -> ntfs-3g 
	apple-hfs -> hfsplus
