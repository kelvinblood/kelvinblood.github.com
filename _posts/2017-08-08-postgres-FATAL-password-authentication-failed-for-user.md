---
layout: post
title: 连接PostgreSQL 显示 password authentication failed for user
category: tech
tags:  postgresql
---
![](https://cdn.kelu.org/blog/tags/postgresql.jpg)

解决方法：重置密码

1、编辑pg_hba.conf,将md5认证修改成trust认证，编辑后退出保存 

		vi /etc/postgresql/9.4/main/pg_hba.conf
		/usr/lib/postgresql/9.4/bin/pg_ctl reload

2、psql连接，用alter role修改密码 

		su - postgres
		psql 
		psql (9.2.3) 
		Type "help" for help. 
		
		postgres=# alter role postgres with password '123'; 
		ALTER ROLE

3、退出psql. \q
4、编辑 pg_hba.conf, 将turst认证修改成md5认证，编辑后退出保存，执行pg_ctl reload加载生效


# 参考资料

* [关于连接PostgreSQL时提示 FATAL: password authentication failed for user "连接用户名" 的解决方法](http://shao-lixin.iteye.com/blog/1921333)
