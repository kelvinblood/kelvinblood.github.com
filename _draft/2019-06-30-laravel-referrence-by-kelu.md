---
layout: post
title: 个人向 laravel 常用备忘
category: tech
tags: laravel php
---
![](https://cdn.kelu.org/blog/tags/laravel.jpg)

这篇文章是 laravel 5.7 作为标准，记录常用的命令和方法。

1. 确定当前环境

    通过 `.env` 文件中的 `APP_ENV` 变量确定的。

    使用 `App facade` 中的 `environment` 方法来访问此值：

    ```php
    $environment = App::environment();
    if (App::environment(['local', 'staging'])) {
        // 当前的环境是 local 或 staging...
    }
    ```

    

1. 访问配置值

    ```php
    $value = config('app.timezone');
    ```

    要在运行时设置配置值，传递一个数组给 `config` 函数

    ```php
    config(['app.timezone' => 'America/Chicago']);
    ```

    

1. 生产环境配置

    ```
    php artisan config:cache // 优化配置缓存，生成一个配置文件。
    composer install --optimize-autoloader --no-dev //优化自动加载
    php artisan route:clear
    php artisan route:cache
    ```

    

1. 创建外部访问软连接

    ```
    php artisan storage:link  // 优化路由加载
    ```

    将创建一个由 `storage/app/public` 指向 `public/storage` 的软链接。

    

1. laravel  常见开发模式

    * command: 命令行。
    * job： 队列。应用的任务可以被推送到队列或者在当前请求的生命周期内同步运行。
    * `Listeners` ： 事件监听器接收事件实例并执行响应该事件被触发的逻辑。例如， `UserRegistered` 事件可能由 `SendWelcomeEmail` 监听器处理。
    * `Mail` ： 邮件对象将邮件的逻辑封装单个类中，邮件对象还可以使用 `Mail::send` 方法来发送邮件。
    * `Notifications` ： Laravel 的通知功能抽象了发送通知接口，你可以通过各种驱动（例如邮件、Slack、短信）发送通知，或是存储在数据库中。
    * `Policies` ：应用的授权策略类。策略可以用来决定一个用户是否有权限去操作指定资源。
    * `Providers` ：服务提供者，在服务容器中绑定服务、注册事件、以及执行其他任务来为即将到来的请求做准备来启动应用。
    * `Rules` ：验证规则对象。这些规则意在将复杂的验证逻辑封装在一个简单的对象中。

    

1. 路由约束

    ```php
    RouteServiceProvider 
        
    public function boot()
    {
        Route::pattern('id', '[0-9]+');
    
        parent::boot();
    }
    
    ---
        
    Route::get('user/{id}', function ($id) {
        // 只有在 id 为数字时才执行。
    });
    ```

    

1. 表单方法伪造

    ```
    <form action="/foo/bar" method="POST">
        @method('PUT')
        @csrf
    </form>
    ```

    

1. 当前路由

    ```
    $route = Route::current();
    
    $name = Route::currentRouteName();
    
    $action = Route::currentRouteAction();
    ```

    

1. 单控制器

    ```php
    php artisan make:controller ShowProfile --invokable
    
    	public function __invoke($id)
        {
            return view('user.profile', ['user' => User::findOrFail($id)]);
        }
    ```

    

1. 资源控制器

    ```
    php artisan make:controller PhotoController --resource --model=Photo
    
    Route::resources([
        'photos' => 'PhotoController',
        'posts' => 'PostController'
    ]);
    
    Route::resource('photos', 'PhotoController')->only([
        'index', 'show'
    ]);
    
    Route::resource('photos', 'PhotoController')->except([
        'create', 'store', 'update', 'destroy'
    ]);
    ```

    

1. api控制器

     ```
     php artisan make:controller API/PhotoController --api
     ```

     

1. 旧输入存储

     ```
     $request->flash();
     return redirect('form')->withInput(
         $request->except('password')
     );
     
     或全局辅助函数old
     <input type="text" name="username" value="{{ old('username') }}">
     ```

     

1. 文件下载

     ```
     return response()->download($pathToFile);
     
     return response()->download($pathToFile, $name, $headers);
     
     return response()->download($pathToFile)->deleteFileAfterSend(true);
     
     流式下载（中转）
     return response()->streamDownload(function () {
         echo GitHub::api('repo')
                     ->contents()
                     ->readme('laravel', 'laravel')['contents'];
     }, 'laravel-readme.md');
     
     直接显示
     return response()->file($pathToFile);
     
     return response()->file($pathToFile, $headers);
     ```

     

1. 与所有视图共享数据

     ```
     class AppServiceProvider extends ServiceProvider
     {
         public function boot()
         {
             View::share('key', 'value');
         }
     ```

     

1. url

     ```
     echo url()->current();
     echo url()->full();
     echo url()->previous();
     echo URL::current();
     
     ```

     

1. 签名url

     ```
     使用签名 URL 来实现通过电子邮件发送给客户的公共 「取消订阅」链接。
     
     return URL::signedRoute('unsubscribe', ['user' => 1]);
     
     # route
     Route::get('/unsubscribe/{user}', function (Request $request) {
         if (! $request->hasValidSignature()) {
             abort(401);
         }
     
         // ...
     })->name('unsubscribe');
     
     protected $routeMiddleware = [
         'signed' => \Illuminate\Routing\Middleware\ValidateSignature::class,
     ];
     
     Route::post('/unsubscribe/{user}', function (Request $request) {
         // ...
     })->name('unsubscribe')->middleware('signed');
     ```

     

1. 表单验证

     ```
     php artisan make:request StoreBlogPost
     
     
     ```

     表单请求后钩子: 

     可以使用 `withValidator` 方法。这个方法接收一个完整的验证构造器，允许你在验证结果返回之前调用任何方法：

     

1. 范德萨

1. 

1. 范德萨

1. 

1. 范德萨

1. 

1. 范德萨

1. 

1. 范德萨
