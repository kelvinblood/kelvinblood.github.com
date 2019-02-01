---
layout: post
title: javascript入门
category: tech
tags: front-end javascript tutorial
---

最近使用javascript的频率比较多，是不是会和PHP弄混。于是记录一些简单的信息信息，避免每次都去查阅手册。注意，这并不是一个完整的入门教程，例如我不会在本文包含最基础的加减乘除此类的信息。

## 目录

1. 基本知识
1. js 对象
1. DOM 文档对象模型
1. BOM 浏览器对象模型 

## 1 基本知识

JavaScript 是因特网上最流行的脚本语言。

1. 语法
1. 变量
1. 数据类型
1. 对象Object
1. 语句
1. 函数
1. 运算


### 1.1 语法

	<script> 和 </script> 之间的代码行包含了 JavaScript
	<script type="text/javascript" src="jq.js ></script>
	
	分号用于分隔 JavaScript 语句
	JavaScript 对大小写是敏感的。
	javascript是动态类型
	
	单行注释以 // 开头。
	多行注释以 /* 开始，以 */ 结尾。

### 1.2 变量

	var name="Gates",
	age=56,
	job="CEO";
	
未使用值来声明的变量，其值实际上是 undefined。

JavaScript 中的所有事物都是对象(拥有属性和方法)。
	
变量类型有：数据类型，字符串、数字、布尔、数组、对象、Null、Undefined。

### 1.3 数据类型

	var carname=new String;
	var x=      new Number;
	var y=      new Boolean;
	var cars=   new Array("hello","world","2");
	var person= new Object;

	var myString = "hello";
	var i1 = 3.2;
	var flag = true;
	var arr=["Hello","world"];	// 静态定义（相同数据类型的集合）
	var arr2= new Array("hello","world","2"); // 
	var cars= new Array();
	cars[0]="Audi";
	cars[1]="BMW";
	cars[2]="Volvo";
	
	数组的显示是[]包裹(使用console.log查看)


#### 1.4 对象Object

	对象的显示是{}包裹。(使用console.log查看)

	// 这个people将会以全局方式村子啊。如果加一个var，那就是局部的。
	people = new Object();
	people.name = 'bill';
	people.age = 13;

	或者这么定义:
	
	people = {name:"bill",age:30};
	
	或者使用函数来定义一个类对象。
	
	function people(name,age){
		this._name = name;
		this._age = age;
	}
	son = new people('bill',23);

### 1.5 语句

	if else
	for
	while
	switch case
	try catch
	
	for (变量x in 对象array)
	{
	    在此执行代码
	    array[x];
	}

### 1.6 函数

通常，我们需要在某个事件发生时执行代码，比如当用户点击按钮时。
如果我们把 JavaScript 代码放入函数中，就可以在事件发生时调用该函数。

	function demo(a,b){}
	
	// 两种调用方法
	1. demo();
	2. <button onclick="demo()"></button>

### 1.7 运算

如果把数字与字符串相加，结果将成为字符串。

有一个比较特别的运算符 === ，给定 x=5

	===	全等（值和类型）	x===5 为 true；x==="5" 为 false

## 2 JS 对象
	
1. JS Array
1. JS Boolean
1. JS Date
1. JS Math
1. JS Number
1. JS String
1. JS RegExp
1. JS Functions


### 2.1 Array 对象

	属性
	constructor	返回对创建此对象的数组函数的引用。
	length	设置或返回数组中元素的数目。
	prototype	使您有能力向对象添加属性和方法。
	
	方法
	concat()	连接两个或更多的数组，并返回结果。
	join()	把数组的所有元素放入一个字符串。元素通过指定的分隔符进行分隔。
	pop()	删除并返回数组的最后一个元素
	push()	向数组的末尾添加一个或更多元素，并返回新的长度。
	reverse()	颠倒数组中元素的顺序。
	shift()	删除并返回数组的第一个元素
	slice()	从某个已有的数组返回选定的元素
	sort()	对数组的元素进行排序
	splice()	删除元素，并向数组添加新元素。
	toSource()	返回该对象的源代码。
	toString()	把数组转换为字符串，并返回结果。
	toLocaleString()	把数组转换为本地数组，并返回结果。
	unshift()	向数组的开头添加一个或更多元素，并返回新的长度。
	valueOf()	返回数组对象的原始值
	
