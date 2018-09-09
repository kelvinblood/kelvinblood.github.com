---
layout: post
title: 使用 docker 构建本地 lnmp 开发环境（Mac）
category: tech
tags: php laravel postgresql docker openresty nginx
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

最近给个人的 mac 重装了系统，所有的配置全部没有了。对 Mac 下的 PHP 不同语言的环境切换还是很头疼的。这篇文章将介绍我使用 docker 部署本地 lnmp 开发环境的整个过程，可以结合我的 github 提交历史了解。业务涉及的知识点有 openresty、php 7.1、laravel、composer、postgresql、redis 等。

>  本项目也已经开源在 github 上，可以简单使用 docker-compose up -d 命令直接运行起来。

# 架构

这套环境由前端 openresty 接收请求，通过 linux sock 的方式传给 php-fpm，php-fpm 解析 php 代码，并连接数据库 postgresql 和 redis。 

openresty 模块要做好配置文件，与 php-fpm 进行对接。

php-fpm 模块，需要事前编译 postgresql 扩展包。也要做好配置文件，与 openresty 对接。同时代码运行也需要提前使用 composer 进行依赖包的安装，并做好与 postgresql 的配置对接。

postgresql 模块需要准备好 dump 文件，用于首次运行的数据库准备工作。如有需要还要编辑postgresql的配置文件，比如打开慢日志、外部连接等配置。

相关的日志文件保存到 log 文件夹下。

对应的 docker-compose.yml 文件如下：

```
version:  '3.0'
services:
  nginx:
    image: openresty/openresty:alpine
    volumes:
      - $MYWORKSPACE:/var/www/html
      - ./openresty:/etc/nginx/conf.d
      - ./sock:/sock
      - ./log:/log
    links:
      - "php:php"
    ports:
      - "8000:80"

  php:
    build: ./php
    volumes:
      - $MYWORKSPACE:/var/www/html
      - ./php/php-fpm.d:/usr/local/etc/php-fpm.d
      - ./php/conf/php-fpm.conf:/usr/local/etc/php-fpm.conf
      - ./sock:/sock
      - ./log:/log
    links:
      - "pgsql:pgsql"

  pgsql:
    image: postgres:9.4-alpine
    volumes:
      - ./psql/data:/var/lib/postgresql/data
      - ./psql/dump:/var/lib/postgresql/dump
    ports:
      - "5432:5432"
```

# openresty

基于 laravel 的写法，主要注意点在于 fastcgi 使用 sock 的方式，对提高 php 性能很有帮助。

```
server {
    listen       80;

    access_log off;
    error_log off;

    root         /var/www/html/public;

    location = / {
        fastcgi_pass                               unix:/sock/www.sock;
        fastcgi_index                              index.php;
        include                                    fastcgi.conf;
    }

    location = /_status {
        fastcgi_pass                               unix:/sock/www.sock;
        include                                    fastcgi.conf;
        fastcgi_param           SCRIPT_NAME        /_status;
    }

    location / {
        # URLs to attempt, including pretty ones.
        try_files   $uri $uri/ /index.php?$query_string;
    }

    # Remove trailing slash to please routing system.
    if (!-d $request_filename) {
        rewrite     ^/(.+)/$ /$1 permanent;
    }

    location ~* ^(.+\.php)(.*)$ {
        # limit_req zone=req_perip burst=8;
        fastcgi_pass                               unix:/sock/www.sock;
        fastcgi_split_path_info                    ^(.+\.php)(.*)$;
        include                                    fastcgi.conf;
    }

    location /nginx_status {
       stub_status on;
       access_log off;
    }
}

```

# php-fpm

我使用的是 postgresql 数据库，官方默认没有带有 postgresql 的扩展，需要自行编译。官方专门为容器提供了三个的命令，用来简化扩展的安装： `docker-php-ext-configure`, `docker-php-ext-install`, 和 `docker-php-ext-enable` 。具体使用可以查看 Dockerfile：

```
FROM php:7.1-fpm

RUN apt-get update

RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo_pgsql pgsql

```



还有需要注意的是laravel 项目的依赖安装的工作。在这里我也是使用了容器进行处理。可以参考 test.sh 文件中的命令：

```
#!/bin/bash

MYWORKSPACE="/Users/kelu/workspace/wechat.kelu.org"

docker run -it --rm \
  -v $MYWORKSPACE:/app \
  composer:1.4.2 install --ignore-platform-reqs --no-scripts

```

# postgresql

完成了前面两步，接下来开始安装 postgresql。

我目前还在使用 postgresql 9.4的版本，所以安装时指定了版本号。

postgresql 比较重要的两个配置文件我提取了出来，以方便修改：

* ./psql/data/postgresql.conf
* ./psql/data/pg_hba.conf

因为本地环境的原因我便偷懒了一会，首次运行后需要手动进入镜像还原数据库。按照标准的做法是做一个只运行一次用于还原数据库的镜像。

如何使用可以参考 psql 目录下的 readme 文件，主要步骤是：

* 设定数据库管理员密码
* 生成用户 abc 和 其管理的数据库 abc
* 还原 dump 文件
* 检验是否还原成功

```
su postgres
psql

\password postgres
CREATE USER abc WITH PASSWORD 'abc';
CREATE DATABASE abc OWNER abc;
GRANT ALL PRIVILEGES ON DATABASE abc to abc;

sudo -u postgres pg_restore -d abc abc.dump;

\l
\c abc
\d
\d account
\q
```

# 待办

redis 的内容待完成。