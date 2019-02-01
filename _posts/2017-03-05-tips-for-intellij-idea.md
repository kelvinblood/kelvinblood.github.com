---
layout: post
title: 几个 IntelliJ IDEA 小技巧
category: tech
tags: intellij
---

![](https://cdn.kelu.org/blog/tags/intellij.jpg)

Idea 可谓我的主力IDE，吃饭的家伙。感觉 Idea 太大了没办法面面俱到，下面就列一些常用容易遗忘的技巧。

# 关于 IDEA

IDEA 全称 IntelliJ IDEA，JetBrains 公司旗下产品。IntelliJ在业界被公认为最好的java开发工具之一，尤其在智能代码助手、代码自动提示、重构、J2EE支持、Ant、JUnit、CVS整合、代码审查、 创新的GUI设计等方面的功能可以说是超常的。另外通过插件，Idea 对 PHP 和前端开发也有强力的支持。个人感觉 IntelliJ IDEA 是目前所有 IDE 中最具备沉浸式的 IDE。

JetBrains 公司下的其他产品包括：

* PhpStorm 主要用于开发 PHP
* RubyMine 主要用于开发 Ruby
* PyCharm 主要用于开发 Python
* AppCode 主要用于开发 Objective-C / Swift
* CLion 主要用于开发 C / C++
* WebStorm 主要用于开发 JavaScript、HTML5、CSS3 等前端技术
* 0xDBE 主要用于开发 SQL
* Android Studio 主要用于开发 Android（Google 基本 IntelliJ IDEA 社区版进行迭代所以也姑且算上）

# 常用快捷键

还有不少是与 Vim 重合的快捷键，就不列出来了。作为开发者，Vim 和 Emacs  少是会一个吧。    


| 快捷键  | 说明  |
|---|---|
| Ctrl+Q | 显示注释文档 |
| Ctrl+/	 | 注释光标所在行代码 |
| Ctrl+Alt+L | 格式化代码 |
| Ctrl+Alt+O | 格式化import列表 |
| Ctrl+Alt+V | [快速定义变量][1] |
| `/**+Enter` | 快速添加annotations |
| `Ctrl+[` | 移动光标到当前所在代码的花括号开始位置 |
| `Ctrl+]` | 移动光标到当前所在代码的花括号结束位置 |
| Ctrl+Alt+左 | 上一个操作的地方 |
| Ctrl+Alt+右 | 下一个操作的地方 |
| Ctrl+Alt+F12 | 快速在资源管理器中打开当前文件 |
| Ctrl+Shift+U | 大小写转换 |
| Ctrl+Shift+T | 对当前类生成单元测试类 |
| F2 | 跳转到下一个高亮错误或警告位置 |
| Shift+F6 | 快速重命名变量 |
| Alt+Insert | 自动生成代码 |
| 连按两次Shift | 弹出SearchEverywhere |

# 其他技巧

### 查看效率指南

![](https://cdn.kelu.org/blog/2017/03/20170305183744.jpg)

![](https://cdn.kelu.org/blog/2017/03/20170305183724.jpg)

### <span id='extract'>快速定义变量</span>

选中一个表达式，然后在菜单中选择 Refactor - Extract - Variable，即可将该表达式提取为一个变量。同理也可以提取为成员、参数、常量等。

![](https://cdn.kelu.org/blog/2017/03/1421151681_4076.jpg)

### 快速优化语句

IntelliJ 能帮助你快速优化语句。虽然感觉这个功能不太稳定，也蛮好的。

![](https://cdn.kelu.org/blog/2017/03/1421151682_6823.jpg)

### 自定义注释信息

![](https://cdn.kelu.org/blog/2017/03/20170305210510.jpg)

更详细设定查看官网[File Template Variables](https://www.jetbrains.com/help/idea/2016.3/file-template-variables.html)

# 参考资料

* [IntelliJ IDEA 教程 - phperz](http://www.phperz.com/article/15/0923/159068.html)

[1]: #extract