---
layout: post
title:  Windows下的whois程序，SysInternals工具集
category: software
tags: windows sysInternals
---
![](https://cdn.kelu.org/blog/tags/windows.jpg)

# whois

心血来潮查了一下。微软的官网有提供whois的程序。

<https://docs.microsoft.com/en-us/sysinternals/downloads/whois>

可以查看官网的介绍：

![](https://cdn.kelu.org/blog/2018/02/win_20180207092522.jpg)

下载解压后放到 `C:\Windows\System32` 即可使用。

比如查一下哔哩哔哩：

![](https://cdn.kelu.org/blog/2018/02/win_20180207092812.jpg)

![](https://cdn.kelu.org/blog/2018/02/win_20180207092832.jpg)

# 关于SysInternals


以下内容转自<https://www.sysgeek.cn/what-is-sysinternals-tools/>

SysInternals 工具集最早由大牛 Mark Russinovich 开发，它是一套完全免费的 Windows 工具套件，其官方网站为 [www.SysInternals.com](http://www.sysinternals.com/) 。由于已经于 2006 年被微软收购，Mark 也已经出任 Aazure CTO，访问网址时会直接跳转到 Technet 的 SysInternals 主页。

说到 SysInternals 工具集，在 ITPro 当中应该说是无人不知，该工具集在平常的维护和排错工作中经常都会用到，微软的 Troubleshooting 团队也会经常使用该工具集中的工具。正是由于其强大的功能和便利性，被微软收购也不足为奇了。SysInternals 工具集的工具有很多，大概涵盖了如下的几个类型：

*   文件和磁盘工具
*   网络工具
*   进程工具
*   安全工具
*   系统信息工具
*   其它类型工具

不知道大家是否记得有一次差点让索尼身败名裂的事件：Sony 试图将 rootkit 嵌入其音乐 CD，最早检测到该问题的就是 Sysinternals 工具。该次事件之后 Sysinternals 工具便名声大振，随后便被微软收购。

Sysinternals 套件可以免费从微软 Technet 网站下载，而且都是绿色版无需安装，大家可以放到 U 盘中随身携带，非常方便。

该工具包中大名鼎鼎的 Process Explorer 可以说是 Windows 任务管理器的超级增强版，而 Process Monitor 则可以全方位监控 Windows 中进程对文件系统、注册表、网络的操作活动，Autoruns 是专门对系统的启动项目进行查看和管理的工具，TCPView 则可以查看当前系统中的连网状态等信息，总结起来就是 — 非常牛掰。

![](https://cdn.kelu.org/blog/2018/02/what-is-sysinternals-tools-2.jpg)

> **注意：**由于工作得很底层，基本上执行 SysInternals 的所有工具都会需要管理员权限。

举例：你的浏览器运行缓慢或假死，我们便可以在 Process Explorer 中双击其进程，浏览到 Threads(线程)选项卡，便可以看到其在后台调用了哪些 DLL 和系统模块，也便可以帮助分析出假死的原因。

![](https://cdn.kelu.org/blog/2018/02/what-is-sysinternals-tools-3.jpg)

## 如何获取SysInternals工具集

1\. 最简单的办法就是直接去官网进行单个下载或直接下载 SysInternals 套件。

[Windows Sysinternals](https://technet.microsoft.com/en-us/sysinternals/bb842062)

2\. 另一种方式是直接使用SysInternals Live来执行

在运行中直接执行** \\live.sysinternals.com\** 便可以打开 SysInternals 工具集发布在公网上的 [UNC 路径](http://baike.baidu.com/view/4397108.htm)

![](https://cdn.kelu.org/blog/2018/02/what-is-sysinternals-tools-4.jpg)

所有工具的最新版本都存储到 **Tools **文件夹当中

![](https://cdn.kelu.org/blog/2018/02/what-is-sysinternals-tools-5.jpg)
