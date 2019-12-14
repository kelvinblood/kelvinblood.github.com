---
layout: post
title: nginx 启用目录索引，显示文件列表
category: tech
tags: nginx
---
![](https://cdn.kelu.org/blog/tags/nginx.jpg)

在nginx中，如果特定目录中没有index.html 文件，则默认会返回 `404 Not Found` 的错误。

但是，Nginx 自动索引模块提供了一种**自动生成列表**的方法，添加自动索引非常容易，使用 autoindex on 即可。

```
server {
        listen   80;
        ... ...
        
        location /somedir {
           autoindex on;
        }
}
```

除了简单地使用自动索引打开或关闭之外，还可以对其做其他的配置，包括：

- **autoindex_exact_size;** - 显示输出的确切文件大小，还是最接近的KB，MB或GB。有2个选项：on | off。
- **autoindex_format;** - 该指令指定Nginx索引列表应以什么格式输出。该指令有4个选项：html | xml | json | jsonp。
- **autoindex_localtime;** - 该指令指定目录列表的时间应该输出为本地时间还是UTC。该指令有2个选项：on | off。

使用这几个配置后配置内容类似于如下内容：

```nginx
location /somedirectory/ {
    autoindex on;
    autoindex_exact_size off;
    autoindex_format html;
    autoindex_localtime on;
}
```



# 参考资料

* [Enabling the Nginx Directory Index Listing - KeyCDN](<https://www.keycdn.com/support/nginx-directory-index>)