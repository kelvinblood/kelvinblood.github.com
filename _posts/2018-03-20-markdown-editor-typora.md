---
layout: post
title: 一款好用的 markdown 编辑器 —— Typora | 少数派
category: software
tags: markdown
---
![](https://cdn.kelu.org/blog/tags/markdown.jpg)

以前曾介绍过一款 markdown 编辑器 —— Yu Writer，确实好用。不过开发者已经很久没更新了，期望的一些特性也没有添加上去。最近又发现了一款不错的编辑器，而且是全平台支持的。与其它一些 markdown 编辑器最大的不一样是——所见即所得，不再是一边源文件一遍预览的方式了。

目前我还是用 Yu Writer 作为公众号的排版使用，Typora作为日常编辑使用。

总的说来 Typora 很赞，推荐一波。

![](https://cdn.kelu.org/blog/2018/03/20180401141848.jpg)



[点此前往官网下载 Typora](http://typora.io/)



以下转载自少数派：[《让 Markdown 写作更简单，免费极简编辑器：Typora》](https://sspai.com/post/30292)

Markdown 其实向来是文字爱好者和码农们的小众需求，但市面上竟涌现出了这么多种形形色色的 Markdown 编辑器，[Mou](http://mouapp.com/)、[Typed](https://sspai.com/30271)、[Ulysess](https://sspai.com/27336)、[Macdown](http://macdown.uranusjr.com/) 等等，各有特色，难分伯仲。特别是国内口碑颇高的 Mou，说好的 1.0 版本也总是姗姗来迟，又跳票到了今年八月。

------

如果你还不了解 Markdown 及相关背景知识，可以参见：

- [《认识与入门 Markdown》](https://sspai.com/25137)
- [《解决作者们的焦虑：7 款优秀 Markdown 编辑工具推荐》](https://sspai.com/27792)

------

然而看看市面上现在比较流行的 Markdown 编辑器，都基本采用了「写字」和「预览」相分离的策略，无论是像 Mou 这样将窗口左右排列，还是像 Typed 一样两种状态需要切换显示，都似乎离 Markdown 的初衷渐行渐远：优雅可控的格式是为了让文字本身更易读。然而，在实际使用的时候，由于文字的输入源和文字的输出源是割裂的，这件事情本身就显得不纯粹，再加上众多 Markdown 编辑器始终没有着手解决表格、代码等格式的编辑，也使 Markdown 变得不那么优雅。是的，如果你用 Markdown 原生格式去编辑过一个表格，你应该懂我的意思。

![img](https://cdn.kelu.org/blog/2018/03/267194.jpg)

## 看看 Typora 是怎么解决这个问题的

无意中发现了 Typora 这款 Markdown 编辑器。第一眼看上去它就像任何一款 Markdown 编辑器的同类，尤其是 Mou，但再看一眼，你就发现，它是如此的不同。

因为它将「写字」和「预览」这两件事情合并了，你输入的地方，也是输出的地方，即现在很流行的 WYSIWYG（What You See Is What You Get）。其实转念一想，这不就是回到了 Office Word 嘛，只不过编辑文本时不用再去工具栏上点选，一切的格式都能通过符号来控制。

用 Typora 官方的介绍视频，你就懂这一切是多么的自然。没错，所有的行内元素（如加粗、斜体）都会根据当前是否在编辑态而智能地在编辑态和预览态切换，而区块级元素（如标题、列表）则会在按下 Enter 后即时渲染，不能再次编辑。

一切都变得如此干净、纯粹。

 当然，Typora 的强大之处不仅仅在于颠覆了 Markdown 编辑器传统的交互模式，它还引入了一系列强大的功能，一起看看吧。

## 表格编辑变得如此简单

之前提到了，用 Markdown 编辑表格是如此痛苦的一件事情，因为它的原生格式是这样的：

```
| Left-Aligned  | Center Aligned  | Right Aligned |
| :------------ |:---------------:| -----:|
| col 3 is      | some wordy text | $1600 |
| col 2 is      | centered        |   $12 |
| zebra stripes | are neat        |    $1 |
```

简直反人类啊！还好，Markdown 提供了像 Office 一样的表格编辑能力。通过菜单栏或快捷键 Command+T 可以插入表格，Typora 会弹出一个表格插入设置，你可以预先设定好行数和列数，确定后表格就出现了。每一列上面还有三个按钮，可以控制本列的文字向左、居中、向右对齐。甚至，你可以点击左上角改变表格的行数和列数，是不是一种 Office 的既视感，但却又如此得恰到好处，弥补了 Markdown 编辑器中反人类的表格编辑设定。

![img](https://cdn.kelu.org/blog/2018/03/267198.jpg)

![img](https://cdn.kelu.org/blog/2018/03/267197.jpg)

![img](https://cdn.kelu.org/blog/2018/03/267199.jpg)

## 插入图片也变得如此简单

在传统的 Markdown 编辑器中，如果想要插入一张图片，默认的语法是这样的：

`![logo](http://typora.io/img/favicon-128.jpg)`

而在 Typora 中，你只需要像把图片拖拽进去，就大功告成了。再也不用记住语法格式，再也不用输文件名，再也不用自己去找文件的路径地址，就是这么简单。

![img](https://cdn.kelu.org/blog/2018/03/267201.jpg)

![img](https://cdn.kelu.org/blog/2018/03/267200.jpg)

## 还有最好用的代码和数学公式输入

Typora 里代码和数学公式的输入，也做得一样出色。当插入代码区域时，你可以先选择代码的种类，Typora 基本支持了所有主流的代码高亮（C#、PHP、Java 等等），连 Swift 也不在例外。而数学公式更加，Typora 甚至连 Latex 都支持了。

除此之外，Typora 的编辑还支持插入任务列表、目录、YAML Front Matters。在所有 Markdown 编辑器中，Typora 的代码和数学公式输入，绝对算上得最好用的之一。

![img](https://cdn.kelu.org/blog/2018/03/267203.jpg)

![img](https://cdn.kelu.org/blog/2018/03/267205.jpg)

![img](https://cdn.kelu.org/blog/2018/03/267204.jpg)

## 支持显示目录大纲

Typora 还可以根据当前文档的标题层级，自动生成显示大纲，将光标移动到窗口右上角，就会出现字数统计和大纲预览，如果有需要的话，还可以将目录层级固定在左侧显示。突然间，就觉得 Mou 1.0 来得有些迟了，已经深深地爱上 Typora 不能自拔。

![img](https://cdn.kelu.org/blog/2018/03/267207.jpg)

![img](https://cdn.kelu.org/blog/2018/03/267209.jpg)

## 百变主题，随心定制

Typora 默认提供了六套主题样式：Github、默认主题 Gothic、出版风格的 Newsprint、夜间模式 Night、Pixyll 和 Whitey，每一款主题都非常精美。并且，主题是基于 CSS 样式的，这意味着你可以自己新增任何主题，或者在当前主题的基础上做一些微调。想想某些厂商的换肤换色，不知道高到哪里去了。

![img](https://cdn.kelu.org/blog/2018/03/267211.jpg)

![img](https://cdn.kelu.org/blog/2018/03/267212.jpg)

![img](https://cdn.kelu.org/blog/2018/03/267213.jpg)

经过一段时间的体验和使用，Typora 几乎就是我理想中的 Markdown 编辑器应有的样子，尽管还是 Beta 版，但完成度之高、性能之稳定已经令人折服，贯穿其中的给人从始至终「干净、纯粹」的感觉。

Typora 在 Markdown 的基础上，保持了应有的简洁和优雅，又一定程度地改良了 Markdown 本身较为不合理和烦琐的地方，适度地引入一些高级的编辑功能，使得一切都觉得如此顺手。如果你也是 Markdown 的重度用户，一定去试试这款新秀之作，目前仍在公测期间完全免费，未来即使要付费，也必须是买买买的节奏啊。
