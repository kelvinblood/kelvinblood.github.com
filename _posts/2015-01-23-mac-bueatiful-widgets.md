---
layout: post
title: uebersicht - 一款漂亮的桌面Widgets
category: software
tags: mac
---
Übersicht 是Mac下一款可以用来自定义桌面插件的工具。我们可以根据自己的喜好定制不同的Widgets。和Windows下的Rainmeter类似。把玩了一下感觉棒棒的。

效果还真挺炫的。目前在想着可以给自己的服务器加一些状态接口，通过uebesicht方便简单又干脆就可以拿到服务器的实时数据，实在是居家旅行必备。

![uebersicht](https://cdn.kelu.org/blog/2015/01/desktopScreenShot.jpg)

详细的介绍在[少数派](http://sspai.com/28020)上有介绍，下面是转载文。


在相关的同类应用中，听说得比较多的当属 [GeekTool](http://projects.tynsoe.org/en/geektool/) 和人称「通知中心 GeekTool」的 [Today Scripts](https://sspai.com/27662) 无疑，它们和 Übersicht 的运行原理基本相同，但后者的不同在于，它还支持 [HTML5](http://zh.wikipedia.org/zh/HTML5) 和特殊的 [CoffeeScript](https://github.com/felixhageloh/uebersicht#readme) 语法，所以 它的优势就很明显了：

*   相对轻松的编写和自定义过程。
*   多元化的显示风格。
*   主动适配不同屏幕尺寸的能力。

## 安装插件

Übersicht Widgets 的安装方法很简单，先在官网 [下载安装 Übersicht](http://tracesof.net/uebersicht/) ，然后前往 [官方 Widget 商店](http://tracesof.net/uebersicht-widgets/) 寻找自己想要的插件，点击 Banner 封面图可以读取相关开发者的介绍，或直接通过右下方 download 进行下载。接着，将解压缩后得到的 .coffee 文件置入 Übersicht Widgets 的文件夹即可（偏好设置中可以进行自定义）。稍等片刻，桌面插件就会被主程序自动读取，安装完成。

![](https://cdn.kelu.org/blog/2015/01/216496.jpg)

不过，有些插件的安装方法比较复杂，比如 [Pretty Weather](https://github.com/felixhageloh/uebersicht-widgets/tree/master/pretty-weather) 这款。除了上述步骤，它还要求用户获取「天气数据」所需的个人 API Key，读者可以 [点击](https://developer.forecast.io/) 前往注册。接着，需要将 API Key 覆盖至源代码中的相关地址，方可正常显示天气数据。还有最后一步，就是获取你当前的位置信息，有条件的读者可以通过 [Google Maps](https://www.google.com/maps) 获取。

![](https://cdn.kelu.org/blog/2015/01/216497.jpg)

## 自定义插件

由于 Übersicht 的发布处于 OS X 10.9 与 OS X 10.10 的跨越阶段，所以部分插件可能存在兼容性方面的问题。这是个尴尬的局面，好在开发商对此特意加入了「Inspect Element」调试工具，以便使用者清楚地了解当前运行状态中可能存在的问题。可是...

![](https://cdn.kelu.org/blog/2015/01/216498.jpg)

掌握浅层系统知识的人都知道，像这类调整当前状态的「调试」工具，大多都是针对「内存数据」的，即修改的结果只能临时起效，而一旦发生缓存被清除或插件重启的行为，刚才的方案将全部失效，取而代之，插件会重新从源代码中读取数据，生成最原始的效果。我想说的是，当用户需要调整插件位置（或外观）这些基本参数时，若想保证状态的持久性，就一定要从源代码中下手。这里笔者推荐一款强大的代码编辑应用 [Sublime Text](http://www.sublimetext.com/) 系列（免费版即可）。

![](https://cdn.kelu.org/blog/2015/01/216499.jpg)

以插件 [Simple-Clock](https://github.com/soberstadt/simple-clock-widget) 为例。第一步，先将 .coffee 文件以 Sublime Text 方式打开，完成后就能看到插件的源代码（见上图）。第二步，在第 48 行找到 style 关键词，也就是「外观」和「位置」的参数地址。第三步，修改数据并使用 CMD-S 进行保存以刷新插件状态，完成修改步骤。

*   fontSize：文字大小
*   width：插件占用的单位宽度（百分比）
*   transform：自比例调整能力（自动）
*   bottom：距离屏幕下方边缘的单位长度（百分比）
*   right：距离屏幕右侧边缘的单位长度（百分比）

还可以通过修改 background color 参数调整插件的背景色、修改 font-family 参数调整显示字体或修改 text-align 参数调整文字相对背景框的显示位置：center 置中、left 置左、right 置右等。插件（位置及外观）参数的单位可能是百分比，也可能是像素（px），但笔者个人不建议没有相关基础的读者修改其默认单位，因为通常情况下会使 Widgets 出现「报错」现象，那就得不偿失了。

![](https://cdn.kelu.org/blog/2015/01/216500.jpg)

* * *

其实最先 Übersicht 只是由独立开发者 [@Felix](https://github.com/felixhageloh) 托管在 Github 上的项目，因获得大量用户好评（其中包括 [Brett](http://brettterpstra.com/contact/)）从而得以正身。所以，为保证用户能及时获取最新资讯和问题反馈，建议大家前往 [官方 Github 页面](https://github.com/felixhageloh/uebersicht/issues?page=1) 或 [官方网站](http://tracesof.net/) 了解详情。


