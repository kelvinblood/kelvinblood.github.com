---
layout: post
title: laravel phpunit中使用namespace
category: tech
tags: test laravel phpunit
---

![](https://cdn.kelu.org/blog/tags/phpunit.jpg)

原先项目并没有做单元测试。今天写了几个hello world，发现使用 namespace 时候报错

    PHP Fatal error:  Class 'Tests\TestCase' not found in C:\Workspace\xxx\tests\Unit\ExampleTest.php on line 10
    
解决办法：
    
    修改composer.json，增加如下设置：
   
    "autoload-dev": {
       "psr-4": {
           "Tests\\": "tests"
       }

修改完成后 composer install 重新加载项目即可。

关于新增的autoload-dev的作用，以及composer.json文件的解释，下篇文章写一个。

# 参考资料

* [Trait not found inside Laravel 5 unit tests](http://stackoverflow.com/questions/31253706/trait-not-found-inside-laravel-5-unit-tests)
* [Laravel 5 Unit Testing and Namespacing](http://stackoverflow.com/questions/29500549/laravel-5-unit-testing-and-namespacing)
* [深入 Composer autoload](https://laravel-china.org/topics/1002)
* [Using namespace with Laravels TestCase (integrated testing)](https://laracasts.com/discuss/channels/testing/using-namespace-with-laravels-testcase-integrated-testing)
* [testing laravel-china](https://laravel-china.org/docs/5.1/testing)
