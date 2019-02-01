---
layout: post
title: svg入门
category: tech
tags: front-end svg html tutorial
---

连续整理几篇入门，再来一篇svg的。基本上转载自[《HTML5实战——svg学习》](http://www.cnblogs.com/duanhuajian/archive/2013/07/31/3227410.html)

本文将按照以下目录进行介绍。

* 基本形状
* 文本与图像
* 笔画与填充
* 颜色的表示
* 坐标与变换
* 重用与引用
* 文档结构
* 蒙板
* 滤镜
* 动画
* SVG DOM
* svg对决canvas

转载的那篇文章排版要好很多，建议大家去那儿看。我也是在慢慢学习中。未完待续。



## 基本形状

右键自行查看源代码

<svg width="200" height="250">
 <rect x="10" y="10" width="30" height="30" stroke="black" fill="transparent" stroke-width="5"/>
 <rect x="60" y="10" rx="10" ry="10" width="30" height="30" stroke="black" fill="transparent" stroke-width="5"/>

 <circle cx="25" cy="75" r="20" stroke="red" fill="transparent" stroke-width="5"/>
 <ellipse cx="75" cy="75" rx="20" ry="5" stroke="red" fill="transparent" stroke-width="5"/>

 <line x1="10" x2="50" y1="110" y2="150" stroke="orange" fill="transparent" stroke-width="5"/>
 <polyline points="60 110 65 120 70 115 75 130 80 125 85 140 90 135 95 150 100 145"
     stroke="orange" fill="transparent" stroke-width="5"/>

 <polygon points="50 160 55 180 70 180 60 190 65 205 50 195 35 205 40 190 30 180 45 180"
     stroke="green" fill="transparent" stroke-width="5"/>

 <path d="M20,230 Q40,205 50,230 T90,230" fill="none" stroke="blue" stroke-width="5"/>
</svg>

矩形 - rect元素

	x：矩形左上角的坐标(用户坐标系)的x值。
	y：矩形左上角的坐标(用户坐标系)的y值。
	width：矩形宽度。
	height：矩形高度。
	rx：实现圆角效果时，圆角沿x轴的半径。
	ry：实现圆角效果时，圆角沿y轴的半径。

圆 - circle元素

	r：圆的半径。
	cx：圆心坐标x值。
	cy：圆心坐标y值。

椭圆 - ellipse元素

	rx：半长轴(x半径)。
	ry：半短轴(y半径)。
	cx：圆心坐标x值。
	cy：圆心坐标y值。

直线 - line元素

	x1：起点x坐标。
	y1：起点y坐标。
	x2：终点x坐标。
	y2：终点y坐标。


折线 - polyline元素

	折线主要是要定义每条线段的端点即可，所以只需要一个点的集合作为参数。

	points：一系列的用空格，逗号，换行符等分隔开的点。每个点必须有2个数字：x值和y值。所以下面3个点 (0,0), (1,1)和(2,2)可以写成："0 0, 1 1, 2 2"。


多边形 - polygon元素

	这个元素就是比polyline元素多做一步，把最后一个点和第一个点连起来，形成闭合图形。参数是一样的。
	points：一系列的用空格，逗号，换行符等分隔开的点。每个点必须有2个数字：x值和y值。所以下面3个点 (0,0), (1,1)和(2,2)可以写成："0 0, 1 1, 2 2"。

 

路径 - path元素

	　　这个是最通用，最强力的元素了；使用这个元素你可以实现任何其他的图形，不仅包括上面这些基本形状，也可以实现像贝塞尔曲线那样的复杂形状；此外，使用path可以实现平滑的过渡线段，虽然也可以使用polyline来实现这种效果，但是需要提供的点很多，而且放大了效果也不好。这个元素控制位置和形状的只有一个参数：
	d：一系列绘制指令和绘制参数(点)组合成。

	绘制指令分为绝对坐标指令和相对坐标指令两种，这两种指令使用的字母是一样的，就是大小写不一样，绝对指令使用大写字母，坐标也是绝对坐标；相对指令使用对应的小写字母，点的坐标表示的都是偏移量。
　　
指令说明

	M
	x y
	将画笔移动到点(x,y)
	
	L
	x y
	画笔从当前的点绘制线段到点(x,y)
	H
	x 
	画笔从当前的点绘制水平线段到点(x,y0)
	
	V
	y 
	画笔从当前的点绘制竖直线段到点(x0,y)
	
	A
	rx ry x-axis-rotation large-arc-flag sweep-flag x y
	画笔从当前的点绘制一段圆弧到点(x,y)
	
	C
	x1 y1, x2 y2, x y
	画笔从当前的点绘制一段三次贝塞尔曲线到点(x,y)
	
	S
	x2 y2, x y
	特殊版本的三次贝塞尔曲线(省略第一个控制点)
	
	Q
	x1 y1, x y 
	绘制二次贝塞尔曲线到点(x,y)
	
	T
	x y
	特殊版本的二次贝塞尔曲线(省略控制点)
	
	Z
	无参数
	绘制闭合图形，如果d属性不指定Z命令，则绘制线段，而不是封闭图形。
　　

移动画笔指令M，画直线指令：L，H，V，闭合指令Z都比较简单；下面重点看看绘制曲线的几个指令。

### 绘制圆弧指令

	A  rx ry x-axis-rotation large-arc-flag sweep-flag x y
	　　用圆弧连接2个点比较复杂，情况也很多，所以这个命令有7个参数，分别控制曲线的的各个属性。下面解释一下数值的含义：
	rx,ry 是弧的半长轴、半短轴长度
	x-axis-rotation 是此段弧所在的x轴与水平方向的夹角，即x轴的逆时针旋转角度，负数代表顺时针转动的角度。
	large-arc-flag 为1 表示大角度弧线，0 代表小角度弧线。
	sweep-flag 为1代表从起点到终点弧线绕中心顺时针方向，0 代表逆时针方向。
	x,y 是弧终端坐标。
	　　前两个参数和后两个参数就不多说了，很简单；下面就说说中间的3个参数：
_

	x-axis-rotation代表旋转的角度
	
<svg width="320px" height="320px">
  <path d="M10 315
           L 110 215
           A 30 50 0 0 1 162.55 162.45
           L 172.55 152.45
           A 30 50 -45 0 1 215.1 109.9
           L 315 10" stroke="black" fill="green" stroke-width="2" fill-opacity="0.5"/>
</svg>

	large-arc-flag和sweep-flag控制了圆弧的大小和走向，体会下面例子中圆弧的不同：

<svg width="325px" height="325px">
  <path d="M80 80
           A 45 45, 0, 0, 0, 125 125
           L 125 80 Z" fill="green"/>
  <path d="M230 80
           A 45 45, 0, 1, 0, 275 125
           L 275 80 Z" fill="red"/>
  <path d="M80 230
           A 45 45, 0, 0, 1, 125 275
           L 125 230 Z" fill="purple"/>
  <path d="M230 230
           A 45 45, 0, 1, 1, 275 275
           L 275 230 Z" fill="blue"/>
</svg>

### 绘制三次贝塞尔曲线指令：C  x1 y1, x2 y2, x y          

　　三次贝塞尔曲线有两个控制点，就是(x1,y1)和(x2,y2)，最后面(x,y)代表曲线的终点。体会下面的例子：

<svg width="190px" height="160px">
  <path d="M10 10 C 20 20, 40 20, 50 10" stroke="black" fill="transparent"/>
  <path d="M70 10 C 70 20, 120 20, 120 10" stroke="black" fill="transparent"/>
  <path d="M130 10 C 120 20, 180 20, 170 10" stroke="black" fill="transparent"/>
  <path d="M10 60 C 20 80, 40 80, 50 60" stroke="black" fill="transparent"/>
  <path d="M70 60 C 70 80, 110 80, 110 60" stroke="black" fill="transparent"/>
  <path d="M130 60 C 120 80, 180 80, 170 60" stroke="black" fill="transparent"/>
  <path d="M10 110 C 20 140, 40 140, 50 110" stroke="black" fill="transparent"/>
  <path d="M70 110 C 70 140, 110 140, 110 110" stroke="black" fill="transparent"/>
  <path d="M130 110 C 120 140, 180 140, 170 110" stroke="black" fill="transparent"/>
</svg>


### 特殊版本的三次贝塞尔曲线：S  x2 y2, x y

　　很多时候，为了绘制平滑的曲线，需要多次连续绘制曲线。这个时候，为了平滑过渡，常常第二个曲线的控制点是第一个曲线控制点在曲线另外一边的映射点。这个时候可以使用这个简化版本。这里要注意的是，如果S指令前面没有其他的S指令或C指令，这个时候会认为两个控制点是一样的，退化成二次贝塞尔曲线的样子；如果S指令是用在另外一个S指令或者C指令后面，这个时候后面这个S指令的第一个控制点会默认设置为前面的这个曲线的第二个控制点的一个映射点，体会一下：

<svg width="190px" height="160px">
  <path d="M10 80 C 40 10, 65 10, 95 80 S 150 150, 180 80" stroke="black" fill="transparent"/>
</svg>

上面的S指令只有第二个控制点，第一个控制点采用了前面的曲线指令的第二个控制点的一个映射点。


### 绘制二次贝塞尔曲线指令：Q  x1 y1, x y ， T x y  (特殊版本的二次贝塞尔曲线)
　　二次贝塞尔曲线只有一个控制点(x1,y1)，通常如下图所示：
　　如果是连续的绘制曲线，同样可以使用简化版本T。同样的，只有T前面是Q或者T指令的时候，后面的T指令的控制点会默认设置为前面的曲线的控制点的映射点，体会一下：

<svg width="190px" height="160px">
  <path d="M10 80 Q 52.5 10, 95 80 T 180 80" stroke="black" fill="transparent"/>
</svg>　　

同样的，如果T指令前面不是Q或者T指令，则认为无控制点，画出来的是直线。

### 相对坐标绘制指令
　　与绝对坐标绘制指令的字母是一样的，只不过全部是小写表示。这组指令的参数中涉及坐标的参数代表的是相对坐标，意思就是参数代表的是从当前点到目标点的偏移量，正数就代表向轴正向偏移，负数代表向反向偏移。不过对Z指令来说，大小写没有区别。

　　这里要注意，绝对坐标指令与相对坐标指令是可以混合使用的。有时混合使用可以带来更灵活的画法。

 

SVG path绘制注意事项：
　　绘制带孔的图形时要注意：外层边的绘制需要是逆时针顺序的，里面的洞的边的顺序必须是顺时针的。只有这样绘制的图形填充效果才会正确。
　　
## 文本与图像
　SVG的强大能力之一是它可以将文本控制到标准HTML页面不可能有的程度，而无须求助图像或其它插件。任何可以在形状或路径上执行的操作（如绘制或滤镜）都可以在文本上执行。　　此外，可以使用 tspan 元素可以将文本元素分成几部分，允许每部分有各自的样式。

　　还有，在text元素中，空格的处理与HTML类似：换行和回车变成空格，而多个空格压缩成单个空格。
　　
#### 直接显示在图片中的文本 - text元素
　　直接显示文本，可以使用text元素，例子如下：

<svg>  
  <rect width="300" height="200" fill="red" />  
  <circle cx="150" cy="100" r="80" fill="green" />  
  <text x="150" y="125" font-size="60" text-anchor="middle" fill="white">这是文字</text>  
</svg> 

* x,y是文本位置坐标。
* text-anchor是文本显示的方向，其实也就是位置(x,y)处于文本的位置。这个属性有start,middle和end三种值。
* start表示文本位置坐标(x,y)位于文本的开始处，文本从这点开始向右挨个显示。
* middle表示(x,y)位于文本中间处，文本向左右两个方向显示，其实就是居中显示。
* end表示(x,y)点位于文本结尾，文本向左挨个显示。
	　　除了这些属性，下面的这些属性都既可以在CSS中指定，也可以直接在属性中指定:
	
	fill,stroke：填充和描边颜色，具体使用在后面总结。
	font的相关属性：font-family, font-style, font-weight, font-variant, font-stretch, font-size, font-size-adjust, kerning, letter-spacing, word-spacing and text-decoration。


####   文本区间 - tspan元素
　　这个元素是text元素的强力补充；它用于渲染一个区间内的文本；它只能出现在text元素或者tspan元素的子元素中。典型的用法就是强调显示部分文本。例如：

<text>
  <tspan font-weight="bold" fill="red">This is bold and red</tspan>
</text>



tspan元素有下列的属性可以设置：

x,y用于设置包含的文本的绝对坐标值，这个值会覆盖默认的文本位置。这些属性可以包含一系列数字，这些数字会应用到每个对应的单个字符。没有对应设置的字符会紧跟前一个字符。例如：

<text x="10" y="10">Hello World!
  <tspan x="100 200 300"  font-weight="bold" fill="red">This is bold and red</tspan>
</text>

dx,dy用于设置包含的文本相对于默认的文本位置的偏移量。这些属性同样可以包含一系列数字，每个都会应用到对应的字符。没有对应设置的字符会紧跟前一个字符。你可以把上面的例子中的x换成dx看看效果。

rotate用于设置字体的旋转角度。这个属性页可以包含一系列数字，应用到每个字符。没有对应设置的字符会使用最后设置的那个数字。

<text x="10" y="10">Hello World!
 <tspan rotate="10 20 45"  font-weight="bold" fill="red">This is bold and red</tspan>
</text>

textLength：这是最令人费解的属性，据说设置完以后，渲染发现文本的长度与这个值不一致时，会以这个长度为准。但是我没有试出来效果。

#### 文本引用 - tref元素
　　这个元素允许引用定义过的文本，并高效的拷贝到当前位置，通常配合xlink:href指定目的元素。因为是拷贝过来的，所以使用css修改当前文本的时候，不会修改原来的文本。看例子：

<text id="example">This is an example text.</text>
<text>
    <tref xlink:href="#example" />
</text>
 

#### 文本路径 - textPath元素
　　这个比较有意思，效果也很酷，能做出很多的艺术效果；这个元素从它的xlink:href属性获取指定的路径并把文本对齐到这个路径上，看例子：

<path id="my_path" d="M 20,20 C 40,40 80,40 100,20" />
<text>
  <textPath xlink:href="#my_path">This text follows a curve.</textPath>
</text>


SVG中渲染图片 - image元素

　　SVG中的image元素可以直接支持显示光栅图片，使用很简单。看下面的例子：

<svg width="5cm" height="4cm">
  <image xlink:href="http://wechat.kelu.org/Public/pic/container_2.png" x="0" y="0" height="50px" width="50px"/>
</svg>

这里需要注意几点：
1.如果没有设置x或y坐标，则默认是0。

2.如果没有设置width或height，则默认也是0.

3.如果显式的设置width或height为0，则会禁止渲染这幅图片。

4.图片的格式支持png,jpeg,jpg,svg等等，所以svg是支持嵌套svg的。 

5.image与其他元素一样，是svg的常规元素，所以它支持所有的裁剪，蒙板，滤镜，旋转等效果。


## 笔画与填充
<svg>
<rect x="10" y="10" width="100" height="100" stroke="blue" fill="red"
       fill-opacity="0.5" stroke-opacity="0.8"/>
</svg>       

上面例子中画了一个红色蓝边的矩形。注意几点：

1. 如果不提供fill属性，则默认会使用黑色填充,如果要取消填充，需要设置成none。
2. 可以设置填充的透明度，就是fill-opacity，值的范围是0到1。
3. 稍微复杂一点的是fill-rule属性。这个属性定义了判断点是不是属于填充范围的算法；除了inherit这个值外，还有两个取值：

nonzero：这个值采用的算法是：从需要判定的点向任意方向发射线，然后计算图形与线段交点的处的走向；计算结果从0开始，每有一个交点处的线段是从左到右的，就加1；每有一个交点处的线段是从右到左的，就减1；这样计算完所有交点后，如果这个计算的结果不等于0，则该点在图形内，需要填充；如果该值等于0，则在图形外，不需要填充。看下面的示例：


evenodd：这个值采用的算法是：从需要判定的点向任意方向发射线，然后计算图形与线段交点的个数，个数为奇数则改点在图形内，需要填充；个数为偶数则点在图形外，不需要填充。看下图的示例：


#### 边框色 - stroke属性

　　上面的例子中已经用到了stroke属性，这个属性使用设置的值画图形的边框，使用起来也很直接，把颜色值赋给它就可以了。注意：

1. 如果不提供stroke属性，则默认不绘制图形边框。
2. 可以设置边的透明度，就是stroke-opacity，值的范围是0到1。
　　
实际上，边的情况比图形内部稍微复杂一点，因为边除了颜色，还有"形状"需要定义。

####   线的端点 - stroke-linecap属性
　　这个属性定义了线段端点的风格，这个属性可以使用butt,square,round三个值。看例子：

<svg width="160" height="140">
  <line x1="40" x2="120" y1="20" y2="20" stroke="black" stroke-width="20" stroke-linecap="butt"/>
  <line x1="40" x2="120" y1="60" y2="60" stroke="black" stroke-width="20" stroke-linecap="square"/>
  <line x1="40" x2="120" y1="100" y2="100" stroke="black" stroke-width="20" stroke-linecap="round"/>
</svg>
 
#### 线的连接 - stroke-linejoin属性
　　这个属性定义了线段连接处的风格，这个属性可以使用miter,round,bevel三个值。看例子：

<svg width="160" height="280">
<polyline points="40 60 80 20 120 60" stroke="black" stroke-width="20" stroke-linecap="butt" fill="transparent" stroke-linejoin="miter"/>
  
<polyline points="40 140 80 100 120 140" stroke="black" stroke-width="20" stroke-linecap="round" fill="transparent" stroke-linejoin="round"/>
  
<polyline points="40 220 80 180 120 220" stroke="black" stroke-width="20" stroke-linecap="square" fill="transparent" stroke-linejoin="bevel"/>
</svg>

#### 线的虚实 - stroke-dasharray属性
　　这个属性可以设置线段采用何种虚实线。看例子：

<svg width="200" height="150">
  <path d="M 10 75 Q 50 10 100 75 T 190 75" stroke="black"
    stroke-linecap="round" stroke-dasharray="5,10,5" fill="none"/>
  <path d="M 10 75 L 190 75" stroke="red"
    stroke-linecap="round" stroke-width="1" stroke-dasharray="5,5" fill="none"/>
</svg>

这个属性是设置一些列数字，不过这些数字必须是逗号隔开的。属性中当然可以包含空格，但是空格不作为分隔符。每个数字定义了实线段的长度，分别是按照绘制、不绘制这个顺序循环下去。

除了这些常用的属性，还有下列属性可以设置：  
stroke-miterlimit：这个和canvas中的一样，它处理什么时候画和不画线连接处的miter效果。  
stroke-dashoffset：这个属性设置开始画虚线的位置。
 
#### 使用CSS展示数据
　　HTML5强化了DIV+CSS的思想，所以展示数据的部分还可以交给CSS处理。与普通HTML元素相比，只不过是 background-color和border换成了fill和stroke。其他的大多都差不多。简单看个例子：

	#MyRect:hover {
	   stroke: black;
	   fill: blue;
	 }

