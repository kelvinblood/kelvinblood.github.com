---
layout: post
title:  Let's Encrypt
category: tech
tags:  linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

# 简介

Let's Encrypt是国外一个公共的免费SSL项目，由 Linux 基金会托管，它的来头不小，由Mozilla、思科、Akamai、IdenTrust和EFF等组织发起，目的就是向网站自动签发和管理免费证书，以便加速互联网由HTTP过渡到HTTPS，目前Facebook等大公司开始加入赞助行列。

Let's Encrypt已经得了 IdenTrust 的交叉签名，这意味着其证书现在已经可以被Mozilla、Google、Microsoft和Apple等主流的浏览器所信任，你只需要在Web 服务器证书链中配置交叉签名，浏览器客户端会自动处理好其它的一切，Let's Encrypt安装简单，未来大规模采用可能性非常大。

Let's Encrypt 每次只有 90 天的有效期，可以通过脚本定期更新，配好之后一劳永逸。

# 生成证书

```
git clone https://github.com/letsencrypt/letsencrypt
cd letsencrypt
./letsencrypt-auto
```

运行后得到这样的提示：

![](https://cdn.kelu.org/blog/2017/07/2017-07-18-1.26.00.jpg)

提示无法自动配置 apache，因为我根本就没装2333333 不用在意，按照它的提示运行命令

	./letsencrypt-auto certonly

按照提示输入一些基本信息，就生成 ssl 文件啦！

![](https://cdn.kelu.org/blog/2017/07/2017-07-18-1.45.28.jpg)

可以看到生成的文件在：`/etc/letsencrypt/live/` 这样的文件夹下。fullchain.pem就是公钥，privkey.pem就是私钥。有了这两个文件我们就可以在Ngnix上配置SSL证书了。

# 配置Nginx

在 server 模块加上下面内容

    listen 443;
    ...
    
    ssl on;
    ssl_certificate /etc/letsencrypt/live/xxx/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/xxx/privkey.pem;
    ssl_session_timeout 5m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers AESGCM:ALL:!DH:!EXPORT:!RC4:+HIGH:!MEDIUM:!LOW:!aNULL:!eNULL;
    ssl_prefer_server_ciphers on;

重新加载配置即可。

# 参考资料

* [免费SSL证书Let’s Encrypt安装使用教程:Apache和Nginx配置SSL](https://www.freehao123.com/lets-encrypt/)

* [Let's Encrypt，免费好用的 HTTPS 证书](https://imququ.com/post/letsencrypt-certificate.html)

