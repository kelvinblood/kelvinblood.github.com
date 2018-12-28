---
layout: post
title: kubernetes 批量删除 helm chart 应用
category: tech
tags: docker kubernetes
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

在开发环境常常批量安装 helm chart 应用，如果普通删除，会留下很多应用的信息，而且无法安装同名应用。

使用下面简单的命令，快速删除状态为 DELETED 的chart应用。

```
helm list -a | grep DELETED | awk '{print $1}' |  xargs helm del --purge
```

