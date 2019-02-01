---
layout: post
title: Selenium 介绍
category: tech
tags: selenium test webdriver
---
![](https://cdn.kelu.org/blog/tags/selenium.jpg)

之前写了一篇很初级的[《selenium入门》](/tech/2017/02/16/selenium-tutorial.html)，仅仅算是 Selenium 2 的 hello world。现在的这篇，主要是记录我对 Selenium 2（又名 WebDriver） 的一些认识。

#  前言

Selenium 是 ThroughtWorks 公司开发的针对Web应用的开源测试框架，支持多种浏览器和多种编程语言。Selenium 2 集成了 WebDriver(曾经是 Selenium 1的竞争对手)。

Selenium 和 WebDriver 开发人员都认为两个工具各有优势，二者合并将创造更强大的web测试框架。于是它们就合并了。真是一阵祥和。 

更多 Selenium 和 WebDriver 的历史，可以查看官方blog：[Selenium项目简史](http://seleniumhq.org/docs/01_introducing_selenium.html#brief-history-of-the-selenium-project)。

# Selenium 1 和 Selenium 2 的区别

习惯上 Selenium1.x 时通常指的是 Selenium RC, WebDirver 指的是 Selenium 2,反过来也是。  

Selenium RC在浏览器中运行JavaScript应用，而WebDriver通过原生浏览器支持或者浏览器扩展直接控制浏览器。

Selenium 2包括Selenium Server，通过Selenium Grid支持分布式测试。

# Selenium 3

与2的发布相隔了5年，2016-10-13，Selenium 的官方博客宣布了 [Selenium 3 正式发布](https://seleniumhq.wordpress.com/2016/10/13/selenium-3-0-out-now/)。

新版本中 Selenium Core 的实现改由 WebDriver 的一个模块实现，这将影响所有 Selenium 1代 Selenium RC 的 API接口。对于 Selenium 2 用户基本没影响。 Selenium 1 被 WebDriver 替代的趋势较之 Selenium 2 更为强烈。

对于 Selenium 2/WebDriver 的用户，这个升级对 Api 接口没什么影响，只是解决了一些 bug。

# Selenium 名字的来源

Selenium 的中文名为“硒”，是一种化学元素的名字，它对汞 （Mercury）有天然的解毒作用。

而 Mercury 公司开发了一系列的测试工具（QTP，QC，LR，WR...），他们功能强大，但是却很贵。

故 thoughtworks 特意把他们的 Web 开源测试工具命名为 Selenium，以此帮助大家脱离汞毒。

不由想到了 IBM 开发的 eclipse 意图对抗 Sun，嘿嘿。当然最后 Sun 确实被收购了。

# Selenium 组件

刚接触时候我被各种 Selenium 绕晕了。一方面原因是 Selenium 混乱的组件，Selenium 2 的内容和 1 混淆起来就找不着北了。

从官网上可以看到，Selenium项目包含4个组件：

* Selenium WebDriver 可本地运行或远程运行
* Selenium Grid 分布式Selenium
* Selenium IDE Firefox插件，有录制脚本的功能。支持自动录制动作和自动生成其他语言的自动化脚本。
* Selenium RC(Selenium 1) 服务器客户端组件，可远程控制子节点

# 参考资料

* [Selenium VS Webdriver - IBM][ibm]

[ibm]: https://www.ibm.com/developerworks/cn/web/1309_fengyq_seleniumvswebdriver/