### 2.2 Boolean 对象

	属性
	constructor	返回对创建此对象的 Boolean 函数的引用
	prototype	使您有能力向对象添加属性和方法。
	
	方法
	toSource()	返回该对象的源代码。
	toString()	把逻辑值转换为字符串，并返回结果。
	valueOf()	返回 Boolean 对象的原始值。

### 2.3 Date 对象
		
	属性
	constructor	返回对创建此对象的 Date 函数的引用。
	prototype	使您有能力向对象添加属性和方法。
	
	方法
	Date()	返回当日的日期和时间。
	getDate()	从 Date 对象返回一个月中的某一天 (1 ~ 31)。
	getDay()	从 Date 对象返回一周中的某一天 (0 ~ 6)。
	getMonth()	从 Date 对象返回月份 (0 ~ 11)。
	getFullYear()	从 Date 对象以四位数字返回年份。
	getYear()	请使用 getFullYear() 方法代替。
	getHours()	返回 Date 对象的小时 (0 ~ 23)。
	getMinutes()	返回 Date 对象的分钟 (0 ~ 59)。
	getSeconds()	返回 Date 对象的秒数 (0 ~ 59)。
	getMilliseconds()	返回 Date 对象的毫秒(0 ~ 999)。
	getTime()	返回 1970 年 1 月 1 日至今的毫秒数。
	getTimezoneOffset()	返回本地时间与格林威治标准时间 (GMT) 的分钟差。
	getUTCDate()	根据世界时从 Date 对象返回月中的一天 (1 ~ 31)。
	getUTCDay()	根据世界时从 Date 对象返回周中的一天 (0 ~ 6)。
	getUTCMonth()	根据世界时从 Date 对象返回月份 (0 ~ 11)。
	getUTCFullYear()	根据世界时从 Date 对象返回四位数的年份。
	getUTCHours()	根据世界时返回 Date 对象的小时 (0 ~ 23)。
	getUTCMinutes()	根据世界时返回 Date 对象的分钟 (0 ~ 59)。
	getUTCSeconds()	根据世界时返回 Date 对象的秒钟 (0 ~ 59)。
	getUTCMilliseconds()	根据世界时返回 Date 对象的毫秒(0 ~ 999)。
	parse()	返回1970年1月1日午夜到指定日期（字符串）的毫秒数。
	setDate()	设置 Date 对象中月的某一天 (1 ~ 31)。
	setMonth()	设置 Date 对象中月份 (0 ~ 11)。
	setFullYear()	设置 Date 对象中的年份（四位数字）。
	setYear()	请使用 setFullYear() 方法代替。
	setHours()	设置 Date 对象中的小时 (0 ~ 23)。
	setMinutes()	设置 Date 对象中的分钟 (0 ~ 59)。
	setSeconds()	设置 Date 对象中的秒钟 (0 ~ 59)。
	setMilliseconds()	设置 Date 对象中的毫秒 (0 ~ 999)。
	setTime()	以毫秒设置 Date 对象。
	setUTCDate()	根据世界时设置 Date 对象中月份的一天 (1 ~ 31)。
	setUTCMonth()	根据世界时设置 Date 对象中的月份 (0 ~ 11)。
	setUTCFullYear()	根据世界时设置 Date 对象中的年份（四位数字）。
	setUTCHours()	根据世界时设置 Date 对象中的小时 (0 ~ 23)。
	setUTCMinutes()	根据世界时设置 Date 对象中的分钟 (0 ~ 59)。
	setUTCSeconds()	根据世界时设置 Date 对象中的秒钟 (0 ~ 59)。
	setUTCMilliseconds()	根据世界时设置 Date 对象中的毫秒 (0 ~ 999)。
	toSource()	返回该对象的源代码。
	toString()	把 Date 对象转换为字符串。
	toTimeString()	把 Date 对象的时间部分转换为字符串。
	toDateString()	把 Date 对象的日期部分转换为字符串。
	toGMTString()	请使用 toUTCString() 方法代替。
	toUTCString()	根据世界时，把 Date 对象转换为字符串。
	toLocaleString()	根据本地时间格式，把 Date 对象转换为字符串。
	toLocaleTimeString()	根据本地时间格式，把 Date 对象的时间部分转换为字符串。
	toLocaleDateString()	根据本地时间格式，把 Date 对象的日期部分转换为字符串。
	UTC()	根据世界时返回 1970 年 1 月 1 日 到指定日期的毫秒数。
	valueOf()	返回 Date 对象的原始值。
	

