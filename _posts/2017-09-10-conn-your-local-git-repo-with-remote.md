---
layout: post
title: 将本地Git仓库与远程仓库进行关联
category: tech
tags:  git
style: summer
---
![](https://cdn.kelu.org/blog/tags/git.jpg)

平时有在本地随手建立代码库当 hello world，开发到一半发现好像还不错，就想直接 push 到远端进行关联。

这一篇介绍如何进行这样的操作。

# 本地初始化仓库

	git init

然后就正常对仓库进行编辑提交。

# 远端新建项目

这个就各显神通了，可以用 github oschina 或者 gitlab 之类的。然后拿到 git 的 ssh 地址，类似这种：

	git@github.com:kelvinblood/KeluLinuxKit.git

# 关联

将本地的仓库和远程的仓库进行关联，例如

```
git remote add origin git@github.com:kelvinblood/KeluLinuxKit.git
```
至此，就将本地与远端的代码仓库关联了起来。

