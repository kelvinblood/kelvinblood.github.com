---
layout: post
title: css3备忘
category: tech
tags: front-end css css3
---

本文将会着重记录一下css的高级属性与css3的几个特有的属性（其实目前就两个，有空再回来补）。

## CSS3 transform 属性
transform 属性向元素应用 2D 或 3D 转换。该属性允许我们对元素进行旋转、缩放、移动或倾斜。

	div
	{
	transform:rotate(7deg);
	-ms-transform:rotate(7deg); 	/* IE 9 */
	-moz-transform:rotate(7deg); 	/* Firefox */
	-webkit-transform:rotate(7deg); /* Safari 和 Chrome */
	-o-transform:rotate(7deg); 	/* Opera */
	}
	
	translate 	定义 2D 转换
	scale		定义 2D 缩放转换
	rotate(angle)	定义 2D 旋转，在参数中规定角度
	skew(x-angle,y-angle)	定义沿着 X 和 Y 轴的 2D 倾斜转换。

## CSS高级选择器 nth-child

	:nth-child(2)选取第几个标签，“2可以是你想要的数字”
	.demo01 li:nth-child(2){background:#090}
	
	:nth-child(n+4)选取大于等于4标签，“n”表示从整数，下同
	.demo01 li:nth-child(n+4){background:#090}
	
	:nth-child(-n+4)选取小于等于4标签
	.demo01 li:nth-child(-n+4){background:#090}
	
	:nth-child(2n)选取偶数标签，2n也可以是even
	.demo01 li:nth-child(2n){background:#090}
	
	:nth-child(2n-1)选取奇数标签，2n-1可以是odd
	.demo01 li:nth-child(2n-1){background:#090}
	
	:nth-child(3n+1)自定义选取标签，3n+1表示“隔二取一”
	.demo01 li:nth-child(3n+1){background:#090}
	
	:last-child选取最后一个标签
	.demo01 li:last-child{background:#090}
	
	:nth-last-child(3)选取倒数第几个标签,3表示选取第3个