### 2.4 Math 对象

	属性
	E	返回算术常量 e，即自然对数的底数（约等于2.718）。
	LN2	返回 2 的自然对数（约等于0.693）。
	LN10	返回 10 的自然对数（约等于2.302）。
	LOG2E	返回以 2 为底的 e 的对数（约等于 1.414）。
	LOG10E	返回以 10 为底的 e 的对数（约等于0.434）。
	PI	返回圆周率（约等于3.14159）。
	SQRT1_2	返回返回 2 的平方根的倒数（约等于 0.707）。
	SQRT2	返回 2 的平方根（约等于 1.414）。
	
	方法
	abs(x)	返回数的绝对值。
	acos(x)	返回数的反余弦值。
	asin(x)	返回数的反正弦值。
	atan(x)	以介于 -PI/2 与 PI/2 弧度之间的数值来返回 x 的反正切值。
	atan2(y,x)	返回从 x 轴到点 (x,y) 的角度（介于 -PI/2 与 PI/2 弧度之间）。
	ceil(x)	对数进行上舍入。
	cos(x)	返回数的余弦。
	exp(x)	返回 e 的指数。
	floor(x)	对数进行下舍入。
	log(x)	返回数的自然对数（底为e）。
	max(x,y)	返回 x 和 y 中的最高值。
	min(x,y)	返回 x 和 y 中的最低值。
	pow(x,y)	返回 x 的 y 次幂。
	random()	返回 0 ~ 1 之间的随机数。
	round(x)	把数四舍五入为最接近的整数。
	sin(x)	返回数的正弦。
	sqrt(x)	返回数的平方根。
	tan(x)	返回角的正切。
	toSource()	返回该对象的源代码。
	valueOf()	返回 Math 对象的原始值。
	
### 2.5 Number 对象

	属性
	constructor	返回对创建此对象的 Number 函数的引用。
	MAX_VALUE	可表示的最大的数。
	MIN_VALUE	可表示的最小的数。
	NaN	非数字值。
	NEGATIVE_INFINITY	负无穷大，溢出时返回该值。
	POSITIVE_INFINITY	正无穷大，溢出时返回该值。
	prototype	使您有能力向对象添加属性和方法。

	方法
	toString	把数字转换为字符串，使用指定的基数。
	toLocaleString	把数字转换为字符串，使用本地数字格式顺序。
	toFixed	把数字转换为字符串，结果的小数点后有指定位数的数字。
	toExponential	把对象的值转换为指数计数法。
	toPrecision	把数字格式化为指定的长度。
	valueOf	返回一个 Number 对象的基本数字值。


### 2.6 String字符串对象

	属性
	constructor	对创建该对象的函数的引用
	length	字符串的长度
	prototype	允许您向对象添加属性和方法
	
	方法
	anchor()	创建 HTML 锚。
	big()	用大号字体显示字符串。
	blink()	显示闪动字符串。
	bold()	使用粗体显示字符串。
	charAt()	返回在指定位置的字符。
	charCodeAt()	返回在指定的位置的字符的 Unicode 编码。
	concat()	连接字符串。
	fixed()	以打字机文本显示字符串。
	fontcolor()	使用指定的颜色来显示字符串。
	fontsize()	使用指定的尺寸来显示字符串。
	fromCharCode()	从字符编码创建一个字符串。
	indexOf()	检索字符串。
	italics()	使用斜体显示字符串。
	lastIndexOf()	从后向前搜索字符串。
	link()	将字符串显示为链接。
	localeCompare()	用本地特定的顺序来比较两个字符串。
	match()	找到一个或多个正则表达式的匹配。
	replace()	替换与正则表达式匹配的子串。
	search()	检索与正则表达式相匹配的值。
	slice()	提取字符串的片断，并在新的字符串中返回被提取的部分。
	small()	使用小字号来显示字符串。
	split()	把字符串分割为字符串数组。
	strike()	使用删除线来显示字符串。
	sub()	把字符串显示为下标。
	substr()	从起始索引号提取字符串中指定数目的字符。
	substring()	提取字符串中两个指定的索引号之间的字符。
	sup()	把字符串显示为上标。
	toLocaleLowerCase()	把字符串转换为小写。
	toLocaleUpperCase()	把字符串转换为大写。
	toLowerCase()	把字符串转换为小写。
	toUpperCase()	把字符串转换为大写。
	toSource()	代表对象的源代码。
	toString()	返回字符串。
	valueOf()	返回某个字符串对象的原始值。
	

