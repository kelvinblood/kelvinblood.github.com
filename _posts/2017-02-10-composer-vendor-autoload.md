---
layout: post
title: composer install update 报错需要 vendor autoload.php
category: tech
tag: composer
---

先说一下背景。这些天在整一些laravel底层架构。今天composer update了某个包，报错。因为是实验性的，所以也没怎么注意，删掉vendor重新install一下呗。转念一想，顺便把composer.lock也重新构建一下吧。

然后。

就嗝屁了。

    Warning: require(vendor/autoload.php): failed to open stream: No such file or directory in 
    
总之得出来的一个教训就是，composer.lock和vendor不能同时删除。

也找到了之前一个[配置](/tech/2017/01/16/php-laravel-composer-update-trap.html)谜之被删的原因了：[Remove-pre-update-cmd][Removepreupdatecmd]


# 参考资料

* [Fail to install laravel with the latest version composer](https://github.com/composer/composer/issues/5066)
* [Composer install failing, vendor folder missing](https://laracasts.com/discuss/channels/laravel/composer-install-failing-vendor-folder-missing)
* [php composer 自动加载机制的疑惑之处](https://www.oschina.net/question/914024_244803)




[Removepreupdatecmd]: https://github.com/laravel/laravel/pull/3687


