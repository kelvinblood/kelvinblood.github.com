---
layout: post
title: markdown入门
category: tech
tags: markdown tutorial
---
Markdown 是一种轻量级的「标记语言」，学习成本低。很早前就在使用markdown，就连我的blog
的编写，也都是使用markdown语言编写的。这篇文章里将记录一些常用的markdown语法、Mac下的
工具，以及Mou的快捷键。

## Mou快捷键

	大小写 		Ctrl (Shift) U
	文章前data 	Ctrl Shift G
	大小于和& 	Ctrl Shift ,(.)(7)
	参考手册 		Cmd R




## Markdown语法

### 加粗 Cmd B
	*emphasize*   **strong** 	
	
### 斜体 Cmd I				
	_emphasize_   __strong__					
	

### 链接 Ctrl Shift L

	行内链接
	An [example](http://url.com/ "Title")		
	
	关联链接
	An [example][id]. Then, anywhere
	else in the doc, define the link:
	
	  [id]: http://example.com/  "Title"	
	  	
	自动链接
	<http://example.com/>
	  	
	Email
	An email <example@example.com> link.
	
### 图片 Ctrl Shift I
	行内链接
	![alt text](/path/img.jpg "Title")			
	
	关联链接
	![alt text][id]								
	
	[id]: /url/to/img.jpg "Title"
	
### 标题 Cmd 1
	类 Setext:
	Header 1
	========
	Header 2
	--------
	
	类 atx 形式(后边的#可加可不加):
	# Header 1 #				Cmd 1
	## Header 2 ##				Cmd 2
	### Header 6				Cmd 6

### 列表 Ctrl L

有序列表:

	1.  Foo
	2.  Bar

无序列表:

	*   A list item.			
	    With multiple paragraphs.
	*   Bar
	
还可以这样:

	*   Abacus
	    * answer
	*   Bubbles
	    1.  bunk
	    2.  bupkis
	        * BELITTLER
	    3. burper
	*   Cunning
	
### 引用 Ctrl Q
	> Email-style angle brackets		
	> are used for blockquotes.
	
	> > And, they can be nested.
	
	> ### Headers in blockquotes
	> 
	> * You can quote a list.
	> * Etc.

### 代码框 Cmd K	

	`<code>` 		


### 代码块 Cmd [ (])

四个空格，或者一个tab

    This is a preformatted		
    code block.
    
### backtick  Cmd K

	```				
	Fenced code blocks are like Stardard
	Markdown’s regular code blocks, except that
	they’re not indented and instead rely on a
	start and end fence lines to delimit the code
	block.
	```
    
### 横线

	---
	
	* * *
	
	- - - - 

### 强制换行

行末添加两个空格

### 删除线 Cmd U

	~~ ~~		


### 表格
简单的表格

	First Header | Second Header | Third Header
	------------ | ------------- | ------------
	Content Cell | Content Cell  | Content Cell
	Content Cell | Content Cell  | Content Cell

单元格左右对齐

	First Header | Second Header | Third Header
	:----------- | :-----------: | -----------:
	Left         | Center        | Right
	Left         | Center        | Right

### 页内链接

	## [This is an example](id:anchor1)
	
	Click this [link](#anchor1) in the Preview view will auto scroll to the place of the destination anchor.

### 脚标

	That's some text with a footnote.[^1]
	
	[^1]: And that's the footnote.

## 其它相关

运行以下命令安装markdown快速预览插件：

	$ brew cask install qlmarkdown
	
也可以在github上获得这个插件[qlmarkdown](https://github.com/toland/qlmarkdown)。
