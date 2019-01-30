---
layout: post
title: 批量调整word中插入的图片大小 - 到处玩的
category: software
tags: microsoft
---
![](https://cdn.kelu.org/blog/tags/windows.jpg)

使用宏，alt+F8进入宏查看界面，点击创建，输入以下代码，设置图片高、宽，单位：厘米。f5或保存后退出宏编辑界面。

然后alt+F8进入宏查看界面，点击运行即可。

```
Sub 批量设置图片大小()
'
' Macro 宏
'
'
Myheigth = 9
Mywidth = 12
On Error Resume Next '忽略错误
For Each iShape In ActiveDocument.InlineShapes
iShape.Height = 28.345 * Myheigth '设置图片高度为任意cm
iShape.Width = 28.345 * Mywidth '设置图片宽度
Next
For Each Shape In ActiveDocument.Shapes
Shape.Height = 28.345 * Myheigth '设置图片高度为任意cm
Shape.Width = 28.345 * Mywidth '设置图片宽度
Next
End Sub
```

# 参考资料

* <https://www.zhihu.com/question/23242989/answer/168158120>