---
layout: post
title: windows 下查看端口占用、查看pid进程与结束进程
category: tech
tags: windows linux docker
---
![](https://cdn.kelu.org/blog/tags/windows.jpg)

一直以来都是在Linux下运行项目。自从微软支持docker后，本机也能运行docker程序了，开始对 Windows 的命令行 powershell 也有了点需求。这一篇记录Linux下四个常用的运维命令。

* netstat
* grep
* ps aux
* kill -9

1. 查看所有的端口占用情况

   ```
   netstat -ano
   ```

2. 查看指定端口的占用情况

   ```
   netstat -aon | findstr "9050"
   ```

3. 查看PID对应的进程

   ```
   tasklist|findstr "2016"
   ```

4. 结束进程

   ```
   taskkill /f /t /im tor.exe
   ```