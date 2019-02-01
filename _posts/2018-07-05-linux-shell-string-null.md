---
layout: post
title: linux shell 中判断字符串为空的正确方法
category: tech
tags: linux shell
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

```
#!/bin/sh

STRING=

if [ -z "$STRING" ]; then 
    echo "STRING is empty" 
fi

if [ -n "$STRING" ]; then 
    echo "STRING is not empty" 
fi
```


# 参考资料

* [linux shell 中判断字符串为空的正确方法](https://www.cnblogs.com/cute/archive/2011/08/26/2154137.html)