---
layout: post
title: postgresql 连接报错 - no pg_hba_conf entry for host
category: tech
tags: postgresql database
---

![](https://cdn.kelu.org/blog/tags/postgresql.jpg)

最近换了办公环境，发现内部测试时使用 postgres 无法正常连接数据库。 使用工具连接时报错 

    connect to PostgreSQL server: FATAL: no pg_hba.conf entry for host "4X.XXX.XX.XXX", user "userXXX", database "dbXXX".

在维护 PostgreSQL 库时，pg_hba.conf 属于认证文件，在业务服务器出现调整，或增加应用服务器时，需要增加 pg_hba.conf 的 IP 签权信息。 另外pg_hba.conf 文件的更改对当前连接不影响，仅影响更改配置之后的新的连接。

如果 Postgresql 在 windows 下安装，使用安装时附带的 pgAdmin 进行修改即可。

一般该文件位于

    C:\my_pp\PostgreSQL\9.4\data\pg_hba.conf

![](https://cdn.kelu.org/blog/2017/02/2017021.jpg)
![](https://cdn.kelu.org/blog/2017/02/2017022.jpg)
![](https://cdn.kelu.org/blog/2017/02/2017023.jpg)

如果是 Linux 环境，使用 find 全局查找也能查出来。按照文件example修改即可。因为内网环境，也就没所谓了，让所有链接都能通过，即 0.0.0.0/0

    local   all             all                                     peer
    # IPv4 local connections:
    host    all             all             0.0.0.0/0            trust
    host    all             all             samenet                 trust
    # IPv6 local connections:
    host    all             all             ::1/128                 trust

# pg 的几个基本概念
# pg 的几个基本概念

* 实例(instance)：一台机器上可以跑多个实例，每个实例要占用单独的端口，默认只跑一个实例，默认端口是5432
* 数据库(database)：一个实例可以包含多个数据库
* 模式(schema)：一个数据库可以包含多个模式，模式之间的命名不会冲突，默认模式是public
* 对象(object)：模式里包含的所有东西都是对象，包括表、视图、索引、函数等等

# 参考资料

* [postgres无法正常连接数据库FATAL: no pg_hba.conf entry for host](http://www.cnblogs.com/chinadyw/p/3507207.html)
