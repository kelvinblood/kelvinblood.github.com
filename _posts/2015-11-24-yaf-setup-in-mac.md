---
layout: post
title: Mac下安装yaf
category: tech
tags: mac php yaf ide
---

刚刚加入了新的团队。团队里使用鸟哥惠新宸的yaf框架。于是便在自己电脑上安装了起来，稍微记录一下注意事项。题外话，我也是刚刚才了解到，鸟哥竟然是我的学长😓。。。。。。

由于之前使用的是thinkphp框架，本地的环境基本上已经搭建好了，xampp+phpstorm搞定。于是要做的，就是将yaf编译好，将其与xampp的php结合起来，即可。

先在yaf官网上面下载最新的源码，然后按照官网上的教程进行安装。<http://www.laruence.com/manual/>

## 1. 编译

官网上给出的编译步骤如下，

	下载Yaf的最新版本, 解压缩以后, 进入Yaf的源码目录, 依次执行

	$PHP_BIN/phpize
	./configure --with-php-config=$PHP_BIN/php-config
	make
	make install
	
其中，$PHP_BIN指的是php所在的bin目录，在这我们的目录是`/Applications/XAMPP/bin`
同时注意需要在make和make install命令前面加上sudo。

##### tips
在这个过程中你可能会遇到这个问题：

	Cannot find autoconf. Please check your autoconf installation and the $PHP_AUTOCONF environment variable. Then, rerun this script.

于是使用万能的homebrew来进行安装autoconf。

	brew install autoconf



## 2. 配置
make install之后，系统会编译出一个yaf.so，并且存放在某个文件夹下面。具体存放在哪不用去了解。将yaf.so加入配置文件php.ini中。

	vi /Applications/XAMPP/etc/php.ini
加入以下语句：

	extension=yaf.so
使用php -m，查看yaf是否已经加入php

	/Applications/XAMPP/bin/php -m
	[PHP Modules]
	……
	省略一些模块
	……
	xmlwriter
	xsl
	yaf
	zip
	zlib

如果看到了yaf，就说明yaf这个模块已经载入成功了。


##### tips
为了使你的php用的更加方便点，可以添加一个alias进入你的.bashrc文件中

	alias xamppphp='/Applications/XAMPP/bin/php'
	
## 3. 生成sample应用

按照yaf官网上面的教程，生成一份样例的yaf应用，具体步骤如下：

下载php-yaf源码

	git clone https://github.com/laruence/php-yaf/
运行代码生成工具

	$PHP_YAF_SRC/tools/cg/yaf_cg sample

然后将会在`$PHP_YAF_SRC/tools/cg/output`下生成sample应用。


##### tips
将此应用移动到你的workspace目录下

## 4. 配置PHPstorm
按照普通项目设置run configurations即可。增加项目的PHP build-in web server，设置好项目根目录，即可。
