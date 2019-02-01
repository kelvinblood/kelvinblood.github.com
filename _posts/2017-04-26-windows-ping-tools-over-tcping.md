---
layout: post
title: 禁ping也能ping的工具:tcping
category: software
tags: windows
---

![](https://cdn.kelu.org/blog/tags/encoding.jpg)

查看网络延迟标配工具：ping。但是机房服务器禁止ping的情况也很常见。这时候就用到tcping了。

tcping 是类似ping的工具，通过TCP协议工作（ping是通过icmp协议来工作的），也可以通过它来监控服务器的情况。

使用方法很简单，就是把它放在C盘windows目录下的system32文件夹下就可以使用了。

使用格式如下：

    tcping www.baidu.com
    tcping -t www.baidu.com         # 参数-t 一直运行ping
    tcping -d -t www.baidu.com      # -d 是显示时间
    tcping -d -t www.baidu.com 21   # 21是监听的端口
    
效果如下图：
    
![](https://cdn.kelu.org/blog/2017/04/20170503205740.jpg)    


下载链接：<http://pan.baidu.com/s/1nvodysD> 密码：u2c4

下载的软件包括 tcping 和 tcping64，其中 tcping64 是64位的意思。

常用的也就上面一些命令。如果你对其他的命令感兴趣，可以查看官网介绍：<https://elifulkerson.com/projects/tcping.php>
