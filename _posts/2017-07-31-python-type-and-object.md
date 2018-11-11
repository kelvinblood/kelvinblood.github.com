---
layout: post
title: Python 的 object 类
category: tech
tags:  python
---
![](https://cdn.kelu.org/blog/tags/python.jpg)

# 结论

先说结论，**Python中的一切都是对象，它们要么是类的实例，要么是元类的实例** .

![](https://cdn.kelu.org/blog/2017/07/types_map.jpg)

在图中可以看出对象分两种:

1.  classes(类)
2.  instances(实例)

虚线表示一个对象的type(类型),实线表示一个对象的base(基类/父类).

首先我们要明确，类创造了实例,而不是继承关系。那么问题来了,是什么创造了类呢? Python 引进了`metaclasses`,`<type 'type'>`就是元类,它可以创建类.

# 使用

可以参考一下这些链接：

* [Python 为什么要继承 object 类？](https://www.zhihu.com/question/19754936)

由于历史原因，2.x 里 object 是新基类，需要显示定义。在3.x里，object已经默认做为所有东西的基类了。

```python
class A:  # 旧式类
    pass

class B(object):  # 新式类
    pass
```
两个方法：

*   issubclass(A,B) (测试超类-子类关系) ：A 是 B 的子类，B 是 A 的超类
*   isinstance(A,B) (测试类型-实例关系) ，A 是 B 的实例

		class Foo(object):
		    pass
		
		class Bar(Foo):
		    pass
		
		print issubclass(Foo,object)
		print issubclass(Bar,object)
		print isinstance(Bar(),Foo)

# 原因

那么问题来了，为什么要加入新式类呢?

新式类有很多优势:

* 基于内建类型构建新的用户类型
* 支持property和描述符特性等.
* 定义了一些特殊方法,子类可以对这些方法进行覆盖以满足自身的特殊需求.

		`__new__()`
		`__init__()`
		`__delattr__()`
		`__getattribute__()`
		`__setattr__()`
		`__hash__()`
		`__repr__()`
		`__str__()`

另外新式类和旧式类还有一个区别就是在多继承的时候，查找要调用的方法。新式类是广度优先的查找算法。旧式类的查找方法是深度优先的.

# 参考资料

* [Python 类型和对象 - 啄木鸟社区](http://wiki.woodpecker.org.cn/moin/PyTypesAndObjects)
* [为什么要有type和object?](http://hackerxu.com/2014/11/26/type_object.html)
* [Python 新式类介绍](http://www.kaka-ace.com/python2_new-style-and-classic-classes/)
* [Python:类和对象object](http://gohom.win/2015/10/20/pyObject/)
