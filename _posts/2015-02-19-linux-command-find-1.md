---
layout: post
title: Linux命令之find (1) - 查找
category: tech
tags: linux linux-command
---


最近用到find的下面命令，简单记录一下。主要是与时间有关的find命令。

## atime、ctime与mtime

先说说时间参数atime、ctime与mtime。

* atime指access time，即文件新建或者执行的时间，修改文件是不会改变access time的。

* ctime即change time文件状态改变时间，指文件的i结点被修改的时间，如通过chmod修改文件属性，ctime就会被修改。

* mtime即modify time，指文件内容被修改的时间。



使用touch可以改变这三个时间。使用stat可以查看文件的信息。

	# stat kelubksys.sh
	  File: `kelubksys.sh'
	  Size: 1063            Blocks: 8          IO Block: 4096   regular file
	Device: ca00h/51712d    Inode: 99421       Links: 1
	Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
	Access: 2015-02-02 10:20:37.392697633 +0800
	Modify: 2015-02-21 16:18:54.787485938 +0800
	Change: 2015-02-21 16:18:54.787485938 +0800
	 Birth: - 

也可以使用ls查看文件的atime、ctime、mtime。

	ls -l		// modefiy
	ls -lu	// access
	ls -lc	// change

## 一些例子
	
	# find /home -size +10M 		// /home目录下大小超过10MB的文件
	# find . -mtime +120 			// 120天以前被修改过的文件
	# find /var \! -atime -90 	// /var目录下90天之内未被访问过的文件
	# find / -name core -exec rm {} \; //在整个目录树下查找文件core，如发现则无需提示直接删除它们。