### 2.7 RegExp 对象

直接语法
`/pattern/attributes`

创建 RegExp 对象的语法
`new RegExp(pattern, attributes)`

	修饰符	
	i	执行对大小写不敏感的匹配。
	g	执行全局匹配（查找所有匹配而非在找到第一个匹配后停止）。
	m	执行多行匹配。
	
	表达式	
	[abc]	查找方括号之间的任何字符。
	[^abc]	查找任何不在方括号之间的字符。
	[0-9]	查找任何从 0 至 9 的数字。
	[a-z]	查找任何从小写 a 到小写 z 的字符。
	[A-Z]	查找任何从大写 A 到大写 Z 的字符。
	[A-z]	查找任何从大写 A 到小写 z 的字符。
	[adgk]	查找给定集合内的任何字符。
	[^adgk]	查找给定集合外的任何字符。
	(red|blue|green)	查找任何指定的选项。
	
	元字符	
	.	查找单个字符，除了换行和行结束符。
	\w	查找单词字符。
	\W	查找非单词字符。
	\d	查找数字。
	\D	查找非数字字符。
	\s	查找空白字符。
	\S	查找非空白字符。
	\b	匹配单词边界。
	\B	匹配非单词边界。
	\0	查找 NUL 字符。
	\n	查找换行符。
	\f	查找换页符。
	\r	查找回车符。
	\t	查找制表符。
	\v	查找垂直制表符。
	\xxx	查找以八进制数 xxx 规定的字符。
	\xdd	查找以十六进制数 dd 规定的字符。
	\uxxxx	查找以十六进制数 xxxx 规定的 Unicode 字符。
	
	量词	
	n+	匹配任何包含至少一个 n 的字符串。
	n*	匹配任何包含零个或多个 n 的字符串。
	n?	匹配任何包含零个或一个 n 的字符串。
	n{X}	匹配包含 X 个 n 的序列的字符串。
	n{X,Y}	匹配包含 X 或 Y 个 n 的序列的字符串。
	n{X,}	匹配包含至少 X 个 n 的序列的字符串。
	n$	匹配任何结尾为 n 的字符串。
	^n	匹配任何开头为 n 的字符串。
	?=n	匹配任何其后紧接指定字符串 n 的字符串。
	?!n	匹配任何其后没有紧接指定字符串 n 的字符串。
	
	属性		
	global	RegExp 对象是否具有标志 g。	
	ignoreCase	RegExp 对象是否具有标志 i。	
	lastIndex	一个整数，标示开始下一次匹配的字符位置。	
	multiline	RegExp 对象是否具有标志 m。	
	source	正则表达式的源文本。	
	
	方法		
	compile	编译正则表达式。	
	exec	检索字符串中指定的值。返回找到的值，并确定其位置。	
	test	检索字符串中指定的值。返回 true 或 false。	
	
	支持正则表达式的 String 对象的方法
	方法		
	search	检索与正则表达式相匹配的值。	
	match	找到一个或多个正则表达式的匹配。	
	replace	替换与正则表达式匹配的子串。	
	split	把字符串分割为字符串数组。
	

