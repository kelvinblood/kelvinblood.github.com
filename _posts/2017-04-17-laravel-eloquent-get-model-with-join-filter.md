---
layout: post
title: Laravel Eloquent 左联时进行筛选
category: tech
tags: php laravel
---

![](https://cdn.kelu.org/blog/tags/laravel.jpg)

在 laravel Eloquent ORM 中我们经常用到 with 这一方法来关联表。普通的使用场景也很简单，例如

    class Talent{
        public function account()
        {
            return $this->belongsTo('App\Models\Account', 'account_uuid');
        }
    }
    
使用 Talent::with('account') 就可以获取到关联数据。如果希望左联查询，可以在行内使用如下语句实现：

    $yesterdayCreateTalent = Talent::with(['account' => function ($q) {
      $q->yesterday();
    }])->get();
    
也可以拆分方法进行使用。

    // Talent
    public function test()
    {
       return $this->belongsTo('App\Models\Account', 'account_uuid')->yesterday();
       // or
       // return $this->account()->yesterday();
    }
