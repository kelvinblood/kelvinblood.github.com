---
layout: post
title: Mac 下使用 homebrew 切换不同版本 php
category: tech
tags: mac php
---
![](https://cdn.kelu.org/blog/tags/php.jpg)

最近刚切换回 Mac 下进行开发，所以写了比较多的 Mac 环境部署之类的文章。今天需要重新切换一下本地的开发环境。原本想直接在当前环境下开发，
毕竟 Mac 自带了 PHP 环境，今天需要新添一个扩展 freetype ，需要重新编译一遍 PHP。
由于这个扩展是核心内置扩展，没法通过phpize来编译安装。
解决办法只有一个，就是找到PHP的安装源码重新编译一下，在编译的时候，加上–with-freetype-dir。

但是要知道的一个事 —— Mac上PHP是内置的，根本就找不到它的安装源码在哪！

所以需要重新编译一遍 PHP，并且不影响 Mac 当前的 PHP 环境。

Mac 下软件的安装和管理，当然离不开 homebrew 了。 

# 安装 php 不同版本

    brew install php54
    brew install php55
    brew install php56
    brew install php70
    
安装新版本时，你很大几率上会被提醒，php 已经安装了 xxx 版本了，你需要先 unlink 原先的版本。于是就是下面的这个命令了。先 unlink 再安装。
安装后自然就 link 好了。    

# 常规切换

通过 brew 安装的 php 可以通过brew link和brew unlink来切换不同版本。

    brew list
    brew unlink php56
    brew link php55
    
大版本可以用brew list来查，如果是小版本的话只能去/usr/local/Cellar/php55看了。这个时候使用php-version可以更方便一点。

homebrew 中有一个非常便于管理和切换 PHP 版本的工具 —— php-version.

# php-version

安装php-version

    brew install php-version
    
然后执行下面的命令。也可以讲下面这个命令放到 ~/.bashrc 或 ~/.zshrc 里去

    source $(brew --prefix php-version)/php-version.sh && php-version xxx # xxx 是版本号
    
直接执行

    php-version
    
就可以看到现有的版本，比如我自己的

    ➜  ~ php-version
          5.4.45
          5.5.38
          5.6.30
        * 7.0.20

然后使用以下命令切换即可

    php-version 7.0.20
    
再看php的版本，已经切换好了。

    php -v

>
注：我在早期时已经装好了 php7，今天切换版本的时候 `php -v` 一直没什么变化，误导了我。最后我先将这个 php70 版本 remove 后再 install，
就没问题了。

# 在 IDEA 中使用

虽然在终端里，php -v 已经是最新的7了。我原先 IDEA 里的 php 版本还是 5.6.30 的。这个改起来就很简单了。

在 Preference 里找到 php 的设置，讲原先的 `/usr/bin/php` 改为 `/usr/local/bin/php` 即可。

# 不同版本的配置

各版本的配置在目录

    /usr/local/etc/php/xxx
    
里，根据需要设置即可。

# 安装扩展

假设我们要装5.6版本的 mcrypt 插件

    brew search php56-mcrypt

    brew install php56-mcrypt  #默认安装在`/usr/local/Cellar/`下
    
然后找到mcrypt.so 文件，通过pwd查看路径,接着编辑PHP配置文件(php.ini):

    vi /usr/local/etc/php/xxx/php.ini  #通过brew默认配置文件路径
    
在php配文件增加代码：

    extension=/usr/local/Cellar/php56-mcrypt/5.6/mcrypt.so

# 参考资料

* [Mac OSX 多PHP版本共存](https://www.leocode.net/article/index/26.html)
* [MAC OS X 通过HOMEBREW安装PHP扩展](https://www.vstary.com/article/38)