#### 2.8 全局对象

	函数
	decodeURI()	解码某个编码的 URI。
	decodeURIComponent()	解码一个编码的 URI 组件。
	encodeURI()	把字符串编码为 URI。
	encodeURIComponent()	把字符串编码为 URI 组件。
	escape()	对字符串进行编码。
	eval()	计算 JavaScript 字符串，并把它作为脚本代码来执行。
	getClass()	返回一个 JavaObject 的 JavaClass。
	isFinite()	检查某个值是否为有穷大的数。
	isNaN()	检查某个值是否是数字。
	Number()	把对象的值转换为数字。
	parseFloat()	解析一个字符串并返回一个浮点数。
	parseInt()	解析一个字符串并返回一个整数。
	String()	把对象的值转换为字符串。
	unescape()	对由 escape() 编码的字符串进行解码。
	
	属性
	Infinity	代表正的无穷大的数值。
	java	代表 java.* 包层级的一个 JavaPackage。
	NaN	指示某个值是不是数字值。
	Packages	根 JavaPackage 对象。
	undefined	指示未定义的值。

## 3 DOM 文档对象模型

1. DOM 简介
1. DOM 对象
1. DOM 事件
1. DOM HTML
1. DOM CSS

### 3.1 DOM简介

DOM 是 W3C（万维网联盟）的标准。

JavaScript 能够改变页面中的所有 HTML 元素、 属性、CSS 样式，并且能够对页面中的所有事件做出反应。

### 3.2 DOM 对象

#### document对象

当网页被加载时，浏览器会创建页面的文档对象模型（Document Object Model）。
Document 对象使我们可以从脚本中对 HTML 页面中的所有元素进行访问。

	方法
	getElementById()	返回对拥有指定 id 的第一个对象的引用。
	getElementsByName()	返回带有指定名称的对象集合。
	getElementsByTagName()	返回带有指定标签名的对象集合。

	属性
	body
	cookie	设置或返回与当前文档有关的所有 cookie。
	domain	返回当前文档的域名。
	lastModified	返回文档被最后修改的日期和时间。
	referrer	返回载入当前文档的文档的 URL。
	title	返回当前文档的标题。
	URL		返回当前文档的 URL。

	集合
	all[]	提供对文档中所有 HTML 元素的访问。
	anchors[]	返回对文档中所有 Anchor 对象的引用。
	applets	返回对文档中所有 Applet 对象的引用。
	forms[]	返回对文档中所有 Form 对象引用。
	images[]	返回对文档中所有 Image 对象引用。
	links[]	返回对文档中所有 Area 和 Link 对象引用。

在这里顺带说一下jQuery，获取对象的方法为：

	$("button").text(xxx);
	$("#id").text(xxx);
	$(".class").text();

#### element对象

在 HTML DOM 中，Element 对象表示 HTML 元素。
换一种说法，从document对象中的id、标签名或者类名找到的元素，就称为element对象。

