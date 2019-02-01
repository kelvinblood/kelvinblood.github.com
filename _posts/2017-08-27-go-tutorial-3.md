---
layout: post
title: Go 语言笔记 - 复合数据类型
category: tech
tags: go
---
![](https://cdn.kelu.org/blog/tags/go.jpg)

go 的复合类型包括：

*   数组类型
*   指针类型（Pointer）
*   结构体类型(struct)
*   切片类型 (slice)
*   Map 类型


# 数组

// 数组访问索引从0开始
	var variable_name [SIZE] variable_type 			// 声明
	var balance =  [5] float32 {1000.0,  2.0,  3.4,  7.0,  50.0}  // 初始化
	var balance =  [...] float32 {1000.0,  2.0,  3.4,  7.0,  50.0} // 与上个语句效果相同

多维数组

	var threedim [5][10][4]int
	
	a = [3][4]int{  
		 {0, 1, 2, 3} ,   /*  第一行索引为 0 */
		 {4, 5, 6, 7} ,   /*  第二行索引为 1 */
		 {8, 9, 10, 11}   /*  第三行索引为 2 */
	}

# 指针

	var var_name *var-type
	var ip *int  /* 指向整型*/  
	var fp *float32 /* 指向浮点型 */

	var a int=  20  /* 声明实际变量 */  
	var ip *int  /* 声明指针变量 */ 
	ip =  &a /* 指针变量的存储地址 */

当一个指针被定义后没有分配到任何变量时，它的值为 nil。nil 指针也称为空指针。

# 结构体

	type Books struct {
	   title string
	   author string
	   subject string
	   book_id int
	}

	var Book1 Books        /* 声明 Book1 为 Books 类型 */
  
   /* book 1 描述 */
   Book1.title = "Go 语言"
   Book1.author = "www.runoob.com"
   Book1.subject = "Go 语言教程"
   Book1.book_id = 6495407

# 切片(动态数组)

切片是对数组的抽象。

Go 数组的长度不可改变，在特定场景中这样的集合就不太适用，Go中提供了一种灵活，功能强悍的内置类型切片("动态数组"),与数组相比切片的长度是不固定的，可以追加元素，在追加时可能使切片的容量增大。

	var xxx []type		// 声明，值为 nil，是空切片

或使用make()函数来创建切片，其中capacity为可选参数，说明切片可达到的最大数。

	make([]type, length, capacity)


	// 初始化
	s :=[]  int  {1,2,3  }  

	s := arr[:]   // 初始化切片s,是数组arr的引用

	s := arr[startIndex:endIndex]   // 从下标startIndex到endIndex-1 下的元素创建为一个新的切片

	s1 := s[startIndex:endIndex]   通过切片s初始化切片s1

	s :=make([]int,len,cap)   通过内置函数make()初始化切片s,[]int 标识为其元素类型为int的切片

### len() 和 cap() 函数

切片可以由 len() 方法获取长度。由 cap() 测量切片最长可以达到多少。

### 切片截取

可以通过设置下限、上限来设置截取切片 _[lower-bound:upper-bound]_

## append() 和 copy() 函数

	/* 同时添加多个元素 */ 
	numbers = append(numbers,  2,3,4)
	/* 拷贝 numbers 的内容到 numbers1 */ 
	copy(numbers1,numbers)

# Map(集合)

Map 是一种无序的键值对的集合，使用 hash 表来实现的。

	/* 声明变量，默认 map 是 nil */  
	var xxx map[key_data_type]value_data_type 

	/* 使用 make 函数 */ 
	xxx := make(map[key_data_type]value_data_type)

	/* 创建 map */
	countryCapitalMap := 
	map[string]  string  {"France":"Paris","Italy":"Rome","Japan":"Tokyo","India":"New Delhi"}

	/* 删除元素 */  
	delete(countryCapitalMap,"France");

# 参考资料

* [Go 语言教程](http://www.runoob.com/go/go-tutorial.html)
