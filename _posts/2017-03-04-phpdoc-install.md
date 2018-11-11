---
layout: post
title: PHPDoc 介绍与安装
category: tech
tags: php
---
![](https://cdn.kelu.org/blog/tags/php.jpg)

PHPDoc是一个用PHP写的强大的文档自动生成工具，对于有规范注释的php程序，能够快速生成具有结构清晰、相互参照、索引等功能的API文档。

PHPDoc的原理是: 扫描指定目录下面的php源代码，扫描其中的关键字，截取需要分析的注释，然后分析注释中的专用的tag，生成xml文件，接着根据已经分析完的类和模块的信息，建立相应的索引，生成xml文件对于生成的xml文件，使用定制的模板输出为html文件。 

目前，PHPDoc的分析结果可以以HTML形式表现，由于使用了模板机制，可以很方便地定制风格。同时也提供了相应的接口，可以把API文档生成其他的形式，比如PDF，LATEX，WORD等。

以下是我的安装和使用过程。 

# 增加php环境依赖

PHPDoc 依赖于 xsl 和 intl 插件，如果 php.ini 没有打开这两个插件的话要预先打开。当然也可以直接跳过，后边安装不了会弹出错误的，例如：

    phpdocumentor/template-zend 1.3.2 requires ext-xsl * -> the requested PHP extension xsl is missing from your system.
    zendframework/zend-i18n 2.1.6 requires ext-intl * -> the requested PHP extension intl is missing from your system.

找到你的 php.ini 文件，新增

    extension=php_xsl.dll
    extension=php_intl.dll

PHPDoc安装方式有三种

1. PEAR
1. PHAR
1. Composer

composer方式尝试之后发现与其它插件依赖冲突，[Can't install with Composer - github issues][composer_conflict],于是换用了 PEAR 方式。其他方式也可以参考[官网][phpdoc_install]

# 安装PEAR

下载文件 <http://pear.php.net/go-pear.phar> 放到 php 目录下。使用管理员权限下打开 cmd/powershell，执行 

    php go-pear.phar

一路回车即可。这个安装会询问几个问题，主要意思是

* 以全局模式安装或者本地模式拷贝(应该是绿色安装不写入注册表的意思)
* 确认安装目录
* 确认修改 php.ini 文件

安装完成后提示注册环境变量。在安装目录下会生成 pear_env.reg 文件，双击即可。然后检查是否安装成功：

    pear -h

最后注册pear的channel(不知道怎么翻译比较好了)
    
    pear channel-discover pear.phpdoc.org

# 安装 PHPDoc

    pear install phpdoc/phpdocumentor

于是就安装完成了。

# PHPDoc的简单使用

最简单的命令是：

    phpdoc -d [SOURCE_PATH] -t [TARGET_PATH]
    
    -d  这个目录代表着需要生成文档的原始php文件目录（注意是目录） 
    -t  这个目录代表着生成的文档存放目录

例如：

    phpdoc -f baseTags.php -t docs

搭起服务器就可以访问了。或者直接本地打开index.html文件也可以查看。

要想获得更多参数说明， `phpdoc -h`即可。因为phpdoc可以使用模板，可以在官网上选择你中意的模板再导出。默认的样式如下图：

![](https://cdn.kelu.org/blog/2017/03/clean.jpg)

tips：phpdoc的中文文档真的很少，要深入使用还是尽量在官网上看。
    
# 小问题    

* GraphViz not installed

    在终端运行phpdoc时你可能会遇到如下问题(略过不解决也没问题的样子)：
        
        Unable to find the `dot` command of the GraphViz package. Is GraphViz correctly installed and present in your path?
    
    这是由于系统没有安装 GraphViz 的原因。官网上下载GraphViz：<http://www.graphviz.org/Download_windows.php>
    然后增加环境变量，例如我的是 `C:\my_pp\Graphviz2.38\bin`

* Phpdoc No Summary found for this file
  
    在生成的文档页面中会有错误提示。其中有一个诡异的错误
  
        Type        Line    Description
        error       0       No summary was found for this file  
    
    具体的原因这个 Stackoverflow 回答的很好 —— [《Phpdoc No Summary found for this file》][stack]。以下是我的解决办法，在文件头部加上如下信息:

        /**
         * Class Category | Notification/NtCenter.php
         *
         * @package App\Notification\Models
         * @author kelvinblood <admin@kelu.org>
         * @version     v0.0.1 (2017-3-6)
         * @copyright   Copyright (c) 2017, kelu.org
         */


# 参考资料

* [PHPDoc 官网](https://phpdoc.org)
* [pear：使用phpdoc轻松建立你的pear文档 - ibm](https://www.ibm.com/developerworks/cn/linux/sdk/php/pear3/)
* [windows下安装PHPDoc(phpdoc)笔记](http://www.cnblogs.com/52fhy/p/3979894.html)
* [Creating PHP Documentation Comments - intellij idea](https://www.jetbrains.com/help/idea/2016.3/creating-php-documentation-comments.html)
* [Phpdoc No Summary found for this file][stack]

[phpdoc_install]: https://www.phpdoc.org/docs/latest/getting-started/installing.html
[composer_conflict]: https://github.com/phpDocumentor/phpDocumentor2/issues/1738
[stack]: http://stackoverflow.com/questions/21312643/phpdoc-no-summary-found-for-this-file