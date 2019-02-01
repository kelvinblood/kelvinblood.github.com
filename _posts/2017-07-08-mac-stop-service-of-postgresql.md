---
layout: post
title: Mac 下停止 PostgreSQL 服务
category: tech
tags: mac postgres
---

![](https://cdn.kelu.org/blog/tags/postgresql.jpg)

在 Mac 下有很多种方式可以安装 PostgreSQL 。比如源码安装、homebrew 安装，dmg 包安装。 现在想起来，我应该用 homebrew 安装——还是命令行可控性强一些。当时觉得方便，使用官网提供的 dmg 包安装，然后问题就来了：无法停止 PostgreSQL。

参照网上的办法，使用了下面这个命令：

	/Library/PostgreSQL/9.6/bin/pg_ctl -D /Library/PostgreSQL/9.6/bin/postgres stop -s -m fast

出现了这样的错误：

	pg_ctl: could not open PID file "/Library/PostgreSQL/9.6/bin/postgres/postmaster.pid": Not a directory

无法找到 postmaster.pid 的位置。后来也找了一系列的办法，都不行。好在竟然在 github 上找到了 gui 界面停止的办法—— [MaccaTech](https://github.com/MaccaTech)/**[PostgresPrefs](https://github.com/MaccaTech/PostgresPrefs)**

安装办法很简单，下载 [GUI](https://github.com/mckenfra/postgresql-mac-preferences/releases) 后点击安装，会在系统偏好设置里生成管理图标，就可以在里边进行开启、停止的操作啦！

![](https://cdn.kelu.org/blog/2017/07/2017-07-18-3.14.18.jpg)

![](https://cdn.kelu.org/blog/2017/07/2017-07-18-3.12.01.jpg)

# 参考资料

* [How to start PostgreSQL server on Mac OS X?](https://stackoverflow.com/questions/7975556/how-to-start-postgresql-server-on-mac-os-x)

* [Stop postgreSQL service on Mac via terminal](https://stackoverflow.com/questions/34173451/stop-postgresql-service-on-mac-via-terminal)

