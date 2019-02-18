---
layout: post
title: Mac 下安装 php 包管理器 composer
category: tech
tags: php mac
---
![](https://cdn.kelu.org/blog/tags/composer.jpg)

许久未在 Mac 上开发。不想今晚心血来潮试着把玩起老项目，好像最近刚重装了系统，mac 竟然没有 composer 命令。这篇文章记录下如何在 Mac 下安装 composer 命令。

一般来说，使用 brew 命令安装即可：

```
brew install composer
```

![](https://cdn.kelu.org/blog/2018/08/php1.jpg)



![](https://cdn.kelu.org/blog/2018/08/php2.jpg)

然而我在安装时出现了上面的错误：

```

==> Downloading https://getcomposer.org/download/1.7.2/composer.phar

curl: (35) LibreSSL SSL_connect: SSL_ERROR_SYSCALL in connection to getcomposer.org:443
Error: Failed to download resource "composer"
Download failed: https://getcomposer.org/download/1.7.2/composer.phar
```

参考 github 的帖子 [Mac OS 10.14 Mojave brew upgrade Curl LibreSSL SSL_connect: SSL_ERROR_SYSCALL #4436](https://github.com/Homebrew/brew/issues/4436)，设置如下环境变量即可：

```
export HOMEBREW_FORCE_BREWED_CURL =1
```

具体如下：

![](https://cdn.kelu.org/blog/2018/08/php3.jpg)

安装完成后，就可以幸福的 ```composer install ``` 啦！

