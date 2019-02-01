---
layout: post
title: 修改 PostgreSQL 数据库默认密码
category: tech
tags: postgresql
---
![](https://cdn.kelu.org/blog/tags/postgresql.jpg)

1. 登录PostgreSQL

		sudo -u postgres psql

1. 修改登录PostgreSQL密码

		ALTER USER postgres WITH PASSWORD 'postgres';

注意：

*   密码postgres要用引号引起来
*   命令最后有分号
