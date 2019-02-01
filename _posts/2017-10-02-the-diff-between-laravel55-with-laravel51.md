---
layout: post
title: 从 laravel 中文文档查看 5.5 相对 5.1 中的变动  (1)
category: tech
tags: php laravel
---
![](https://cdn.kelu.org/blog/tags/laravel.jpg)

laravel 5.5也发布了一段时间了。 这是 laravel 第二个 LTS 版本，自然不能错过。实际上我也很少关注中间几个版本，并不了解它们增加了哪些东西。

趁着这个国庆把5.5的文档粗略看了一遍，以前对 laravel 多以应用为主，需要的时候才会去查，研究不算深，所以应该会有很多疏漏，或是错误，我也会不断修改过来，欢迎指正。

这篇主要对比一些基础性的不同，从 5.5 的目录来看是从`前言`到`前端开发`的内容。

下一篇在这里[从 laravel 中文文档查看 5.5 相对 5.1 中的变动  (2)
](/tech/2017/10/03/the-diff-between-laravel55-and-laravel51-2.html)


当前本文的修改时间是2017-10-03 15:27:29

![](https://cdn.kelu.org/blog/2017/10/larvave_category.jpg)

相同的部分我就不多赘述了，大部分只点出目前看到的不同的地方。

查阅的 laravel 手册为：
* [5.5](https://d.laravel-china.org/docs/5.5/) 
* [5.1](https://d.laravel-china.org/docs/5.1/)

# 目录

刚开始看目录的时候，乍看之下觉得怎么多了这么多东西。实际上5.5的文档将很多原本属于5.1文档中属于系统服务的东西抽出来组成新的主题，所以显得比较多。

另外文档主题的顺序更合理一些，比如文件夹结构的内容就放到了入门指南里，易于新手入门，快速掌握。

# 安装部署

这一部分没太大的变化，主要是环境依赖有变化：

* php 必须7.0.0以上
* 多了『PHP XML 扩展』的依赖。

对于 Mac 的开发环境，多提供了一个 「Valet」环境。

5.5的文件目录新增了几个(有些也可能以前有，我没使用 Orz)：

* 路由，从 http 目录下的单个文件 routes.php 变成与 app 目录平级的 `\routes` 目录
* 邮件的逻辑，`app\Mail` 目录
* 应用授权策略，`app\Policies` 目录
* 自定义验证规则对象，`app\Rules` 目录
* 「事务性」通知，`app\Notifications` 目录

文档还给了一个更加详细的 Nginx 的配置案例，可以看一下。

# 核心架构

了解5.1的基本不用看了。毕竟核心架构也不可能有多大变化。

	* 请求周期
	* Container
	* Provider
	* Facades
	* Contracts

# 基本功能

	* 路由			
	* 中间件		
	* CSRF 保护 	
	* 控制器				
	* 请求				
	* 响应
	* 视图
	* URL
	* Session
	* 表单验证
	* 错误与日志

## 路由

### 路由方法

路由参照 RESTful API，实现了里边常用的请求类型(除了 head，用的少就没所谓了),5.1只实现了 get 和 post：

```php
Route::get($uri, $callback);
Route::post($uri, $callback);
Route::put($uri, $callback);
Route::patch($uri, $callback);
Route::delete($uri, $callback);
Route::options($uri, $callback);
```
csrf 跟以前一样

### 检查当前路由`named`

```php
public function handle($request, Closure $next)
{
    if ($request->route()->named('profile')) {
        //
    }

    return $next($request);
}
```
### 路由命名空间`namespace`

```php
Route::namespace('Admin')->group(function () {
    // 在 "App\Http\Controllers\Admin" 命名空间下的控制器
});
```
### 路由模型绑定

增加了隐式绑定，还可以自定义键名，比较复杂，可以点击这里直接查看手册 <https://d.laravel-china.org/docs/5.5/routing#route-model-binding>

```php
Route::get('api/users/{user}', function (App\User $user) {
    return $user->email;
});
```
### 访问当前路由

```php
$route = Route::current();

$name = Route::currentRouteName();

$action = Route::currentRouteAction();
```
## 控制器

# __invoke()

单个行为控制器
```php
class ShowProfile extends Controller
{
    /**
     * 展示给定用户的信息。
     */
    public function __invoke($id)
    {
        return view('user.profile', ['user' => User::findOrFail($id)]);
    }
}
```
### 资源控制器

5.1就存在了，不过一直没怎么用。比较复杂，包括资源路由、本地化 uri 等等，可以直接看文档: <https://d.laravel-china.org/docs/5.5/controllers#resource-controllers>

## 请求

有很多5.1就存在的实用的方法，列一下：

```php
$uri = $request->path();

if ($request->is('admin/*')) {
    //
}

// Without Query String...
$url = $request->url();

// With Query String...
$url = $request->fullUrl();
```
关于旧输入也列一下：

```php
$username = $request->old('username');

# 前端中使用：

old('username')
```
### 文件

终于有了文件扩展名的判断了，感谢！

```php
$path = $request->photo->path();

$extension = $request->photo->extension();
```
存储文件的方法也有了改变：

```php
$path = $request->photo->store('images');

$path = $request->photo->store('images', 's3');


$path = $request->photo->storeAs('images', 'filename.jpg');

$path = $request->photo->storeAs('images', 'filename.jpg', 's3');
```
### 配置 TLS/SSL

这一块没有在5.1用过。

在 Laravel 应用程序中包含 `App\Http\Middleware\TrustProxies` 中间件，快速自定义应用程序信任的负载均衡器或代理，还可以配置代理发送包含原始请求信息的请求头：

```php
<?php

namespace App\Http\Middleware;

use Illuminate\Http\Request;
use Fideloper\Proxy\TrustProxies as Middleware;

class TrustProxies extends Middleware
{
    /**
     * 这个应用程序的可信代理列表
     *
     * @var array
     */
    protected $proxies = [
        '192.168.1.1',
        '192.168.1.2',
    ];

    /**
     * 当前代理响应头映射关系
     *
     * @var array
     */
    protected $headers = [
        Request::HEADER_FORWARDED => 'FORWARDED',
        Request::HEADER_X_FORWARDED_FOR => 'X_FORWARDED_FOR',
        Request::HEADER_X_FORWARDED_HOST => 'X_FORWARDED_HOST',
        Request::HEADER_X_FORWARDED_PORT => 'X_FORWARDED_PORT',
        Request::HEADER_X_FORWARDED_PROTO => 'X_FORWARDED_PROTO',
    ];
}
```
## 验证

# bail 规则

使得在某个属性第一次验证失败后停止运行验证规则：

```php
$this->validate($request, [
    'title' => 'bail|required|unique:posts|max:255',
    'body' => 'required',
]);
```
## 错误日志

最大的变化就是——终于可以根据log_level的配置，只打印对应级别的日志了。

```php
'log_level' => env('APP_LOG_LEVEL', 'error'),
```
## 模板

新增好几个命令。

// unless 不是新增的

```php
@unless (Auth::check())
    你尚未登录。
@endunless
```
### `@isset` 
```php
@isset($records)
    // $records 被定义并且不为空...
@endisset

@empty($records)
    // $records 是「空」的...
@endempty
```
### `@auth` 和 `@guest`

```php
@auth
    // 用户已经通过身份认证...
@endauth

@guest
    // 用户没有通过身份认证...
@endguest
```
### loop 循环变量

`$loop` 变量也包含了其它各种有用的属性：

| 属性 | 描述 |
| --- | --- |
| `$loop->index` | 当前循环迭代的索引（从0开始）。 |
| `$loop->iteration` | 当前循环迭代 （从1开始）。 |
| `$loop->remaining` | 循环中剩余迭代数量。 |
| `$loop->count` | 迭代中的数组项目总数。 |
| `$loop->first` | 当前迭代是否是循环中的首次迭代。 |
| `$loop->last` | 当前迭代是否是循环中的最后一次迭代。 |
| `$loop->depth` | 当前循环的嵌套级别。 |
| `$loop->parent` | 在嵌套循环中，父循环的变量。 |

```php
@foreach ($users as $user)
    @foreach ($user->posts as $post)
        @if ($loop->parent->first)
            This is first iteration of the parent loop.
        @endif
    @endforeach
@endforeach
```
### `@includeIf`  `@includeWhen`

```php
@includeIf('view.name', ['some' => 'data'])
```
```php
@includeWhen($boolean, 'view.name', ['some' => 'data'])
```
# 前端相关

laravel 5.5 通过 Laravel Mix，很方便的使用前端框架，例如 Bootstrap vue 和 React。这一部分几乎是全新的，可以在文档中直接查看。 <https://d.laravel-china.org/docs/5.5/frontend>


# 参考资料

* [laravel 5.5](https://d.laravel-china.org/docs/5.5/) 
