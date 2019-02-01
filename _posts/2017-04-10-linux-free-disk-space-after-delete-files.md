---
layout: post
title: Linux 删除文件后释放系统空间
category: tech
tags: linux
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

又遇到了系统磁盘满的问题了。记录一下事后解决的流程。

首先进入自己认为可能出现问题的目录，使用du命令查看该目录下文件的大小（包括文件夹）：

    du --max-depth=1 -ah 2> /dev/null | sort -hr | head 

查出问题源后，显然就是删除 rm 了。

如果这个文件是没有进程访问的，rm 之后是会立刻释放空间的，`df -h` 就可以看到了。如果有进程访问该文件，那事实上系统还是认为自己没有空间。解决的办法就是 kill 掉这个进程。

所以先查看哪个进程在访问这个文件：

    lsof |grep file

显示如下：

    oracle    12639  oracle    5w      REG              253,0         648     215907 /home/oracle/admin/dbticb/udump/dbticb_ora_12637.trc (deleted)
    
kill掉进程即可：

    kill -9 12639

话又说回来，这个只是事后不久，解决问题最好的办法是是事先预警,将问题扼杀在摇篮里。
