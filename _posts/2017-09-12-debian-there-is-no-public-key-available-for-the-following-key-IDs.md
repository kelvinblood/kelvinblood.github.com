---
layout: post
title: There is no public key available for the following key IDs
category: tech
tags:  linux 
style: summer
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

光盘安装Debian，手动修改了source.list，在使用 apt-get 的时候出现了这个问题—— `There is no public key available for the following key IDs: xxxxx`

解决的办法也很简单，就是请求keyserver把这个key的公钥给你：

	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys KEY_ID xxxxx

# 参考资料

* [There is no public key available for the following key IDs](https://ubuntuforums.org/showthread.php?t=2323037&s=0cdeede640e985e786504ac4cc28e414)
