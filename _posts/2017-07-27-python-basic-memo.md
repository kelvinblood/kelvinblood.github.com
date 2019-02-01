---
layout: post
title:   Python 基础的笔记
category: tech
tags:  python
---
![](https://cdn.kelu.org/blog/tags/python.jpg)

大学时候就写了不少 Python 代码。最近又用到了，复习一下。 参考资料[Python 之旅 - 极客学院](http://wiki.jikexueyuan.com/project/explore-python/)

# 背景知识

Python2 的默认编码是 ascii，Python3 的默认编码是 utf-8

# 输入输出

Python2 提供了 `input`，`raw_input`，`print` 等用于输入输出，但在 Python3 中发生了一些改变，`raw_input` 已经没有了，`input` 的用法发生了变化，`print` 也从原来的语句变成了一个函数。

```python
name = input('please input your name: ')
```

使用 `input` 的时候，如果输入的是字符串，必须使用引号把它们括起来；如果输入的是数值类型，则返回的也是数值类型；如果输入的是表达式，会对表达式进行运算。

```python
print('%10.3f' %pi)     # 字段宽度 10，精度 3
print('%010.3f' % pi)    # 用 0 填充空白
print('%+f' % pi)        # 显示正负号
print('%10.3f' %pi) ,     # 不换行输出，逗号，中间填充空格
```

Python3 中使用 print 必须加括号。

```python
print(i, end='')    # 加上一个 end 参数 不换行输出
```

# 数据类型

## 定义

```python
# 列表[] 值，可以对它进行随意修改。 
numbers = [1, 2, 3, 4, 5, 5, 7, 8]
words = ['hello', 'world', 'you', 'me', 'he']
numbers[1]
words[2]

# 元组() 元组是一种不可变序列,不能赋值
a = (1, 2, 3)   
a[2] 

# 字符串'' 和元组一样，不可变不能赋值：
s = 'hello, '
s[3]

# 字典{} 键值对 
d1 = {'name': 'ethan', 'age': 20}
d1['age']

# 集合{} 键，无值
s1 = {'a', 'b', 'c', 'a', 'd', 'b'}
```

## 列表

列表常用方法：

*   index
*   count
*   append
*   extend
*   insert
*   pop
*   remove
*   reverse
*   sort

字符串常用方法：
*   find
*   split
*   join
*   strip
*   replace
*   translate
*   lower/upper

字典常用方法

*   clear
*   copy
*   get
*   setdefault
*   update
*   pop
*   popitem
*   keys/iterkeys
*   values/itervalues
*   items/iteritems
*   fromkeys

# 函数

*   参数组合在使用的时候是有顺序的，依次是必选参数、默认参数、可变参数和关键字参数。
*   `*args` 和 `**kwargs` 是 Python 的惯用写法。


```python
def func(x, y, z=0, *args, **kwargs):
    print 'x =', x
    print 'y =', y
    print 'z =', z
    print 'args =', args
    print 'kwargs =', kwargs
```

# 语句

## if else

```python
num = 5     
if num == 3:            # 判断num的值
    print 'boss'    
elif num < 0:           # 值小于零时输出
    print 'error'
else:
    print 'roadman'     # 条件均不成立时输出
```

## while

```python
count = 0
while (count < 9):
   print 'The count is:', count
   count = count + 1
 
print "Good bye!"
```

## for

```python
for iterating_var in sequence: 
	statements(s)


for (index,iterating_var) in sequence: 
	statements(s)

# 序列索引
fruits = ['banana', 'apple',  'mango']
for index in range(len(fruits)):
   print '当前水果 :', fruits[index]
 
print "Good bye!"

# 输出 2 到 100 的质数
prime = []
for num in range(2,100):  # 迭代 2 到 100 之间的数字
   for i in range(2,num): # 根据因子迭代
      if num%i == 0:      # 确定第一个因子
         break            # 跳出当前循环
   else:                  # 循环的 else 部分
      prime.append(num)
print prime
```

## try...catch...

```python
try:
     Normal execution block
except A:
     Exception A handle
except B:
     Exception B handle
except:
     Other exception handle
else:
     if no exception,get here
finally:
     print("finally")
```

# 参考资料

* [Python 之旅 - 极客学院](http://wiki.jikexueyuan.com/project/explore-python/)
* [Python 基础语法](http://www.runoob.com/python/python-basic-syntax.html)
* [Python 教程](http://python.usyiyi.cn/translate/python_278/tutorial/index.html)