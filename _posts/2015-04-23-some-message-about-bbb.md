---
layout: post
title: BeagleBone Black的一些资料
category: tech
tags: linux BeagleBone-Black
---

前段时间在胡乱捣弄bbb，最后的结果反正是，bbb没办法从eMMC启动了。之前不确定是什么问题，从网上买了Micro HDMI转HDMI的线，忘了自己的显示器是DP口了，只好又买了个HDMI转DVI的线😂。

看了屏幕才想起来了，之前在配置启动自动加载外置硬盘时候，随手写了个，“外接硬盘必须正常挂载才能启动”的配置，于是，再也启动不起来了😂。最近暂时不管了，晾一边了。不过也找到了一些bbb的资料，顺道记录一下。



## 启动模式

四种引导模式：
 
* eMMC引导：这是默认启动模式，启动时间最短。不需要一个含有OS镜像的TF卡，也不需要购买TF卡以及读卡器

* SD引导：此模式将从TF卡插槽引导开机。这个模式可以用来重写eMMC。再生产或者现场更新时，可用来升级eMMC。

* 串口引导模式：这个模式可以利用串口直接下载软件。需要准备一个USB转TTL的线。

* USB引导模式：这个模式支持通过USB口引导。
 
可以通过一个开关来切换引导模式————断电情况下按住BOOT按钮，重新上电会，如果没有TF卡插入，会强制从USB口引导，如果USB口不能引导，会从串口引导。

如果没有按住BOOT按钮 ，板子会按照eMMC->TF卡->串口->USB口的顺序进行引导。如果按住BOOT按钮重新上电，并且插有含有可启动映像的TF卡的话，会从TF卡引导。

注：按主板上的RESET按钮，将不会导致引导模式的改变。必须切断电源并重新接通电源来更改引导模式。启动引脚上电时采样上电复位从PMIC到处理器。电路板上的复位按钮只有一个热复位并不会强制引导模式转变。


## macroSD卡启动及恢复

BeagleBone Black的macroSD卡启动及恢复

* 将BBB flash(emmc）上的bootloader（MLO文件）更名
* 在macro SD卡上安装新的系统，使用SD启动新系统,例如我安装ubuntu系统  
	在BBB上插入SD卡，由于BBB eMMC已经没有bootloader文件，BBB就直接从SD卡启动ubuntu，这避免了40多分钟的SD卡烧写eMMC的问题。
* 修复emmc上的MLO，以便能够恢复从BBB flash中启动  
	用SD启动进入ubuntu系统，sudo到root权限，查看系统分区fdisk -l  
	看到两个mmc磁盘/dev/mmcblk0, /dev/mmcblk1,找到那个size为2G的磁盘，这就是BBB的flash， mount这个盘上的boot分区，恢复MLO的文件名
	
		#mount /dev/mmcblk1p1 /mnt/tmp
		#cd /mnt/tmp
		#mv MLO.rename MLO

参考资料：

* [[技术交流] 【BBB学习笔记】一、升级系统](http://bbs.ickey.cn/group-topic-id-34943.html)
* [BeagleBone Black板的N节课](http://blog.csdn.net/luyejie8888/article/category/2417735)
* [BB Black 启动模式](http://bbs.eeworld.com.cn/thread-431223-1-1.html)
* [BeagleBone Black的macroSD卡启动及恢复](http://hi.baidu.com/mars208/item/ee7b7248c8214b39fa8960b9)
