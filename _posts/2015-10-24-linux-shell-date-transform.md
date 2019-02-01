---
layout: post
title: linux date时间戳的互相转换
category: tech
tags: linux shell time
---

因为需要将时间存入数据库中，为了让数据库的数据比较友好，之前采用了`1990-01-01 01:01:01`这种格式。计算相隔时间时，应当如下计算：

首先取当前时间：

	NOWTIME=`date "+%Y-%m-%d %H:%M:%S"`

将指定时间转为时间戳

	time1=$(date +%s -d '$NOWTIME');
	
将时间戳转成特定时间

	time1=$(date +%Y-%m-%d\ %H:%M:%S -d "1970-01-01 UTC $time1 seconds");