## 颜色的表示
SVG和canvas中是一样的，都是使用标准的HTML/CSS中的颜色表示方法，这些颜色都可以用于fill和stroke属性。
基本有下面这些定义颜色的方式：

1. 颜色名字： 直接使用颜色名字red, blue, black...
2. rgba/rgb值： 这个也很好理解，例如#ff0000,rgba(255,100,100,0.5)。
3. 十六进制值： 用十六进制定义的颜色，例如#ffffff。
4. 渐变值：这个也与canvas中一样，支持两种渐变色：线性渐变，环形渐变。
5. 图案填充：使用自定义的图案作为填充色。

####   线性渐变
　　使用linearGradient元素即可定义线性渐变，每一个渐变色成分使用stop元素定义。看下面的例子：

	<svg width="120" height="240">  
	 <defs>  
	    <linearGradient id="Gradient1">  
	      <stop class="stop1" offset="0%"/>  
	      <stop class="stop2" offset="50%"/>  
	      <stop class="stop3" offset="100%"/>  
	    </linearGradient>  
	    <linearGradient id="Gradient2" x1="0" x2="0" y1="0" y2="1">  
	      <stop offset="0%" stop-color="red"/>  
	      <stop offset="50%" stop-color="black" stop-opacity="0"/>  
	      <stop offset="100%" stop-color="blue"/>  
	    </linearGradient>  
	    <style type="text/css"><![CDATA[  
	       #rect1 { fill: url(#Gradient1); }  
	       .stop1 { stop-color: red; }  
	       .stop2 { stop-color: black; stop-opacity: 0; }  
	       .stop3 { stop-color: blue; }  
	     ]]>
	    </style>  
	  </defs>  
	    
	  <rect id="rect1" x="10" y="10" rx="15" ry="15" width="100" height="100"/>  
	  <rect x="10" y="120" rx="15" ry="15" width="100" height="100" fill="url(#Gradient2)"/>     
	</svg>  

