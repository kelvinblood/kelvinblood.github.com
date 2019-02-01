---
layout: post
title: jQuery入门
category: tech
tags: Front-end jquery tutorial
---

jQuery 是一个 JavaScript 库。jQuery 很容易学习。最近用到了jQuery和Bootstrap，于是记录一下。这一篇是jQuery的一个很粗略的列表总结。

## jQuery选择器

	$(this)			当前 HTML 元素
	$("p")			所有 <p> 元素
	$("p.intro")	所有 class="intro" 的 <p> 元素
	$(".intro")		所有 class="intro" 的元素
	$("#intro")		id="intro" 的元素
	$("ul li:first")		每个 <ul> 的第一个 <li> 元素
	$("[href$='.jpg']")		所有带有以 ".jpg" 结尾的属性值的 href 属性
	$("div#intro .head")	id="intro" 的 <div> 元素中的所有 class="head" 的元素
	
	:first	$("p:first")	第一个 <p> 元素
	:last	$("p:last")		最后一个 <p> 元素
	:even	$("tr:even")	所有偶数 <tr> 元素
	:odd	$("tr:odd")		所有奇数 <tr> 元素
	 	 	 
	:eq(index)	$("ul li:eq(3)")	列表中的第四个元素（index 从 0 开始）
	:gt(no)	$("ul li:gt(3)")		列出 index 大于 3 的元素
	:lt(no)	$("ul li:lt(3)")		列出 index 小于 3 的元素
	:not(selector)	$("input:not(:empty)")	所有不为空的 input 元素
	 	 	 
	:header	$(":header")	所有标题元素 <h1> - <h6>
	:animated	 			所有动画元素





## jQuery事件

触发实例：

$("button#demo").click()

常用事件

	bind()	向匹配元素附加一个或更多事件处理器
	click()	触发、或将函数绑定到指定元素的 click 事件
	focus()	触发、或将函数绑定到指定元素的 focus 事件
	scroll()	触发、或将函数绑定到指定元素的 scroll 事件
	toggle()	绑定两个或多个事件处理器函数，当发生轮流的 click 事件时执行。
	trigger()	所有匹配元素的指定事件
	load()	触发、或将函数绑定到指定元素的 load 事件

全部事件

	方法	描述
	blur()	触发、或将函数绑定到指定元素的 blur 事件
	change()	触发、或将函数绑定到指定元素的 change 事件
	dblclick()	触发、或将函数绑定到指定元素的 double click 事件
	delegate()	向匹配元素的当前或未来的子元素附加一个或多个事件处理器
	die()	移除所有通过 live() 函数添加的事件处理程序。
	error()	触发、或将函数绑定到指定元素的 error 事件
	event.isDefaultPrevented()	返回 event 对象上是否调用了 event.preventDefault()。
	event.pageX	相对于文档左边缘的鼠标位置。
	event.pageY	相对于文档上边缘的鼠标位置。
	event.preventDefault()	阻止事件的默认动作。
	event.result	包含由被指定事件触发的事件处理器返回的最后一个值。
	event.target	触发该事件的 DOM 元素。
	event.timeStamp	该属性返回从 1970 年 1 月 1 日到事件发生时的毫秒数。
	event.type	描述事件的类型。
	event.which	指示按了哪个键或按钮。
	keydown()	触发、或将函数绑定到指定元素的 key down 事件
	keypress()	触发、或将函数绑定到指定元素的 key press 事件
	keyup()	触发、或将函数绑定到指定元素的 key up 事件
	live()	为当前或未来的匹配元素添加一个或多个事件处理器
	mousedown()	触发、或将函数绑定到指定元素的 mouse down 事件
	mouseenter()	触发、或将函数绑定到指定元素的 mouse enter 事件
	mouseleave()	触发、或将函数绑定到指定元素的 mouse leave 事件
	mousemove()	触发、或将函数绑定到指定元素的 mouse move 事件
	mouseout()	触发、或将函数绑定到指定元素的 mouse out 事件
	mouseover()	触发、或将函数绑定到指定元素的 mouse over 事件
	mouseup()	触发、或将函数绑定到指定元素的 mouse up 事件
	one()	向匹配元素添加事件处理器。每个元素只能触发一次该处理器。
	ready()	文档就绪事件（当 HTML 文档就绪可用时）
	resize()	触发、或将函数绑定到指定元素的 resize 事件
	select()	触发、或将函数绑定到指定元素的 select 事件
	submit()	触发、或将函数绑定到指定元素的 submit 事件
	triggerHandler()	第一个被匹配元素的指定事件
	unbind()	从匹配元素移除一个被添加的事件处理器
	undelegate()	从匹配元素移除一个被添加的事件处理器，现在或将来
	unload()	触发、或将函数绑定到指定元素的 unload 事件
	
