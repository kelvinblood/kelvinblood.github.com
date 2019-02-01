---
layout: post
title: shell 脚本中切换用户并执行命令
category: tech
tags: shell
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

# 背景

目前使用的是超级用户root，然而我需要使用脚本批量运行一些命令行，然而由于用户权限的原因无法直接使用。

对于常规的系统，我通常使用 sudo -u 的方式进行切换，例如备份 postgresql 数据库时：

```
sudo -u postgres pg_dump -F c -Z 9 -d abc > abc.dump
```

如果是没有 sudo 的系统，应当如何解决呢？

# 方案

还是以上文备份 postgresql 数据库为例，

如果只需要执行一行命令，使用：

```
su - postgres -c "pg_dump -F c -Z 9 -d abc > abc.dump"
```

如果执行多行命令，如下:

```
su - postgres <<EOF
/bin/bash -c "psql -c \"CREATE USER abc WITH PASSWORD 'abc';\""
/bin/bash -c "psql -c \"CREATE DATABASE abc OWNER abc;\""
/bin/bash -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE abc to abc;\""
pg_dump -F c -Z 9 -d abc > /var/lib/postgresql/dump/abc.dump
EOF
```



# 参考资料

* [How can I set the timezone please? #136 - github issue](https://github.com/gliderlabs/docker-alpine/issues/136)