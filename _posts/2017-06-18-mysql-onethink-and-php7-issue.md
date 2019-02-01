---
layout: post
title:  onethink 的数据库依赖 Mysql 在 PHP7 上的小坑
category: tech
tags: php thinkphp mysql
---
![](https://cdn.kelu.org/blog/tags/php.jpg)

Onethink是基于Thinkphp 3.2开发的一款内容管理框架。 今天在安装过程中出现mysql_connect检测失败，无法安装的问题。

从根源上说，这个是 PHP7 关于 MySQL 连接实现的改变引起的一个问题。

Onethink 总共检测了3个函数 mysql_connect(),file_put_contents(),mb_strlen()，如果在低于PHP7的环境下可能没什么问题，
在PHP7中，mysql_connect()函数已经被废弃，所以无论如何都检测不过的，PHP官方也是推荐使用Mysqli或者PDO（PHP数据对象）方式连接数据库，增加应用的安全性。

因此我们可以修改环境检测的代码，只要修改一处就可以了。

在Application/Install/Common/function.php中找到方法check_func()把检测 mysql_connect 改成 mysqli_connect 即可

    /**
     * 函数检测
     * @return array 检测数据
     */
    function check_func(){
        $items = array(
            array('mysqli_connect',     '支持', 'success'),
            array('file_get_contents', '支持', 'success'),
            array('mb_strlen',         '支持', 'success'),
        );

        foreach ($items as &$val) {
            if(!function_exists($val[0])){
                $val[1] = '不支持';
                $val[2] = 'error';
                $val[3] = '开启';
                session('error', true);
            }
        }

        return $items;
    }
    
检测后，安装选择mysqli的方式连接数据库。