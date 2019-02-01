---
layout: post
title: Linux 以图形界面启动
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

这一块在各个发行版之间、同一个发行版内部，都有不同的方式。这一篇以 Debian 8 作为例子，其它版本请谨慎阅读。

* 修改内核启动参数

        vi /etc/default/grub

        GRUB_CMDLINE_LINUX_DEFAULT="text"  # 原先为 GRUB_CMDLINE_LINUX_DEFAULT="quiet"
        GRUB_TERMINAL=console  # 原先被注释掉了
        
    然后运行    
        
        update-grub

* 不启动窗口管理器

        vi /etc/X11/default-display-manager
 
        #/usr/sbin/gdm3
        /bin/true
        
* 加载默认配置

        systemctl set-default multi-user.target
        
        
完成。        
