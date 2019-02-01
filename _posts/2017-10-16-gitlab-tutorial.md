---
layout: post
title: gitlab 入门
category: tech
tags: git gitlab docker
---
![](https://cdn.kelu.org/blog/tags/gitlab.jpg)

# 介绍

[GitLab](https://about.gitlab.com/) 是一个使用`Ruby on Rails`开发的开源应用程序，实现一个自托管的Git项目仓库，使用PostgreSQL或MySQL数据库，Redis做缓存。一般自己搭建私有代码仓库，Gitlab通常是首选。

提供了：

1.  代码托管服务
2.  访问权限控制
3.  问题跟踪，bug的记录、跟踪和讨论
4.  Wiki，项目中一些相关的说明和文档
5.  代码审查，可以查看、评论代码

它拥有与Github类似的功能，能够浏览源代码，管理缺陷和注释。可以管理团队对仓库的访问，它非常易于浏览提交过的版本并提供一个文件历史库。团队成员可以利用内置的简单聊天程序(Wall)进行交流。它还提供一个代码片段收集功能可以轻松实现代码复用，便于日后有需要的时候进行查找。

开源中国代码托管平台`git.oschina.net`就是基于GitLab项目搭建。

下面是我在安装时的一些过程输出文档。

* [安装](/tech/2017/10/17/gitlab-tutorial-1.html)
* [文档目录](/tech/2017/10/17/gitlab-tutorial-2.html)
* [gitlab与postgresl redis](/tech/2017/10/17/gitlab-tutorial-3.html)
* [docker build 创建自己的镜像](/tech/2017/10/17/gitlab-tutorial-4.html)

# 参考资料

* [gitlab 官方文档](https://docs.gitlab.com/)
* <https://docs.gitlab.com/ce/README.html>