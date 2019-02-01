---
layout: post
title: 数据库入门
category: tech
tags: database tutorial
---

前几天写的git入门，在开发的时候还蛮用的上的。目前对MySQL的掌握也比较薄弱，一鼓作气，把一些数据库的知识也归纳一下。

## MySQL

数据库（Database）是按照数据结构来组织、存储和管理数据的仓库，我们也可以将数据存储在文件中，但是在文件中读写数据速度相对较慢。

根据存储模型划分，数据库类型主要可分为
* 网状数据库(Network Database)
* 关系数据库(Relational Database)
* 树状数据库(Hierarchical Database)
* 面向对象数据库(Object-oriented Database)等。



### 简介
MySQL是一个小型关系型数据库管理系统，开发者为瑞典MySQL AB公司。在2008年1月16号被Sun公司收购。而2009年,SUN又被Oracle收购.对于Mysql的前途,没有任何人抱乐观的态度.目前MySQL被广泛地应用在Internet上的中小型网站中。由于其体积小、速度快、总体拥有成本低，尤其是开放源码这一特点，许多中小型网站为了降低网站总体拥有成本而选择了MySQL作为网站数据库。

所谓的关系型数据库，是建立在关系模型基础上的数据库，借助于集合代数等数学概念和方法来处理数据库中的数据。

在关系数据库模型中，二维表的列称为属性或者说是字段，二维表的行称为记录或者说是元组。

### 特性

* 使用C和C++编写，并使用了多种编译器进行测试，保证源代码的可移植性
* 支持AIX、FreeBSD、HP-UX、Linux、Mac OS、Novell Netware、OpenBSD、OS/2 Wrap、Solaris、Windows等多种操作系统 　　
* 为多种编程语言提供了API。这些编程语言包括C、C++、Python、Java、Perl、PHP、Eiffel、Ruby和Tcl等。 　　
* 支持多线程，充分利用CPU资源 　　
* 优化的SQL查询算法，有效地提高查询速度 　　
* 既能够作为一个单独的应用程序应用在客户端服务器网络环境中，也能够作为一个库而嵌入到其他的软件中提供多语言支持，常见的编码如中文的GB 2312、BIG5，日文的Shift_JIS等都可以用作数据表名和数据列名 　　
* 提供TCP/IP、ODBC和JDBC等多种数据库连接途径 　　
* 提供用于管理、检查、优化数据库操作的管理工具 　　
* 可以处理拥有上千万条记录的大型数据

与其他的大型数据库例如Oracle、DB2、SQL Server等相比，MySQL规模小、功能有限（MySQL Cluster的功能和效率都相对比较差）等，但是这丝毫也没有减少它受欢迎的程度。对于一般的个人使用者和中小型企业来说，MySQL提供的功能已经绰绰有余，而且由于MySQL是开放源码软件，因此可以大大降低总体拥有成本。 

## 代码

ps：因为我使用MySQL的机会并不是很多，记到哪算哪吧。

### 常用步骤数据库

	# mysql -u root -p		# 然后输入MySQL密码
	# mysql> show databases;
	# mysql> use xxx
	# mysql> show tables;
	# mysql> SELECT * from xxxtable WHERE Column='Sanjay';
	# mysql> desc department;
	mysql> exit				# 退出

### 表结构修改

增加列

	①alter table 表名 add 列名 列类型 列参数【加的列在表的最后面】
	alter table test add username char(20) not null default '';
	alter table test add birth date not null default '0000-00-00';
	
	②alter table 表名 add 列名 列类型 列参数 after 某列【把新列加在某列后面】
	alter table test add gender char(1) not null default '' after username;
	
	③alter table 表名 add 列名 列类型 列参数 first【把新列加在最前面】
	alter table test add pid int not null default 0 first;

未完待续...


待思考：
向上扩展
水平扩展

[LICEcap]:http://www.cockos.com/licecap/
