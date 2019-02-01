---
layout: post
title:  PHP模块加载失败
category: tech
tags: php
---
![](https://cdn.kelu.org/blog/tags/php.jpg)

当我们编译好 php 后，启动 php-fpm 时会出现这样一系列的模块加载失败的错误：

    NOTICE: PHP message: PHP Warning:  Module 'bcmath' already loaded in Unknown on line 0
    NOTICE: PHP message: PHP Warning:  Module 'curl' already loaded in Unknown on line 0
    ...

如图：

![](https://cdn.kelu.org/blog/2017/07/20.24.20.jpg)

或者是查看 php 版本时，`php -v` 也会出现这样的错误。

PHP有两种方式添加扩展模块， 一种是直接编译进了PHP，另外一种是通过共享模式添加模块，并在php.ini配置文件中配置相应的模块。 在编译时的区别如下：

以下是直接编进内核的示例：

    ./configure --prefix /usr/share/php7  \
        --enable-mbstring \
        --with-bz2 \
        --with-curl \
        --with-xsl

以下是共享模式添加的示例：

    ./configure --prefix /usr/share/php7  \
        --enable-mbstring \
        --with-bz2=share \
        --with-curl=share \
        --with-xsl

以上问题出现的原因是我们需要的模块已经编译进PHP了，但是我们通过共享模块再次加载了这些模块，这样就导致重复加载。

解决方案：修改php.ini配置文件，注释掉相应的模块配置

    ;extension=pcre.so
    ;extension=spl.so
    ;extension=simplexml.so
    ;extension=session.so
    ;extension=exif.so

# 参考资料 
# 参考资料 

* [PHP Warning: Module 'modulename' already loaded in Unknown on line 0](http://www.somacon.com/p520.php)