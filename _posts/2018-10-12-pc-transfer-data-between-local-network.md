---
layout: post
title: Windows 局域网互传 - 知乎
category: software
tags: mac
---

![](https://cdn.kelu.org/blog/tags/windows.jpg)

> 来自[Pjer](https://www.zhihu.com/people/pjer) 的答案。最近在局域网交换文件用到的。

最方便快捷的同时快速的方案应该是【windows 局域网共享】

![img](https://cdn.kelu.org/blog/2018/10/v2-c9a980c26b2d3481dcdbaa6e9aa145f1_hd.jpg)

我之前也是苦于寻找一种PC之间大文件快速交换的解决方案，因为实验室的笔记本和主机都是有生产力电脑，所以需要经常传文件，而且经常很大，移动硬盘拷贝写入大概80M/s读取稍快一些综合起来USB3.0不计插拔时间平均大概是45M/s其实已经很棒了，但是移动硬盘是用来备份的经常高强度读写很容易GG

如果恰好有个像样点的路由器【某宝上随便找个“千兆”路由器都成】两台电脑都在插路由器上，似乎在平常的办公环境下这个条件很好满足），然后都打开局域网共享

具体路径是：
Control Panel>Network and Internet>Network and Sharing Center>Advanced sharing settings

![img](https://cdn.kelu.org/blog/2018/10/v2-f623cd96efce89eb4fde9a24dec04bd6_hd.jpg)

像这样

然后在文件管理器侧边栏里：

![img](https://cdn.kelu.org/blog/2018/10/v2-fc87cbd25b16a7a86294ea95f4ee7365_hd.jpg)

的NetWork目录下可以相互找到，如果觉得不安全的话设个授权就成。然后可以像访问本底目录一样访问另一台电脑目录，而且文件是可以打开的，电影可以播放，文档可以编辑，贼方便。

![img](https://cdn.kelu.org/blog/2018/10/v2-de2f2dd9428b6a6f579b516e7f1b4d6a_hd.jpg)

传送大文件的话速度取决于路由器带宽决定，因为是内网直传，硬盘允许的情况下可以打满带宽，比如说：

![img](https://cdn.kelu.org/blog/2018/10/v2-089b9dc56192ae7ea1188c42b2c6897a_hd.jpg)

1000M带宽的理论数据吞吐上限是125MB/s这个可以有112MB/s的话肯定是比移动硬盘插拔插拔要舒服的多

更稳的解决方案是家庭组：

![img](https://cdn.kelu.org/blog/2018/10/v2-39e74f3b848f2a5d5dfa1c30b3eae1f6_hd.jpg)

原理和上面的局域网共享类似，但是提供更封闭快速的环境

如果恰好身边有交换机的话就更爽了，不过硬盘有可能撑不住

# 参考资料

* [如何让两台PC进行文件传输？两台Windows7 家庭普通版的笔记本（不支持家庭组的连接），想进行上百G(图片）的文件传输，请问IT高手们有什么办法？](https://www.zhihu.com/question/20293143)