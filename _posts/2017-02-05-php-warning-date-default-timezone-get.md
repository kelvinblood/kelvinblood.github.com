---
layout: post
title: php 报错 date default timezone get
category: tech
tags: php composer
---
![](https://cdn.kelu.org/blog/tags/php.jpg)

今天在使用satis生成网页

    php bin/satis build satis.json public/
    
报了如下的错误：

    [Twig_Error_Runtime]
    An exception has been thrown during the rendering of a template ("date_default_timezone_get(): It is not safe to rely on the system's timezone settings. You are *required* to use the date.timezone setting or the date_default_timezone_set() function. In case you used any of those methods and you are still getting this warning, you most likely misspelled the timezone identifier. We selected the timezone 'UTC' for now, but please set date.timezone to select your timezone.").

    [ErrorException]
    date_default_timezone_get(): It is not safe to rely on the system's timezone settings. You are *required* to use the date.timezone setting or the date_default_timezone_set() function. In case you used any of those methods and you are still getting this warning, you most likely misspelled the timezone identifier. We selected the timezone 'UTC' for now, but please set date.timezone to select your timezone. 
    
解决方法：

修改php.ini配置文件(我的路径为C:\my_pp\php\php-5.5.30-nts-Win32-VC11-x64\php.ini)

在php.ini配置文件中找到：  `;date.timezone =` 

    date.timezone = "Asia/Shanghai"

修改完后，重启apache/nginx。
