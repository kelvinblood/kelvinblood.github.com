---
layout: post
title: sudo 出现unable to resolve host 
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

每次执行sudo 就出现这个警告讯息:

```
sudo: unable to resolve host xxx
```

虽然有提示，其实并不影响执行。最近在运行某个脚本也出现了这个提示。这就不得了了。

解决办法也简单，在`/etc/hosts`中设定xxx(hostname) 指向 127.0.0.1 的 IP 即可：

```
127.0.0.1       localhost xxx  #要保证这个名字与 /etc/hostname中的主机名一致

# 或改成下面这两行
127.0.0.1       localhost
127.0.0.1       xxx
```

