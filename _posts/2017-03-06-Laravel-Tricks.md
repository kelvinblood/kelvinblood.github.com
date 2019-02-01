---
layout: post
title: Laravel 小技巧
category: tech
tags: php laravel
---

![](https://cdn.kelu.org/blog/tags/laravel.jpg)

本文节选自[50分钟学会Laravel 50个小技巧][original],有修改。针对Laravel 5.1 版本。

一共分为8篇

* [Model篇][1]
* [Eloquent ORM篇][2]
* [Blade篇][3]
* [集合篇][4]
* [中间件/服务篇][5]
* [路由篇][6]
* [其他篇][7]
* [测试篇][8]

# <span id='1'>Model 篇</span>

1. model自动检验字段合法性

        class User extends Eloquent
        {
            public static $autoValidate = true;
            protected static $rules = [
                'email' => 'required|between:6,255|email|unique:backend_users',
                'login' => 'required|between:2,255|unique:backend_users',
                'password' => 'required:create|between:4,255|confirmed',
                'password_confirmation' => 'required_with:password|between:4,255'
            ];
        
            protected static function boot()
            {
                parent::boot();
                // You can also replace this with static::creating or static::updating
                static::saving(function ($model) {
                    if($model::$autoValidate) {
        
                        return $model->validate();
                    }
                });
            }
        
            public function validate() { }
        }

1. 用trait创建通用方法

        trait CrudTrait
        {
            /**
             * 创建实例
             *
             * @author kelvinblood <admin@kelu.org>
             * @param array $array
             * @return mixed
             */
            public static function createInstance(Array $array)
            {
                $className = get_called_class();
                $newClass = new $className();
                foreach ($array as $key => $value) {
                    $newClass->$key = $value;
                }
                $newClass->save();

                return $className::find($newClass->uuid);
            }
        }

1. uuid作为主键

         use Ramsey\Uuid\Uuid;
         
         trait UUIDModel
         {
             public $incrementing = false;
             protected static function boot()
             {
                 parent::boot();
                 static::creating(function ($model) {
                     $key = $model->getKeyName();
                     if(empty($model->{$key})) {
                         $model->{$key} = (string)$model->generateNewId();
                     }
                 });
             }

             public function generateNewUuid()
             {
                 return Uuid::uuid4();
             }
         }
        
        
        
        
1. 简单的加减数字
        
    这样就可以省去读取、赋值和 save 操作了。
        
        $customer = Customer::find($customer_id);
        $loyalty_points = $customer->loyalty_points + 50;
        $customer->update(['loyalty_points' => $loyalty_points]);
        
        // adds one loyalty point
        
        Customer::find($customer_id)->increment('loyalty_points', 50);
        // subtracts one loyalty point
        
        Customer::find($customer_id)->decrement('loyalty_points', 50);
        
        
1. 为model添加多余字段

    嗯，这个方法算是取巧，也很实用。
        
        function getFullNameAttribute()
        {
            return $this->first_name . ' ' . $this->last_name;
        }
        
1. 保存model时返回关系
        
        public function store()
        {
            $post = new Post;
            $post->fill(Input::all());
            $post->user_id = Auth::user()->user_id;
            $post->user;
            return $post->save();
         }
         
1. 同时新建model和migration.         
         
         php artisan make:model Books -m




# <span id='2'>Eloquent ORM 篇</span>        
        
1. 有条件的关联关系

        class myModel extents Model
        {
             public function category()
             {
             return $this->belongsTo('myCategoryModel', 'categories_id')->where('users_id', Auth::user()->id);
             }
        }
        
1. 可排序的关联关系

        class Category extends Model
         {
             public function products()
             {
                 return $this->hasMany('App\Product')->orderBy('name');
             }
         }        
         
1. 仅显示关联关系存在的数据
         
         class Category extends Model
         {
             public function products()
             {
                 return $this->hasMany('App\Product');
             }
         }
         
         public function getIndex()
         {
             $categories = Category::with('products')->has('products')->get();
             return view('categories.index', compact('categories'));
         }
        
1. Where的语法表达式

    真是够奇葩的，呵呵ε=(･д･｀*)ﾊｧ…

        $products = Product::where('category', '=', 3)->get();
        $products = Product::where('category', 3)->get();
        $products = Product::whereCategory(3)->get();        
        
        
1. Query Builder 的 havingRaw 方法

        SELECT *, COUNT(*) FROM products GROUP BY category_id HAVING count(*) > 1;
        
        DB::table('products')
            ->select('*', DB::raw('COUNT(*) as products_count'))
            ->groupBy('category_id')
            ->having('products_count', '>', 1)
            ->get();
        Product::groupBy('category_id')->havingRaw('COUNT(*) > 1')->get();
        
1. 日期筛选
        
        $q->whereDate('created_at', date('Y-m-d'));
        $q->whereDay('created_at', date('d'));
        $q->whereMonth('created_at', date('m'));
        $q->whereYear('created_at', date('Y'));
        
1. 随机取数据
   
        $questions = Question::orderByRaw('RAND()')->take(10)->get();        
        
        
1.  只取特定字段lists       

        $employees = Employee::where('branch_id', 9)->get()->lists('full_name', 'id');
        
        
        
# <span id='3'>Blade 篇</span>

1. 获取数组首尾的元素

        //hide all but the first item
        @foreach ($menu as $item)
        <div @if ($item != reset($menu)) class="hidden" @endif>
        <h2>\{\{ $item->title }}</h2>
             </div>
        @endforeach

         //apply css to last item only
         @foreach ($menu as $item)
        <div @if ($item == end($menu)) class="no_margin" @endif> 
        <h2>\{\{ $item->title }}</h2>
         </div>
        @endforeach
        
1. 自定义错误页面        
        
        <?php 
        namespace App\Exceptions; 
        use Exception; 
        use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler; 
        use Symfony\Component\Debug\ExceptionHandler as SymfonyDisplayer; 
        class Handler extends ExceptionHandler { 
            protected function convertExceptionToResponse(Exception $e) {
                $debug = config('app.debug', false); 
                if($debug) { 
                    return (new SymfonyDisplayer($debug))->createResponse($e);
                }
        
                return response()->view('errors.default', ['exception' => $e], 500);
            }
        }

# <span id='4'>集合篇</span>

1. 集合筛选

        $customers = Customer::all();
        $us_customers = $customers->filter(function ($customer) {
            return $customer->country == 'United States';
        });
        
        $non_uk_customers = $customers->reject(function ($customer) {
            return $customer->country == 'United Kingdom';
        });
        
1. find,where
        
        $collection = App\Person::find([1, 2, 3]);
        $collection = App\Person::all();
        $programmers = $collection->where('type', 'programmer');
        $critic = $collection->where('type', 'critic');
        $engineer = $collection->where('type', 'engineer');
        
1. closures排序        

        $collection = collect([
            ['name' => 'Desk'],
            ['name' => 'Chair'],
            ['name' => 'Bookcase']
        ]);

        $sorted = $collection->sortBy(function ($product, $key) {
            return array_search($product['name'], [1 => 'Bookcase', 2 => 'Desk', 3 => 'Chair']);
        });
        
1. 提取数组的值作为键        
        
        $library = $books->keyBy('title');
        
        [
            'Lean Startup' => ['title' => 'Lean Startup', 'price' => 10],
            'The One Thing' => ['title' => 'The One Thing', 'price' => 15],
            'Laravel: Code Bright' => ['title' => 'Laravel: Code Bright', 'price' => 20],
            'The 4-Hour Work Week' => ['title' => 'The 4-Hour Work Week', 'price' => 5],
        ]
        
        
        
1. collection unions

    没明白。

        // the point is to actually combine results from different models
        $programmers = \App\Person::where('type', 'programmer')->get();
        $critic = \App\Person::where('type', 'critic')->get();
        $engineer = \App\Person::where('type', 'engineer')->get();

        $collection = new Collection;

        $all = $collection->merge($programmers)->merge($critic)->merge($engineer);
        
1. collection lookaheads

    没明白。
    
        $collection = collect([1 => 11, 5 => 13, 12 => 14, 21 => 15])->getCachingIterator();
        foreach ($collection as $key => $value) {
            dump($collection->current() . ':' . $collection->getInnerIterator()->current());
        }
        
# <span id='5'>中间件/服务篇</span>
        
1. 共享cookies        
        
        // app/Http/Middleware/EncryptCookies.php
        protected $except = [
            'shared_cookie'
        
        ];
        
        Cookie::queue('shared_cookie', 'my_shared_value', 10080, null, '.example.com');

1. 有条件的Provider
        
        // app/Providers/AppServiceProvider.php
        public function register()
        {
            $this->app->bind('Illuminate\Contracts\Auth\Registrar', 'App\Services\Registrar');
        
            if($this->app->environment('production')) {
                $this->app->register('App\Providers\ProductionErrorHandlerServiceProvider');
            } else {
                $this->app->register('App\Providers\VerboseErrorHandlerServiceProvider');
            }
        }
        
# <span id='6'>路由篇</span>

1. 嵌套路由

        Route::group(['prefix' => 'account', 'as' => 'account.'], function () {
        
            Route::get('login', ['as' => 'login', 'uses' => 'AccountController@getLogin']);
            Route::get('register', ['as' => 'register', 'uses' => 'AccountController@getRegister']);
        
            Route::group(['middleware' => 'auth'], function () {
                Route::get('edit', ['as' => 'edit', 'uses' => 'AccountController@getEdit']);
            });
        
        });
        
        <a href="\{\{ route('account.login') }}">Login</a>`
        <a href="\{\{ route('account.register') }}">Register</a>`
        <a href="\{\{ route('account.edit') }}">Edit Account</a>`
        
1. 匹配所有路由        
        
        // app/Http/routes.php
        
        Route::group(['middleware' => 'auth'], function () {
            Route::get('{view}', function ($view) {
                try {
                    return view($view);
                } catch (\Exception $e) {
                    abort(404);
                }
            })->where('view', '.*');
        });
        
# <span id='7'>其他篇</span>
        
1. Model支持多语言

        // database/migrations/create_articles_table.php
        public function up()
        {
          Schema::create('articles', function (Blueprint $table) {
              $table->increments('id');
              $table->boolean('online');
              $table->timestamps();
          });
        }

        //database/migrations/create_articles_table.php
        public function up()
        {
          $table->increments('id');
          $table->integer('article_id')->unsigned();
          $table->string('locale')->index();
          $table->string('name');
          $table->text('text');
          $table->unique(['article_id', 'locale']);
          $table->foreign('article_id')->references('id')->on('articles')->onDelete('cascade');

        }

        // app/Article.php
        class Article extends Model
        {
          use \Dimsav\Translatable\Translatable;
          public $translatedAttributes = ['name', 'text'];
        }

        // app/ArticleTranslation.php
        class ArticleTranslation extends Model
        {
          public $timestamps = false;
        }

        // app/http/routes.php

        Route::get('{locale}', function ($locale) {
          app()->setLocale($locale);
          $article = Article::first();
          return view('article')->with(compact('article'));
        });

        // resources/views/article.blade.php

        <h1>\{\{ $article->name }}</h1>

        \{\{ $article->text }}        
        
1. 定时清理日志
        
        $schedule->call(function () {
            Storage::delete($logfile);
        })->weekly();
        
1. pipeling
        
        $result = (new Illuminate\Pipeline\Pipeline($container)
            ->send($something)
            ->through('ClassOne', 'ClassTwo', 'ClassThree')
            ->then(function ($something) {
                return 'foo';
            });
            
            
# <span id='8'>测试篇</span>

1. 环境变量

        // phpunit.xml
        
        <php>
            <env name="APP_ENV" value="testing"/>
            <env name="CACHE_DRIVER" value="array"/>
            <env name="SESSION_DRIVER" value="array"/>
            <env name="QUEUE_DRIVER" value="sync"/>
            <env name="DB_DATABASE" value=":memory:"/>
            <env name="DB_CONNECTION" value="sqlite"/>
            <env name="TWILIO_FROM_NUMBER" value="+15005550006"/>
        </php>
        
        
        //	.env.test – add to .gitignore
        TWILIO_ACCOUNT_SID = fillmein
        TWILIO_ACCOUNT_TOKEN = fillmein
        
        
        //	access directly from your tests using helper function
        env('TWILIO_ACCOUNT_TOKEN');
        
        
         // tests/TestCase.php 
         <?php 
         class TestCase extends Illuminate\Foundation\Testing\TestCase { 
         
         /** 
         * The base URL to use while testing the application. 
         * 
         * @var string 
         */ 
         protected $baseUrl = 'http://localhost'; 
         /** 
         * Creates the application. 
         * 
         * @return \Illuminate\Foundation\Application 
         */ 
         public function createApplication() { 
             $app = require __DIR__ . '/../bootstrap/app.php';
             if(file_exists(dirname(__DIR__) . '/.env.test')) {
                Dotenv::load(dirname(__DIR__), '.env.test'); 
             } 
             
             $app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();
                     
             return $app;
         }
     }

1. 自动测试

        // gulpfile.js

         var elixir = require('laravel-elixir');

         mix.phpUnit();

         $ gulp tdd
 
# 参考资料

* [50分钟学会Laravel 50个小技巧][original]
* [50 Laravel Tricks in 50 Minutes by willroth](https://speakerdeck.com/willroth/50-laravel-tricks-in-50-minutes)
* [理解Laravel中的pipeline](http://www.jianshu.com/p/3c2791a525d0)

[original]: http://www.mamicode.com/info-detail-1617045.html
[1]: #1
[2]: #2
[3]: #3
[4]: #4
[5]: #5
[6]: #6
[7]: #7
[8]: #8
