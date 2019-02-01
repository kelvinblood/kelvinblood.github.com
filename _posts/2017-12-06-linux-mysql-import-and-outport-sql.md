---
layout: post
title: Linux 下导入和导出.sql文件
category: tech
tags: linux mysql
---
![](https://cdn.kelu.org/blog/tags/mysql.jpg)

# mysqldump 导出

1. 导出数据和表结构：

		mysqldump -u用户名 -p密码 数据库名 > 数据库名.sql

2. 只导出表结构

		mysqldump -u用户名 -p密码 -d 数据库名 > 数据库名.sql


# 二、导入数据库

方法一：

1. 登陆

		mysql -u用户名 -p密码

1. 建空数据库

		create database abc;

1. 导入数据库

	* 选择数据库

			mysql>use abc;

	* 设置数据库编码

			mysql>set names utf8;

	* 导入数据（注意sql文件的路径）

			mysql>source /init.sql;

方法二：

	mysql -u用户名 -p密码 数据库名 < 数据库名.sql
