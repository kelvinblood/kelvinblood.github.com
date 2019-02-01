---
layout: post
title: postgresql 使用不同账号新建数据库
category: tech
tags: postgresql
style: summer
---
![](https://cdn.kelu.org/blog/tags/postgresql.jpg)

今天用 postgresql 的默认账号 postgres，想新建一个角色然后新建数据库，竟然报错：

![](https://cdn.kelu.org/blog/2017/09/pg1.jpg)

	ERROR:  must be member of role "ttfix"

好奇以前为什么没有发现这个问题——[《# PostgreSQL入门》](/tech/2017/04/08/postgresql-tutorial.html)

比较简单的解决办法是在新建用户后，将新用户的权限赋予当前用户，再进行其他操作。具体如下：

![](https://cdn.kelu.org/blog/2017/09/pg2.jpg)

	GRANT "ttfix" to postgres;
	CREATE DATABASE "ttfix" owner "ttfix";
	GRANT ALL PRIVILEGES ON DATABASE ttfix to ttfix;
	REVOKE ttfix from postgres;

# 参考资料

* [Creating a database under a different owner](https://dba.stackexchange.com/questions/96368/creating-a-database-under-a-different-owner)
