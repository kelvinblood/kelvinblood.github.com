---
layout: post
title: 转载 | Composer 入门
category: tech
tags: php composer
---
![](https://cdn.kelu.org/blog/tags/composer.jpg)

前言： 最近总结了好多和 composer 相关的文章。这一篇对 composer 做个简单介绍。文章大部分来源于[Composer 中文文档][composer-cn]

对于现代语言而言，包管理器基本上是标配。Java 有 Maven，Python 有 pip，Ruby 有 gem，Nodejs 有 npm。PHP 的则是 PEAR，不过 PEAR 坑不少：

    依赖处理容易出问题
    配置非常复杂
    难用的命令行接口

composer 也是 PHP 用来管理依赖关系的工具。它做的如此之好，以至于如果你只是纯粹地进行 php 开发，在平时使用中对几乎可以忽略 composer。 你可以在自己的项目中声明所依赖的外部工具库，Composer 会帮你安装这些依赖的库文件。它实际上包含了两个部分：[Composer][getcomposer] 和 [Packagist][Packagist]。

Composer 是由 Jordi Boggiano 和 Nils Aderman 创造的一个命令行工具，它的使命就是帮你为项目自动安装所依赖的开发包。Composer 包含了一个依赖解析器，用来处理开发包之间复杂的依赖关系；另外，它还包含了下载器、安装器等有趣的东西。
Packagist 是 Composer 的默认的开发包仓库。你可以将自己的安装包提交到 packagist，当你在自己的 Git 仓库中新建了 tag 或更新了代码，packagist 都会自动构建一个新的开发包。



# 安装 Composer

Composer 需要 PHP 5.3.2+ 才能运行。

    $ curl -sS https://getcomposer.org/installer | php
    
这个命令会将 composer.phar 下载到当前目录。PHAR（PHP 压缩包）是一个压缩格式，可以在命令行下直接运行。

你可以使用 --install-dir 选项将 Composer 安装到指定的目录，例如：

    $ curl -sS https://getcomposer.org/installer | php -- --install-dir=bin
    
当然也可以进行全局安装：

    $ curl -sS https://getcomposer.org/installer | php
    $ mv composer.phar /usr/local/bin/composer
    
在 Mac OS X 下也可以使用 homebrew 安装：

    brew tap josegonzalez/homebrew-php  
    brew install josegonzalez/php/composer  
    
不过通常情况下只需将 composer.phar 的位置加入到 PATH 环境变量就可以，不一定要全局安装。

# 声明依赖
在项目目录下创建一个 composer.json 文件，指明依赖，比如，你的项目依赖 monolog：

    {
        "require": {
            "monolog/monolog": "1.2.*"
        }
    }
    
# 安装依赖
安装依赖非常简单，只需在项目目录下运行：

    composer install  
如果没有全局安装的话，则运行：

    php composer.phar install  

# 自动加载
Composer 提供了自动加载的特性，只需在你的代码的初始化部分中加入下面一行：

    require 'vendor/autoload.php';  
    
# 模块仓库
[packagist.org][Packagist] 是Composer的仓库，很多著名的 PHP 库都能在其中找到。你也可以提交你自己的作品。

# 高级特性
Composer 还有一些[高级特性](http://www.phpcomposer.com/5-features-to-know-about-composer-php)，虽然不是必需的，但是往往能给 PHP 开发带来方便。

# 几个小技巧

### 1. 仅更新单个库

    composer update foo/bar  
    
### 2. 不编辑composer.json的情况下安装库

你可能会觉得每安装一个库都需要修改composer.json太麻烦，那么你可以直接使用require命令。

    composer require "foo/bar:1.0.0"  

这个方法也可以用来快速地新开一个项目。init命令有--require选项，可以自动编写composer.json：（注意我们使用-n，这样就不用回答问题）

    $ composer init --require=foo/bar:1.0.0 -n
    $ cat composer.json
    {
        "require": {
            "foo/bar": "1.0.0"
        }
    }
    
### 3. create-project

    composer create-project doctrine/orm path 2.2.0  
    
这会自动克隆仓库，并检出指定的版本。克隆库的时候用这个命令很方便，不需要搜寻原始的URI了。

### 4. 考虑缓存，dist包优先

最近一年以来的Composer会自动存档你下载的dist包。默认设置下，dist包用于加了tag的版本，例如"symfony/symfony": "v2.1.4"，或者是通配符或版本区间，"2.1.*"或">=2.2,<2.3-dev"（如果你使用stable作为你的minimum-stability）。

dist包也可以用于诸如dev-master之类的分支，Github允许你下载某个git引用的压缩包。为了强制使用压缩包，而不是克隆源代码，你可以使用install和update的--prefer-dist选项。

下面是一个例子（我使用了--profile选项来显示执行时间）：

    $ composer init --require="twig/twig:1.*" -n --profile
    Memory usage: 3.94MB (peak: 4.08MB), time: 0s

    $ composer install --profile
    Loading composer repositories with package information  
    Installing dependencies  
      - Installing twig/twig (v1.12.2)
        Downloading: 100%

    Writing lock file  
    Generating autoload files  
    Memory usage: 10.13MB (peak: 12.65MB), time: 4.71s

    $ rm -rf vendor

    $ composer install --profile
    Loading composer repositories with package information  
    Installing dependencies from lock file  
      - Installing twig/twig (v1.12.2)
        Loading from cache

    Generating autoload files  
    Memory usage: 4.96MB (peak: 5.57MB), time: 0.45s  
    
这里，twig/twig:1.12.2的压缩包被保存在~/.composer/cache/files/twig/twig/1.12.2.0-v1.12.2.zip。重新安装包时直接使用。

### 5.为生产环境作准备

在部署代码到生产环境的时候，别忘了优化一下自动加载：

    composer dump-autoload --optimize  
安装包的时候可以同样使用--optimize-autoloader。不加这一选项，你可能会发现20%到25%的性能损失。

如果你需要帮助，或者想要了解某个命令的细节，你可以阅读官方文档或者中文文档，也可以查看JoliCode做的这个[交互式备忘单](http://composer.json.jolicode.com/)。

# 参考资料

* [Composer 中文文档 - Github](https://github.com/5-say/composer-doc-cn)
* [Composer 命令行](http://docs.phpcomposer.com/03-cli.html#create-project)

[composer-cn]: https://github.com/5-say/composer-doc-cn
[getcomposer]: https://getcomposer.org/
[Packagist]: https://packagist.org/
