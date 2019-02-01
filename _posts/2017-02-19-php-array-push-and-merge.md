---
layout: post
title: php 数组增加元素的方法 array_push 和 array_merge
category: tech
tags: php
---
![](https://cdn.kelu.org/blog/tags/php.jpg)

本文的起因是今天需要给一个数组添加成员，一个是无序数组，直接往里扔就可以，另一个是key-value形式的数组。

无序数组只要array_push即可，key-value数组如果数量少，也可以用 `$data['pussy'] = 'wagon'`形式。

# array_push(array,value1,value2...)

    参数	描述
    array	必需。规定数组。
    value1	必需。规定要添加的值。
    value2	可选。规定要添加的值。
    
例子：    
    
    $config = require_once __DIR__ . '/../vendor/xxx.php';
    array_push($config['providers'],
        xxx\Providers\HttpClientServiceProvider::class,
        xxx\Providers\SmsServiceProvider::class,
        xxx\Providers\QrCodeServiceProvider::class,
        \Intervention\Image\ImageServiceProvider::class,
        xxx\Providers\ImageServiceProvider::class,
        xxx\Providers\WordSegmentServiceProvider::class,
        xxx\Providers\WechatServiceProvider::class,
        xxx\Providers\RecommendServiceProvider::class,
        Ignited\LaravelOmnipay\LaravelOmnipayServiceProvider::class
    );
    
    
    
# array_merge(array1,array2,array3...)

    参数	描述
    array1	必需。规定数组。
    array2	可选。规定数组。
    array3	可选。规定数组。
    
例子接上：    
    
    $config['aliases'] = array_merge($config['aliases'], [
            'HttpClient' => xxx\Facades\HttpClient::class,
            'Sms' => xxx\Facades\Sms::class,
            'QrCode' => xxx\Facades\QrCode::class,
            'Image' => \Intervention\Image\Facades\Image::class,
            'ImageUpload' => xxx\Facades\Image::class,
            'WordSegment' => xxx\Facades\WordSegment::class,
            'Recommend' => xxx\Facades\Recommend::class,
            'Wechat' => xxx\Facades\Wechat::class,
            'Omnipay' => Ignited\LaravelOmnipay\Facades\OmnipayFacade::class
        ]
    );
