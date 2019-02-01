---
layout: post
title: Go 语言笔记 - 环境配置
category: tech
tags: go
---
![](https://cdn.kelu.org/blog/tags/go.jpg)

嗯，最近一个项目需要用到 Go 语言开发。捡起来复习一下，于是出了这篇文章。最近几天还会继续总结，欢迎和我讨论。

# 简介

Go 语言被设计成一门应用于搭载 Web 服务器，存储集群或类似用途的巨型中央服务器的系统编程语言。

对于高性能分布式系统领域而言，Go 语言无疑比大多数其它语言有着更高的开发效率。它提供了海量并行的支持，这对于游戏服务端的开发而言是再好不过了。

# 观点

[Go语言，Docker和Kubernetes -王垠](http://www.yinwang.org/blog-cn/2016/03/27/docker)

# 安装

Go 语言支持以下系统：

*   Linux
*   FreeBSD
*   Mac OS X
*   Window

安装包下载地址为：[https://golang.org/dl/](https://golang.org/dl/)。

## Windows

Windows 只要安装 msi 安装包即可。

![](https://cdn.kelu.org/blog/2017/08/go0.jpg)

## Mac

我用的是 Mac，直接下载 pkg 安装包即可。需要在系统路径里增加 go 的地址

	export PATH=/usr/local/go/bin:$PATH

可以用下面这个 demo 测试一下效果:

	## $HOME/go/src/hello/hello.go

	package main
	
	import "fmt"
	
	func main() {
	    fmt.Printf("hello, world\n")
	}

你既可以像 C 语言一样先编译一遍再运行：

	$ cd $HOME/go/src/hello
	$ go build
	$ ./hello
	hello, world

也可以直接运行:

	$ cd $HOME/go/src/hello
	$ go run hello.go

## Linux

	wget https://redirector.gvt1.com/edgedl/go/go1.9.2.linux-amd64.tar.gz
	sudo tar -C /usr/local -xzf go1.9.2.linux-amd64.tar.gz 
	sudo ln -s /usr/local/go/bin/go /usr/bin/go

# IntelliJ IDEA 配置

* 安装插件

	![](https://cdn.kelu.org/blog/2017/08/go1.jpg)

* 配置 GOROOT

	![](https://cdn.kelu.org/blog/2017/08/go2.jpg)

* 配置 GOPATH

	 ![](https://cdn.kelu.org/blog/2017/08/go3.jpg)


# 参考资料

* [Go语言，Docker和Kubernetes -王垠](http://www.yinwang.org/blog-cn/2016/03/27/docker)
* [godoc.org](https://godoc.org)
* [Kubernetes Client-Go包使用示例](http://jimmysong.io/blogs/kubernetes-client-go-sample/)
* [199GO语言零基础入门资料整理](http://www.jianshu.com/p/a70098a94d18)
* [Go 语言教程](http://www.runoob.com/go/go-tutorial.html)
* [使用intelliJ做为Golang的IDE](https://segmentfault.com/a/1190000003933657)
* [Go 入门指南 - 极客学院](http://wiki.jikexueyuan.com/project/the-way-to-go/)
* [怎么学习golang？](https://www.zhihu.com/question/23486344)
* [Unknwon](https://github.com/Unknwon)/[the-way-to-go_ZH_CN](https://github.com/Unknwon/the-way-to-go_ZH_CN)
* [Go语言圣经（中文版）](http://docs.ruanjiadeng.com/gopl-zh/ch0/ch0-01.html)
* [Go Channel 详解](http://colobu.com/2016/04/14/Golang-Channels/)
* [深入学习golang(2)—channel](http://www.cnblogs.com/hustcat/p/4003729.html)
* [# Golang channels 教程 _【已翻译100%】_](http://www.oschina.net/translate/golang-channels-tutorial)
* [# Golang Channel用法简编](http://tonybai.com/2014/09/29/a-channel-compendium-for-golang/)
* [在 Golang 中使用 Go 关键字和 Channel 实现并行](https://segmentfault.com/a/1190000005064535)

