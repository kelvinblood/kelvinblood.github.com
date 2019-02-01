---
layout: post
title: Python Selenium 的 XPath 定位方式详解
category: tech
tags:  python selenium
---
![](https://cdn.kelu.org/blog/tags/python.jpg)

先介绍一下 XPath。XPath 是一门在 XML 文档中查找信息的语言。可用来在 XML 文档中对元素和属性进行遍历。

在 selenium 中定位元素，使用 XPath 能更好的抽象代码（比如讲 XPath 表达式提取成一个单独的配置）。所以我在日常使用中尽量使用 XPath。

# HTML与XML

html 是标记语言，XML 是标记语言的元语言。

HTML和XML的最大区别在于：HTML是一个定型的标记语言，它用固有的标记来描述，显示网页内容。比如<H1>表示首行标题，有固定的尺寸。相对的，XML则没有固定的标记，XML不能描述网页具体的外观，内容，它只是描述内容的数据形式和结构。

# Xpath定位方法

本小节节选自 [Xpath定位方法深入探讨及元素定位失败常见情况](http://www.jianshu.com/p/89c10770d72c)

### 绝对定位

```
driver.findElement(By.xpath("/html/body/div/form/input"))。
```

特点：这个路径是从网页起始标签开始一直到要定位的元素的路径，如果要定位的元素在页面最下面，则这个Xpath路径会非常长。如果在要定位的元素与页面开始之间的元素有任何增减，元素定位就会失败。

### 相对定位

```
driver. findElement(By.xpath ("//input") )
```

返回查找到的第一个符合条件的元素。

特点：相对路径一般只会包含与被定位元素最近的几层元素有关，相对路径写的好的话，页面变动影响最小，而且定位准确。

### 索引定位

使用索引定位元素，索引的初始值为1。

```
driver. findElement(By.xpath ("//input[2]") )
```

返回查找到的第二个符合条件的元素。

### 属性值定位

```
driver. findElement(By.xpath ("//input[@id='username']"));
driver. findElement(By.xpath ("//img[@alt='flowr']"));
```

特点：属性定位也是比较常用的方法，如果元素中没有常见的id,name,class等直接有方法可调用的属性，也可以查找元素中是否有其他能唯一标识元素的属性，如果有，就可以用此方法定位。

### 逻辑运算符 and与or

```
driver.findElement(By.xpath("//input[@id='username' and @name='userID']"));
```

特点：多个属性值联合定位，更能准确定位到元素。并且如果多个相同标签的元素，如果其包含的属性值有不同的，也可以用这个方法区分开来。

### 属性名定位

```
driver. findElement(By.xpath ("//input[@button]"))
```

特点：此方法可以区分同一种标签，含有不同属性名的元素。定位相对简单一些儿，但也同样存在着无法区分同种标签含有同种属性名的多个元素，这个时候要配合索引定位才行。

### 属性值匹配

（a）starts-with()

```
driver. findElement(By.xpath ("//input[stars-with(@id,'user')]"))
```

（b）ends-with()

```
driver. findElement(By.xpath ("//input[ends-with(@id,'name')]"))
```

（c）contains()

```
driver. findElement(By.xpath ("//input[contains(@id,"ernam")]"))
```

特点：此方法更加灵活，可以定位属性值不太规律，或是部分变动，中间有空格的情况。注：如果属性值中间包含空格，Webdriver定位的时候容易出错，时而能定位到时而定位不到，所以应该避免用含用空格的属性值定位。可以采用此方法，进行部分属性值定位。

### 任意属性值匹配

```
driver. findElement(By.xpath ("//input[@*='username']"))
```

特点：此方法相当于模糊查询，只要欲定位的标签，如input中任何属性值等于‘username’,就能匹配成功。缺点，可能会匹配含有这个属性值的其他元素，所以我们在定位的时候要查看一下这个元素值在页面中是否唯一。

### XPath 轴匹配

选自 [Python selenium —— 父子、兄弟、相邻节点定位方式详解](https://huilansame.github.io/huilansame.github.io/archivers/father-brother-locate)

 <style type="text/css">
        table {
			width: 100%
		}
  </style>

###### 普通方式

```python
# -*- coding: utf-8 -*-
from selenium import webdriver

driver = webdriver.Chrome()
driver.get('http://www.baidu.com')

# 1.xpath 父子关系
print driver.find_element_by_xpath("//div[@id='B']/div").text

# 1.xpath 父子关系
# `.`代表当前节点; '..'代表父节点
print driver.find_element_by_xpath("//div[@id='C']/../..").text

# 1.xpath,通过父节点获取其哥哥节点
print driver.find_element_by_xpath("//div[@id='D']/../div[1]").text

# 1.xpath，通过父节点获取其弟弟节点
print driver.find_element_by_xpath("//div[@id='D']/../div[3]").text
```

###### XPath 轴

```python
# 1.xpath轴 child 父子关系
print driver.find_element_by_xpath("//div[@id='B']/child::div").text # child是xpath默认的轴，可以忽略不写

# 1.xpath轴 parent 父子关系
print driver.find_element_by_xpath("//div[@id='C']/parent::*/parent::div").text

# 1.xpath轴 preceding-sibling 哥哥节点
print driver.find_element_by_xpath("//div[@id='D']/preceding-sibling::div[1]").text

# 1.xpath轴 following-sibling 弟弟节点
print driver.find_element_by_xpath("//div[@id='D']/following-sibling::div[1]").text

# 1.xpath轴 following 弟弟节点
print driver.find_element_by_xpath("//div[@id='D']/following::*").text
```

# xpath常用函数

1.  child 选取当前节点的所有子节点
2.  parent 选取当前节点的父节点
3.  descendant 选取当前节点的所有后代节点
4.  ancestor 选取当前节点的所有先辈节点
5.  descendant-or-self 选取当前节点的所有后代节点及当前节点本身
6.  ancestor-or-self 选取当前节点所有先辈节点及当前节点本身
7.  preceding-sibling 选取当前节点之前的所有同级节点
8.  following-sibling 选取当前节点之后的所有同级节点
9.  preceding 选取当前节点的开始标签之前的所有节点
10.  following 选去当前节点的开始标签之后的所有节点
11.  self 选取当前节点
12.  attribute 选取当前节点的所有属性
13.  namespace 选取当前节点的所有命名空间节点

# 路径表达式

| 表达式 | 描述 |
|--|--|
| nodename | 选取此节点的所有子节点。 |
| / | 从根节点选取。 |
| // | 匹配任意多的节点，而不考虑它们的位置。 |
| . | 选取当前节点。 |
| .. | 选取当前节点的父节点。 |
| @ | 选取属性。 |

# 谓语（Predicates）

谓语用来查找某个特定的节点或者包含某个指定的值的节点。

| 路径表达式 | 结果 |
|--|--|
| /bookstore/book[1] | 选取属于 bookstore 子元素的第一个 book 元素。 |
| /bookstore/book[last()] | 选取属于 bookstore 子元素的最后一个 book 元素。 |
| /bookstore/book[last()-1] | 选取属于 bookstore 子元素的倒数第二个 book 元素。 |
| /bookstore/book[position()<3] | 选取最前面的两个属于 bookstore 元素的子元素的 book 元素。 |
| //title[@lang] | 选取所有拥有名为 lang 的属性的 title 元素。 |
| //title[@lang='eng'] | 选取所有 title 元素，且这些元素拥有值为 eng 的 lang 属性。 |
| /bookstore/book[price>35.00] | 选取 bookstore 元素的所有 book 元素，且其中的 price 元素的值须大于 35.00。 |
| /bookstore/book[price>35.00]/title | 选取 bookstore 元素中的 book 元素的所有 title 元素，且其中的 price 元素的值须大于 35.00。 |

# 通配符

XPath 通配符可用来选取未知的 XML 元素。

| 通配符 | 描述 |
|--|--|
| * | 匹配任何元素节点。 |
| @* | 匹配任何属性节点。 |
| node() | 匹配任何类型的节点。 |、

例子：

| 路径表达式 | 结果 |
|--|--|
| /bookstore/* | 选取 bookstore 元素的所有子元素。 |
| //* | 选取文档中的所有元素。 |
| //title[@*] | 选取所有带有属性的 title 元素。 |

# 多个表达式

通过在路径表达式中使用“|”运算符，您可以选取若干个路径
例子：

| 路径表达式 | 结果 |
|--|--|
| //book/title | //book/price | 选取 book 元素的所有 title 和 price 元素。 |
| //title | //price | 选取文档中的所有 title 和 price 元素。 |
| /bookstore/book/title | //price | 选取属于 bookstore 元素的 book 元素的所有 title 元素，以及文档中所有的 price 元素。 |

# 关键字

| 关键字 | 结果 |
|--|--|
|starts-with | 顾名思义，匹配一个属性开始位置的关键字|
|contains |匹配一个属性值中包含的字符串|
|text()| 匹配的是显示文本信息，此处也可以用来做定位用|
|Sibling| 提取指定元素的所有同级元素，即获取目标元素的所有兄弟节点。 |

例子：

| 例子 | 结果 |
|--|--|
|//input[starts-with(@name,'name1')] |    查找name属性中开始位置包含'name1'关键字的页面元素|
|//input[contains(@name,'na')]     |    查找name属性中包含na关键字的页面元素|
|//a[text()='百度搜索'] ||
| //a[contains(text(),"百度搜索")] ||
| //a[not(contains(@id, 'xx'))] ||
|//div[(contains(@class,'typeA') or contains(@class,'typeB')) and not(contains(@class,'ng-hide'))]||


# 参考资料

* [Python selenium —— 父子、兄弟、相邻节点定位方式详解](https://huilansame.github.io/huilansame.github.io/archivers/father-brother-locate)
* [xpath选择当前结点的子节点](http://blog.csdn.net/destinyuan/article/details/51297611)
* [Xpath定位方法深入探讨及元素定位失败常见情况](http://www.jianshu.com/p/89c10770d72c)
* [Python selenium —— 模拟鼠标键盘操作(ActionChains)](https://huilansame.github.io/huilansame.github.io/archivers/mouse-and-keyboard-actionchains)
* [Python selenium —— 一定要会用selenium的等待，三种等待方式解读](https://huilansame.github.io/huilansame.github.io/archivers/sleep-implicitlywait-wait)
* [在Selenium Webdriver中使用XPath Contains、Sibling函数定位](http://www.jianshu.com/p/16e96ce58f32)
* [Xpath syntax for “and not contains”](https://stackoverflow.com/questions/26640746/xpath-syntax-for-and-not-contains)
