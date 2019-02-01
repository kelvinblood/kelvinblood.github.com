---
layout: post
title: 使用 laravel 的 queryScope 处理 relations
category: tech
tags: php laravel
---

本文是 Laravel scope 的两个应用技巧。在[官方文档 5.1](https://laravel-china.org/docs/5.1/eloquent) 的文档中给出的是这样的描述。

    全局作用域（Global Scopes）可让你定义有限制的共用集合，它可以轻松地在你的应用程序中被重复使用。例如，你可能需要频繁地获取所有被认为是「受欢迎的」用户。要定义此范围，则可以简单地在 Eloquent 模型方法前面加上前缀 scope. 它总是返回查询构造器的实例.

scope 的便利之处在于在繁杂的数据中确定出数据间的逻辑关系。在简单的应用中，按照官方文档，scope 已经很好满足了我们的要求了。在下面的例子中，我在 trait 中定义了一系列具有共性的 scope：

    namespace App\Supports;

    use Carbon\Carbon;

    trait ScopeTrait
    {
        /**查询创建时间
         * 使用 prefix 是历史原因使用了 leftjoin.
         * @param $query
         * @return mixed
         */
        public function scopeCreatedAt($query, $start = '', $end = '', $equal = true)// start <= target < end
        {
            $className = get_class($this);
            $prefix = $className::TABLE . '.';
            if ($start) {
                $compare = $equal ? '>=' : '>';
                $query->where($prefix .'created_at', $compare, $start);
            }
            if ($end) {
                $query->where($prefix .'created_at', '<', $end);
            }
            return $query;
        }
        
        public function scopeSource($query, $source)
        {
            $className = get_class($this);
            $prefix = $className::TABLE . '.';
            if ($source) {
                $query->where($prefix . 'source', '=', $source);
            }
            return $query;
        }

        public function scopeYesterday($query)
        {
            $start = Carbon::yesterday();
            $end = Carbon::today();
            return $query->createdAt($start, $end);
        }
    }



我们通过这个方法查询某个时间段内表的有效数据。假定 Account 表中使用了这个 trait，需要查找昨天创建的帐号，可以这么使用：

    $accounts = Account::yesterday()->get();

在 laravel Eloquent ORM 中还经常用到 with 这一方法来关联表。普通的使用场景也很简单，例如

    class Talent{
        public function account()
        {
            return $this->belongsTo('App\Models\Account', 'account_uuid');
        }
    }
    
使用 Talent::with('account') 就可以获取到关联数据。如果希望leftjoin，可以在行内使用如下语句实现：

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
    
# 参考资料

* [Laravel. Use scope() in models with relation](http://stackoverflow.com/questions/26178315/laravel-use-scope-in-models-with-relation)
