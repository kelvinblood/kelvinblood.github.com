---
layout: post
title: 搭建自己的 git 服务器，创建属于自己的私人仓库
category: tech
tags: git
---
![](https://cdn.kelu.org/blog/tags/git.jpg)

# 背景

以前有装过 gitlab，本来也打算用 gitlab 来搭建自己的 git 服务，奈何gitlab 吃内存是众所周知的。

而我实际上也并不需要那么多的功能，个人使用，只要有简单的命令行界面即可。遂而使用了原始的 git server。当然对我来说也是容器化过后的，于是这一篇就是记录如何使用容器化的git-server。 

当然系统占用也特别小，目前一个项目，只占用了6M内存，实在是非常精炼。

#使用

编辑 `vi docker-compose.yml` 文件

```
version: '3.2'
services:
  app:
    image: kelvinblood/git-server
    volumes:
      - /root/.ssh:/git-server/keys
      - ./:/repos
    ports:
      - '22:22'
    restart: always
```

假设 ssh 的密钥在文件夹内 `/root/.ssh`，

运行 `docker-compose up -d` 运行即可。

### 初始化仓库

假设当前所在的文件夹为git，运行如下命令初始化仓库：

```
docker exec git_app_1 git init --bare test.git
```

此时在当前文件夹下多出了 `test.git` 这个初始化仓库。

###拉取仓库 

按照常用方式使用git，例如：

```
cd /tmp
git clone git@xx.xx.xx.xx:/repos/test.git
cd test
touch readme.md
git add .
git commit -m "[init]"
git push
```

如果你使用的不是22端口，假设是2222端口，则clone的命令要稍作改变：

```
git clone ssh://git@xx.xx.xx.xx:2222/repos/test.git
```

完成。

# 更多

本项目已共享至github：[kelvinblood/git-server](https://github.com/kelvinblood/git-server)，以下是 `dockerfile`

```
FROM alpine:3.4

# "--no-cache" is new in Alpine 3.3 and it avoid using
# "--update + rm -rf /var/cache/apk/*" (to remove cache)
RUN apk add --no-cache \
# openssh=7.2_p2-r1 \
  openssh \
# git=2.8.3-r0
  git

# Key generation on the server
RUN ssh-keygen -A

# SSH autorun
# RUN rc-update add sshd

# -D flag avoids password generation
# -s flag changes user's shell
RUN mkdir -p /git-server/keys \
  && adduser -D -s /usr/bin/git-shell git \
  && echo git:12345 | chpasswd \
  && mkdir /home/git/.ssh

# This is a login shell for SSH accounts to provide restricted Git access.
# It permits execution only of server-side Git commands implementing the
# pull/push functionality, plus custom commands present in a subdirectory
# named git-shell-commands in the user鈥檚 home directory.
# More info: https://git-scm.com/docs/git-shell
COPY src/git-shell-commands /home/git/git-shell-commands

# sshd_config file is edited for enable access key and disable access password
COPY src/sshd_config /etc/ssh/sshd_config
COPY src/start.sh /git-server/start.sh

EXPOSE 22

WORKDIR /repos

CMD ["sh", "/git-server/start.sh"]
```

dockerfile参考了 [jkarlosb/**git-server-docker**](https://github.com/jkarlosb/git-server-docker)，做了极小的改动.