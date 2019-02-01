---
layout: post
title: 在Mac下搭建jekyll环境
category: tech
tags: mac jekyll github ide
---

一直在用github pages来管理自己的Blog。不过一起太懒，都是直接在模板上修改，导致最近修改css查看效果特别麻烦，每次都要commit push之后才看到效果。想着还是在本地也配个环境吧，做下来之后蛮简单的。

## 1、安装/升级本地ruby

先 `ruby -v` 查看下本地ruby版本号，如果是1.9.2以上的直接跳过该步。由于我的系统是10.10，ruby版本已经上到2了，所以这一个步骤就跳过了。

### 安装rvm

	$ curl -L https://get.rvm.io | bash -s stable

安装好rvm后需要按照提示 `source ~/.bash_profile` 将rvm添加到环境变量中。




### 安装ruby

	$ rvm use 1.9.3
	ruby-1.9.3-p392 is not installed.
	To install do: 'rvm install ruby-1.9.3-p392'
	$ rvm install ruby-1.9.3-p392

## 2、安装jekyll

	$ gem install jekyll
	
安装的时间蛮久的，我这里网络不好。安装完成后，cd到项目根目录

	$ jekyll s

通过 localhost:4000 即可访问。

参考资料:

<http://jekyllcn.com/>