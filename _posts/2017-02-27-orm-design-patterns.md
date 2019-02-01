---
layout: post
title: ORM 设计模式
category: tech
tags: design_pattern
---

![](https://cdn.kelu.org/blog/tags/design_patterns.jpg)

# 什么是ORM？

ORM全称Object Relational Mapping，中文是对象关系映射。它其实是创建了一个可在编程语言里使用的--“虚拟对象数据库”。我们在具体的操作实体对象的时候，就不需要再去和复杂的 SQL 语句打交道，只需简单的操作实体对象的属性和方法。至于这个对象里的数据该怎么存储又该怎么获取，通通不用关心。大大缩短了程序员的编码时间，减少了程序员对数据库的学习成本。对于敏捷开发和团队合作开发来说，好处是非常非常大的。

当然，省事的东西往往是靠牺牲性能换来的，ORM也不例外，在处理多表联查、where条件复杂之类的查询时，ORM的语法会变得复杂因而降低效率，而且越是功能强大的ORM越是消耗内存。
                               
ORM一般都针对数据模型提供了一下常见的接口函数，比如：create(), update(), save(), load(), find(), find_all(), where()等，也就是讲sql查询全部封装成了编程语言中的函数，通过函数的链式组合生成最终的SQL语句。

常见的ORM框架有：Java的Hibernate、以及很多php框架自带的ORM库。


# 数据库的设计模式

* Row Data Gateway
* Table Data Gateway
* Active Record(活动记录)
* Data Mapper(数据映射)
* Identity Map



## Row Data Gateway
![](https://cdn.kelu.org/blog/2017/02/row-data-gateway.jpg)

一个对象扮演的角色就像是数据库中单行记录,每个对象对应一行.

## Table Data Gateway
![](https://cdn.kelu.org/blog/2017/02/table-data-gateway.jpg)

Table Data Gateway中对象扮演着数据库的一张表,一个对象处理了表中所有的行记录。这种模式就是DAO。

## Active Record(活动记录)

![](https://cdn.kelu.org/blog/2017/02/active-record.jpg)

Active Record是一种和数据库结构一致的简单结构，对应每个数据库表都有一个类，每个对象负责数据库的存取过程。

Active Record则是随着ruby on rails的流行而火起来的一种ORM模式，它是把负责持久化的代码也集成到数据对象中，即这个数据对象知道怎样把自己存到数据库里。这与以往的ORM有不同，传统的ORM会把数据对象和负责持久化的代码分开，数据对象只是一个单纯包含数据的结构体，在模型层和ORM层中传递。而在Active Record中，模型层集成了ORM的功能，他们既代表实体，包含业务逻辑，又是数据对象，并负责把自己存储到数据库中，当然，存储的这一部分代码是早已在模型的父类中实现好了的，属于框架的一部分，模型只需简单的调用父类的方法来完成持久化而已。

Ruby和Laravel的ORM都采取了Active Record的模式，因此它们ORM像下面这样：

	$user = new User;
	$user->username = 'philipbrown';
	$user->save();

每个对象直接对应着数据库中的一个表：

	+----+-------------+
	| id | username    |
	+----+-------------+
	| 1  | philipbrown |
	+----+-------------+

## Data Mapper(数据映射)
## Data Mapper(数据映射)
![](https://cdn.kelu.org/blog/2017/02/data-mapper.jpg)

将内存中的数据映射到数据库中，同时保持着彼此之间的解耦

使用Data Mapper的ORM是这样的：

	$user = new User;
	$user->username = 'philipbrown';
	EntityManager::persist($user);

Data Mapper 和 Active Record最基本的区别：在Active Record中，对象有一个save()方法，对象通常会继承一个ActiveRecord的基类来实现。
而在Data Mapper模式中，对象不存在save()方法，持久化操作由一个中间类来实现。

## Identity Map
![](https://cdn.kelu.org/blog/2017/02/identity-map.jpg)

Identity Map保证每个对象只会从数据库中加载一次，一旦加载进来，将其保存到一个map中.

# 参考资料

* [wildurand-edu - github](https://github.com/willdurand-edu/php-slides/blob/master/src/common/09_databases.md)
* [orm 系列 之 常用设计模式 - 简书](http://www.jianshu.com/p/b0a3ab7f8d47)
* [架构模式中的Active Record和Data Mapper - 简书](http://www.jianshu.com/p/4a3432b514b1)
* [Active Record 基础 - RailGuides](http://guides.ruby-china.org/active_record_basics.html)