Element 对象可以拥有类型为元素节点、文本节点、注释节点的子节点。

	属性 / 方法
	element.accessKey	设置或返回元素的快捷键。
	element.appendChild()	向元素添加新的子节点，作为最后一个子节点。
	element.attributes	返回元素属性的 NamedNodeMap。
	element.childNodes	返回元素子节点的 NodeList。
	element.className	设置或返回元素的 class 属性。
	element.clientHeight	返回元素的可见高度。
	element.clientWidth	返回元素的可见宽度。
	element.cloneNode()	克隆元素。
	element.compareDocumentPosition()	比较两个元素的文档位置。
	element.contentEditable	设置或返回元素的文本方向。
	element.dir	设置或返回元素的文本方向。
	element.firstChild	返回元素的首个子。
	element.getAttribute()	返回元素节点的指定属性值。
	element.getAttributeNode()	返回指定的属性节点。
	element.getElementsByTagName()	返回拥有指定标签名的所有子元素的集合。
	element.getFeature()	返回实现了指定特性的 API 的某个对象。
	element.getUserData()	返回关联元素上键的对象。
	element.hasAttribute()	如果元素拥有指定属性，则返回true，否则返回 false。
	element.hasAttributes()	如果元素拥有属性，则返回 true，否则返回 false。
	element.hasChildNodes()	如果元素拥有子节点，则返回 true，否则 false。
	element.id	设置或返回元素的 id。
	element.innerHTML	设置或返回元素的内容。
	element.insertBefore()	在指定的已有的子节点之前插入新节点。
	element.isContentEditable	设置或返回元素的内容。
	element.isDefaultNamespace()	如果指定的 namespaceURI 是默认的，则返回 true，否则返回 false。
	element.isEqualNode()	检查两个元素是否相等。
	element.isSameNode()	检查两个元素是否是相同的节点。
	element.isSupported()	如果元素支持指定特性，则返回 true。
	element.lang	设置或返回元素的语言代码。
	element.lastChild	返回元素的最后一个子元素。
	element.namespaceURI	返回元素的 namespace URI。
	element.nextSibling	返回位于相同节点树层级的下一个节点。
	element.nodeName	返回元素的名称。
	element.nodeType	返回元素的节点类型。
	element.nodeValue	设置或返回元素值。
	element.normalize()	合并元素中相邻的文本节点，并移除空的文本节点。
	element.offsetHeight	返回元素的高度。
	element.offsetWidth	返回元素的宽度。
	element.offsetLeft	返回元素的水平偏移位置。
	element.offsetParent	返回元素的偏移容器。
	element.offsetTop	返回元素的垂直偏移位置。
	element.ownerDocument	返回元素的根元素（文档对象）。
	element.parentNode	返回元素的父节点。
	element.previousSibling	返回位于相同节点树层级的前一个元素。
	element.removeAttribute()	从元素中移除指定属性。
	element.removeAttributeNode()	移除指定的属性节点，并返回被移除的节点。
	element.removeChild()	从元素中移除子节点。
	element.replaceChild()	替换元素中的子节点。
	element.scrollHeight	返回元素的整体高度。
	element.scrollLeft	返回元素左边缘与视图之间的距离。
	element.scrollTop	返回元素上边缘与视图之间的距离。
	element.scrollWidth	返回元素的整体宽度。
	element.setAttribute()	把指定属性设置或更改为指定值。
	element.setAttributeNode()	设置或更改指定属性节点。
	element.setIdAttribute()	
	element.setIdAttributeNode()	
	element.setUserData()	把对象关联到元素上的键。
	element.style	设置或返回元素的 style 属性。
	element.tabIndex	设置或返回元素的 tab 键控制次序。
	element.tagName	返回元素的标签名。
	element.textContent	设置或返回节点及其后代的文本内容。
	element.title	设置或返回元素的 title 属性。
	element.toString()	把元素转换为字符串。
	nodelist.item()	返回 NodeList 中位于指定下标的节点。
	nodelist.length	返回 NodeList 中的节点数。
	

### 3.3 DOM 事件

HTML 4.0 的新特性之一是能够使 HTML 事件触发浏览器中的行为，比如当用户点击某个 HTML 元素时启动一段 JavaScript。下面是一个属性列表，可将之插入 HTML 标签以定义事件的行为。

	属性
	onabort	图像的加载被中断。
	onblur	元素失去焦点。
	onchange	域的内容被改变。
	onclick	当用户点击某个对象时调用的事件句柄。
	ondblclick	当用户双击某个对象时调用的事件句柄。
	onerror	在加载文档或图像时发生错误。
	onfocus	元素获得焦点。
	onkeydown	某个键盘按键被按下。
	onkeypress	某个键盘按键被按下并松开。
	onkeyup	某个键盘按键被松开。
	onload	一张页面或一幅图像完成加载。
	onmousedown	鼠标按钮被按下。
	onmousemove	鼠标被移动。
	onmouseout	鼠标从某元素移开。
	onmouseover	鼠标移到某元素之上。
	onmouseup	鼠标按键被松开。
	onreset	重置按钮被点击。
	onresize	窗口或框架被重新调整大小。
	onselect	文本被选中。
	onsubmit	确认按钮被点击。
	onunload	用户退出页面。

	移动设备
	touchstart: 当手指触摸屏幕时触发，即使是一个手指放在屏幕上也会触发。
	touchmove:当手指在屏幕上滑动时连续地触发，这个事件发生期间，我们可以使用preventDefault()事件可以阻止滚动。
	touchend: 当手指从屏幕上移开时触发。
	touchcancel: 当系统停止跟踪触摸时触发


