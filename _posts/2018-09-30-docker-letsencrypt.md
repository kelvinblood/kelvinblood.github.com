---
layout: post
title: 为网站启用https，使用容器化的 Let's Encrypt
category: tech
tags: docker https
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

# 背景

去年有记录过一篇 Let's Encrypt ，不过是基于源码的。最近在为服务器做迁移，将运维组件也容器化。这篇文章记录我使用 容器化 Let's Encrypt 的过程。更详细的操作步骤可以参考我以前的文章——[《Let's Encrypt》](/tech/2017/07/10/lets-encrypt.html)。

# 什么是 Let's Encrypt

Let’s Encrypt是国外一个公共的免费SSL项目，由 Linux 基金会托管，它的来头不小，由Mozilla、思科、Akamai、IdenTrust和EFF等组织发起，目的就是向网站自动签发和管理免费证书，以便加速互联网由HTTP过渡到HTTPS，目前Facebook等大公司开始加入赞助行列。

Let’s Encrypt已经得了 IdenTrust 的交叉签名，这意味着其证书现在已经可以被Mozilla、Google、Microsoft和Apple等主流的浏览器所信任，你只需要在Web 服务器证书链中配置交叉签名，浏览器客户端会自动处理好其它的一切，Let’s Encrypt安装简单，未来大规模采用可能性非常大。

# 方案

Let's Encrypt 分为 [Standanlone](https://certbot.eff.org/docs/using.html#standalone) 和 [Webroot](https://certbot.eff.org/docs/using.html#webroot) 两种认证方式，主要区别在于：

1. **Standalone 的认证方式需要暂时占用服务器的 80 或者 443 端口**，来进行获取和更新证书的操作。这意味着网站必须下线才行。
2. Webroot 认证方式需要在域名配置文件里 `server.conf` （监听 80 端口那部分）中，添加一个通配规则，使得 `certbot` 可以生成一个特定的验证文件，同时让之后 Let’s Encrypt 的验证服务器发起的 [http-01](https://tools.ietf.org/html/draft-ietf-acme-acme-03#section-7.2) 请求可以验证到对应文件。

就目前来说我属于比较懒的一类人，目前暂时忍受住了临时下线的问题（网站下线10s左右），standalone较为简单，遂使用了 standalone 的方式。

例如首次认证test.kelu.org这个域名：

```
docker run -it --rm --name certbot \
  -p 80:80 \
  -v "$(pwd)/data:/etc/letsencrypt" \
  -v "$(pwd)/datalib:/var/lib/letsencrypt" \
  certbot/certbot certonly \
  --standalone \
  --email admin@kelu.org --agree-tos \
  -d test.kelu.org
```

便在当前目录下的data文件夹里生成好了证书。

证书有三个月的有效期，此时运行renew命令即可续约：

```
docker run -it --rm --name certbot \
  -p 80:80 \
  -v "$(pwd)/data:/etc/letsencrypt" \
  -v "$(pwd)/datalib:/var/lib/letsencrypt" \
  certbot/certbot renew
```

# nginx相关配置

因为一切都是容器化，nginx的配置也固化在文件中，下面是我的docker-compose.yml配置参考：

```
  nginx:
    image: openresty/openresty:alpine
    restart: always
    volumes:
      - ./:/var/www/html:rw
      - ./docker/letsencrypt/data:/etc/letsencrypt:rw
      - ./docker/openresty/conf.d:/etc/nginx/conf.d:rw
      - ./docker/openresty/conf/nginx.conf:/usr/local/openresty/nginx/conf/nginx.conf:rw
      - ./docker/log:/log:rw
    links:
      - "php"
    ports:
      - "80:80"
      - "443:443"
```

nginx 的配置如下：

```
server {
    listen       443;
    server_name  test.kelu.org;

    access_log /log/yukari.nginx.maintain.access.log;
    error_log  /log/yukari.nginx.maintain.error.log;

    ssl on;
    ssl_certificate /etc/letsencrypt/live/test.kelu.org/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/test.kelu.org/privkey.pem;
    ssl_session_timeout 5m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers AESGCM:ALL:!DH:!EXPORT:!RC4:+HIGH:!MEDIUM:!LOW:!aNULL:!eNULL;
    ssl_prefer_server_ciphers on;

    root         /var/www/html/;

    error_page 404 500 502 503 504 /index.html;
}

```

# 改进

本文是一个简单初级的生成证书的方式，可快速部署。

目前有几个待改进的点：

1. 生成证书需要占用80、443端口，意味着当前业务必须停止。
2. 证书 renew 也需要停止当前业务。
3. 目前有以dns认证的方式获取证书，更加方便。



# 参考资料

* [**certbot** - github](https://github.com/certbot/certbot)
* [certbot.eff.org/docs](https://certbot.eff.org/docs/)
* [LET’S ENCRYPT WITH DOCKER](https://devsidestory.com/lets-encrypt-with-docker/)
* [Enabling HTTPS with Let's Encrypt on Docker](https://medium.com/bros/enabling-https-with-lets-encrypt-over-docker-9cad06bdb82b)
* [Let's Encrypt](/tech/2017/07/10/lets-encrypt.html)
* [无80端口情况下使用 CertBot 申请SSL证书 并实现自动续期](https://blog.csdn.net/conghua19/article/details/81433716)