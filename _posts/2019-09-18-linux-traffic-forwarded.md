---
layout: post
title: 简易 tcp 流量转发
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

tcp 流量转发有很多方式可以达成，比如系统默认iptables就可以做到，又比如可以用haproxy完成。这篇文章记录的都不是这两个。

这里我介绍一个简单的200行左右的c代码，完成的端口转发这样的功能。

GitHub地址：<https://github.com/bovine/datapipe>



1. 下载c文件：

   ```
   wget https://raw.githubusercontent.com/bovine/datapipe/master/datapipe.c
   ```

   

2. 编译：

   前提是已经安装了gcc编译工具。

   ```
   gcc datapipe.c -o dp
   ```

   

3. 赋予可执行权限：

   ```
   chmod +x dp
   ```

   

4. 运行示例：

   ```
   ./dp 0.0.0.0 40022 47.96.79.77 40022
   ```

   在这里吧40022的所有端口流量转到 47.96.79.77:40022