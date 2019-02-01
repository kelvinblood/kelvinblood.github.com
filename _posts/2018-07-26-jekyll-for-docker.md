---
layout: post
title: 使用 docker 部署 jekyll 本地开发环境
category: tech
tags: docker jekyll
---
![](https://cdn.kelu.org/blog/tags/jekyll.jpg)

自从使用上 docker，安装软件环境再也不是一件痛苦的事。以下是我在 Windows 下运行 Jekyll 的 docker-compose.yml 文件：

```
version: '2'
services:
  site:
    network_mode: "host"
    command: jekyll serve
    image: jekyll/jekyll:latest
    volumes:
      - D:\GitHub\kelvinblood.github.com:/srv/jekyll
      - D:\GitHub\kelvinblood.github.com/vendor/bundle:/usr/local/bundle
```

只需要在当前目录下运行

```
docker-compose up -d
```

即可。

![](https://cdn.kelu.org/blog/2018/07/docker-jekyll.jpg)

# 参考资料

* [kelvinblood/**kelvinblood.github.com**](https://github.com/kelvinblood/kelvinblood.github.com)