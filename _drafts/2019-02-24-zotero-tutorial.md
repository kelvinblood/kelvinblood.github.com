---
layout: post
title: 文献管理然间 Zotero
category: software
tags: 
---
![](https://cdn.kelu.org/blog/tags/literature.jpg)

# 背景

不知道什么缘由下载了这个软件，网上一搜发现确实蛮有用的一个工具，开始使用起来。这篇文章整理了相关的资料，做个简单的介绍。

# 介绍

Zotero 是一个跨平台的开源的参考文献管理软件。然而它的管理能力不仅仅是文献，还包括书籍、专利、百科以及新闻。

参考 GitHub 上它的自我定位——`a free, easy-to-use tool to help you collect, organize, cite, and share your research sources`，也即它包含收集、整理、分享/引用功能。

<https://github.com/zotero/zotero>



![55107403954](C:\Users\kelu\AppData\Local\Temp\1551074039545.png)

![55107408030](C:\Users\kelu\AppData\Local\Temp\1551074080300.png)

![55107412506](C:\Users\kelu\AppData\Local\Temp\1551074125067.png)



![55107424423](C:\Users\kelu\AppData\Local\Temp\1551074244233.png)



# 下载

## 1. 下载软件

访问网址 <https://www.zotero.org/> 你将会看到如下页面，点击下载并完成安装。

![img](https://upload-images.jianshu.io/upload_images/5727621-bfb04bb832023e63.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

Zotero官网，点击大红色按钮下载

## 2. 添加中文文献格式的支持

我相信大部分同学都会在CNKI上查询文献，CNKI上查到的都是中文文献，要让Zotero支持索引中文文献，我们还需要进一步配置一下:

（1）打开zotero，工具>首选项>引用，并切换到样式选项卡。如下图：

![img](https://upload-images.jianshu.io/upload_images/5727621-ada62e18161b6e5c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/616/format/webp)

在这里设置对中文文献的支持

（2）点击获取其他样式，将会打开一个网页，在搜索框中输入：

```
Chinese Std GB/T 7714-2005 (numeric, Chinese)
```

并下载样式文件，如下示意图：

![img](https://upload-images.jianshu.io/upload_images/5727621-b37bae6ee89a1f3d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/877/format/webp)

点击这个链接下载

（3）下载完成之后回到Zotero的设置，点击+号添加这个样式。

![img](https://upload-images.jianshu.io/upload_images/5727621-4864c6141f22f825.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/616/format/webp)

点击+号添加样式

之后点击ok保存即可。至此，Zotero已经可以索引CNKI的文献了

> 注意：为了防止大量下载而导致知网封IP，可以取消勾选自动附加pdf这个选项。点击ok保存。

> 
>
> ![img](https://upload-images.jianshu.io/upload_images/5727621-1dfa76fcf68fc3bf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/616/format/webp)
>
> 取消勾选红圈中的选项

## 2.添加浏览器支持

一般来说，当你安装完成以后，Zotero会自动添加浏览器支持，如果没有也没关系，这里将教大家如何手动添加支持。

##### 目前支持的浏览器：

- Chrome
- Safari
- Firefox

##### 以Chrome为例（事实上，我也非常推荐大家使用Chrome）：

访问 <https://chrome.google.com/webstore/category/extensions?hl=zh-CN> 搜索zotero，第一个即是，直接添加即可。

![img](https://upload-images.jianshu.io/upload_images/5727621-a12668c0576dfab6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

添加第一个插件

# 二、添加你的第一篇文献

## 1. 需找你的文献（以知网为例）

进入知网，搜索你想要的文献，例如我搜索等离子体，随意进入一篇文章。

![img](https://upload-images.jianshu.io/upload_images/5727621-68c6c89e71679132.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

搜索你想要的文章

## 2. 导入到Zotero

点击右上角Zotero图标，即可一键导入这篇文献。

> 注意：当鼠标移到图标上时，应该显示Save to Zotero(CNKI)，如果不是，请检查前面的步骤或者重启一下电脑试试？？

![img](https://upload-images.jianshu.io/upload_images/5727621-6b95cff3efe76afb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

点击右上角的图标导入

## 3. 查看文献

打开Zotero客户端，不出意外的话，该文献已经导入到你的库里面了。如下图所示，右边是这篇文献的详细信息。

![img](https://upload-images.jianshu.io/upload_images/5727621-1f3029adddb37e89.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/931/format/webp)

刚刚导入的文献

# 三、 在论文里插入文献

这里介绍两种插入的方法：

- Word里插入参考文献
- LaTeX里插入参考文献

## 1. 在Word里插入文献

（1）打开Word，切换到Zotero选项卡

![img](https://upload-images.jianshu.io/upload_images/5727621-5850f4dcf5384854.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

切换到Zotero选项卡

（2）将光标放在要插入的地方，点击左上角的Add/Edit图标

![img](https://upload-images.jianshu.io/upload_images/5727621-88cd7d1a6098077d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

点击图标插入参考文献

（3）点击搜索框左边图标切换到经典视图

![img](https://upload-images.jianshu.io/upload_images/5727621-ffe21783670233e0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

切换到经典视图

（4）选中要插入的参考文献，点击OK

![img](https://upload-images.jianshu.io/upload_images/5727621-5e84a2aad0fdcc0b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

插入参考文献

![img](https://upload-images.jianshu.io/upload_images/5727621-e7d109e224b5358f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

插入完成

（5）切换尾注与脚注
首先打开Zotero的文档设置

![img](https://upload-images.jianshu.io/upload_images/5727621-e2f3c035faf4f294.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

打开设置

你将会看到

![img](https://upload-images.jianshu.io/upload_images/5727621-0ae183449be43f23.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

设置

## 2. 在LaTeX里插入文献

（1）导出为BibTex格式的数据库
选中需要导出的文献，鼠标右键打开菜单，点击导出

![img](https://upload-images.jianshu.io/upload_images/5727621-1766e4797042966a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/931/format/webp)

导出条目

在出现的对话框选择BibTex即可

![img](https://upload-images.jianshu.io/upload_images/5727621-565186b276819ac5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/917/format/webp)

选择BibTex

（2）应用数据库
在你的LaTeX文档中声明这个数据库，调用即可。这部分内容是LaTeX知识，这里并不会讲2333333.

# 参考资料

* [参考文献管理——简易Zotero教程](https://www.jianshu.com/p/68f0e4134b04)
* [Zotero（1）：文献管理软件Zotero基础及进阶示范](https://www.yangzhiping.com/tech/zotero1.html)

