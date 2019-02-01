---
layout: post
title: Linux命令之sort
category: tech
tags: linux linux-command
---

sort将文件的每一行作为一个单位，相互比较，比较原则是从首字符向后，依次按ASCII码值进行比较，最后将他们按升序输出。记录一下常用的选项。更多选项参照`man sort`。

各选项含义如下：

	-u --unique 去除重复行。
	-r --reverse 降序。
	-o --output=FILE sort默认是把结果输出到标准输出，所以需要用重定向才能将结果写入文件
		`sort -r number.txt -o number.txt`
	-t --field-separator=SEP 设定间隔符
	-k --key=POS1[,POS2] 指定列数
		`sort -n -k 2 -t :`
	-f --ignore-case 忽略大小写
	-s --stable sort 命令默认是不稳定的排序，此选项使排序结果稳定。
	-R --random-sort 随机排序，每次运行的结果均不同。
	-g, --general-numeric-sort 将数字按数值大小排列，
	-n, --numeric-sort 将字符串以数值来排序（避免10小于2）
	-h --human-numeric-sort 按人类的方式排序 (例如, 2K 1G)




其实今天用到这个命令是因为需要查看文件夹里的文件大小。结合du命令最后得到的命令如下，获得占空间最大的十个文件或文件夹：

	du --max-depth=1 -ah | sort -hr | head
	
参考链接：

* Stack Overflow - [How can I sort du -h output by size](http://serverfault.com/questions/62411/how-can-i-sort-du-h-output-by-size)