---
layout: post
title: 快捷键之tmux
category: tech
tags: linux tmux
---

这份常用快捷键是基于[Maximum-Awesome](https://github.com/square/maximum-awesome)的，不全面但足够日常使用。如果你还没有安装，参考我的上一篇文章[使用Maximum Awesome](/tech/2015/02/12/Maximum-Awesome-configuration-for-vim-and-tmux.html)。

## 窗口
	C-a c		新建窗口
	C-a space 下一个窗口
	C-a bspace 上一个窗口
	C-a v 纵向切割窗口
	C-a s 横向切割窗口
	C-a w 以菜单方式显示及选择窗口
	C-a & 关闭窗口



## 面板操作
	C-a h/j/k/l 选择面板
	C-a a 上一个面板
	C-a ; 上一个面板
	C-a q 显示面板编号
	C-a x 关闭面板

## 面板布局
	C-a enter 面板下一种布局（均分、全纵向、全横向、主横向、主纵向）
	C-a C-o 逆时针旋转面板
	C-a + 主面板 - 横向
	C-a = 主面板 - 纵向

## 操作
	C-a : 输入命令
	C-a r 重载配置文件
	C-a L 清除历史
	C-a d 退出tumx，并保存当前会话
	
	C-a [ 复制模式
	C-a ] 粘贴模式

## 其它

由于是在服务器上设置的tmux，默认的复制粘贴有问题，修改成了vim的经典模式：v选择，y复制，如下：

	bind-key -t vi-copy v begin-selection
	bind -t vi-copy y copy-selection
	
## 参考资料

* [tmux的使用方法和个性化配置](http://mingxinglai.com/cn/2012/09/tmux/)
