---
layout: post
title: postgresql报错 —— column “rolcatupdate” does not exist
category: tech
tags: postgresql
---
![](https://cdn.kelu.org/blog/tags/postgresql.jpg)

最近又要安装新系统，然后按照惯例地搭建工作环境。却在 postgresql 这一块出了问题，使用 Navicat Premium 访问数据库时弹出了这样的错误：

	column “rolcatupdate” does not exist

出现这个问题的根源在于 Postgres 9.5 以后 "rolcatupdate" 便不再支持了。这个问题是客户端的问题。23333333333

所以用官方自带的 pgAdmin 4 访问数据库，则完全不会出现这个问题呢。

其实要解决 Navicat Premium 的这个报错也很简单，你只需要用官方自带的客户端添加好相应的数据库db 和角色role，这个报错就不会再出现了~

# 参考资料

* [PostgreSQL: column “rolcatupdate” does not exist error?](http://csharp.wekeepcoding.com/article/11839727/PostgreSQL%3A+column+%E2%80%9Crolcatupdate%E2%80%9D+does+not+exist+error%3F)
* [ERROR:COLUMN "ROLCATUPDATE" DOES NOT EXIST](http://www.debugrun.com/a/sQHbY89.html)