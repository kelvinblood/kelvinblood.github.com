---
layout: post
title: sass备忘
category: tech
tags: front-end sass css
---

本文并不是科普性文章，主要是个人的资料收集和备忘。文章大部分转载自[《SegmentFault - CSS 强化装备！Sass 安装与使用》](http://segmentfault.com/a/1190000003912703)与[《阮一峰 - SASS用法指南》](http://www.ruanyifeng.com/blog/2012/06/sass.html)，需要入门的请移步这两篇文章。

## 安装配置

注意提前翻墙，或者使用淘宝 RubyGems 镜像

	gem install sass

按回车键确认，等待一段时间就会提示 Sass 安装成功。最后使用版本查看命令确保安装成功：

	sass -v

## scss和sass

* 文件扩展名不同。
Sass 是以“.sass”后缀为扩展名，而 SCSS 是以“.scss”后缀为扩展名；
* 语法书写方式不同。
Sass 是以严格的缩进式语法规则来书写，不带大括号“{}”和分号“；”，而 SCSS 的语法书写和我们的 CSS 语法书写方式非常类似。

## sass转换成css

	sass test.scss
	sass test.scss test.css
	sass --style compressed test.scss test.min.css
	// 监听文件
	sass --watch input.scss:output.css
	
	// 监听目录 
	sass --watch sassFileDirectory:cssFileDirectory




Sass 提供四个编译风格的选项：

* nested: 嵌套缩进的css代码，它是默认值；
* expanded: 没有缩进的、扩展的css代码；
* compact: 简洁格式的css代码；
* compressed：压缩后的css代码。

## 基本语法

### 1.变量

SASS允许使用变量，所有变量以$开头。

如果变量需要镶嵌在字符串之中，就必须需要写在#{}之中。`border-#{$side}-radius: 5px;`

### 2.嵌套

	ul {    
	   li {
	       display: inline-block;
	   }
	}
	
在嵌套的代码块内，可以使用&引用父元素。比如a:hover伪类，可以写成：

	a {
	　　　&:hover { color: #ffb3ff; }
	　 }

### 3.导入

	　@import "path/filename.scss";
	
### 4.mixin

Sass 中可用mixin定义一些代码片段，且可传参数，方便日后根据需求调用。从此处理 CSS 3 的前缀兼容轻松便捷。

	//sass style
	//-----------------------------------
	@mixin box-sizing ($sizing) {
	    -webkit-box-sizing: $sizing;
	       -moz-box-sizing: $sizing;
	           -box-sizing: $sizing;
	}
	.box-border {
	    border: 1px solid #ccc;
	    @include box-sizing(border-box);
	}
	
	//css style
	//-----------------------------------
	.box-border {
	    border: 1px solid #ccc;
	    -webkit-box-sizing: border-box;
	       -moz-box-sizing: border-box;
	           -box-sizing: border-box; 
	}
	
### 5.扩展/继承

Sass 可通过 @extend 来实现代码组合声明，使代码更加优越简洁。

	//sass style
	//-----------------------------------
	.bar-left {
	    border: 1px solid #ccc;
	}
	.bar-right {
	    @extend .bar-left;
	    color: #999;
	}
	
	//css style
	//-----------------------------------
	.bar-left, .bar-right {
	    border: 1px solid #ccc; 
	}
	.bar-right {
	    color: #999; 
	}

### 6.运算

Sass 可进行简单的加减乘除运算等。

	//sass style
	//-----------------------------------
	$defaultFontSize: 10px;
	.msg {
	    position: absolute;
	    top: (800px/2);
	    left: 200px + 200px;
	    font-size: $defaultFontSize * 2;
	}
	
	//css style
	//-----------------------------------
	.msg {
	    position: absolute;
	    top: 400px;
	    left: 400px;
	    font-size: 20px; 
	}
	
### 7.颜色函数
SASS提供了一些内置的颜色函数，以便生成系列颜色。

	　　lighten(#cc3, 10%) // #d6d65c
	　　darken(#cc3, 10%) // #a3a329
	　　grayscale(#cc3) // #808080
	　　complement(#cc3) // #33c

### 8.注释

Sass 共有两种注释风格。

标准的 CSS 注释 /* comment */，会保留到编译后的文件  
单行注释 // comment，只保留在 SASS 源文件中，编译后会被省略。  
提示：在/*后面加一个感叹号，表示这是“重要注释”。即使是压缩模式编译，也会保留这行注释。通常可以用于声明版权。  
	
	/*!
	    重要注释！
	*/

## 高级用法

### 条件语句

	　　@if lightness($color) > 30% {
	　　　　background-color: #000;
	　　} @else {
	　　　　background-color: #fff;
	　　}
### 循环语句
SASS支持for循环：

	　　@for $i from 1 to 10 {
	　　　　.border-#{$i} {
	　　　　　　border: #{$i}px solid blue;
	　　　　}
	　　}
　　
也支持while循环：

	　　$i: 6;
	　　@while $i > 0 {
	　　　　.item-#{$i} { width: 2em * $i; }
	　　　　$i: $i - 2;
	　　}
each命令，作用与for类似：

	　　@each $member in a, b, c, d {
	　　　　.#{$member} {
	　　　　　　background-image: url("/image/#{$member}.jpg");
	　　　　}
	　　}
	　　
### 自定义函数
SASS允许用户编写自己的函数。

	　　@function double($n) {
	　　　　@return $n * 2;
	　　}
	　　#sidebar {
	　　　　width: double(5px);
	　　}


