---
layout: post
title: python 自定义一个 setting 模块并使用其变量
category: tech
tags:  python
---
![](https://cdn.kelu.org/blog/tags/python.jpg)

最简单的方式是定义一个 setting 的 module：

{%raw%}

		(settings.py)
		
		CONSTANT1 = "value1"
		CONSTANT2 = "value2"
		
		(consumer.py)
		
		import settings
		
		print settings.CONSTANT1
		print settings.CONSTANT2

{%endraw%}

当我们引用 settings 模块里的变量时需要在前面添加模块的名称。如果我们真的不想添加模块的名称，并且我需要担心变量可能会改变，那么我们可以使用按照下面的方式引入：

{%raw%}

		from settings import CONSTANT1, CONSTANT2
		
		print CONSTANT1
		print CONSTANT2

{%endraw%}

然而这样子其实会导致其他人阅读这个代码的时候不知道这变量从哪来的。所以最简单的方式应该是这样：
	
{%raw%}

		import settings as s
		
		print s.CONSTANT1
		print s.CONSTANT2

{%endraw%}

方便了输入，又使得代码易懂。

# 参考资料

* [Create constants using a “settings” module?](https://stackoverflow.com/questions/3824455/create-constants-using-a-settings-module)
