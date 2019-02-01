---
layout: post
title: Linux 输入历史命令的小技巧
category: tech
tags: linux linux-command
---

平时经常会输入完全相同的命令，或者类似的命令，可以使用以下几个命令查看和复用曾输入过的命令，提高工作效率。

	history			显示完整历史
	history N		显示历史中的最后 N 行
	history -d N		从历史中删除行 N；比如，如果行中包含密码的话就需要这样做
	!!			上一个命令
	!N			第 N 个历史命令
	!-N		回到历史中的 N 个命令（!-1 相当于 !!）
	!#			正在输入的当前命令
	!string			以 string 开头的最近一次命令
	!?string?		包含 string 的最近一次命令

同时，还可以在`~/.bashrc`中添加下面一些命令来对命令历史做一些修改

    HISTFILESIZE=200000 #最大命令历史记录数
    HISTCONTROL=erasedups #去掉重复条目，默认为ignoreboth（没想通为什么不是erased ups）
    HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S " # 为history添加输入的时间