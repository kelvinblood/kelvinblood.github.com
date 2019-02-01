---
layout: post
title: 在vim中将DOS行尾转换成Linux格式的
category: tech
tags: linux vim
---
![](https://cdn.kelu.org/blog/2017/12/linux1.jpg)

使用 `:set ff` 可以看到当前行尾使用的换行方式。

使用 `:set ff=unix` 即可修改为lf换行方式。