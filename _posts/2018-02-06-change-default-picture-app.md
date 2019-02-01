---
layout: post
title:  修改 Win10 默认照片查看器
category: software
tags: windows
---
![](https://cdn.kelu.org/blog/tags/windows.jpg)

最近两年用的都是 Windows 10，整体还不错，不过有一点蛮恼人的——不是从前默认的看图软件，改成了一个xx3D的图片编辑器，无法理解。而且在修改默认打开工具里找不到以前默认的照片查看器！

接下来记录一下如何通过修改注册表修复这个问题：

1. 打开注册表

	Windows徽标键+R键，打开运行命令窗口，输入“**regedit**”命令。

	![](https://cdn.kelu.org/blog/2018/02/win_20180206202511.jpg)

1. 双击左侧的目录，依次打开**HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations**目录。

	![](https://cdn.kelu.org/blog/2018/02/win_20180205130047.jpg)

1. 在**FileAssociations**目录下，对着界面击右键，选择“**新建-字符串值**”菜单。

1. 数值名称要写为.jpg，数值数据写为“PhotoViewer.FileAssoc.Tiff”，如下图所示，然后点击“**确定**”按钮。

1. 打开方式中终于出现照片查看器了！

	![](https://cdn.kelu.org/blog/2018/02/win_20180205130256.jpg)
