---
layout: post
title: usr/bin/ld cannot find lxxx 问题
category: tech
tags: devops linux
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

在源码安装 snmp 时，在安装的第一步

    ./configure --prefix=/usr/local/snmp --with-mib-modules=ucd-snmp/diskio

时出现了错误：

![](https://cdn.kelu.org/blog/2017/03/20170328202414.jpg)

记录一下解决办法。

这是编译软件时常遇到的错误讯息。

    /usr/bin/ld: cannot find -lxxx 
    
其中xxx即表示函式库文件名称，有以下几种情形：

* 系统没有安装相对应的lib
* 相对应的lib版本不对
* lib的symbolic link 不正确，没有连结到正确的函式库文件(.so)

在我的例子中是没有安装 perl 的 lib 文件。于是这么解决：

    apt-get install libperl-dev
    
大功告成。    

# 参考资料

* [usr/bin/ld: cannot find -lxxx问题总结](http://eminzhang.blog.51cto.com/5292425/1285705)

