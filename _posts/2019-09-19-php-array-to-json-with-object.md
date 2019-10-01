---
layout: post
title: PHP json_encode 转换空数组为对象
category: tech
tags: php
---
![](https://cdn.kelu.org/blog/tags/php.jpg)

今天使用 json_encode() 将数组转换成json格式时，发现期望显示空对象的json，被转换成了空数组。这样一来和外部交互时就出了问题，数据结构不一致，导致对端解析json失败。

原本：

```
$server = [
    "stats" => [],
    "api" => [
        "tag" => "api",
        "services" => [
            "StatsService"
        ]
    ],
 ]
```

转换为json：

```
{"stats":[],"api":{"tag":"api","services":["StatsService"]}}
```

而我们期望的json为：

```
{"stats":{},"api":{"tag":"api","services":["StatsService"]}}
```

使用 ArrayObject 可以解决这个问题。按如下方式定义数组：

```
$server = [
    "stats" => new \ArrayObject(),
    "api" => [
        "tag" => "api",
        "services" => [
            "StatsService"
        ]
    ],
 ]
```

即可得到期望的json。