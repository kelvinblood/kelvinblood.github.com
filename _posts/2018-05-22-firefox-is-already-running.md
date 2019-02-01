---
layout: post
title: 解决 Firefox is already running, but is not responding 错误
category: tech
tags: chrome
---
![](https://cdn.kelu.org/blog/tags/firefox.jpg)

远程vnc的时候，发现firefox没办法启动，报了这个错误：

> Firefox is already running, but is not responding. To open a new window, you must first close the existing Firefox process, or restart your system.

即使将 Firefox 的进程全部杀死，仍然会报这个错误。

解决方法如下：

在linux的终端输入：

```
firefox -profilemanager 

# 或者
firefox -p
```

在出现的页面中将当前出错的 Profile 删除掉，然后新建个即可。