用法示例

	<p><a href="http://developer.mozilla.org/" onmouseover="oTooltip.append(event,'Example text 1');" onmousemove="oTooltip.follow(event);" onmouseout="oTooltip.remove();">Move your mouse here&hellip;</a></p>

	
鼠标 / 键盘属性

	altKey	返回当事件被触发时，"ALT" 是否被按下。
	button	返回当事件被触发时，哪个鼠标按钮被点击。
	clientX	返回当事件被触发时，鼠标指针的水平坐标。
	clientY	返回当事件被触发时，鼠标指针的垂直坐标。
	ctrlKey	返回当事件被触发时，"CTRL" 键是否被按下。
	metaKey	返回当事件被触发时，"meta" 键是否被按下。
	relatedTarget	返回与事件的目标节点相关的节点。
	screenX	返回当某个事件被触发时，鼠标指针的水平坐标。
	screenY	返回当某个事件被触发时，鼠标指针的垂直坐标。
	shiftKey	返回当事件被触发时，"SHIFT" 键是否被按下。



### 3.4 DOM HTML

在 JavaScript 中，document.write() 可用于直接向 HTML 输出流写内容。

修改 HTML 内容的最简单的方法时使用 innerHTML 属性。

	document.getElementById(id).innerHTML=new HTML

改变 HTML 元素的属性

	document.getElementById(id).attribute=new value

### 3.5 DOM CSS

	document.getElementById(id).style.property=new style

### 4 BOM 浏览器对象模型 

浏览器对象模型（Browser Object Model）尚无正式标准。所有浏览器都支持 window 对象。它表示浏览器窗口。

甚至 HTML DOM 的 document 也是 window 对象的属性之一。

1. JS Window. Window 对象表示浏览器中打开的窗口。
1. JS Navigator. Navigator 对象包含有关浏览器的信息。
1. JS History. History 对象包含用户（在浏览器窗口中）访问过的 URL。
1. JS Location. Location 对象包含有关当前 URL 的信息。
1. JS Screen. Screen 对象包含有关客户端显示屏幕的信息。

#### 4.1 window对象
Window 对象表示浏览器中打开的窗口。
如果文档包含框架（frame 或 iframe 标签），浏览器会为 HTML 文档创建一个 window 对象，并为每个框架创建一个额外的 window 对象。

	属性
	closed	返回窗口是否已被关闭。
	defaultStatus	设置或返回窗口状态栏中的默认文本。
	document	对 Document 对象的只读引用。请参阅 Document 对象。
	history	对 History 对象的只读引用。请参数 History 对象。
	innerheight	返回窗口的文档显示区的高度。
	innerwidth	返回窗口的文档显示区的宽度。
	length	设置或返回窗口中的框架数量。
	location	用于窗口或框架的 Location 对象。请参阅 Location 对象。
	name	设置或返回窗口的名称。
	Navigator	对 Navigator 对象的只读引用。请参数 Navigator 对象。
	opener	返回对创建此窗口的窗口的引用。
	outerheight	返回窗口的外部高度。
	outerwidth	返回窗口的外部宽度。
	pageXOffset	设置或返回当前页面相对于窗口显示区左上角的 X 位置。
	pageYOffset	设置或返回当前页面相对于窗口显示区左上角的 Y 位置。
	parent	返回父窗口。
	Screen	对 Screen 对象的只读引用。请参数 Screen 对象。
	self	返回对当前窗口的引用。等价于 Window 属性。
	status	设置窗口状态栏的文本。
	top	返回最顶层的先辈窗口。
	window	window 属性等价于 self 属性，它包含了对窗口自身的引用。
	screenLeft
	screenTop
	screenX
	screenY 只读整数。声明了窗口的左上角在屏幕上的的 x 坐标和 y 坐标。IE、Safari 和 Opera 支持 screenLeft 和 screenTop，

	方法
	alert()	显示带有一段消息和一个确认按钮的警告框。
	blur()	把键盘焦点从顶层窗口移开。
	clearInterval()	取消由 setInterval() 设置的 timeout。
	clearTimeout()	取消由 setTimeout() 方法设置的 timeout。
	close()	关闭浏览器窗口。
	confirm()	显示带有一段消息以及确认按钮和取消按钮的对话框。
	createPopup()	创建一个 pop-up 窗口。
	focus()	把键盘焦点给予一个窗口。
	moveBy()	可相对窗口的当前坐标把它移动指定的像素。
	moveTo()	把窗口的左上角移动到一个指定的坐标。
	open()	打开一个新的浏览器窗口或查找一个已命名的窗口。
	print()	打印当前窗口的内容。
	prompt()	显示可提示用户输入的对话框。
	resizeBy()	按照指定的像素调整窗口的大小。
	resizeTo()	把窗口的大小调整到指定的宽度和高度。
	scrollBy()	按照指定的像素值来滚动内容。
	scrollTo()	把内容滚动到指定的坐标。
	setInterval()	按照指定的周期（以毫秒计）来调用函数或计算表达式。
	setTimeout()	在指定的毫秒数后调用函数或计算表达式。

