---
layout: post
title:  Python 生成随机数
category: tech
tags: python
---
![](https://cdn.kelu.org/blog/tags/python.jpg)

	# coding:utf-8
	import time
	import random
	
	time.sleep(random.randint(4,9))

这里我用了 random 模块的 randint() 函数来生成随机数，每次执行后都返回不同的数字（4到 9）。

函数的语法为：

	random.randint(a,b)
	
函数返回数字 N ，N 为 a 到 b 之间的数字（a <= N <= b），包含 a 和 b。


# 参考资料

* [runoob.com](http://www.runoob.com/python3/python3-random-number.html)