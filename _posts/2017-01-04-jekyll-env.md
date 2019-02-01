---
layout: post
title: Jekyll Windows 环境配置
category: tech
tags: jekyll dev github mac windows
---

昨天配好了Mac下的开发环境。记录下一些问题。

### 安装 Ruby

<http://rubyinstaller.org/downloads/>

就目前来说，下文的 DevKit 因为仅支持ruby 2.3，所以不要安装高于2.3的版本。

完成后进入“CMD”输入“**ruby -v**”如显示版本则代表安装成功。

如果Ruby环境变量没有添加，后把安装目录下的 Bin 目录添加到系统Path环境变量即可。

### 安装 DevKit

DevKit 是一个在 Windows 上帮助简化安装及使用 Ruby C/C++ 扩展如 RDiscount 和 RedCloth 的工具箱。

下载与 Ruby 版本相对应的 DevKit 安装包：<http://rubyinstaller.org/downloads/>



把 DevKit 解压到某个目录，运行：

```shell
ruby dk.rb init
ruby dk.rb install
```



### 安装 Jekyll

首先确保 gem 已经正确安装

```
//命令输入
gem -v
//输出
2.2.2
```

```shell
gem install jekyll
```

### 安装 Python
<https://www.python.org/>

使用2.7的版本，安装完成后把 Python 安装目录和 Scripts 目录添加到系统Path环境变量中。

## 安装 Rouge

一般来说静态生成中经常会使用高亮代码等功能，而高亮代码的生成一般需要插件帮助完成才行。

在常规中一般都是使用：“Pygments”；因为”Pygments“是python下面的插件，所以需要先安装Python之后才能安装该插件，我嫌麻烦在实际使用中采用的是”Rouge“高亮插件。 
之所以使用：”Rouge”，是因为在 Jekyll 官网中也曾提到以后将会使用该插件。 

```
gem install jekyll-paginate
gem install rouge
```

# 问题定位

### jekyll-paginate

Q：It looks like you don't have jekyll-paginate or one of its dependencies installed
    
A：在 Gemfile 文件中添加如下内容：

    gem 'jekyll-paginate', group: :jekyll_plugins

   

### gems renamed to plugins

Q: Configuration file: D:/GitHub/kelvinblood.github.com/_config.yml                                                                                              Deprecation: The 'gems' configuration option has been renamed to 'plugins'. Please update your config file accordingly.

A：在 _config.yml 文件中修改如下内容：

```
# gems: [jekyll-paginate]
plugins: [jekyll-paginate]
```

### gem install tzinfo

Q: Dependency Error: Yikes! It looks like you don't have tzinfo or one of its dependencies installed.

```
gem install tzinfo
gem install tzinfo-data
```

 

### Gemfile

Q：在 Mac 下运行得好好的，Windows 下不能运行，报错。

    C:/Ruby23-x64/lib/ruby/2.3.0/rubygems/core_ext/kernel_require.rb:55:in `require': cannot load such file -- bundler (LoadError)
        from C:/my_pp/Ruby23-x64/lib/ruby/2.3.0/rubygems/core_ext/kernel_require.rb:55:in `require'
        from C:/my_pp/Ruby23-x64/lib/ruby/gems/2.3.0/gems/jekyll-3.2.1/lib/jekyll/plugin_manager.rb:34:in `require_from_bundler'
        from C:/my_pp/Ruby23-x64/lib/ruby/gems/2.3.0/gems/jekyll-3.2.1/exe/jekyll:9:in `<top (required)>'
        from C:/my_pp/Ruby23-x64/bin/jekyll:23:in `load'
        from C:/my_pp/Ruby23-x64/bin/jekyll:23:in `<main>'

A：Windows 下删除 Gemfile 文件即可。


### `jekyll-paginate` gem

Deprecation: You appear to have pagination turned on, but you haven't included the `jekyll-paginate` gem. Ensure you have `plugins: [jekyll-paginate]` in your configuration file. 



```
gem install jekyll-paginate
```

# 常用命令

安装完成后，使用

    jekyll serve --incremental

运行项目，只改变修改的文章内容，加快运行速度。毕竟平时也就修改文章内容，不会改变系统配置。

参考资料：

* [Running Jekyll on Windows](http://www.madhur.co.in/blog/2011/09/01/runningjekyllwindows.html)
* [jekyllcn.com](http://jekyllcn.com)
* [jekyll-paginate issue](https://github.com/jekyll/jekyll/issues/4124)
* [Jekyll/Liquid API 语法文档 - Alfred Sun](http://alfred-sun.github.io/blog/2015/01/10/jekyll-liquid-syntax-documentation/)
* [Liquid 基础篇 - 波波的个人主页](https://lsbbd.github.io/2016/08/26/liquid-basic/#liquid)
* [add possibility to convert string to number](https://github.com/Shopify/liquid/issues/130)
* [给jekyll增加自定义分页](http://www.oushit.com/technology/2014/11/03/add-postpager-for-jekyll.html)