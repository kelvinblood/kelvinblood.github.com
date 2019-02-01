---
layout: post
title: php laravel 框架中的 try catch
category: tech
tags: php laravel
---
![](https://cdn.kelu.org/blog/tags/laravel.jpg)



嗯，平时不怎么习惯使用 try catch。今天用起来竟然发现不生效。无法理解。

经过一番折腾之后，发现其实 ide 已经有做很好的提示了！

![](https://cdn.kelu.org/blog/2018/01/20180423142236.jpg)

在类名前面添加斜杠即可：

![](https://cdn.kelu.org/blog/2018/01/20180423142201.jpg)

这个问题不仅是 `Exception` 这个类而已，所有PHP自带的类都需要添加`\`