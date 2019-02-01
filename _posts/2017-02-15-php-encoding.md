---
layout: post
title: php 获取编码和转换编码
category: tech
tags: php encoding
---
![](https://cdn.kelu.org/blog/tags/encoding.jpg)

做爬虫抓取页面的时候，常常有非utf-8的混入，包括gbk gb2312 甚至是 Big5，需要转换成我们期望的格式。
同时，Windows与其他操作系统也不同。普通的Linux和Mac都是原生使用utf-8的编码格式，而中文的windows用的则是gbk格式。因此针对不同系统的终端输出(console,cmd)，我们也需要进行编码转换。

看代码说话：

    function exchangeEncoding($text, $pageEncoding = '', $targetEncoding = 'UTF-8')
    {
        if (!$pageEncoding) {
            $pageEncoding = mb_detect_encoding($text, array("ASCII", 'UTF-8', "GB2312", "GBK", 'BIG5'));
        }

        if ($pageEncoding != $targetEncoding) {
            return mb_convert_encoding($text,$targetEncoding,$pageEncoding);
        }

        return $text;
    }

    function consoleText($text, $pageEncoding = '', $consoleEncoding = '')
    {
        // windows
        if (!$consoleEncoding) {
            if (stristr(php_uname('s'), 'win')) {
                $consoleEncoding = "GBK";
            } else {
                $consoleEncoding = 'UTF-8';
            }
        }
        return exchangeEncoding($text, $pageEncoding, $consoleEncoding);
    }


# 使用 php_uname() 判断操作系统类型

    /**
     *       'a':  返回所有信息
     *       's':  操作系统的名称，如FreeBSD
     *       'n':  主机的名称,如cnscn.org
     *       'r':  版本名，如5.1.2-RELEASE
     *       'v':  操作系统的版本号
     *       'm': 核心类型，如i386
     */
    function php_uname ($mode = null) {}

运行 php_uname(), 在我本机 Windows 中，返回类似如下的数据

    Windows NT KELU-PC 10.0 build 10586 (Windows 10) AMD64

在 Linux 服务器中则如下

    Linux debian 4.8.6-x86_64 #1 SMP Tue Nov 1 14:51:21 EDT 2016 x86_64


# 使用 mb_detect_encoding 判断字符编码

    function mb_detect_encoding ($str, $encoding_list = null, $strict = null) {}

# 使用 mb_convert_encoding 转换字符编码

    function mb_convert_encoding ($str, $to_encoding, $from_encoding = null) {}
    
# 参考资料

* [php.net](http://php.net/manual/zh/function.mb-convert-encoding.php)
* [php获取编码方式及改变编码方法 - segmentfault](https://segmentfault.com/a/1190000004115412)
