---
layout: post
title: ssh转发代理
category: tech
tags: linux proxy
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

原来这么简单啊= =目前只在Mac下试过，真的好简单！

首先本地添加自动代理地址：

	系统偏好设置->网络->高级->代理->自动代理配置

在url栏中添加代理配置。然后打开终端

	ssh -D 转发端口 -p 登陆端口 -g user@hostname

输入密码之后就可以了Orz。



另外ssh命令的几个参数：

    -D 绑定本地端口
    -p 远程服务器的端口
    -q Quiet mode，ssh的诊断信息以及警告等信息被抑制
    -T 禁用伪终端分配
    -f 该选项是后台执行的ssh在规定时间(10秒)内进行连接，如果超过该时间ssh将退出。
    -n 重定向标准输入到/dev/null中，为了防止从标准输入中读入。ssh进行后台执行时必须使用该参数。该选项对于要求输入密码不起作用
    -N 不执行远程命令