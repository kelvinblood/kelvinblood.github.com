---
layout: post
title: python 字典的一些操作
category: tech
tags:  python
---
![](https://cdn.kelu.org/blog/tags/python.jpg)

字典是一个非常常用的数据类型，这一篇记录一些常用用法。

# 遍历

```python
dict={"a":"apple","b":"banana","o":"orange"} 

for i in dict: 
  print "dict[%s]=" % i,dict[i] 

for (k,v) in  dict.items(): 
  print "dict[%s]=" % k,v 

for k,v in dict.iteritems(): 
  print "dict[%s]=" % k,v 

for k,v in zip(dict.iterkeys(),dict.itervalues()): 
  print "dict[%s]=" % k,v
```

# key 是否存在

```python
dict.has_key()
key in dict.keys()
```

# for 循环按顺序输出

字典的本质是hash表，一种散列表结构，数据输入后按特征已经被散列了，注定它就是无序的。

所以预先添加的内容输出的顺序是不可预期的。有两种解决方法

1. 不使用dict，使用元组，元组是记录输入顺序的、有序的，也能方便地转换成dict。
2. 另用一个列表记录下输入时的顺序。


# 参考资料

* [Python selenium —— 父子、兄弟、相邻节点定位方式详解](https://huilansame.github.io/huilansame.github.io/archivers/father-brother-locate)

* [xpath选择当前结点的子节点](http://blog.csdn.net/destinyuan/article/details/51297611)
