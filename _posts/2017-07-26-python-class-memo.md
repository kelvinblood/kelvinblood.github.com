---
layout: post
title:   Python 类的笔记
category: tech
tags:  python
---
![](https://cdn.kelu.org/blog/tags/python.jpg)

一些笔记而已。

# 面向对象

*   类是具有相同**属性**和**方法**的一组对象的集合，实例是一个个具体的对象。
*   方法是与实例绑定的函数。
*   获取对象信息可使用下面方法：
    *   `type(obj)`：来获取对象的相应类型；
    *   `isinstance(obj, type)`：判断对象是否为指定的 type 类型的实例；
    *   `hasattr(obj, attr)`：判断对象是否具有指定属性/方法；
    *   `getattr(obj, attr[, default])` 获取属性/方法的值, 要是没有对应的属性则返回 default 值（前提是设置了 default），否则会抛出 AttributeError 异常；
    *   `setattr(obj, attr, value)`：设定该属性/方法的值，类似于 obj.attr=value；
    *   `dir(obj)`：可以获取相应对象的**所有**属性和方法名的列表：

*   **方法重写：**如果从父类继承的方法不能满足子类的需求，可以对其进行改写，这个过程叫方法的覆盖（override），也称为方法的重写。
*   **实例变量：**定义在方法中的变量，只作用于当前实例的类。
*   **继承：**即一个派生类（derived class）继承基类（base class）的字段和方法。继承也允许把一个派生类的对象作为一个基类对象对待。例如，有这样一个设计：一个Dog类型的对象派生自Animal类，这是模拟"是一个（is-a）"关系（例图，Dog是一个Animal）。
*   **实例化：**创建一个类的实例，类的具体对象。
*   **方法：**类中定义的函数。
*   **对象：**通过类定义的数据结构实例。对象包括两个数据成员（类变量和实例变量）和方法。

# Python类简介

类的私有属性：

	__private_attrs  两个下划线开头，声明该属性为私有，使用时 self.__private_attrs

类的方法

	使用def关键字可以为类定义一个方法，类方法必须包含参数self,且为第一个参数

私有的类方法

	__private_method 两个下划线开头，声明该方法为私有方法，调用时 slef.__private_methods

类的专有方法(魔法方法)：

	__init__  构造函数，在生成对象时调用
	__del__   析构函数，释放对象时使用
	__repr__ 打印，转换
	__setitem__按照索引赋值
	__getitem__按照索引获取值
	
	__len__获得长度
	__cmp__比较运算
	__call__函数调用
	
	__add__加运算
	__sub__减运算
	__mul__乘运算
	__div__除运算
	__mod__求余运算
	__pow__称方

*   `__new__` 在 `__init__` 之前被调用，用来创建实例。
*   `__str__` 是用 print 和 str 显示的结果，`__repr__` 是直接显示的结果。
*   `__getitem__` 用类似 `obj[key]` 的方式对对象进行取值
*   `__getattr__` 用于获取不存在的属性 obj.attr
*   `__call__` 使得可以对实例进行调用

使用 `dir(obj)` 可以获取相应对象的**所有**属性和方法名的列表，以下是个例子

```python
['__class__',
 '__delattr__',
 '__dict__',
 '__doc__',
 '__format__',
 '__getattribute__',
 '__hash__',
 '__init__',
 '__module__',
 '__new__',
 '__reduce__',
 '__reduce_ex__',
 '__repr__',
 '__setattr__',
 '__sizeof__',
 '__str__',
 '__subclasshook__',
 '__weakref__',
 'age',
 'greet',
 'name']
```

# 示例

```python
class People:
    name = ''
    age = 0
    __weight = 0

    def __init__(self,n,a,w):
        self.name = n
        self.age = a
        self.__weight = w
    def speak(self):
        print("%s is speaking: I am %d years old" %(self.name,self.age))


p = People('tom',10,30)
p.speak()
```

# 继承和多态

```python
class Man(People):
    def speak(self):
        print 'hello.., I am %s. ' %self.name
```

# 类方法和静态方法

```python
class A(object):
	@classmethod
	def class_foo(cls)
	
	@staticmethod
	def static_foo():
```

类方法参数是 cls，静态方法没有 self 参数

# slots 魔法

限定允许动态绑定的属性，减少因为动态绑定带来的内存消耗。

*   `__slots__` 设置的属性仅对当前类有效，对继承的子类不起效，除非子类也定义了 slots，这样，子类允许定义的属性就是自身的 slots 加上父类的 slots。

# @property

把方法『变成』了属性。如果不设定 setter，就是只读属性。

```python
class Exam(object):
    def __init__(self, score):
        self._score = score

    @property
    def score(self):
        return self._score

    @score.setter
    def score(self, val):
        if val < 0:
            self._score = 0
        elif val > 100:
            self._score = 100
        else:
            self._score = val

```

# super

`super` 的一个最常见用法是在子类中调用父类的初始化方法。你可以认为 super 调用了父类的方法，实际上和父类没有什么关系。

对于我们定义的每一个类，Python 会计算出一个**方法解析顺序（Method Resolution Order, MRO）列表**，**它代表了类继承的顺序**，更加具体的内容查看这里<http://wiki.jikexueyuan.com/project/explore-python/Class/super.html>


# 元类 metaclass

*   在 Python 中，类也是一个对象。
*   类创建实例，元类创建类。
*   元类主要做了三件事：
    *   拦截类的创建
    *   修改类的定义
    *   返回修改后的类
*   当你创建类时，解释器会调用元类来生成它，定义一个继承自 object 的普通类意味着调用 type 来创建它。

更加具体的内容查看这里<http://wiki.jikexueyuan.com/project/explore-python/Class/metaclass.html>
