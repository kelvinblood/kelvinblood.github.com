---
layout: post
title: linux硬盘分区、格式化与挂载
category: tech
tags: linux
style: summer
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

给手上的一台 Windows 安装 CentOS 后，发现 1T 的硬盘没有利用上。所以这一篇介绍怎么将它配置好。

主要用到一下知识点：

1.  对磁盘进行分区，以创建可用的分区；
1.  对分区进行格式化 （format）；
1.  创建挂载点 ，将磁盘挂载上来；

# 分区

## 查看磁盘列表lsblk

lsblk 是 “list block device ” 的缩写，就是列出所有储存设备的意思

```
lsblk [-dfimpt] [device]
选项与参数：
-d  ：仅列出磁盘本身，并不会列出该磁盘的分区数据
-f  ：同时列出该磁盘内的文件系统名称
-i  ：使用 ASCII 的线段输出，不要使用复杂的编码 （再某些环境下很有用）
-m  ：同时输出该设备在 /dev 下面的权限数据 （rwx 的数据）
-p  ：列出该设备的完整文件名！而不是仅列出最后的名字而已。
-t  ：列出该磁盘设备的详细数据，包括磁盘伫列机制、预读写的数据量大小等
```
![lsblk](https://cdn.kelu.org/blog/2017/10/block1.jpg)

从图片中可以目标磁盘是sdb，并且没有挂载进来。

## 列出磁盘的分区表类型parted

磁盘分区时要注意的是：“MBR 分区表需要使用 fdisk 分区， GPT 分区表需要使用 gdisk 分区”。搞错的话会分区失败的。

我们可以使用 parted 查看分区表类型。可以看到这块硬盘的格式是NTFS，windows默认的硬盘格式，分区表是MBR。

![parted](https://cdn.kelu.org/blog/2017/10/block2.jpg)

	parted /dev/sdb print

msdos 可以把它当成 MBR。[MBR equals msdos for gparted?](https://superuser.com/questions/700770/mbr-equals-msdos-for-gparted)

你也可能遇上这样的分区表类型：

![parted](https://cdn.kelu.org/blog/2017/10/block13.jpg)

关于loop类型在这里有一篇讨论，可以参考 [Is partition table type “loop” a good or bad idea on BTRFS?](https://unix.stackexchange.com/questions/166569/is-partition-table-type-loop-a-good-or-bad-idea-on-btrfs)

总之不确定的话，你可以简单按照 gpt 进行操作。

然后就可以开始分区了。

## 分区fdisk gdisk

参照 parted 的结果，如果是mbr格式则使用fdisk命令

### fdisk

![fdisk](https://cdn.kelu.org/blog/2017/10/block3.jpg)

`fdisk /dev/sdb`后使用`p`查看，可以看到当前磁盘被分为了4个区。使用`d`全部删掉。

![fdisk](https://cdn.kelu.org/blog/2017/10/block4.jpg)

默认会从最后一个分区开始删除，一路按，就能把所有分区全部删掉。

接下来使用`n`新建分区。默认新建的分区会把整个磁盘用完，嗯，正是我们想要的效果。

![fdisk](https://cdn.kelu.org/blog/2017/10/block5.jpg)

最后使用`w`将刚才的操作写入硬盘。此时再重新lsblk，可以看到已经分区好了。

![fdisk](https://cdn.kelu.org/blog/2017/10/block6.jpg)

### gdisk

和fdisk操作基本相同：

![gdisk](https://cdn.kelu.org/blog/2017/10/block6.jpg)

	gdisk /dev/sdb

# 格式化mkfs

分区之后就是格式化。这里磁盘格式化为Linux默认格式xfs。

![fdisk](https://cdn.kelu.org/blog/2017/10/block7.jpg)

	mkfs.xfs -f /dev/sdb

> 注意：
> 你的系统可能没有mkfs.xfs的命令，我的Ubuntu通过安装xfsprogs即可使用
> 	apt-get install xfsprogs 	

# 挂载

这里我将硬盘挂载到/mnt/sdb文件夹上去。

	mkdir -p /mnt/sdb

-p, --parents  此时若路径中的某些目录尚不存在,加上此选项后,系统将自动建立好那些尚不存在的目录,即一次可以建立多个目录;

查看sdb的uuid：

	blkid /dev/sdb

![blkid](https://cdn.kelu.org/blog/2017/10/block8.jpg)

然后使用`mount`命令进行挂载：

![blkid](https://cdn.kelu.org/blog/2017/10/block9.jpg)

	mount UUID="fd4b9aaa-3faf-487f-8ffc-c25534c9c569" /mnt/sdb
	df -h

此时使用`df -h`，可以看到硬盘已经正确挂载了。

![df -h](https://cdn.kelu.org/blog/2017/10/block10.jpg)

目前只是临时挂载上了，可以修改`/etc/fstab`文件，使系统在启动时便自动挂载硬盘。

![/etc/fstab](https://cdn.kelu.org/blog/2017/10/block11.jpg)

# 结束

最后以 MBR 分区表为例，用命令总结一下刚才的步骤

* lsblk
* parted /dev/sdb print
* fdisk /dev/sdb
* mkfs.xfs -f /dev/sdb
* blkid /dev/sdb
* mount UUID="fd4b9aaa-3faf-487f-8ffc-c25534c9c569" /mnt/sdb
* vi /etc/fstab

经过上面的步骤，便可以正常使用这一块硬盘了。

# 参考资料

* [磁盘的分区、格式化、检验与挂载](https://wizardforcel.gitbooks.io/vbird-linux-basic-4e/content/61.html)