## jQuery效果

$("p").hide(1000,function(){
alert("The paragraph is now hidden");
});
$("#p1").css("color","red").slideUp(2000).slideDown(2000);

	animate()	对被选元素应用“自定义”的动画
	clearQueue()	对被选元素移除所有排队的函数（仍未运行的）
	delay()	对被选元素的所有排队函数（仍未运行）设置延迟
	dequeue()	运行被选元素的下一个排队函数
	fadeIn()	逐渐改变被选元素的不透明度，从隐藏到可见
	fadeOut()	逐渐改变被选元素的不透明度，从可见到隐藏
	fadeTo()	把被选元素逐渐改变至给定的不透明度
	hide()	隐藏被选的元素
	queue()	显示被选元素的排队函数
	show()	显示被选的元素
	slideDown()	通过调整高度来滑动显示被选元素
	slideToggle()	对被选元素进行滑动隐藏和滑动显示的切换
	slideUp()	通过调整高度来滑动隐藏被选元素
	stop()	停止在被选元素上运行动画
	toggle()	对被选元素进行隐藏和显示的切换
	
## HTML操作

属性操作

	addClass()	向匹配的元素添加指定的类名。
	attr()	设置或返回匹配元素的属性和值。
	hasClass()	检查匹配的元素是否拥有指定的类。
	html()	设置或返回匹配的元素集合中的 HTML 内容。
	removeAttr()	从所有匹配的元素中移除指定的属性。
	removeClass()	从所有匹配的元素中删除全部或者指定的类。
	toggleClass()	从匹配的元素中添加或删除一个类。
	val()	设置或返回匹配元素的值。

	$("button").click(function(){
	  $("#w3s").attr("href", function(i,origValue){
	    return origValue + "/jquery";
	  });
	});

css操作

	css()	设置或返回匹配元素的样式属性。
	height()	设置或返回匹配元素的高度。
	offset()	返回第一个匹配元素相对于文档的位置。
	offsetParent()	返回最近的定位祖先元素。
	position()	返回第一个匹配元素相对于父元素的位置。
	scrollLeft()	设置或返回匹配元素相对滚动条左侧的偏移。
	scrollTop()	设置或返回匹配元素相对滚动条顶部的偏移。
	width()	设置或返回匹配元素的宽度。
	
文档操作
	
	addClass()	向匹配的元素添加指定的类名。
	after()	在匹配的元素之后插入内容。
	append()	向匹配元素集合中的每个元素结尾插入由参数指定的内容。
	appendTo()	向目标结尾插入匹配元素集合中的每个元素。
	attr()	设置或返回匹配元素的属性和值。
	before()	在每个匹配的元素之前插入内容。
	clone()	创建匹配元素集合的副本。
	detach()	从 DOM 中移除匹配元素集合。
	empty()	删除匹配的元素集合中所有的子节点。
	hasClass()	检查匹配的元素是否拥有指定的类。
	html()	设置或返回匹配的元素集合中的 HTML 内容。
	insertAfter()	把匹配的元素插入到另一个指定的元素集合的后面。
	insertBefore()	把匹配的元素插入到另一个指定的元素集合的前面。
	prepend()	向匹配元素集合中的每个元素开头插入由参数指定的内容。
	prependTo()	向目标开头插入匹配元素集合中的每个元素。
	remove()	移除所有匹配的元素。
	removeAttr()	从所有匹配的元素中移除指定的属性。
	removeClass()	从所有匹配的元素中删除全部或者指定的类。
	replaceAll()	用匹配的元素替换所有匹配到的元素。
	replaceWith()	用新内容替换匹配的元素。
	text()	设置或返回匹配元素的内容。
	toggleClass()	从匹配的元素中添加或删除一个类。
	unwrap()	移除并替换指定元素的父元素。
	val()	设置或返回匹配元素的值。
	wrap()	把匹配的元素用指定的内容或元素包裹起来。
	wrapAll()	把所有匹配的元素用指定的内容或元素包裹起来。
	wrapinner()	将每一个匹配的元素的子内容用指定的内容或元素包裹起来。
	
jQuery 尺寸

	width()
	height()
	innerWidth()
	innerHeight()
	outerWidth()
	outerHeight()
	
