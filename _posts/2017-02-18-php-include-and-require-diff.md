---
layout: post
title: php include()和 require() 的区别说明
category: tech
tags: php laravel
---
![](https://cdn.kelu.org/blog/tags/php.jpg)

这也是个老生常谈的东西了，今天在阅读laravel的源代码，顺手记一下。 

在php中引用文件有两种办法，require(_once) 及 include(_once)。

他们最主要的不同点在于

* 使用include时，一般是放在流程控制的处理部分中。PHP 程序网页在读到 include 的文件时，才将它读进来。这种方式，可以把程序执行时的流程简单化。当包含的文件不存在时，系统会报出警告级别的错误(warning)，程序会继续往下执行。
* 使用require时，通常放在 PHP 程序的最前面，使得 PHP 程序在执行前，就会先读入 require 所指定引入的文件，使它变成 PHP 程序网页的一部份。当包含的文件不存在时，系统会先报出警告级别的错误(warning)，接着又报一个致命级别的错误(Fatal error)。程序终止执行。
* incluce在用到时加载,require在一开始就加载,_once后缀表示已加载的不加载
* require()通常来导入静态的内容，而include()则适合用导入动态的程序代码。 

        对include()语句来说，在执行文件时每次都要进行读取和评估；
        而对于require()来说，文件只处理一次（实际上，文件内容替换require()语句）。
        这就意味着如果可能执行多次的代码，则使用require()效率比较高，如果每次执行代码时是读取不同的文件，或者有通过一组文件迭代的循环，就使用include()语句。

* include有返回值，而require没有。

    例如laravel的index.php文件中通过 require_once 对 app 进行赋值：

        // index.php
            <?php
            require __DIR__.'/../bootstrap/autoload.php';
            $app = require_once __DIR__.'/../bootstrap/app.php';

        // app.php

            <?php
            $app = new Illuminate\Foundation\Application(
                realpath(__DIR__.'/../')
            );
            
            ...

            return $app;
    
# 参考资料

* [PHP中include()与require()的区别说明](http://www.jb51.net/article/22467.htm)
* [PHP中include和require的区别详解](http://blog.csdn.net/shenpengchao/article/details/52326233)
