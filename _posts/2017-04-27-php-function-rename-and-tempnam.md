---
layout: post
title: php 函数 rename 与 tempnam
category: tech
tags: php
---

![](https://cdn.kelu.org/blog/tags/php.jpg)

前几天用到这两个函数，随后记一下。

rename 和 tempnam 都是 php 的文件系统 Filesystem 函数。Filesystem 允许您访问和操作文件系统。

# rename

rename函数，顾名思义，重命名一个文件或目录

    bool rename ( string $oldname , string $newname [, resource $context ] )
    
示例：

    <?php
    rename("/tmp/tmp_file.txt", "/home/user/login/docs/my_file.txt");
    ?>
    
    
# tempnam

tempnam 函数创建一个具有唯一文件名的临时文件。

若成功，则该函数返回新的临时文件名。若失败，则返回 false。

    tempnam(dir,prefix)
    
    * dir	必需。规定创建临时文件的目录。
    * prefix	必需。规定文件名的开头。

示例：

    <?php
    echo tempnam("C:\inetpub\testweb","TMP0");
    ?> 
    
# 参考资料
    
* [rename - php.net](http://php.net/manual/zh/function.rename.php)
* [文件系统函数 - php.net](http://php.net/manual/zh/ref.filesystem.php)
* [文件系统函数 - W3school](http://www.w3school.com.cn/php/php_ref_filesystem.asp)
* [PHP tempnam() 函数 - W3school](http://www.w3school.com.cn/php/func_filesystem_tempnam.asp)