jQuery遍历

	.each()	对 jQuery 对象进行迭代，为每个匹配元素执行函数。
	.filter()	将匹配元素集合缩减为匹配选择器或匹配函数返回值的新元素。

	.add()	将元素添加到匹配元素的集合中。
	.andSelf()	把堆栈中之前的元素集添加到当前集合中。
	.children()	获得匹配元素集合中每个元素的所有子元素。
	.closest()	从元素本身开始，逐级向上级元素匹配，并返回最先匹配的祖先元素。
	.contents()	获得匹配元素集合中每个元素的子元素，包括文本和注释节点。
	
	.end()	结束当前链中最近的一次筛选操作，并将匹配元素集合返回到前一次的状态。
	.eq()	将匹配元素集合缩减为位于指定索引的新元素。
	.find()	获得当前匹配元素集合中每个元素的后代，由选择器进行筛选。
	.first()	将匹配元素集合缩减为集合中的第一个元素。
	.has()	将匹配元素集合缩减为包含特定元素的后代的集合。
	.is()	根据选择器检查当前匹配元素集合，如果存在至少一个匹配元素，则返回 true。
	.last()	将匹配元素集合缩减为集合中的最后一个元素。
	.map()	把当前匹配集合中的每个元素传递给函数，产生包含返回值的新 jQuery 对象。
	.next()	获得匹配元素集合中每个元素紧邻的同辈元素。
	.nextAll()	获得匹配元素集合中每个元素之后的所有同辈元素，由选择器进行筛选（可选）。
	.nextUntil()	获得每个元素之后所有的同辈元素，直到遇到匹配选择器的元素为止。
	.not()	从匹配元素集合中删除元素。
	.offsetParent()	获得用于定位的第一个父元素。
	.parent()	获得当前匹配元素集合中每个元素的父元素，由选择器筛选（可选）。
	.parents()	获得当前匹配元素集合中每个元素的祖先元素，由选择器筛选（可选）。
	.parentsUntil()	获得当前匹配元素集合中每个元素的祖先元素，直到遇到匹配选择器的元素为止。
	.prev()	获得匹配元素集合中每个元素紧邻的前一个同辈元素，由选择器筛选（可选）。
	.prevAll()	获得匹配元素集合中每个元素之前的所有同辈元素，由选择器进行筛选（可选）。
	.prevUntil()	获得每个元素之前所有的同辈元素，直到遇到匹配选择器的元素为止。
	.siblings()	获得匹配元素集合中所有元素的同辈元素，由选择器筛选（可选）。
	.slice()	将匹配元素集合缩减为指定范围的子集。

## jQuery Ajax

`$(selector).load(URL,data,callback);`

	$("#div1").load("demo_test.txt #p1");

`$.get(URL,callback);`

	$("button").click(function(){
	  $.get("demo_test.asp",function(data,status){
	    alert("Data: " + data + "\nStatus: " + status);
	  });
	});

`$.post(URL,data,callback);`

	$("button").click(function(){
	  $.post("demo_test_post.asp",
	  {
	    name:"Donald Duck",
	    city:"Duckburg"
	  },
	  function(data,status){
	    alert("Data: " + data + "\nStatus: " + status);
	  });
	});

jQuery Ajax 库

	jQuery.ajax()	执行异步 HTTP (Ajax) 请求。
	.ajaxComplete()	当 Ajax 请求完成时注册要调用的处理程序。这是一个 Ajax 事件。
	.ajaxError()	当 Ajax 请求完成且出现错误时注册要调用的处理程序。这是一个 Ajax 事件。
	.ajaxSend()	在 Ajax 请求发送之前显示一条消息。
	jQuery.ajaxSetup()	设置将来的 Ajax 请求的默认值。
	.ajaxStart()	当首个 Ajax 请求完成开始时注册要调用的处理程序。这是一个 Ajax 事件。
	.ajaxStop()	当所有 Ajax 请求完成时注册要调用的处理程序。这是一个 Ajax 事件。
	.ajaxSuccess()	当 Ajax 请求成功完成时显示一条消息。
	jQuery.get()	使用 HTTP GET 请求从服务器加载数据。
	jQuery.getJSON()	使用 HTTP GET 请求从服务器加载 JSON 编码数据。
	jQuery.getScript()	使用 HTTP GET 请求从服务器加载 JavaScript 文件，然后执行该文件。
	.load()	从服务器加载数据，然后把返回到 HTML 放入匹配元素。
	jQuery.param()	创建数组或对象的序列化表示，适合在 URL 查询字符串或 Ajax 请求中使用。
	jQuery.post()	使用 HTTP POST 请求从服务器加载数据。
	.serialize()	将表单内容序列化为字符串。
	.serializeArray()	序列化表单元素，返回 JSON 数据结构数据。
