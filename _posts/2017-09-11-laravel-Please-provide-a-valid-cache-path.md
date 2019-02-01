---
layout: post
title: Laravel 部署问题 —— "Please provide a valid cache path"
category: tech
tags:  php laravel
style: summer
---
![](https://cdn.kelu.org/blog/tags/laravel.jpg)

最近新建了一个 laravel 5.5项目，发现本地运行好好的，部署到服务器就发现出问题了。

在访问后台 admin 页面时提醒出错：

	Please provide a valid cache path

经过一番排查，这个可以算作是 gitignore 的问额，也可以不算233333

之前在本地创建项目时，使用的是 github 默认的 laravel 的 gitignore。所以很多文件没有创建，系统缓存没办法创建，于是就出现了这样的问题。

最后的解决办法是手动创建了下面这些目录：

* storage/framework
* storage/logs
* storage/framework/cache
* storage/framework/sessions
* storage/framework/views
* bootstrap/cache

最后就 ok 了。

