---
layout: post
title: linux查看运行级别
category: tech
tags: linux
---

Linux运行级别从0～6，共7个。

    0：关机。不能将系统缺省运行级别设置为0，否则无法启动。
    1：单用户模式，只允许root用户对系统进行维护。
    2：多用户模式，但不能使用NFS(相当于Windows下的网上邻居)
    3：字符界面的多用户模式。
    4：未定义。
    5：图形界面的多用户模式。
    6：重启。不能将系统缺省运行级别设置为0，否则会一直重启。
    
　　查看运行级别命令：

    runlevel

　　先后显示系统上一次和当前运行级别。如果不存在上一次运行级别，则用N表示。

![](http://7vigrt.com1.z0.glb.clouddn.com/blog/pic/201701/QQ%E6%88%AA%E5%9B%BE20170113212734.jpg)