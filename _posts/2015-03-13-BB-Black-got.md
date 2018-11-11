---
layout: post
title: 新入了一块BB-Black
category: tech
tags: linux BeagleBone-Black Raspberry-Pi
---

新入了一块BBB，便迫不及待地将它运转起来用。入手的这块bbb全称是 —— BeagleBone BB-BLACK TI AM335x Cortex-A8开发板 REV.C。趁着刚入门的新鲜劲没过去，赶紧先把它拿来当下载器了。图里比较乱😂不要太在意~

![BBB](https://cdn.kelu.org/blog/2015/03/bbb.jpg)



## 关于BBB

BB Black是一款基于AM335x处理器的开发套件。处理器集成了ARM Cortex-A8 内核，并提供了丰富的外设接口。中国版BB-Black的扩展接口包括网口、USB Host、USB OTG、TF卡接口、串口、JTAG接口（默认不焊）、HDMI D Type接口、eMMC、ADC、I2C、SPI、PWM和LCD屏接口。

中国版BB-Black的应用场景非常广泛，能够满足包括游戏外设、家庭和工业自动化、消费类医疗器械、打印机、智能收费系统、智能售货机称重系统、教育终端和高级玩具等在内的各个领域的不同需求。

通用接口包括4组通用输入输出接口（GPIO），每一组GPIO模组提供32个专用的通用接口输入输出管脚，因此通用的GPIO可以高达128个（4x32）管脚。可编程实时单元和工业通讯子系统（PRU-ICSS）包含了两个32位RISC内核（可编程实时单元，即PRUs）、存储器、终端控制器以及能够支持更多周边接口和协议的内部外设。

POWERVR® SGX图形加速器子系统用于3D图形加速以支持显示和游戏效果，该子系统的主要特性如下：

* Tile-Based架构，处理能力高达20Mploy/秒
* 通用可扩展渲染引擎是一个具有像素和顶点渲染功能的多线程引擎
* 超过Microsoft VS3.0、PS3.0和OGL2.0的高级渲染功能指令集
* 工业标准API，支持Direct3D Mobile、OGL-ES 1.1和2.0、OpenVG 1.0和OpenMax

## BBB vs 树莓派

树莓派的推广要远远胜于BBB的感觉。在我买了BBB之后，想为BBB找一个好壳子，一番搜索下来，外设数量之多远超BBB。

![PIvsBBB](https://cdn.kelu.org/blog/2015/03/PIvsBBB.jpg)

另外在我看来，BBB大概需要购买一个USB HUB才能更好地使用。目前一个USB接口已经接上了移动硬盘，再也没有额外的位置挂其它东西了。其它的详细对比信息可以参考我前一篇转载的文章。

## 使用过程

BBB的盒子中附上了一张简单的使用说明书。BBB可以由5V的电源或USB驱动。最简单的接入方法就是用USB线将其连接到电脑上，在弹出的u盘中安装平台下的驱动就好了，Windows、Linux和Mac都有，很棒的。

装好驱动后，重启BBB，就可以通过ssh连接了。可以使用以下代码连接：

	ssh root@192.168.7.2

默认root无密码，直接就可以登录了。

## 一些注意事项

ssh连接上之后基本就没大问题了。下面记录一下遇到的几个问题。

1. 挂载Mac移动硬盘

	BBB单独的USB口供电不足，必须使用外接电源的移动硬盘或者USB HUB才可以驱动。
	
	`man mount`可以查看挂载硬盘的相关方法。默认挂载Mac硬盘时候只能以只读模式挂载。所以我们需要的是先将硬盘卸载，再挂载：
	
		$ mkdir ~/sda2
		$ df -h
		$ umount /dev/sda2
		$ mount -t hfsplus -o force,rw /dev/sda2 ~/sda2
	
	关于mount的更多用法，可以参考这篇文章[Linux mount/unmount命令](http://www.cnblogs.com/xd502djj/p/3809375.html)
	
		格式：mount [-参数] [设备名称] [挂载点] 
		其中常用的参数有：
			-a 安装在/etc/fstab文件中类出的所有文件系统。
			-f 伪装mount，作出检查设备和目录的样子，但并不真正挂载文件系统。
			-n 不把安装记录在/etc/mtab 文件中。
			-r 讲文件系统安装为只读。
			-v 详细显示安装信息。
			-w 将文件系统安装为可写，为命令默认情况。
			-t  指定设备的文件系统类型，常见的有： 
				ext2  linux目前常用的文件系统 
				msdos  MS-DOS的fat，就是fat16 
				vfat  windows98常用的fat32 
				nfs  网络文件系统 
				iso9660  CD-ROM光盘标准文件系统 
				ntfs  windows NT/2000/XP的文件系统 
				auto 自动检测文件系统 
			-o  指定挂载文件系统时的选项，有些也可写到在/etc/fstab中。常用的有： 
				defaults 使用所有选项的默认值（auto、nouser、rw、suid）
				auto/noauto 允许/不允许以 –a选项进行安装
				dev/nodev 对/不对文件系统上的特殊设备进行解释
				exec/noexec 允许/不允许执行二进制代码
				suid/nosuid 确认/不确认suid和sgid位
				user /nouser 允许/不允许一般用户挂载
				codepage=XXX 代码页 
				iocharset=XXX 字符集 
				ro 以只读方式挂载 
				rw 以读写方式挂载 
				remount 重新安装已经安装了的文件系统
				loop 挂载回旋设备
		
		需要注意的是，挂载点必须是一个已经存在的目录，这个目录可以不为空，但挂载后这个目录下以前的内容将不可用，umount以后会恢复正常。使用多个-o参数的时候，-o 只用一次，参数之间用半角逗号隔开：

2. 使用tmux会产生大量的TIME_WAIT，导致系统缓慢

	这已经不是第一次和tmux在一起的不和谐了。具体原因不明。总之结果就是，尽量不进入tmux中进行操作，或者进去之后马上退出来。
	
	![image](https://cdn.kelu.org/blog/2015/03/time_wait.jpg) 

3. E: Sub-process /usr/bin/dpkg returned an error code (1)

	apt-get install 时候，出现了这样一个错误，导致之后再也无法install。目前我的方法是：
	
		cd /var/lib/dpkg
		mv info info.bak
		mkdir info
		apt-get --reinstall xxxx #重新安装
		cp -r info.bak/* info/

4. 查看操作系统信息

		$ lsb_release -a
			No LSB modules are available.
			Distributor ID:	Debian
			Description:	Debian GNU/Linux 7.8 (wheezy)
			Release:	7.8
			Codename:	wheezy
		$ getconf LONG_BIT
			32

5. apt-get: NO_PUBKEY / GPG error

	W: GPG error: ftp://ftp.debian.org/ testing Release: 
	The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 9AA38DCD55BE302B

	W: There is no public key available for the following key IDs:9AA38DCD55BE302B

		$ gpg --keyserver pgpkeys.mit.edu --recv-key 9AA38DCD55BE302B 
		$ gpg -a --export 9AA38DCD55BE302B | sudo apt-key add -

6. 设置固定IP

		$ cp /etc/network/interfaces  /etc/network/interfacesbak
		$ vi /etc/network/interfaces 
		# 增加一下内容
			auto eth0
			allow-hotplug eth0
			iface eth0 inet static
			    address 10.0.1.10
			    netmask 255.255.255.0
			    network 10.0.1.0
			    gateway 10.0.1.1
		$ service networking restart
	
7. 在国内的话使用国内的debian源

		$ vi /etc/apt/sources.list
			# china▫▫▫▫
			deb http://ftp.cn.debian.org/debian/ wheezy main contrib non-free▫▫▫▫
			deb-src http://ftp.cn.debian.org/debian/ wheezy main contrib non-free▫▫▫▫
			▫▫▫▫
			# multimedia▫▫▫▫
			deb http://deb-multimedia.org wheezy main non-free▫
