---
layout: post
title: git 出现warning crlf will be replaced by...
category: tech 
tags: git
---

我想这应该是下载一个从windows里到处的项目时遇上的。前些天发现了这个问题。在`git commit`时无法提交，提示`warning: LF will be replaced by CRLF…..`。

相关的问题在 [stackoverflow](http://stackoverflow.com/questions/1967370/git-replacing-lf-with-crlf)上也有提及。

产生这个问题的原因是，windows、Linux和Mac在处理文件换行时的标示符是不一致的。windows使用CRLF作为结束符，而Linux和Mac使用LF作为结束符。

同时呢，Git 有两种模式来对待换行符，你可以通过下面这行代码查看你的git配置。

	$ git config core.autocrlf
	
如果显示为true，则每一次当你`git commit`时，如果存在文本文件，那么git会自动帮你将末尾的换行符改为CRLF，省去了烦心的转换工作。

如果显示为false，则git不会对换行符进行修改，保持原本的内容。

所以呢，作为Linux和Mac开发者，这个配置应当为false，而windows开发者，则应当设置为true。

	$ git config --global core.autocrlf  false

---

引用资料：

<http://stackoverflow.com/questions/1967370/git-replacing-lf-with-crlf>