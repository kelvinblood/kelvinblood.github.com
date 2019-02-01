---
layout: post
title: Debian使用apt-get时卡在 waiting for headers
category: tech
tags:  linux
style: summer
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

解决办法

	rm -rf /var/lib/apt/lists/* 
	apt-get clean
	apt-get update
