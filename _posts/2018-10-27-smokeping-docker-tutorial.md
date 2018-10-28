---
layout: post
title: smokeping 初使用
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

# 背景

闲着无事，看到这个古老的Smokeping，尝试用来监控服务器的网络情况。当然，我使用的方案优先是容器化方案。

相关网站链接如下：

* [Smokeping 官方网站](https://oss.oetiker.ch/smokeping/doc/index.en.html)
* [Smokeping Github](https://github.com/oetiker/SmokePing)
* [第三方容器化 dperson/smokeping Github](https://github.com/dperson/smokeping)

运行后监控的界面如下：

![image-20181028104858605](https://cdn.kelu.org/blog/2018/10/image-20181028104858605.jpg)

![image-20181028104933050](https://cdn.kelu.org/blog/2018/10/image-20181028104933050.jpg)

# 什么是 Smokeping

Smokeping是一个开源免费的网络性能监控工具，广泛应用于机房网络质量分析，包括常规的 ping，dig，echoping，curl等，SmokePing的优点在于采用rrdtool画图，监控图像实时更新。

# 使用

### 快速开始

想快速尝鲜的用户可以直接用 docker 启动：

```
$ docker run -it --name smokeping -p 8080:80 -e TZ=Asia/Shanghai -d dperson/smokeping
```

在本机的8080端口访问即可。需要等待几分钟后才能显示图形。添加监控目标可以使用如下命令添加，以添加谷歌 DNS 为例：

```
$ docker exec -it smokeping smokeping.sh -t "Google;DNS1;8.8.8.8"
Service already running, please restart container to apply changes

$ docker restart smokeping
smokeping
```

即在 Google 目录下的 DNS1中显示图像。



### 使用 docker-compose 启动

如下图，内容是我随便填写的，启动后则得到文章开头的实例界面。

```
$ docker-compose up -d
```

![image-20181028105953676](https://cdn.kelu.org/blog/2018/10/image-20181028105953676.jpg)

# 优化

目前是试用了一下。还有很多可以优化的地方，例如中文界面和多节点监控等。我今后也会尝试。

# 参考资料

* [IDC网络质量分析工具之（二）如何解决smokeping中文乱码问题](https://boke.wsfnk.com/archives/271.html)
* [Docker で Smokeping を起動する](http://sig9.hatenablog.com/entry/2016/06/17/003923)
* [网络监控工具:SmokePing Nginx一键安装/管理脚本和Looking Glass中文汉化](https://wzfou.com/smokeping-looking-glass/)

