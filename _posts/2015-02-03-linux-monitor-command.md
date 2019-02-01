---
layout: post
title: linux命令之监控命令
category: tech
tags: linux linux-command
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

简单记录一下Linux自带的一些系统状态监控的命令。关于ps和lsof的命令太过复杂，详细用法有空再记录。

## 1. 用户

* [w](#_w) 不但可以显示有谁登录到系统，还可以显示出这些用户当前正在进行的工作，并且统计数据相对who命令来说更加详细和科学。

相似命令：who/whoami/last/logname/tty/

## 2. 内存

* [free](#_free) 显示内存的使用情况，包括实体内存，虚拟的交换文件内存，共享内存区段，以及系统核心使用的缓冲区等。



## 3. 磁盘吞吐

* [iostat](#_iostat) 主要用于监控系统设备的IO负载情况。

## 4. 进程

* [top](#_top) 显示，管理执行中的程序。并通过它所提供的互动式界面，用热键加以管理。
* [ps](#_ps) 报告程序状况。
* `pstree -a` 以树状图显示进程间的关系

## 5. 网络

* [netstat](#_netstat) 显示网络连接、路由表和网络接口信息。

	netstat是在内核中访问网络及相关信息的程序，它能提供TCP连接，TCP和UDP监听，进程内存管理的相关报告，是一个监控TCP/IP网络的非常有用的工具，它可以显示路由表、实际的网络连接以及每一个网络接口设备的状态信息。Netstat用于显示与IP、TCP、UDP和ICMP协议相关的统计数据，一般用于检验本机各端口的网络连接情况。
	
## 6. 系统版本

* lsb_release -a 获取系统的版本信息。

		No LSB modules are available.
		Distributor ID: Debian
		Description:    Debian GNU/Linux 7.8 (wheezy)
		Release:        7.8
		Codename:       wheezy
		
## 7. 统计

* [vmstat](#_vmstat) 展现给定时间间隔的服务器的状态值,包括服务器的CPU使用率，内存使用，虚拟内存交换情况,IO读写情况。
* [swatch](#_swatch) 系统监控程序。可用来监控系统记录文件，并在发现特定的事件时，执行指定的动作。
* [lsof](#) 系统级的监控、诊断工具。

	linux 下 “一切皆文件”，	包括但不限于 pipes, sockets, directories, devices, 等等。因此，使用 lsof，你可以获取任何被打开文件的各种信息。


## 附录

<span id="_w"></span>
	语　　法：w [-fhlsuV][用户名称]
	
	参　　数： 
	　　-f 　开启或关闭显示用户从何处登入系统。 
	　　-h 　不显示各栏位的标题信息列。 
	　　-l 　使用详细格式列表，此为预设值。 
	　　-s 　使用简洁格式列表，不显示用户登入时间，终端机阶段作业和程序所耗费的CPU时间。 
	　　-u 　忽略执行程序的名称，以及该程序耗费CPU时间的信息。 
	　　-V 　显示版本信息。

<span id="_free"></span>
	语　　法： free [-bkmotV][-s &lt;间隔秒数&gt;]
	
	参　　数： 
		-b 　以Byte为单位显示内存使用情况。 
		-k 　以KB为单位显示内存使用情况。 
		-m 　以MB为单位显示内存使用情况。 
		-o 　不显示缓冲区调节列。 
		-s&lt;间隔秒数&gt; 　持续观察内存使用状况。 
		-t 　显示内存总和列。 
		-V 　显示版本信息。

<span id="_iostat"></span>
	语　　法: iostat [-c|-d][-k|-m][-t][-V][-x][device[...]|ALL][-p[device|ALL]][interval[count]]
	
    参　　数：
    	-c 仅显示CPU统计信息.与-d选项互斥.
    	-d 仅显示磁盘统计信息.与-c选项互斥.
    	-k 以K为单位显示每秒的磁盘请求数,默认单位块.
    	-p device | ALL
    	  与-x选项互斥,用于显示块设备及系统分区的统计信息.也可以在-p后指定一个设备名,如:
    	  # iostat -p hda
    	  或显示所有设备
    	  # iostat -p ALL
    	-t    在输出数据时,打印搜集数据的时间.
    	-V    打印版本号和帮助信息.
    	-x    输出扩展信息.

<span id="_top"></span>
	语　　法：top [bciqsS][d <间隔秒数>][n <执行次数>]
	
	参　　数： 
		b 　使用批处理模式。 
		c 　列出程序时，显示每个程序的完整指令，包括指令名称，路径和参数等相关信息。 
		d<间隔秒数> 　设置top监控程序执行状况的间隔时间，单位以秒计算。 
		i 　执行top指令时，忽略闲置或是已成为Zombie的程序。 
		n<执行次数> 　设置监控信息的更新次数。 
		q 　持续监控程序执行的状况。 
		s 　使用保密模式，消除互动模式下的潜在危机。 
		S 　使用累计模式，其效果类似ps指令的-S参数。

<span id="_netstat"></span>
	语　　法：netstat [-acCeFghilMnNoprstuvVwx] [-A<网络类型>][--ip]
	
	参　　数：
		-a (all)显示所有选项，默认不显示LISTEN相关
		-t (tcp)仅显示tcp相关选项
		-u (udp)仅显示udp相关选项
		-n 拒绝显示别名，能显示数字的全部转化成数字。
		-l 仅列出有在 Listen (监听) 的服務状态
		
		-p 显示建立相关链接的程序名
		-r 显示路由信息，路由表
		-e 显示扩展信息，例如uid等
		-s 按各个协议进行统计
		-c 每隔一个固定时间，执行该netstat命令。
	
	提示：LISTEN和LISTENING的状态只有用-a或者-l才能看到
<span id="_vmstat"></span>

	语　　法：vmstat [-V] [-n] [delay [count]]
	
	参　　数：
	　　－V表示打印出版本信息；
	　　－n表示在周期性循环输出时，输出的头部信息仅显示一次；
	　　delay是两次输出之间的延迟时间；
	　　count是指按照这个时间间隔统计的次数。

<span id="_swatch"></span>

	语　　法：swatch [-A <分隔字符>][-c <设置文件>][-f <记录文件>][-I <分隔字符>][-P <分隔字符>][-r <时间>][-t <记录文件>]
	
	补充说明：swatchswatch所监控的事件以及对应事件的动作都存放在 swatch的配置文件中。预设的配置文件为拥护根目录下的.swatchrc。然而在Red Hat Linux的预设用户根目录下并没有.swatchrc配置文件，您可将/usr/doc/swatch- 2.2/config_files/swatchrc.personal文件复制到用户根目录下的.swatchrc，然后修改.swatchrc所要监控的事件及执行的动作。
	
	参　　数： 
		-A<分隔字符> 　预设配置文件中，动作的分隔字符，预设为逗号。 
		-c设置文件> 　指定配置文件，而不使用预设的配置文件。 
		-f记录文件> 　检查指定的记录文件，检查完毕后不会继续监控该记录文件。 
		-I分隔字符> 　指定输入记录的分隔字符，预设为换行字符。 
		-P分隔字符> 　指定配置文件中，事件的分隔字符，预设为逗号。 
		-r时间> 　在指定的时间重新启动。 
