---
layout: post
title: git提示Agreeing to the Xcode/iOS license...，不能启动的问题
category: tech
tags: mac git xcode
---

今天使用git的时候，提示：`Agreeing to the Xcode/iOS license requires admin privileges, please re-run as root via sudo`，发现原来是刚更新了xcode，但是一直没有启动，还影响到命令行下git的使用。

解决的办法有两个，一个是命令行下运行如下命令

	$ sudo xcodebuild -license
	
另一个方法就是打开xcode，按照步骤同意协议，点击下一步即可。

不过这样子感觉还是不爽呀，不同意你xcode的协议，就不能用git？有点扯啊~