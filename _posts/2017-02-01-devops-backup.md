---
layout: post
title: 一些运维技巧的备忘
category: tech
tags: devops
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

# 计划任务cron

计划任务不必要在直接写在底层的 crontab 中，可以在 crontab 中这么设置

![](https://cdn.kelu.org/blog/2017/02/crontab.jpg)

将运行脚本文件保存到 /var/local/cron 目录中，区分好时间和用户进行管理。

# ssh相关

ssh除了登录端口修改外，在当前用户的家目录下 ~/.ssh 添加 config 文件，用于快速登录其他服务器或 scp 进行文件传输。

    Host    tokyo
      HostName        xx.xx.xx.xx
      Port            1234
      User            kelu
      IdentityFile    ~/.ssh/xxx
    Host    fremont
      HostName        xx.xx.xx.xx
      Port            1234
      User            madcat
      IdentityFile    ~/.ssh/xxx
      
除此之外，还可以修改 /etc/hosts，用于快速ping某某网站等等。
      
      127.0.0.1       localhost
      xx.xx.xx.xx   tokyo
      xx.xx.xx.xx   aliyun

