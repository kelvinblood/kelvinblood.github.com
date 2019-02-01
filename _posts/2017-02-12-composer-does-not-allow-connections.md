---
layout: post
title: composer install 无法下载
category: tech
tags: php composer
---

![](https://cdn.kelu.org/blog/2017/02/logo-composer-transparent2.jpg)

如下图。

![](https://cdn.kelu.org/blog/2017/02/20170212211058.jpg)
    

    your configuration does not allow to connection to `http://xxxxxxx`,see the https://getcomposer.org/doc/06-config.md#secure-http for details.

按照提示打开 <https://getcomposer.org/doc/06-config.md#secure-http> 

    secure-http#
    
    Defaults to true. If set to true only HTTPS URLs are allowed to be downloaded via Composer. If you really absolutely need HTTP access to something then you can disable it, but using Let's Encrypt to get a free SSL certificate is generally a better alternative.

默认是必须使用https的，而默认配置使用的镜像是http的。 

所以，解决办法有两个，一个是，在本项目的composer.json 中添加 secure-http 配置：   

      "config": {
        "secure-http": false
      }

composer的配置分为全局和各个项目的。针对当前项目是可以以第一种方式实现。而如果我们需要使用 composer 创建项目时当然不可行了。例如 `composer create-project --prefer-dist laravel/lumen blog`

于是第二个解决的办法就是在 composer 的全局配置文件 config.json 中添加 secure-http 配置。  在 win10 中这个配置文件位于 `C:\Users\xxx\AppData\Roaming\Composer\config.json` 中。

        "config": {
    	    "secure-http": false
    	},
        "repositories": {
            "packagist": {
                "type": "composer",
                "url": "http://packagist.phpcomposer.com"
            }
        }

# 参考资料

* [composer国内镜像不能使用 - segmentfault](https://segmentfault.com/q/1010000004517793)
