---
layout: post
title: laravel 下正确添加扩展包
category: tech
tags: laravel php composer qiniu
---

![](https://cdn.kelu.org/blog/tags/laravel.jpg)

我们经常要往现有的项目中添加扩展包，有时候因为编码人员还不了解 Laravel，在一些不良开发文档的引导下，如下图来自 [七牛云][qiniu] ，

![](https://cdn.kelu.org/blog/2017/01/20170118235957.jpg)

又或者像这样:

![](https://cdn.kelu.org/blog/2017/01/201701J6xjZS0kx4.jpg)

前者，不经由 Laravel，使用原生 Composer， 舍弃了包的管理，显然有问题。后者，在现在的逻辑中，可能会对项目造成巨大的伤害——这个是一次性把所有扩展包更新到最新版本（避免这个问题可以针对单独一个包进行 update，或者在 composer.json 中指定版本号）。

所以今天好好看了下 composer 在 laravel 项目下的一些配置。




# composer 命令

先简单解释下 composer 命令。

* `composer install` - 如有 composer.lock 文件，直接安装，否则从 composer.json 安装最新扩展包和依赖；
* `composer update` - 从 composer.json 安装最新扩展包和依赖；
* `composer update vendor/package` - 从 composer.json 或者对应包的配置，并更新到最新；
* `composer require new/package` - 添加安装 new/package, 可以指定版本，如： `composer require new/package ~2.5`.

更多详情可以查看 [Composer官方网站][composer_url]，或对应的[中文网站][composer_url_cn]。


# 流程 

新项目:

* composer install，安装扩展包并生成 composer.lock；

协作项目:

* composer install

添加新扩展包:

* composer require vendor/package 添加扩展包

需要加版本的话 `composer require "foo/bar:1.0.0"`


# 关于 composer.lock

composer.lock 文件里保存着对每一个代码依赖的版本记录，配合 composer install 使用，保证了团队所有协作者开发环境、线上生产环境中运行的代码版本的一致性。

# 关于 composer.json

相关文档在 Composer 的官方文档[scripts][composer_scripts]里有详细讲解。

其实从命名里也能看出端倪了。

这是我们项目中的配置

    {
        "name": "xxx/webapp",
        "type": "project",
        "repositories": [
            {
                "type": "vcs",
                "url": "https://git.oschina.net/xxx/xxx.git"
            }
        ],
        "require": {
            "php": ">=5.5.9",
            "laravel/framework": "5.1.*",
            "ramsey/uuid": "3.0.*",
            "rmccue/requests": "1.6.*",
            "doctrine/dbal": "2.5.*",
            "sinergi/browser-detector": "5.1.*",
            "intervention/image": "2.3.*",
            "apkj/webframework": "dev-dev",
            "ignited/laravel-omnipay": "2.*",
            "lokielse/omnipay-alipay": "dev-master",
            "predis/predis": "1.0.*",
            "qiniu/php-sdk": "v7.0.8"
        },
        "require-dev": {
            "fzaninotto/faker": "~1.4",
            "mockery/mockery": "0.9.*",
            "phpunit/phpunit": "~4.0",
            "phpspec/phpspec": "~2.1"
        },
        "autoload": {
            "classmap": [
                "database"
            ],
            "psr-4": {
                "App\\": "app/"
            }
        },
        "autoload-dev": {
            "classmap": [
                "tests/TestCase.php"
            ]
        },
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
        "config": {
            "preferred-install": "dist",
            "secure-http": false
        }
    }

特别说明的一点是 `"secure-http": false`,因为某些包的 https 下载速度实在是太慢了。。。。。
特别说明的一点是 `"secure-http": false`,因为某些包的 https 下载速度实在是太慢了。。。。。

# 错误定位

今天 `composer update` 时发生了这样一个错误：

    PHP Fatal error:  Class Illuminate\Cache\FileStore contains 2 abstract methods and must therefore 
    be declared abstract or implement the remaining methods (Illuminate\Contracts\Cache\Store::many, 
    Illuminate\Contracts\Cache\Store::putMany) in 

其实不是今天了，很久前就出现这个问题了。因为平时都是针对单个包update，所以并不会产生什么影响，也没去解决，一直拖到了现在。

但是事实上在项目的早期是没有这个问题的，于是慢慢回溯查看。终于找到了罪魁祸首！

![](https://cdn.kelu.org/blog/2017/01/20170119004132.jpg)

现在已经不记得当时为什么要如此更改了。总之目前将划线的内容改为了

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

# 参考资料
# 参考资料

* [正确的 Composer 扩展包安装方法 - laravel china](https://laravel-china.org/topics/1901)

[qiniu]: http://developer.qiniu.com/code/v7/sdk/php.html
[composer_url_cn]: http://www.phpcomposer.com/
[composer_url]: http://getcomposer.org/
[composer_scripts]: https://getcomposer.org/doc/articles/scripts.md

