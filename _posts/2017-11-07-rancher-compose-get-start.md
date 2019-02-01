---
layout: post
title: rancher-compose.yml
category: tech
tags: rancher
---
![](https://cdn.kelu.org/blog/tags/rancher.jpg)

查了很多官方的文档，也没有见到 rancher-compose.yml reference. 可以从官方和社区的 rancher-compose.yml 里找到一些案例来学习一下。<https://github.com/rancher/community-catalog>

这个项目实际上是 Rancher Catelog 的项目。每个应用基本上就是 docker-compose.yml 和 rancher-compose.yml 构成。这两个文件定义了整个应用。同时我们也可以从老环境的应用中导出这两个文件，新环境直接部署即可使用，非常的便利。

询问了 Rancher 官方的开发者，他们的建议是理解概念以后使用 UI 界面进行配置后导出，不建议直接编写。

最简单的例子如下:

	# Reference the service that you want to extend
	version: '2'
	services:
	  web:
	    scale: 2
	  db:
	    scale: 1

# 参考资料

* [Rancher-Compose Command and Options](http://rancher.com/docs/rancher/v1.6/en/cattle/rancher-compose/commands/)