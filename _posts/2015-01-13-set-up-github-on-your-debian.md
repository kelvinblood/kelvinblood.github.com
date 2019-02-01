---
layout: post
title: 在你的Debian上连接到Github
category: tech
tags: linux github
---
![](https://cdn.kelu.org/blog/tags/github.jpg)

整个过程都是参考的[github的官方文档](https://help.github.com/articles/set-up-git/#platform-linux)。在这稍微做一个记录。

    $ apt-get install git
    $ git config --global user.name "YOUR NAME"
    $ git config --global user.email "YOUR EMAIL ADDRESS"
    $ ssh-keygen -t rsa -C "YOUR EMAIL ADDRESS"

将你的公钥添加到github上。

    $ ssh-agent bash
    $ ssh-agent -s
    $ ssh-add ~/.ssh/id_rsa
    $ ssh -T git@github.com



出现以下这行就说明连接上了。

    Hi username! You've successfully authenticated, but GitHub does not # provide shell access.

把自己的项目下载到本地，就可以任意编辑了。

    $ git clone git@github.com:YOUR NAME/PROJECT.github.com.git

安装完成。
