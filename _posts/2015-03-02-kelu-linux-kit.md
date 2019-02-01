---
layout: post
title: Linux一键装机 - KeluLinuxKit
category: tech
tags: linux
---

过年的时候一个服务器的某个端口被GFW了，找了好久才找到这原因。为了找到原因还把机器重装了Orz

结果反正是又得重装系统了。想到有一大帮东西要安装就有点头疼。一怒之下写了自己的一键安装包。那亚马逊的机器来试了两天，未来两个星期还有一些小变动，不过大致就是现在的样子了。^_^感兴趣的可以去我的github上取。

那么KeluLinuxKit包含了什么东西呢？

* 定义快捷实用的.bashrc
* 防火墙iptables
* 轻量级的邮件发送工具，mutt & msmtp
* 使用dropbox进行系统一天一备份
* 随时监控服务器的情况cpu内存状况，VPN流量使用情况。
* Linux下的Maximum Awesome
* tmux的一个强大状态栏tmux-powerline
* PPTP-VPN，随时查看当前在线人数，任一个用户的当前使用流量和历史使用情况
* bt下载工具transmission
* 远程连接软件xrdp，支持windows的远程桌面连接
* dropbox
* 使用额外的脚本安装lnmp
* 使用额外的脚本安装github



## 安装方法

在KeluLinuxKit文件夹中运行 `./keluLinuxKitSetup.sh` ，根据提示选择一些必要选项即可。

## 自定义

正在完成

## 卸载

正在完成

## 机器备份

在机器中运行 `./bin/sync.sh` ，一键备份常用配置文件。同时根据是否包含有敏感信息，将敏感文件保存到单独的文件中。

计划添加加密功能。

## 贡献

如果你感兴趣，也可以为KeluLinuxKit贡献你的代码。进入Github上KeluLinuxKit的项目中，新建自己的分支，再为我申请合并分支即可。

非常感谢你的帮助。