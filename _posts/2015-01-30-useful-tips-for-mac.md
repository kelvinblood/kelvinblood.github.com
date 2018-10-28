---
layout: post
title: 几个关于Mac的小技巧
category: software
tags: mac
---

![](https://cdn.kelu.org/blog/tags/mac.jpg)

今天新发现了几个Mac的小技巧！还蛮实用的！

* Cmd按下时点击侧边栏将在新标签页打开文件夹
* Cmd按下时点击dock上的app或者dock文件夹内的文件，都直达app或者文件所在的目录（这个功能超级实用啊）
* Spotlight搜索时cmd+回车，直接在文件夹中显示搜索结果（也挺实用的啊）
* 截图平时常用cmd+shift+4或者cmd+shift+ctl+4截取一个区域，复制内容给朋友看。但是！按下这几个键之后可以再按一下空格键，快速截取当前活跃窗口！

话说有点想做一些软件的速查手册，放在网站的侧边栏上。



## 显示隐藏文件和文件夹

	// 显示
	defaults write com.apple.finder AppleShowAllFiles -boolean true ; killall Finder  
	
	// 不显示
	defaults write com.apple.finder AppleShowAllFiles -boolean false ; killall Finder

该命令适用于 OS X Mavericks 和 OS X Yosemite 系统。
