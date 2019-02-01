---
layout: post
title: 数据库优化尝试
category: tech
tags: database
---
![](https://cdn.kelu.org/blog/tags/postgresql.jpg)

最近个人网站的流量开始多了起来，以前写的代码比较粗放，目前同时在线人数不足30人，就有一些吃力了，1c的机器负载常年为1.5~2。优化有两个方向，一个是数据库优化，查找费时的语句，以此为基础进行优化，同时还可以做分库等高级方式；二是使用 redis 等内存数据库，将常用数据全部放到缓存中，加快系统速度。

目前只做了最基础的数据库优化，便将负载降到了0.2。已经满足了当前的需求了。这篇文章记录下整个过程。

# 1 开启慢查询语句跟踪

在配置文件 postgresql.conf 简单设置以下参数，当然还有错误级别等要设置。

```
vi /etc/postgresql/9.4/main/postgresql.conf

# 以log_开头的配置都可以关注一下，主要是下面几个要配置好
logging_collector = on
log_destination = 'stderr'
log_rotation_age = 1d
log_rotation_size = 10MB
log_min_duration_statement = 1000
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
```

**log_statement：**
设置跟踪的语句类型，有4种类型：none(默认), ddl, mod, all。跟踪所有语句时可设置为 "all"。

**log_min_duration_statement：**
跟踪慢查询语句，单位为毫秒。如设置 5000，表示日志将记录执行5秒以上的SQL语句。

当 log_statement=all 和 log_min_duration_statement 不能同时开启，只设置一个即可。

# 2 代码逻辑中删除不必要的数据

一个临时表一样的数据表，应该定期删除数据。当时发现一个数据表存有上百万条数据，而这张表只是临时表，1小时后便没有了用处。这种表应当在代码逻辑中及时删除。

对于常用的数据，则可以考虑将其放入内存中，减少数据库读取。这部分内容未来再开新文章记录。

# 3 根据日志为数据库添加索引

对于一些 Where 的语句，注意 where 使用到的项，出现次数多的，将他们加入索引。

# 总结

目前通过以上三个步骤，基本解决了我小网站的负载问题。

除此外，还可以将数据表按年月日归档、专门建立统计表等方式，进一步优化。目前还不紧急，待未来再实践。

# 参考资料

* [Postgres的日志实用功能](https://my.oschina.net/Kenyon/blog/118503)
* [设计索引 - IBM](https://www.ibm.com/support/knowledgecenter/zh/SSEPGG_11.1.0/com.ibm.db2.luw.admin.dbobj.doc/doc/c0020181.html)