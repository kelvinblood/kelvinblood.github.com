---
layout: post
title: laravel 根据 jsonb 数组筛选数据行
category: tech
tags: laravel php postgresql 
---
![](https://cdn.kelu.org/blog/tags/postgresql.jpg)

这篇文章记录一下我如何解决在 laravel 中使用jsonb 数组筛选数据行。

# 背景

先描述一下背景，数据库中我们有一个jsonb字段data，这个字段里存的是数组。在 laravel 数据表中定义如下：

```
        Schema::create('xxx', function (Blueprint $table) {
            $table->uuid('uuid');
            $table->jsonb("data")->nullable(); // 
            ... ...
        });
```

在类中定义如下：

```

    protected $casts = [
        'data' => 'array',
    ];
```

在data中我们使用数组存了一组无序的数据，例如：

```
[ a,b,c ]
```

# 初始想法

这种情况和我们使用 jsonb 存对象，根据对象取记录行是不一样的。

先来看下常规的json对象如何筛选记录行的。如果我们使用对象来存，可以很方便的达到我们的效果，例如：

```
if (XxxClass::where("data->id", $id)->where("data->name", $name)->count() == 0) {
}
```

数组无法使用这种方式取值，故而pass。

而laravel我也没有查到相关的办法解决。所以比较好的办法是自己写SQL语句查询。参考 postgresql 官方的文档:<https://www.postgresql.org/docs/9.4/functions-json.html>

很自然的我选择了 `?&` 操作符进行筛选，并且成功了！

![p1](https://cdn.kelu.org/blog/2019/09/p1.jpg)

具体 SQL 语句如下：

```
select * from "xxx" where "data" :: jsonb ?| ARRAY['b']
```

由此查到了相关的记录。

![p1](https://cdn.kelu.org/blog/2019/09/p2.jpg)



# 困难初现

难题在于通过这种方式无法在 laravel 中使用：

![p1](https://cdn.kelu.org/blog/2019/09/p3.jpg)

以下是错误提示：

![p1](https://cdn.kelu.org/blog/2019/09/p4.jpg)

从错误提示里可以知道 `？` 被转义成了laravel eloquent 默认的 变量了。 但即使使用了转义符 `\` 仍然是同样的错误。

为了更准确地定位问题，我用了下面的代码查看生成的sql语句是什么：

```
echo DB::select('select * from "xxx" where "data" :: jsonb ?| ARRAY[\'b\']')->toSql();
```

这个和我使用纯sql语句一毛一样。在此时我一度陷入了困境，便开始群聊和谷歌之旅。

# 定位问题

此时一位能力强悍的老同事，找到了一个issue，不过竟然是golang的框架 gorm 的讨论：[Way to escape Question Mark in Raw Query? #533 - github](<https://github.com/jinzhu/gorm/issues/533>)

问题也就是：这是 postgresql 9.4 的一个系统bug，目前官方并没有解决办法。

# 绕过问题

虽然问题一时半会无法解决，但是社区里找到了绕过此问题的方法，那就是——不使用 `?|` 操作符！

<https://laravel.io/forum/01-25-2015-postgres-94-new-question-mark-operator-cant-be-used-in-eloquent-raw-queries>

具体来说，是使用 `@>` 操作符替代 `?|`操作符：

```
select * from "xxx" where "data" :: jsonb @> '["b"]'
```

至于这两个操作符具体实现和效率有何不同，就不太清楚了，不过已经能解决目前遇到的问题了。转换到 laravel 的实现，使用下面的代码：

```
DB::table('xxx')->whereRaw('"data" :: jsonb @> \'["'.$this->name.'"]\';')->get()
```

问题解决~