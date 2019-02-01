---
layout: post
title:  反向代理 GitHub Pages
category: tech
tags: github
---

![](/assets/img/github.jpg)

我的这个 blog 一直托管在 github 上。因为担心访问问题（貌似 Github 原本就是 GFW 屏蔽的？），配置了一个免费的 CDN：<https://www.incapsula.com/>，不得不说，其实还是不错的，可以避免访问不稳定的问题。缺点在于访问速度确实慢了，大概有1300-2000ms延迟。

手头上刚好有比较好的资源，就做了一个反向代理，效果不错，目前延迟在120-400ms，已经满足了。

配置反代也非常简单，就两步，DNS 重定向和 nginx 反代：

# dns重定向

配置DNS重定向到目标服务器。

# nginx

    server {
        listen       80;
        server_name  blog.kelu.org;

        access_log off; #access_log end
        error_log /dev/null; #error_log end

        location / {
               proxy_pass         http://kelvinblood.github.io;
               proxy_redirect     off;
               proxy_set_header   Host                        $host;
               proxy_set_header   X-Real-IP               $remote_addr;
               proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
        }
    }

配置说明：
    
    proxy_set_header Host $host 设置请求头的Host为反向代理服务器的Host
    
    proxy_set_header X-Real-IP $remote_addr 设置请求头的X-Real-IP为客户端真实IP
    
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for 把请求来源的IP添加到请求头的X-Forwarded-For字段
    
    X-Forwarded-For:简称XFF头，它代表客户端，也就是HTTP的请求端真实的IP，只有在通过了HTTP代理或者负载均衡服务器时才会添加该项。 它不是RFC中定义的标准请求头信息，在squid缓存代理服务器开发文档中可以找到该项的详细介绍。 标准格式如下：X-Forwarded-For: client1, proxy1, proxy2。
