---
layout: post
title: 运行时获得python版本号
category: tech
tags: python
---
![](https://cdn.kelu.org/blog/tags/python.jpg)

	#!/usr/bin/python  
	import platform  
	print platform.python_version()  

或

	#!/usr/bin/python  
	import sys  
	print sys.version   
	print sys.version_info
