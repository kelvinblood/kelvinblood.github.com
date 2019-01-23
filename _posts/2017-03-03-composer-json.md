---
layout: post
title: composer.json 配置文件说明
category: tech
tags: laravel composer
---

![](https://cdn.kelu.org/blog/tags/composer.jpg)

Java有Maven, Node.js有npm, ROR有gem,PHP有composer. 他们都是各个语言的包管理器。

下面将以一个composer.json为例，简单介绍Composer的使用方法。完整的文档可以查看最后的参考资料。

    {
    // ================================ 配置文件 ================================
        "name":             "kelu/app",
        "description":      "血衫非弧的app",
        "keywords":         ["kelvinblood", "kelu", "app"],
        "homepage":         "http://app.kelu.org ",
        "time":             "2016-12-30",
        "license":          "MIT",
        "authors": [{
            "name":         "Kelvin Blood",
            "email":        "xxx@xxx.org",
            "homepage":     "http://www.kelu.org",
            "role":         "CEO"
        }],
        "type": "project", // library project metapackage composer-plugin
        "repositories": [
            {
                "type": "vcs",
                "url": "https://git.oschina.net/apkj/phpwebframework.git"
            }
        ],
    // ================================ 依赖管理 ================================
    // === 默认情况下，composer只会获取稳定版本,修改后运行命令 composer install ===
        "require": {
            "php": ">=5.5.9",
            "laravel/framework": "5.1.*",
            "ignited/laravel-omnipay": "2.*",
            "lokielse/omnipay-alipay": "dev-master"
        },
    // === 有些包依赖只会在开发过程中使用，正式发布的程序不需要这些包，这个时候，就需要用到另外一个键，即require-dev。例如，我们用phpunit单元测试，那么就可以通过require-dev引入这个开发环境下的依赖包
        "require-dev": {
            "fzaninotto/faker": "~1.4",
            "mockery/mockery": "0.9.*",
            "phpunit/phpunit": "~4.0",
            "phpspec/phpspec": "~2.1"
        },
        
    // ================================ 自动加载 ================================
    // === 加载文件最简单的方式就是require或者include, autoload,顾名思义，就是自动加载. 
    // === 修改后，运行命令： composer dump-autoload, 让composer重建自动加载的信息
    // === composer 提供了4种自动加载类型 classmap psr-0 psr-4 files 
    // === files,对应的值是一个数组，数组元素是文件的路径，路径是相对于应用的根目录。
    // === classmap，会在背后就会读取这个文件夹中所有的文件 然后再 vendor/composer/autoload_classmap.php 中怒将所有的 class 的 namespace + classname 生成成一个 key => value 的 php 数组.缺点是一旦增加了新文件，需要执行dump-autoload命令重新生成映射文件。
    // === psr-0 现在这个标准已经过时
    // === psr-4 支持将命名空间映射到路径。命名空间结尾的\\不可省略。当执行install或update时，加载信息会写入vendor/composer/autoload_psr4.php文件。如果希望解析指定路径下的所有命名空间，则将命名空间置为空串即可。
        "autoload": {
         "files":["lib/OrderManager.php"],
            "classmap": [
                "database"
            ],
             // FIG组织制定的一组PHP相关规范，简称PSR，其中PSR-0自动加载 PSR-1基本代码规范 PSR-2代码样式 PSR-3日志接口 PSR-4 自动加载
            "psr-4": {
                "App\\": "app/"         // 自动加载命名空间App,文件夹app里的文件
            }
        },
    // 和require-dev类似，只在开发过程中自动加载
        "autoload-dev": {
            "psr-4": {
                "Tests\\": "tests" // 自动加载Tests的命名空间
            }
        },
        
    // ================================ 脚本 ================================
    // === 在安装过程中的各个阶段挂接脚本。
        "scripts": {
            "post-install-cmd": [
                "php artisan clear-compiled",
                "php artisan optimize"
            ],
            "pre-update-cmd": [
                "php artisan clear-compiled"
            ],
            "post-update-cmd": [
                "php artisan clear-compiled",
                "php artisan optimize"
            ],
            "post-root-package-install": [
                "php -r \"copy('.env.example', '.env');\""
            ],
            "post-create-project-cmd": [
                "php artisan key:generate"
            ]
        },
        
    // ================================ 设置 ================================
        "config": {
            "preferred-install": "dist", //Composer 的默认安装方法。 source、dist 或 auto
            "secure-http": false
        }
    }

# 参考资料
# 参考资料

* [深入 Composer autoload](http://blog.hans-lizihan.com/php/2015/06/25/php-composer-autoload.html)
* [composer.json 架构](http://docs.phpcomposer.com/04-schema.html)
* [PHP的包依赖管理工具Composer简介](http://www.shipingzhong.cn/node/6403)
