---
layout: post
title: 如何使用 Laravel Collections 类编写神级代码
category: tech
tags: php laravel
---
![](https://cdn.kelu.org/blog/tags/laravel.jpg)

> 转自 laravel-china.org:  [如何使用 Laravel Collections 类编写神级代码](http://blog.phpzendo.com/?p=396)。

Laravel 提供了一些超赞的组件，在我看来，它是目前所有 Web 框架中提供组件支持最好的一个。它不仅提供了开箱即用的视图（views）、身份认证（authentication）、会话（sessions）、缓存（caching）、Eloquent、队列（queues）、数据校验（data validation）等组件。甚至还提供了开发工具（Valet 和 Homestead）。

但是，这个框架功能中最强大的一个特性常常被萌新们视而不见 - **Collection（集合）** 类。在这篇文章，我们将探寻如何使用集合提升编码效率、代码的易读行，及编写出更精简的编码。

## 预览

最初接触到使用集合的场景来自于研发人员使用 Eloquent 执行数据库查询，并从返回数据中使用 **foreach** 语句遍历获取模型集合。

不过，初学者可能并没有注意到，集合提供了超过 90 个以上的方法来操作底层数据。更妙的是几乎所有的方法都支持链式操作，能够让你的代码读起来就像一篇散文一样。这样使得你的代码更易阅读，无论是你还是其他使用者都是如此。

还没有进入正题？好吧，让我们回顾一个简单的代码片段，来看看我们如何使用集合编写粗、快、猛的代码吧。

## 代码示例

让我们构建一个真实的世界。假设我们查询某些 API 接口并获取到如下以数组保存的结果集：

```
<?php
// API 请求返回的结果
$data = [
    ['first_name' => 'John', 'last_name' => 'Doe', 'age' => 'twenties'],
    ['first_name' => 'Fred', 'last_name' => 'Ali', 'age' => 'thirties'],
    ['first_name' => 'Alex', 'last_name' => 'Cho', 'age' => 'thirties'],
];
```

我们看到数组包含名字（first name）、姓氏（last name） 和年龄（age）范围。现在，我们假设从记录中获取一名 **年龄（age）** 为 **30 岁（thirties）** 的用户，然后依据 **姓氏（last name）** 进行 **排序（sort）**。最后，我们还希望返回的结果为 **一个字符串（single string）**，这样每个用户独占 **一行（new line）**。最后，我们还希望返回的结果为

这个需求看起来不难实现，现在让我们看看使用 PHP 如何实现这一功能：

```
// 依据姓氏排序
usort($data, function ($item1, $item2) {
    return $item1['last_name'] <=> $item2['last_name'];
});

// 依据年龄范围分组
$new_data = [];

foreach ($data as $key => $item) {
    $new_data[$item['age']][$key] = $item;
}

ksort($new_data, SORT_NUMERIC);

// 从年龄为 30 岁组里获取用户全名
$result = array_map(function($item) {
    return $item['first_name'].' '.$item['last_name'];
}, $new_data['thirties']);

// 将数组转换为字符串并以行分隔符分隔
$final = implode("\n", $result);

// 译注：原文是 $final = implode($results, "\n"); implode函数接收两种顺序的参数，为了保持与文档一致所以我这边做了调整。
```

我们的实现代码超过 20 行，并且很不优雅。移除掉注释及换行相关代码，这段代码会变得难以阅读。再者，我们还需要借助临时变量以及 PHP 中内置的不友好的 sort 方法。

现在，让我们看下借助 Collection 类实现起来是多么简单吧：

```
collect($data)->where('age', 'thirties')
                 ->sortBy('last_name')
                 ->map(function($item){
                    return $item['first_name'].' '.$item['last_name'];
                 })
                 ->implode("\n");
```

哇哦！我们的代码从 20 行变成了 6 行。现在的代码不仅顺畅不少，并且在方法实现时无需借助注释告诉我们它们在处理什么问题。

不过，还存在一个问题阻止我们的代码不如完美阶段... 就是用于比较 first name 和 last name 的 **map** 方法。坦白说，这真的不是什么大问题，但是它为我们探索 **macro（宏）** 概念提供了动力。

## 扩展集合（Extending Collections）

Collection 类，同其它 Laravel 组件一样，支持宏（macroable），就是说你可以给它添加方法随后使用。

> **提示：** 如果你希望新方法随处可用，你应该将它们添加到服务提供中。我喜欢创建一个 **MacroServiceProvider** 实先这个功能，对于你来说随你喜欢就好。

让我们添加一个方法它会连接由数组提供的任意数量的字段并返回字符串结果：

```
Collection::macro('toConcatenatedString', function ($fields = [], $separator = ' ') {
    return $this->map(function($item) use ($fields, $separator) {
        return implode($separator, array_map(function ($el) use ($item) {
                return $item[$el];
            }, $fields)
        );
    })->implode("\n");
});
```

添加完这个方法后，我们的代码基本上就完美了：

```
collect($data)->where('age', 'thirties')
              ->sortBy('last_name')
              ->toConcatenatedString(['first_name', 'last_name']);
```

我们的代码从混乱的 20 多行精简到了 3 行，代码干净整洁功能清晰任何人都可以立马理解。

## 又一个示例

现在让我们看下第二个示例，假设我们一个用户列表，我们需要基于角色（role）过滤出来，然后进一步如果他们的注册时间为 5 年或以上且 **last name** 以字母 A-M 开始的仅获取第一个用户。

数据类似如下：

```
<?php
// API 请求返回的结果
$users = [
    ['name' => 'John Doe', 'role' => 'vip', 'years' => 7],
    ['name' => 'Fred Ali', 'role' => 'vip', 'years' => 3],
    ['name' => 'Alex Cho', 'role' => 'user', 'years' => 9],
];
```

如果我们使用的是 PHP 实现，我们的代码看下来如下：

```
$subset = [];
foreach ($users as $user) {
    if ($user['role'] === 'vip' && $user['years'] >= 5) {
        if (preg_match('/\s[A-Z]/', $user['name'])) {
            $subset[] = $user;
        }
    }
}
return reset($subset)
```

> **注意：** 你可以将第二个 **if** 语句移至第一个里面，但是我个人喜欢在单个 if 语句中使用不超过两个条件语句，因为我认为超过 2 个条件语句回事代码难以阅读。

这段代码不至于太糟糕，但是我们依然需要使用临时变量，我们还需要使用 **reset** 函数将指针重置到第一个用户。我们的代码还有四层缩进，这使得代码解析变得更有挑战性。

相反，我们来看看集合是如何处理这个问题的：

```
collect($users)->where('role', 'vip')
              ->map(function($user) {
                  return preg_match('/\s[A-Z]/', $user['name']);
              })
              ->firstWhere('years', '>=', '5');
```

我们将代码简化到了之前的一般左右，每一步过滤处理清晰明了，并且我们不需要引入临时变量。

遗憾的是目前集合还不支持正则匹配，所以我们使用 **map** 方法，不过我们可以为这个功能创建一个宏：

```
Collection::macro('whereRegex', function($expression, $field) {
    return $this->map(function ($item) use ($expression, $field) {
        return preg_match($expression, $item[$field]);
    })
});
```

得益于宏方法，我们的代码现在看起来如下：

```
collect($users) -> where('role', 'vip')
                -> whereRegex('/\s[A-Z]/', 'name')
                -> firstWhere('years', '>=', 5);
```

> **注意：** 为了简单起见，我们的红仅仅适用于数组集合。如果你计划让它们可以在 Eloquent 集合上使用，你需要在此场景下做相应的代码处理才行。

## 不同的视角

我们可以继续列出无数的示例，但仍然无法涵盖所有可用的集合方法，并且这从来都不是本文的真正目的。

需要注意的是，通过使用 Collection 类，您不仅可以获得一个方法库来简化编程工作，还可以选择一种从根本上改善代码的方法。

你会情不自禁的将你的代码结构从代码块重构简化成一行，同时减少代码的缩进，临时变量的使用和技巧性方法，另外你还可以使用链式编程方法，这让你的代码更加便于阅读和解析，此外最重要的是减少了编码工作！

查看官方文档获取更多这个迷人的类库的使用细节：<https://laravel-china.org/docs/laravel/collections>

> **提示：** 你还可以获取这个 Collection 类独立安装包，在使用非 laravel 项目是会非常有帮助。感谢 Tighten Co 团队做出的努力 <https://github.com/tightenco/collect>。

