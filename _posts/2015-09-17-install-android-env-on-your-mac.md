---
layout: post
title: 在Mac下搭建Android开发环境
category: tech 
tags: mac android ide
---

五年没有碰过Android开发了。最近一个朋友要去澳门赌钱，让我帮开发一个简单的决策大小红黑的APP。感觉蛮简单的，顺手干了起来。不一样的是当时候用的是eclipse，Google于2013 I/O大会针对Android开发推出的新的开发工具Android Studio，从环境配置开始讲起吧。

## 1. 重新安装Java

虽然Mac OSX 10.9以后系统就自带了Java 6的环境，由于下面这个原因，必须再装一遍。

![image](https://cdn.kelu.org/blog/2015/09/blog_20141220102933375.jpg)

安装链接  <https://support.apple.com/kb/DL1572?viewlocale=zh_CN&locale=en_US>

## 2. 下载JDK

下载链接 <http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html>

我下载的是jdk-7u79。目前运行起来也没有问题。



![image](https://cdn.kelu.org/blog/2015/09/blog_AndroidStudio_03.jpg)


## 3. 下载Android studio

下载地址 <http://www.androiddevtools.cn>

安装好以后第一次的话会进入到设置向导页，直接选择“Standard”, 点击“Finish”按钮。然后会自动下载依赖组件，如下图。

![image](https://cdn.kelu.org/blog/2015/09/blog_studio_wizard4.jpg.jpeg)

这个过程需要翻墙，而且依赖你的网速，时间有点久，大家耐心等待…

运行时Android studio可能会提示找不到jdk，让你重新定位你的jdk。这时你可以使用`java -version`查看你的Java版本，然后在弹出的框中选择你的jdk位置。这样Android环境基本上就安装好了。

![image](https://cdn.kelu.org/blog/2015/09/blog_1.pic_hd.jpg)

### 参考资料

[Android Studio系列教程一--下载与安装](http://stormzhang.com/devtools/2014/11/25/android-studio-tutorial1/)

[Android Studio 入门 Hello World](http://segmentfault.com/a/1190000002924501)

