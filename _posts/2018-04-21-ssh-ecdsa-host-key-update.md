---
layout: post
title: 删除 ssh known_hosts 中特定的主机
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

重装了系统，登陆的时候提示无法登陆。

![](https://cdn.kelu.org/blog/2018/04/20180514160631.jpg)

以前的做法，都是直接把 known_hosts 删除了事。由于现在记录的太多了，删除掉会又问题。随意添加了几个反斜杠，就成功了：

```
ssh-keygen -f "/root/.ssh/known_hosts" -R \[103.71.xxx.xxx\]\:xxx
```

显示删除成功

```
Host [103.71.xxx.xxx]:xxx found: line 4 type ECDSA 
/root/.ssh/known_hosts updated. 
Original contents retained as /root/.ssh/known_hosts.old
```