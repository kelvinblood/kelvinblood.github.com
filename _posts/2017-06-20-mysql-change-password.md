---
layout: post
title:  MySQL 修改用户密码
category: tech
tags: mysql
---
![](https://cdn.kelu.org/blog/tags/mysql.jpg)
有两种方法可以修改密码：

# mysqladmin 命令

    mysqladmin -uroot -p[oldpass] password newpass
    
oldpass(老密码)可选，如果root默认密码为空，则不需要输入。

如果需要更改老密码，请注意老密码与-p之间不要有空格。

# mysql 命令

    mysql -uroot -p
    mysql> use mysql;
    mysql> UPDATE user SET Password = PASSWORD('newpass') WHERE user = 'root';
    mysql> FLUSH PRIVILEGES;
