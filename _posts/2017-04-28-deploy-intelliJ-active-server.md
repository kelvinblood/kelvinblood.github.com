---
layout: post
title:  搭建 IntelliJ 激活服务器
category: tech
tags: linux
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

毕竟不是什么光彩的事，赚了钱的同志们还是正版付费吧。这篇文章只贴配置，不解释。
 
# supervisor 配置

    [program:idea]
    command = /var/local/IDEAServer/IDEAServer -p 1024 -prolongationPeriod 999999999 -l 127.0.0.1
    autostart=true
    autorestart=true
    startsecs=3
    redirect_stderr = true  ; 把 stderr 重定向到 stdout，默认 false
    stdout_logfile = /var/local/log/supervisor/idea.log
    
# nginx 配置    
    
    server
    {
      listen 80;
      server_name idea.project.kelu.org;
      root html;
    
       location / {
           proxy_pass http://127.0.0.1:1017;
           proxy_redirect off;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       }
    
       access_log off; #access_log end
       error_log /dev/null; #error_log end
    }
