---
layout: post
title: Nginx 日志按天分割
category: tech
tags: nginx
---
![](https://cdn.kelu.org/blog/tags/nginx.jpg)





```
http {
  log_format default_format '$remote_addr - $remote_user [$time_iso8601] "$request" '
      '$status $body_bytes_sent "$http_referer" '
      '"$http_user_agent" "$http_x_forwarded_for" "$request_body"';
      
      
      server {
          listen 443 ssl;
          ... ...
          if ($time_iso8601 ~ '(\d{4}-\d{2}-\d{2})') {
            set $tttt $1;
          }
          
          access_log /log/blog_access_$tttt.log;
      }
}
```

