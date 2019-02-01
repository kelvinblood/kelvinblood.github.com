---
layout: post
title:  启动nginx状态页
category: tech
tags: nginx
---

![](https://cdn.kelu.org/blog/tags/nginx.jpg)

nginx 内建了一个状态页，对于想了解nginx的状态以及监控nginx非常有帮助。

在你的 nginx.conf 配置的server中添加如下配置:

    location /nginx_status {
        stub_status on;
        access_log off;
        allow 192.168.10.0/24;
        deny all;
    }
    
然后重启 nginx，即可成功。
    
>     
> 你可能在重启的时候遇到 
> 
>     unknown directive "stub_status"
>     
> 这是因为nginx没有加上http_stub_status_module，需要重新安装这个插件：
> 
>     ./configure --with-http_stub_status_module
    
访问该网页，可以看到类似如下的信息：
   
    Active connections: 1998 
    server accepts handled requests
    1189721 1189721 2667471 
    Reading: 2 Writing: 10 Waiting: 1980
    
说明：    
    
* Active connection -活跃的连接数量
* server accepts handled requests  总共处理了1189721个连接，成功创建了1189721次握手，总共处理了2667471个请求
* Reading——读取客户端的连接数
* Writing——响应数据到客户端的数量
* Waitting——开启keep-alive的情况下，这个只等于active-(Reading+Writing),意思就是nginx已经处理完正在等候下一次请求指令的驻留连接
