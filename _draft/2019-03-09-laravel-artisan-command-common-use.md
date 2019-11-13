---
layout: post
title: laravel/yarn 命令行与实践备忘
category: tech
tags: php laravel
---

![](https://cdn.kelu.org/blog/tags/laravel.jpg)

 

# laravel

request

```
php artisan make:request AddCartRequest
```

创建模型

```
php artisan make:model Models/Order -mf
php artisan make:model Models/OrderItem -mf
```

* m: 创建migration
* f：创建factory



要让用户能通过浏览器访问 `storage` 目录下的文件，需要创建一个软链接，

```
php artisan storage:link
```

seeder

```
php artisan make:seeder ProductsSeeder
php artisan db:seed --class=ProductsSeeder
```

migration

```
php artisan make:migration create_user_favorite_products_table --create=user_favorite_products
```

* --create: table名

error

```
 php artisan make:exception InvalidRequestException
```

# laravel-admin

```
php artisan admin:make ProductsController --model=App\\Models\\Product
```

# yarn

```
yarn add @fortawesome/fontawesome-free
```

订单是电商系统的核心之一。



SKU = Stock Keeping Unit（库存量单位），也可以称为『单品』。对一种商品而言，当其品牌、型号、配置、等级、花色、包装容量、单位、生产日期、保质期、用途、价格、产地等属性中任一属性与其他商品存在不同时，可称为一个单品。



我们会有两个数据表：

- `products` 表，产品信息表，对应数据模型 Product ；
- `product_skus` 表，产品的 SKU 表，对应数据模型 ProductSku 。


一笔订单支持多个商品 SKU，因此我们需要 `orders` 和 `order_items` 两张表，`orders` 保存用户、金额、收货地址等信息，`order_items` 则保存商品 SKU ID、数量以及与 `orders` 表的关联。

# laravel 开发实践

可以参考两年前的这篇文章 [Laravel 小技巧](/tech/2017/03/06/Laravel-Tricks.html)

### 1. Boot方法

在类中可以通过 `boot()` 方法注册了一个模型创建事件监听函数，一个经典用法是生成uuid，

```
protected static function boot()
    {
        parent::boot();
        // 监听模型创建事件，在写入数据库之前触发
        static::creating(function ($model) {
            // 如果模型的 no 字段为空
            $model->uuid = (string)Uuid::generate();
        });
    }
```

### 2. 模型参数

```
class User extends Model {
    protected $table = 'users';
    protected $fillable = ['email', 'password']; // 可以使用 User::create() 填充得字段
    protected $dates = ['created_at', 'deleted_at']; // which fields will be Carbon-ized
    protected $appends = ['field1', 'field2']; // additional values returned in JSON
    protected $primaryKey = 'uuid'; // it doesn't have to be "id"
    public $incrementing = false; // and it doesn't even have to be auto-incrementing!
    protected $perPage = 25; // Yes, you can override pagination count PER MODEL (default 15)
    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at'; // Yes, even those names can be overridden
    public $timestamps = false; // or even not used at all
}
```

### 3. find多个

```
$users = User::find([1,2,3]);
```

### 4.associate方法 

```
 // 创建一个订单
            $order   = new Order([
                'address'      => [ // 将地址信息放入订单中
                    'address'       => $address->full_address,
                    'zip'           => $address->zip,
                    'contact_name'  => $address->contact_name,
                    'contact_phone' => $address->contact_phone,
                ],
                'remark'       => $request->input('remark'),
                'total_amount' => 0,
            ]);
            // 订单关联到当前用户
            $order->user()->associate($user);
            // 写入数据库
            $order->save();
```

### 5. make方法



这里的 `load()` 方法与上一章节介绍的 `with()` 预加载方法有些类似，称为 `延迟预加载`，不同点在于 `load()` 是在已经查询出来的模型上调用，而 `with()` 则是在 ORM 查询构造器上调用。