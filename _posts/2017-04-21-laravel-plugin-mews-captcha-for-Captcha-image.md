---
layout: post
title: Laravel 插件 mews/captcha 实现图片验证码
category: tech
tags: php laravel composer
---

![](https://cdn.kelu.org/blog/tags/laravel.jpg)

这是一个用于生成图片验证码的 Laravel 插件。Github 地址: <https://github.com/mewebstudio/captcha>
这个项目基于 [Intervention Image](https://github.com/Intervention/image)

## 预览

![Preview](https://cdn.kelu.org/blog/2017/04/HYtr744.jpg)

## 安装

使用 [Composer](http://getcomposer.org) 安装,修改文件 `composer.json` 如下，然后 ```composer update mews/captcha``` 

```json
{
    "require": {
        "laravel/framework": "5.0.*",
        "mews/captcha": "~2.0"
    },
    "minimum-stability": "dev"
}
```

或者直接

```
composer require mews/captcha
```

Windows 需要在 php.ini 中打开 `php_gd2.dll` 扩展。

## 注册

在 provider 中注册插件：

`config/app.php`

```php
    'providers' => [
        // ...
        Mews\Captcha\CaptchaServiceProvider::class,
    ]
    
    'aliases' => [
        // ...
        'Captcha' => Mews\Captcha\Facades\Captcha::class,
    ]
```

生成配置文件：

```$ php artisan vendor:publish```

然后会在config目录下生成配置文件 `captcha.php`



```php
return [

    'characters' => '2346789abcdefghjmnpqrtuxyzABCDEFGHJMNPQRTUXYZ',

    'default'   => [
        'length'    => 5,
        'width'     => 120,
        'height'    => 36,
        'quality'   => 90,
    ],

    'flat'   => [
        'length'    => 6,
        'width'     => 160,
        'height'    => 46,
        'quality'   => 90,
        'lines'     => 6,
        'bgImage'   => false,
        'bgColor'   => '#ecf2f4',
        'fontColors'=> ['#2c3e50', '#c0392b', '#16a085', '#c0392b', '#8e44ad', '#303f9f', '#f57c00', '#795548'],
        'contrast'  => -5,
    ],

    'mini'   => [
        'length'    => 3,
        'width'     => 60,
        'height'    => 32,
    ],

    'inverse'   => [
        'length'    => 5,
        'width'     => 120,
        'height'    => 36,
        'quality'   => 90,
        'sensitive' => true,
        'angle'     => 12,
        'sharpen'   => 10,
        'blur'      => 2,
        'invert'    => true,
        'contrast'  => -5,
    ]

];
```

安装完成！

## 用法示例

```php

    // [your site path]/Http/routes.php

    Route::any('captcha-test', function()
    {
        if (Request::getMethod() == 'POST')
        {
            $rules = ['captcha' => 'required|captcha'];
            $validator = Validator::make(Input::all(), $rules);
            if ($validator->fails())
            {
                echo '<p style="color: #ff0000;">Incorrect!</p>';
            }
            else
            {
                echo '<p style="color: #00ff30;">Matched :)</p>';
            }
        }
    
        $form = '<form method="post" action="captcha-test">';
        $form .= '<input type="hidden" name="_token" value="' . csrf_token() . '">';
        $form .= '<p>' . captcha_img() . '</p>';
        $form .= '<p><input type="text" name="captcha"></p>';
        $form .= '<p><button type="submit" name="check">Check</button></p>';
        $form .= '</form>';
        return $form;
    });
```

### 返回图片

```php
captcha();
Captcha::create();
```

### 返回图片URL

```php
captcha_src();
Captcha::src();
```

### 返回图片HTML

```php
captcha_img();
Captcha::img();
```

### 切换配置

```php
captcha_img('flat');
Captcha::img('inverse');
```

### 判断用户输入的验证码是否正确

扩展包使用了自定义验证规则方式扩展了验证规则，我们只要在对应的 Controller 添加以下的规则即可：

    $this->validate($request, [
        'captcha' => 'required|captcha'
    ]);

## 参考资料

* [mews/captcha 图片验证码解决方案](https://laravel-china.org/topics/2895/extension-recommended-mewscaptcha-image-authentication-code-solution)
* [Intervention Image](https://github.com/Intervention/image)
* [L5 Captcha on Github](https://github.com/mewebstudio/captcha)
* [L5 Captcha on Packagist](https://packagist.org/packages/mews/captcha)
* [For L4 on Github](https://github.com/mewebstudio/captcha/tree/master-l4)
* [License](http://www.opensource.org/licenses/mit-license.php)
* [Laravel website](http://laravel.com)
* [Laravel Turkiye website](http://www.laravel.gen.tr)
* [MeWebStudio website](http://www.mewebstudio.com)