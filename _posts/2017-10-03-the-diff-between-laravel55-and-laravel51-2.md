---
layout: post
title: 从 laravel 中文文档查看 5.5 相对 5.1 中的变动  (2)
category: tech
tags: php laravel
---
![](https://cdn.kelu.org/blog/tags/laravel.jpg)

这篇主要对比 laravel 5.5相对5.1 的各模块功能的不同，从 5.5 的目录来看是从`安全相关`到`官方扩展包`的内容。

上一篇在这里[从 laravel 中文文档查看 5.5 相对 5.1 中的变动  (1)
](/tech/2017/10/02/the-diff-between-laravel55-with-laravel51.html)

相同的部分我就不多赘述了，大部分只点出目前看到的不同的地方。当前本文的修改时间是 2017-10-03 15:28:41。

查阅的 laravel 手册为：
* [5.5](https://d.laravel-china.org/docs/5.5/) 
* [5.1](https://d.laravel-china.org/docs/5.1/)

# Artisan 命令行工具

## Laravel REPL

所有 Laravel 应用都包含了 Tinker。 `Tinker` 让你可以在命令行中与你整个的 Laravel 应用进行交互，包括 Eloquent ORM、任务、事件等等。运行 Artisan 命令 `tinker` 进入 Tinker 环境：

```php
php artisan tinker
```
# 事件

除了广播变化非常大之外，其它没有什么变化。5.5文档把广播从事件里单独拎出来了。

# 广播

相对于5.1变化的蛮大的，主要因为是增加了 laravel echo，广播的实现变得非常简单 。等到我需要实践的时候再去看好了。

直达链接: [广播系统](https://d.laravel-china.org/docs/5.5/broadcasting)

# 缓存

感觉没什么变化 Orz

# 集合

增加了很多方法。
直达链接: [Collection](https://d.laravel-china.org/docs/5.5/collection)

# 文件系统

保存文件这一块多了文件流式传输的方法：

```php
use Illuminate\Http\File;

// 自动为文件名生成唯一的 ID...
Storage::putFile('photos', new File('/path/to/photo'));

// 手动指定文件名...
Storage::putFileAs('photos', new File('/path/to/photo'), 'photo.jpg');
```
`putFile` 方法将生成唯一的 ID 作为文件名。

在文件上传部分贴心了很多。5.1时候自定义了不少这方面的处理，5.5 直接帮我们完善了：

Request 可以直接用 store 方法保存文件。`store` 也生成唯一的 ID 来作为文件名。

```php
    public function update(Request $request)
    {
        $path = $request->file('avatar')->store('avatars');

        return $path;
    }
```
或者Request 的 storeAs，也可以用 Storage 的 putFileAs，效果一样

```php
$path = $request->file('avatar')->storeAs(
    'avatars', $request->user()->id
);

$path = Storage::putFileAs(
    'avatars', $request->file('avatar'), $request->user()->id
);
```
文件可以被声明为 `public` 或 `private`。不过具体的业务处理，就得自己去完善了。

# 辅助函数

多了不少

### 数组
* array_last
* array_prepend
* `array_wrap` 函数将给定的值包装成一个数组。如果给定的值已经是一个数组，则不会被改变

### 路径
* mix
* `resource_path` 函数返回 `resources` 目录的完整路径。

### 字符串
* `kebab_case` 函数将给定的字符串转换为 `短横线隔开式`
* `e`(并不是新增的) 函数使用 PHP 函数 `htmlspecialchars` 并且 `double_encode` 选项设置为 `false`
* `str_after`
* `str_before` 
* `title_case` 函数将给定的字符串转换为 `每个单词首字母大写`

### url
* `secure_url` 函数为给定的路径生成一个完整的 HTTPS URL 路径

### 其他
* `abort` 函数将会抛出一个 HTTP 异常并且由异常处理程序处理
* `abort_if`
* `abort_unless`
* `dispatch` 函数将一个新的任务推送到 Laravel 任务列队
* `logger` 函数可以将一个 `debug` 级别的消息写入到日志中
* `report` 函数将使用异常处理程序的 `report` 方法抛出异常
* `retry` 函数尝试执行给定的回调，直到到达给定的最大尝试次数。

# 邮件

在 Laravel 5.5 中，每种类型的邮件都代表一个「Mailable」对象。这些对象存储在 `app/Mail` 目录中。


```php
php artisan make:mail OrderShipped
```
并且支持 markdown 格式。

```php
php artisan make:mail OrderShipped --markdown=emails.orders.shipped
```
并且支持预览：

```php
Route::get('/mailable', function () {
    $invoice = App\Invoice::find(1);

    return new App\Mail\InvoicePaid($invoice);
});
```
# 通知

laravel 5.5 强化了它的通知功能。以前只有邮件功能，现在还增加了短信和 Slack 功能，可喜可贺。（我在5.1的时候是借用了 slaask 实现的通知）

```php
php artisan make:notification InvoicePaid
```
更加详细的可以直接参考文档，[直达链接](https://d.laravel-china.org/docs/5.5/notifications)

# 扩展插件开发

这一块不熟悉，应该变化不大。

扩展包是添加功能到 Laravel 的主要方式。扩展包可以包含许多好用的功能，像 [Carbon](https://github.com/briannesbitt/Carbon) 可用于处理时间，或像 [Behat](https://github.com/Behat/Behat) 这种完整的 BDD 测试框架。

# 队列

没有变化。

# 任务调度

也没有变化。

# 数据库

## 死锁

`transaction` 方法接受一个可选的第二个参数，该参数定义在发生死锁时，应该重新尝试事务的次数。一旦这些尝试都用尽了，就会抛出一个异常：

```php
DB::transaction(function () {
    DB::table('users')->update(['votes' => 1]);

    DB::table('posts')->delete();
}, 5);
```
构造器、分页没有什么变化，`paginate`一波流。

数据库迁移部分，没有变化，但解释的更详细一些，尤其是终于给出了哪些字段类型不能修改了。以前修改老是失败，导致我再也不用官方提供的 change 方法，只用原生的SQL 语句。

seeder 也没变化。

## API

laravel 5.5 增加了资源类这样一个说法，具体到业务上，就是可以快速将模型和模型集合转换成 json。

在使用 laravel5.1时，后台经常需要从数据库中取出数据，toArray，最后在返回给前端。有了这个资源类，就不需要那么麻烦了。

这是一个全新的东西，打开文档好好看把。[直达链接](https://d.laravel-china.org/docs/5.5/eloquent-resources)

```php
php artisan make:resource User
php artisan make:resource Users --collection
```

# redis

了解不多，主要是作为 NoSQL，加速网站的，有自定义需要的最好还是看一下。[直达链接](https://d.laravel-china.org/docs/5.5/redis)

# 测试相关

这一块文档主要是讲了 phpunit 一波流作为单元测试的方法，数据库测试的辅助函数以及一些模拟测试的工具，另外增加了 laravel Dusk 作为 BDD 测试框架。

我已经习惯了 Selenium 框架，这一部分就过了一眼。

# 官方扩展包

在5.1时代，社区就呈现出来好多有用的扩展，官方把他们好多直接升格为官方推荐了^_^，都过一遍。

* 收费系统 Cashier
	对国内用户可能不太适用，还是 pass 吧。

* 部署工具 [Laravel Envoy](https://github.com/laravel/envoy) 	
	在远程服务器上运行通用任务。可以很方便的启动任务来进行项目部署、Artisan 命令运行等操作。

* 队列监控面板 - Horizon
	一个可以通过代码进行配置、并且非常漂亮的仪表盘，并且能够轻松监控队列的任务吞吐量、执行时间以及任务失败情况等关键指标。

* API 认证系统 Passport

	太棒了这个东西。使用 Passport 可以轻而易举地实现 API 授权认证，Passport 可以在几分钟之内为你的应用程序提供完整的 OAuth2 服务端实现。

* 全文搜索系统 Scout

	Laravel Scout 为 [Eloquent 模型](https://d.laravel-china.org/docs/5.5/eloquent) 的全文搜索提供了一个简单的、基于驱动程序的解决方案。使用模型观察员，Scout 会自动同步你的搜索索引和 Eloquent 记录。

	目前，Scout 自带了一个 [Algolia](https://www.algolia.com/) 驱动；而编写自定义驱动程序很简单，你可以自由地使用自己的搜索实现来扩展 Scout。

* 社会化登录

	又一个超级棒的东西，可惜好像只支持国外的 SNS。

	Laravel 社会化登录通过 Facebook ， Twitter ，Google ，LinkedIn ，GitHub 和 Bitbucket 提供了一个富有表现力的，流畅的 OAuth 身份验证界面。它几乎能处理所有你害怕处理的各种样板社会认证代码。

# 安全相关

## 用户认证

没变化

## API 认证

见上面插件部分的描述

## 用户授权

这个是 laravel5.5 的新特性。有 gates 和策略 2 种主要方式来实现用户授权。

Gates类似于路由，策略类似于控制器。Gates 提供了一个简单的、基于闭包的方式来授权认证。策略则在特定的模型或者资源中通过分组来实现授权认证的逻辑。

Gates 大部分应用在模型和资源无关的地方，比如查看管理员的面板。与之相反，策略应该用在特定的模型或者资源中。

## 加密解密机制

Laravel 使用 OpenSSL 提供 AES-256 和 AES-128 的加密。

比起 5.1 没有变化，开箱即用不需要修改。

# 结论

两天时间看完文档，大致弄懂了Laravel5.5的功能。进步真的蛮大的。我准备写一两个小网站，希望大家也来用 Laravel，为社区贡献一些力量^_^。

# 参考资料

* [laravel 5.5](https://d.laravel-china.org/docs/5.5/) 
