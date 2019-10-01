---
layout: post
title: laravel 中如何写json文件
category: tech
tags: laravel
---
![](https://cdn.kelu.org/blog/tags/laravel.jpg)

写json要注意使用如下方法:

```
$content = stripslashes(json_encode($array));
```

stripslashes用于删除反斜杠。

写文件使用laravel方法

* Storage::put($file, $content);

或php原生方法：

* file_put_contents



```php
    // 读文件

    $jsonString = file_get_contents(base_path('resources/lang/en.json'));

    $data = json_decode($jsonString, true);


    // 更新内容

    $data['country.title'] = "Change Manage Country";

    // 写文件

    $newJsonString = json_encode($data, JSON_PRETTY_PRINT);

    file_put_contents(base_path('resources/lang/en.json'), stripslashes($newJsonString));


```

# 参考资料

* [How to read and write json file in PHP Laravel?](<https://hdtuto.com/article/how-to-read-and-write-json-file-in-php-laravel>)
* [jq: shell 脚本中JSON创建、解析工具](https://blog.b1uew01f.net/learnnotes/linux/304.html)