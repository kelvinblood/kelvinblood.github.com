---
layout: post
title: Laravel 的一些小坑总结
category: tech
tags: php laravel trap
---

ps: 今天有个小新闻，央行终于对比特币出手了。话说去年今年的新闻真是各种好看各种兴奋。黑天鹅一大波，各种新东西出来。

Laravel 是 Taylor Otwell 开发的一款基于 PHP 语言的 Web 开源框架。由于 Laravel 具备 Rails 敏捷开发等优秀特质，并结合了 PHP 强大的扩展包（Composer）生态与 PHP 开发者广大的受众群，让 Laravel 在发布之后的短短几年时间得到了极其迅猛的发展。

通过 [Google Trends][google_trends] 提供的趋势图可以看出，Laravel 框架在过去十年，其增长速度在各类 PHP 框架中都是有史以来最快的，这也从正面直接反映出了 Laravel 的强大，以及其未来非常可观的发展前景。

![图1](https://cdn.kelu.org/blog/2017/01/20170111175437.jpg)

使用Laravel也有1年多的时间了。偶尔会出现点小问题，也总算是解决了。今后会慢慢总结一些。现在先说说昨天晚上遇到的坑。如果你看到这篇文章并且很巧的知道下文的一些坑的原理的话，欢迎留言或者邮件告诉我。





# 新建 model 的小坑

![图2](https://cdn.kelu.org/blog/2017/01/20170111175246.jpg)

Laravel 的 Eloquent ORM 提供了漂亮、简洁的 ActiveRecord 实现来和数据库进行交互。每个数据库表都有一个对应的「模型」可用来跟数据表进行交互。

然而当 new 一个新对象，并save到数据库时（第1第2步），如果不重新去数据库中 find 出来（第3步），则 Eloquent 中很多默认赋值的属性将不存在！比如说 created_at 等默认属性。

同事跟我说这是没有用好boot方法的原因，源码看少了。表示现在还不了解，接下来好好看了。


# DB::table 导致的std::function()不存在的小坑

起因是使用了DB::table方法，期望是获取Session的实例，在第二个标记处获得它的id。如图

![图3](https://cdn.kelu.org/blog/2017/01/20170112013145.jpg)

然而运行的时候，会报如下错误：

    exception 'Symfony\Component\Debug\Exception\FatalErrorException' with message 'Call to undefined method stdClass::getId()' in xxx.php:38
    Stack trace:
    #0 {main}

古狗大法终于出来了这个原因： [Call to undefined method stdClass][std_error]，原因就是 DB::table 会返回 StdClass objects 的集合，而不是 Session 这个实例的集合。std 显然没有 getId() 这个方法。修正的办法就是将 getId() 改为 id 即可,直接获取属性值。


[google_trends]: https://www.google.com/trends/explore?date=2006-08-16%202017-01-11&amp;q=yii,CodeIgniter,Cakephp,Laravel,%2Fm%2F09cjcl
[std_error]: http://laravel.io/forum/09-21-2014-call-to-undefined-method-stdclass
