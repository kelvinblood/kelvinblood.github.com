---
layout: post
title: Laravel Eloquent 使用 groupBy 获取每个group的数据和
category: tech
tags: php laravel
---

![](https://cdn.kelu.org/blog/tags/laravel.jpg)

最近写到相关的代码，直接上代码做个记录。

    public function scopeUserSum($query)
    {
        return $query->groupBy('username')->selectRaw('sum(data) as sum, username')->orderBy('sum', 'desc');
    }

如果只是纯粹求一列的和，在builder上直接用sum即可。
    
# 参考资料
    
* [Laravel Eloquent: sum with groupBy](http://stackoverflow.com/questions/24887708/laravel-eloquent-sum-with-groupby)    
* [Group By Eloquent ORM](http://stackoverflow.com/questions/22562101/group-by-eloquent-orm)    
* [Laravel Eloquent groupBy() AND also return count of each group](http://stackoverflow.com/questions/18533080/laravel-eloquent-groupby-and-also-return-count-of-each-group)    