在这个例子中，我们需要注意：

1. 渐变色元素必须要放到defs元素中；
2. 需要给渐变色元素设置id值，否则的话，别的元素无法使用这个渐变色。
3. 渐变色的成员使用stop定义，它的属性也可以使用CSS定义；它支持class，id这种标准HTML都支持的属性。其它常用属性如下：
offset属性：这个定义了该成员色的作用范围，该属性取值从0%到100%(或者是0到1)；通常第一种颜色都是设置成0%，最后一种设置成100%。
stop-color属性：这个很简单，定义了该成员色的颜色。
stop-opacity属性：定义了成员色的透明度。
x1,y1,x2,y2属性：这两个点定义了渐变的方向，默认不写的话是水平渐变，上面例子中同时也创建了一个垂直渐变。
4. 渐变色的使用，如例子中所示，直接用url(#id)的形式赋值给fill或者stroke就可以了。
5. 渐变色成员的复用：你也可以使用xlink:href引用定义过的渐变色成员，所以上面的例子也可以改写如下： 

		<linearGradient id="Gradient1">  
		   <stop class="stop1" offset="0%"/>  
		   <stop class="stop2" offset="50%"/>  
		   <stop class="stop3" offset="100%"/>  
		</linearGradient> 
		<linearGradient id="Gradient2" x1="0" x2="0" y1="0" y2="1" xlink:href="#Gradient1"/>

####  环形渐变

　　使用radialGradient元素定义环形渐变，还是使用stop定义成员色。看例子： 

	<svg width="120" height="240">
	  <defs>
	      <radialGradient id="Gradient3">
	        <stop offset="0%" stop-color="red"/>
	        <stop offset="100%" stop-color="blue"/>
	      </radialGradient>
	      <radialGradient id="Gradient4" cx="0.25" cy="0.25" r="0.25">
	        <stop offset="0%" stop-color="red"/>
	        <stop offset="100%" stop-color="blue"/>
	      </radialGradient>
	  </defs>
	 
	  <rect x="10" y="10" rx="15" ry="15" width="100" height="100" fill="url(#Gradient3)"/> 
	  <rect x="10" y="120" rx="15" ry="15" width="100" height="100" fill="url(#Gradient4)"/> 
	</svg>
	
		
　　从上面的例子看到，除了元素名字和一些特别的成员，其他的所有都和线性渐变一样，包括stop的定义，必须放到defs中，必须给它设置id，使用url(#id)去赋值等。这些特别的成员如下：　

	offset属性：这个和线性渐变的值是一样，但是含义不一样。在环形渐变中，0%代表圆心处，这个很好理解
	cx,cy,r属性：其实也很好理解，环形渐变，当然要定义环的圆心和半径了，体会一下上面例子中圆的大小和位置就能理解了
	fx,fy属性：定义颜色中心(焦点)处的位置，也就是渐变色最浓处的坐标，在上面例子中，红色最红的是圆心，这是默认效果；如果想改变一下，就可以设置fx,fy坐标值。
　　
　　不过这里需要注意一下上面cx,cy,r,fx,fy的值，你会发现它们都是小数，那么单位是什么呢？
　　这个需要先了解另外一个相关的属性：gradientUnits，它定义了定义渐变色使用的坐标单位。这个属性有2个可用值：userSpaceOnUse和objectBoundingBox。

　　objectBoundingBox是默认值，它使用的坐标都是相对于对象包围盒的(方形包围盒，不是方形包围盒的情况比较复杂，略过)，取值范围是0到1。例如上例中的cx,cy的坐标值(0.25,0.25)。意味着这个圆心是在包围盒的左上角1/4处，半径0.25意味着半径长是对象方形包围盒长的1/4，就像你们图中看到的那样。
　　userSpaceOnUse表示使用的是绝对坐标，使用这个设置的时候，你必须要保证渐变色和填充的对象要保持在一个位置。
　　再看下面这个例子，注意gradientUnits属性默认值是objectBoundingBox：
	
	<svg width="120" height="120">
	  <defs>
	      <radialGradient id="Gradient5"
	            cx="0.5" cy="0.5" r="0.5" fx="0.25" fy="0.25">
	        <stop offset="0%" stop-color="red"/>
	        <stop offset="100%" stop-color="blue"/>
	      </radialGradient>
	  </defs>
	 
	  <rect x="10" y="10" rx="15" ry="15" width="100" height="100"
	        fill="url(#Gradient5)" stroke="black" stroke-width="2"/>
	
	  <circle cx="60" cy="60" r="50" fill="transparent" stroke="white" stroke-width="2"/>
	  <circle cx="35" cy="35" r="2" fill="white" stroke="white"/>
	  <circle cx="60" cy="60" r="2" fill="white" stroke="white"/>
	  <text x="38" y="40" fill="white" font-family="sans-serif" font-size="10pt">(fx,fy)</text>
	  <text x="63" y="63" fill="white" font-family="sans-serif" font-size="10pt">(cx,cy)</text> 
	</svg>

　　此外，还有渐变色元素还有一些变换的属性，如gradientTransform，这个不是这里的重点，后面会总结变换。
　　另外一个可能用到的属性是spreadMethod属性，这个属性定义了渐变色到达它的终点时应该采取的行为。该属性有3个可选值：pad(默认值),reflect,repeat。pad不用说了，属于自然过渡，渐变色结束以后，使用最后一个成员色直接渲染对象剩下的部分。refect会让渐变色继续，只不过渐变色会反向继续渲染，从最后一个颜色开始到第一个颜色这个顺序渲染；等到再次到达渐变色终点时，再反序，如此这般指导对象填充完毕。repeat也会让渐变色继续渲染，但是不会反序，还是一遍一遍从第一种颜色到最后一种颜色渲染。
 

　　看一段重复渲染的代码： 

<svg width="220" height="220">
  <defs>
      <radialGradient id="Gradient"
            cx="0.5" cy="0.5" r="0.25" fx=".25" fy=".25"
            spreadMethod="repeat">
        <stop offset="0%" stop-color="red"/>
        <stop offset="100%" stop-color="blue"/>
      </radialGradient>
  </defs>
  <rect x="50" y="50" rx="15" ry="15" width="100" height="100"
       fill="url(#Gradient)"/>
</svg>
 
#### 纹理填充
　　纹理填充也是一种流行的填充方式，在SVG中，可以使用pattern创建一个纹理，然后用这个pattern去填充别的对象。直接看例子：

<svg width="200" height="200">
  <defs>
    <linearGradient id="Gradient6">
      <stop offset="0%" stop-color="white"/>
      <stop offset="100%" stop-color="blue"/>
    </linearGradient>
    <linearGradient id="Gradient7" x1="0" x2="0" y1="0" y2="1">
      <stop offset="0%" stop-color="red"/>
      <stop offset="100%" stop-color="orange"/>
    </linearGradient>
  </defs>
  <defs>
    <pattern id="Pattern" x=".05" y=".05" width=".25" height=".25">
      <rect x="0" y="0" width="50" height="50" fill="skyblue"/>
      <rect x="0" y="0" width="25" height="25" fill="url(#Gradient7)"/>
      <circle cx="25" cy="25" r="20" fill="url(#Gradient6)" fill-opacity="0.5"/>
    </pattern> 
  </defs>
  
  <rect fill="url(#Pattern)" stroke="black" x="0" y="0" width="200" height="200"/>
</svg>


例子看起来很简单，由渐变色创建pattern，然后使用pattern

填充矩形。这里需要注意：

1. 不同的浏览器填充这个pattern的时候效果不一样。
比如例子在FireFix和Chrome中效果一样。但是如果你把渐变色
和pattern定义在同一个defs组合里，则FireFox仍然能正常渲染，
但是Chrome就识别不了渐变色，只会用默认的黑色填充。
2. pattern也需要定义id。
3. pattern也必须要定义在defs中。
4. pattern的使用也是把url(#id)直接赋值给fill或stroke。

　　上面这些都是很简单的，我们重点看一下例子中的坐标表示情况，坐标在pattern中比较复杂。
　　pattern中包含两个相关属性：patternUnits和patternContentUnits属性；这两个属性的取值都还是只有2个：objectBoundingBox和userSpaceOnUse，这两个值的含义上面以及讲过了。这里容易混淆的是这　　两个属性的默认值不同，但是当你理解这么做的原因以后，你又会发现这么做还真是有道理。

1. patternUnits属性
　　这个属性与Gradient的gradientUnits属性是一样的，默认采用objectBoundingBox。受这个属性影响的属性有x,y,width,height，这4个属性分别定义了pattern的起点，宽高度。它们都采用了相对值，例子中想要在水平和竖直方向上都填充4次，所以width和height都设为了0.25。
2. patternContentUnits属性
　　这个属性的默认值正好相反，采用userSpaceOnUse。这个属性描述了pattern中绘制的形状(比如上面的rect,circle)的坐标系统。也就是说在默认情况下，你在pattern中绘制的形状和pattern自身的大小/位置使用了不一样的坐标系。考虑上面例子中的情况，我们想填充一个200*200的矩形，而且每个方向重复4次。这就意味着每个pattern是50*50的，那么pattern里面的两个矩形和一个圆形就是画在这个50*50的矩形中。这样我们就能理解上面pattern中的矩形和圆的坐标了。此外，这个例子中的pattern为了居中，需要偏移10px后开始渲染，而这个值是受patternUnits属性制约的，所以默认情况下，x,y值就为：10/200=0.05。
  　那么pattern为什么要这么设置两个属性的默认值呢？

这是由用户的使用决定的(以上面的例子来讨论)：

　　第一种pattern样式：我想这是大多数情况，所以处理成默认值：pattern是会随着外面的图形缩放而被拉伸，不管外围方形是多大，pattern始终在两个方向上都会被填充4次。但是pattern中包含的图形是不会随着外面被填充的方形缩放而进行拉伸的。虽然比较牵强，但就这么理解吧。  
　　第二种pattern样式：pattern中的形状也随着外围的形状缩放进行拉伸。我们可以显示的把patternContentUnits属性的值也设为objectBoundingBox达到这个效果。例如把pattern的部分修改如下：

<pattern id="Pattern" width=".25" height=".25" patternContentUnits="objectBoundingBox">
   <rect x="0" y="0" width=".25" height=".25" fill="skyblue"/>
   <rect x="0" y="0" width=".125" height=".125" fill="url(#Gradient2)"/>
   <circle cx=".125" cy=".125" r=".1" fill="url(#Gradient1)" fill-opacity="0.5"/>
 </pattern>

修改后，当改变被填充的矩形的大小时，pattern中的形状也会进行拉伸。而且修改后改成了相对外围对象的坐标，所以不再需要pattern的x和y坐标了，pattern会始终调整以适合被填充的形状。

　　第三种pattern的样式：pattern的形状和大小都是固定了，不管外围对象怎么缩放，你可以把坐标系统都改成userSpaceOnUse实现这个效果。代码如下： 

<pattern id="Pattern" x="10" y="10" width="50" height="50" patternUnits="userSpaceOnUse">
   <rect x="0" y="0" width="50" height="50" fill="skyblue"/>
   <rect x="0" y="0" width="25" height="25" fill="url(#Gradient2)"/>
   <circle cx="25" cy="25" r="20" fill="url(#Gradient1)" fill-opacity="0.5"/>
 </pattern>
 
 
## 坐标与变换


 
---

参考资料：

<http://www.cnblogs.com/duanhuajian/archive/2013/07/31/3227410.html>

实用参考：

* 脚本索引: <http://msdn.microsoft.com/zh-cn/library/ff971910(v=vs.85).aspx>
* [开发中心](https://developer.mozilla.org/en/SVG)
* [热门参考](http://www.chinasvg.com/)
* [官方文档](http://www.w3.org/TR/SVG11/)