---
layout: post
title:  chrome 检查更新时出错：无法启动更新检查
category: software
tags: windows chrome
---
![](https://cdn.kelu.org/blog/tags/chrome.jpg)

网络都通的，奇怪为什么不能升级。而且很神奇的一点是，无论下载谷歌官方的在线安装包还是离线安装包，都没有办法解决这个问题。

![](https://cdn.kelu.org/blog/2018/02/chrome_20180202134541.jpg)

最后通过下面这个方式解决了：

1. chrome官方清理工具 <https://www.google.com.tw/chrome/cleanup-tool/>

1. 删除目录 `C:\Users\使用者帐户\AppData\Local\Google\Chrome`

1. 重新安装。