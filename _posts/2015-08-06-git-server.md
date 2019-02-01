---
layout: post
title: Gitolite搭建git服务器
category: tech
tags: linux git gitolite tutorial 
---

这段时间用Git用的很顺手很舒服，不过都是登陆自己的服务器写的代码。于是乎研究起了Git服务器。不过经过一天晚上的研究。最后发现还是gitlab舒服。大家直接用gitlab好了。这一篇就当纪念了😄

ps：在Git服务管理工具这个领域，除了刚提到gitlab和gitolite之外，还有 Gitosis 和 Git + Repo + Gerrit 的方案。其中Git + Repo + Gerrit是超级重量级的方案，集版本控制，库管理和代码审核为一身。可管理大型及超大型项目。
大名鼎鼎的Android平台就是使用的 Git + Repo + Gerrit。

pps:gitlab可以使用这个脚本一键安装。https://bitnami.com/stack/gitlab/installer



## 简介

Gitolite是在Git之上的一个授权层，依托sshd或者httpd来进行认证。（概括：认证是确定用户是谁，授权是决定该用户是否被允许做他想做的事情）。

第一步，安装git：

	$ sudo apt-get install git

第二步，创建一个git用户，用来运行git服务：

	$ sudo adduser --system --shell /bin/bash --gecos 'Git SCM User' --group --disabled-password --home /home/git git

第三步，创建证书登录：
收集所有需要登录的用户的公钥，把所有公钥导入到/home/git/.ssh/authorized_keys文件里。

第四步，下载源码并安装：

	$ sudo su git
	$ cd $HOME
	$ git clone http://github.com/sitaramc/gitolite

安装Gitolite（服务器端）

	$ mkdir -p ${HOME}/bin
	$ ${HOME}/gitolite/install -to ${HOME}/bin
	
设置SSH public key（服务器端）

	$ ${HOME}/bin/gitolite setup -pk xxx.pub // 你的公钥
	
到这里，Gitolite已经安装完成。

第五步：克隆Gitolite管理库（客户端）

在客户端上设置ssh的配置文件，config。例如：

	Host    gitolite
	  HostName        199.199.199.199
	  Port            1999
	  User            git
	  IdentityFile    ~/.ssh/xxx
	  
然后只需要在本地服务器上使用如下代码下载。
  
	$ git clone gitolite:gitolite-admin.git

这只是一篇非常非常简约的安装记录，更多的配置和问题请参考相关的资料：

* [服务器上的 Git - Gitolite | git-scm](http://git-scm.com/book/zh/ch4-8.html)
* [使用Gitolite搭建轻量级的Git服务器 | chinaunix](http://blog.chinaunix.net/uid-15174104-id-3843570.html) 
* [Gitolite 构建 Git 服务器](http://www.ossxp.com/doc/git/gitolite.html)
