---
layout: post
title:  nginx 设置目录访问权限
category: tech
tags: nginx
---
![](https://cdn.kelu.org/blog/tags/nginx.jpg)

### 1.创建htpasswd文件：

可以使用以下这个python脚本生成认证文件：[htpasswd.py](https://gist.githubusercontent.com/kelvinblood/efd9d19cc981f71b3f94ee0e04f2ea96/raw/b84137bc2024d30d4ab57a778b5938e9eeef0632/htpasswd.py)

执行命令：

    chmod 777 htpasswd.py
    ./htpasswd.py -c -b filename username password

或安装htpasswd：

```
apt-get install apache2-utils
htpasswd -c filename username
```

### 2.修改nginx的conf

    server {
        listen       80;
        
        ***
        ***
        
        auth_basic "Password";
        auth_basic_user_file /var/local/nginx/conf/xxx;
    
        *** 
        *** 
        }
    }


### 参考资料

* [为Nginx目录设置访问密码](http://yynotes.net/nginx-basic-auth/)