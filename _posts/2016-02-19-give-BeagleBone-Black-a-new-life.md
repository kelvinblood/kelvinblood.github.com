---
layout: post
title: BeagleBone Black焕发第二春
category: tech
tags: linux BeagleBone-Black
---

BeagleBone Black吃灰已久。留着实在可惜。最近又拿出来捣弄了一番。已废旧利用为主要目的。这次总共做了几件事：
1. 烧录系统到micro SD卡并写入eMMC；
1. 使用usb连接电脑后联网。

## 烧录系统到micro SD卡并写入eMMC。

我是在windows下。

* 第一步：下载官方 [Debian](http://beagleboard.org/latest-images) 镜像

* 第二步：解压缩xz文件里的img镜像。

* 第三步：打开 [Win32DiskImager](http://sourceforge.net/projects/win32diskimager/) ，选择镜像和目标SD卡，烧录到SD卡中。


 ![Win32DiskImager烧写](https://cdn.kelu.org/blog/2016/02/blog_2016-02-28-raspi-01-2.jpg)


烧写完成之后将SD卡插入到树莓派的卡槽中，上电启动，我们可以通过串口或者通过ip来登陆。

* 第四步：把烧写好镜像的SD卡插入BBB，按住SD卡槽旁边的按键（在卡槽另一面）（15s左右），BBB会从SD卡启动。然后用 ssh工具putty，或者使用HDMI接口直接连接显示器。

使用cd命令进入boot目录下，可以看到有一个叫uEnv.txt的文件，，使用nano或者vim打开，，将其中的

	##enable BBB: eMMC Flasher:
	#cmdline=init=/opt/scripts/tools/eMMC/init-eMMC-flasher-v3.sh

改成

	##enable BBB: eMMC Flasher:
	cmdline=init=/opt/scripts/tools/eMMC/init-eMMC-flasher-v3.sh

重启BBB。

* 第五步：重启之后，你会看到BBB的四个LED会像流水灯一样闪烁，，接下来等很久很久，，你的BBB就烧写好了，，烧写好，，四个LED会全亮的。。


##  使用usb连接电脑后联网

（1）打开网络连接，找到主机外网的网络连接（如下图中，我的就是本地连接），以及BBB的usb0在主机上的的网络连接（如下图，本地连接2）

![](https://cdn.kelu.org/blog/2016/02/blog_2016-02-28-164943555.jpg)

（2）这时需要修改上图中的本地连接2（这里依据自己机器的实际显示）TCP/IPv4属性，BBB连接主机后，它会默认手动配置ip地址和子网掩码，所以需要把这里改成“自动获取IP地址”和“自动获取DNS服务器地址”，修改后，确定保存，如下图所示：

![](https://cdn.kelu.org/blog/2016/02/blog_2016-02-28-165546942.jpg)

（3）修改本地连接的共享属性，将网络共享给本地连接2，确定保存，如下图：

![](https://cdn.kelu.org/blog/2016/02/blog_2016-02-28-171607394.jpg)

（4）使用putty远程连接BBB上的系统，配置BB-Black的路由和DNS等，输入指令：

	route add default gw 192.168.7.1：

（5）需要配置域名解析，编辑文件  /etc/resolv.conf，使用vim打开之后，增加以下内容：
（5）需要配置域名解析，编辑文件  /etc/resolv.conf，使用vim打开之后，增加以下内容：

	nameserver 8.8.8.8

（6）测试一下是否网络共享了，输入命令：ping www.baidu.com，就OK了
（6）测试一下是否网络共享了，输入命令：ping www.baidu.com，就OK了

---

参考资料：

* [BeagleBone Black 之官方Debian系统安装](http://www.lxway.com/40189691.htm)
* [树莓派入手初体验--镜像烧写+登陆](http://jeremybai.github.io/blog/2014/11/01/raspi-01/)
* [BeagleBone Black与主机共享网络之配置操作](http://blog.csdn.net/u012019376/article/details/42267655)