#### 4.2 Navigator对象
Navigator 对象包含有关浏览器的信息。

	属性
	appCodeName	返回浏览器的代码名。
	appMinorVersion	返回浏览器的次级版本。
	appName	返回浏览器的名称。
	appVersion	返回浏览器的平台和版本信息。
	browserLanguage	返回当前浏览器的语言。
	cookieEnabled	返回指明浏览器中是否启用 cookie 的布尔值。
	cpuClass	返回浏览器系统的 CPU 等级。
	onLine	返回指明系统是否处于脱机模式的布尔值。
	platform	返回运行浏览器的操作系统平台。
	systemLanguage	返回 OS 使用的默认语言。
	userAgent	返回由客户机发送服务器的 user-agent 头部的值。
	userLanguage	返回 OS 的自然语言设置。

	方法	
	javaEnabled()	规定浏览器是否启用 Java。
	taintEnabled()	规定浏览器是否启用数据污点 (data tainting)。
	
#### 4.3 History对象
History 对象包含用户（在浏览器窗口中）访问过的 URL。
History 对象是 window 对象的一部分，可通过 window.history 属性对其进行访问。

	属性
	length	返回浏览器历史列表中的 URL 数量。
	方法	
	back()	加载 history 列表中的前一个 URL。
	forward()	加载 history 列表中的下一个 URL。
	go()	加载 history 列表中的某个具体页面。
	
#### 4.4 Location对象
Location 对象包含有关当前 URL 的信息。
Location 对象是 Window 对象的一个部分，可通过 window.location 属性来访问。

	属性
	hash	设置或返回从井号 (#) 开始的 URL（锚）。
	host	设置或返回主机名和当前 URL 的端口号。
	hostname	设置或返回当前 URL 的主机名。
	href	设置或返回完整的 URL。
	pathname	设置或返回当前 URL 的路径部分。
	port	设置或返回当前 URL 的端口号。
	protocol	设置或返回当前 URL 的协议。
	search	设置或返回从问号 (?) 开始的 URL（查询部分）。

	属性
	assign()	加载新的文档。
	reload()	重新加载当前文档。
	replace()	用新的文档替换当前文档。
		


#### 4.5 Screen对象

Screen 对象包含有关客户端显示屏幕的信息。

	属性
	availHeight	返回显示屏幕的高度 (除 Windows 任务栏之外)。
	availWidth	返回显示屏幕的宽度 (除 Windows 任务栏之外)。
	bufferDepth	设置或返回调色板的比特深度。
	colorDepth	返回目标设备或缓冲器上的调色板的比特深度。
	deviceXDPI	返回显示屏幕的每英寸水平点数。
	deviceYDPI	返回显示屏幕的每英寸垂直点数。
	fontSmoothingEnabled	返回用户是否在显示控制面板中启用了字体平滑。
	height	返回显示屏幕的高度。
	logicalXDPI	返回显示屏幕每英寸的水平方向的常规点数。
	logicalYDPI	返回显示屏幕每英寸的垂直方向的常规点数。
	pixelDepth	返回显示屏幕的颜色分辨率（比特每像素）。
	updateInterval	设置或返回屏幕的刷新率。
	width	返回显示器屏幕的宽度。
