---
layout: post
title: Linux命令之du & df
category: tech
tags: linux linux-command
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

du命令是示每个文件和目录的磁盘使用空间的，但是与df命令不同的是Linux du命令是对文件和目录磁盘使用的空间的查看，还是和df命令有一些区别的.

	命令格式： du [选项][文件]
	
	命令参数：
		-a或-all  显示目录中个别文件的大小。   
		-b或-bytes  显示目录或文件大小时，以byte为单位。   
		-c或--total  除了显示个别目录或文件的大小外，同时也显示所有目录或文件的总和。 
		-k或--kilobytes  以KB(1024bytes)为单位输出。
		-m或--megabytes  以MB为单位输出。   
		-s或--summarize  仅显示总计，只列出最后加总的值。
		-h或--human-readable  以K，M，G为单位，提高信息的可读性。
		-x或--one-file-xystem  以一开始处理时的文件系统为准，若遇上其它不同的文件系统目录则略过。 
		-L<符号链接>或--dereference<符号链接> 显示选项中所指定符号链接的源文件大小。   
		-S或--separate-dirs   显示个别目录的大小时，并不含其子目录的大小。 
		-X<文件>或--exclude-from=<文件>  在<文件>指定目录或文件。   
		--exclude=<目录或文件>         略过指定的目录或文件。    
		-D或--dereference-args   显示指定符号链接的源文件大小。   
		-H或--si  与-h参数相同，但是K，M，G是以1000为换算单位。   
		-l或--count-links   重复计算硬件链接的文件。



其实今天用到这个命令是因为需要查看文件夹里的文件大小。结合du命令最后得到的命令如下，获得占空间最大的十个文件或文件夹：

	du --max-depth=1 -ah | sort -hr | head


​	
linux中df命令的功能是用来检查linux服务器的文件系统的磁盘空间占用情况。默认情况下，磁盘空间将以 1KB 为单位进行显示，除非环境变量 POSIXLY_CORRECT 被指定，那样将以512字节为单位进行显示

	命令格式：	df [选项] [文件]
	命令参数：
	必要参数：
		-a 全部文件系统列表
		-h 方便阅读方式显示
		-H 等于“-h”，但是计算式，1K=1000，而不是1K=1024
		-i 显示inode信息
		-k 区块为1024字节
		-l 只显示本地文件系统
		-m 区块为1048576字节
		--no-sync 忽略 sync 命令
		-P 输出格式为POSIX
		--sync 在取得磁盘信息前，先执行sync命令
		-T 文件系统类型
	
	选择参数：
		--block-size=<区块大小> 指定区块大小
		-t<文件系统类型> 只显示选定文件系统的磁盘信息
		-x<文件系统类型> 不显示选定文件系统的磁盘信息
		--help 显示帮助信息
		--version 显示版本信息