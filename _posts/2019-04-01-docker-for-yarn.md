---
layout: post
title: yarn 容器化及基本操作
category: tech
tags: frontend docker
---
![](https://cdn.kelu.org/blog/tags/frontend.jpg)

容器化早已深入我服务器的方方面面。最近用到yarn，下面记录下前端框架 yarn 的镜像构建的过程，和一些常用的 yarn 的命令。

# Dockerfile

```dockerfile
FROM node:10

# Debian packages
RUN apt-get -y update && \
  apt-get install -y --no-install-recommends \
    fakeroot \
    lintian \
    rpm \
    ruby \
    ruby-dev \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Ruby packages
RUN gem install fpm

WORKDIR /var/www/html
```

我把它编译成了镜像`kelvinblood/yarn`

# docker-compose

```dockerfile
version:  '3.2'

  yarn:
    image: kelvinblood/yarn
    restart: always
    container_name: yarn
    stdin_open: true
    tty: true
    volumes:
      - ./:/var/www/html:rw
      - /usr/local/share/.cache/yarn:/usr/local/share/.cache/yarn
#    entrypoint:  [ "/bin/bash"]
    entrypoint:
      - npm
      - run
      - watch
      - --
      - --watch-poll
```

中间那个entrypoint是为了测试用的，下面是生产用的。



# 常用操作

```bash
yarn config set registry 'https://registry.npm.taobao.org'
SASS_BINARY_SITE=http://npm.taobao.org/mirrors/node-sass yarn
yarn add china-area-data
yarn add sweetalert
npm run watch-poll
```

