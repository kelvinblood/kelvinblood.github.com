---
layout: post
title: nginx 防盗链
category: tech
tags: linux nginx
---
![](https://cdn.kelu.org/blog/tags/nginx.jpg)

先补充一点HTTP的知识。

HTTP Referer是Header的一部分，当浏览器向Web服务器发送请求的时候，一般会带上Referer，告诉服务器是从哪个页面链接过来的，服务器借此可以获得一些信息用于处理。不过 HTTP Referer 可以通过程序来伪装生成的，所以通过Referer信息防盗链并非100%可靠，但是，它能够限制大部分的盗链。

# 用法

	valid_referers [none|blocked|server_names] ...

	默认值：none
	使用环境：server,location
	该指令会根据Referer Header头的内容分配一个值为0或1给变量 $invalid_referer。
	如果Referer Header头不符合valid_referers指令设置的有效Referer，变量$invalid_referer 将被设置为1.

	none:表示无Referer值的情况。
	blocked:表示Referer值被防火墙进行伪装。
	server_names:表示一个或多个主机名称。从Nginx 0.5.33版本开始，server_names中可以使用通配符"*"号。

# 配置

    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
    {
        valid_referers none *.kelu.org *.qq.com *.google.com *.baidu.com *.sinaimg.cn localhost;
        if ($invalid_referer) {
            rewrite ^/ https://wx3.sinaimg.cn/mw690/7b736eb7ly1fjr44z6lesj21hc0rs77f.jpg;
            #return 404;
        }
        expires      30d;
    }
