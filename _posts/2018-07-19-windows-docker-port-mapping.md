---
layout: post
title: windows 下docker容器的端口转换问题
category: tech
tags: windows docker
---
![](https://cdn.kelu.org/blog/tags/windows.jpg)

事实上我目前还是没有解决这个问题，参考了GitHub的这个issue [Docker for windows is not mapping ports to localhost](https://github.com/docker/for-win/issues/204#issuecomment-352193804) 中352193804楼的做法，直接使用了容器的ip + port的方式，绕过了遇到的问题。

有搜索过网上相关的问题——[《解决Windows下无法对docker容器进行端口映射的问题》](https://blog.csdn.net/qq_33212500/article/details/79412930) ，然而我在运行这项命令 `docker-machine ip default` 时，并没有显示预期内容，这个命令应当是老的 Windows docker 工具创建虚拟机时使用的。

另，win下的 docker 其实有两种模式，一种是早期的，在本地起虚拟机(Virtualbox)，虚拟机中运行docker这种方式——Docker Toolbox。 另外一种则是新的 Docker for Windows。

Docker for Windows 依赖于 Hyper-V，需要在 控制面板->程序与功能->windows功能 中打开。



# 参考资料

* [Docker - Docker for Windows 10 入門篇](https://skychang.github.io/2017/01/06/Docker-Docker_for_Windows_10_First/)
* [Windows 上的 Docker 引擎](https://docs.microsoft.com/zh-cn/virtualization/windowscontainers/manage-docker/configure-docker-daemon)
* [Cannot start docker after installation on Windows](https://stackoverflow.com/questions/36885985/cannot-start-docker-after-installation-on-windows)