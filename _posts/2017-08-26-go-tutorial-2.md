---
layout: post
title: Go 语言笔记 - 语法和数据类型
category: tech
tags: go
---
![](https://cdn.kelu.org/blog/tags/go.jpg)

# 基础语法

一个标准 Go 语句如下：

	fmt.Println("Hello, World!")

* 一行代表一个语句结束。每个语句不需以分号 ; 结尾，但也不是 Python 纯靠缩进来表示内容，还是需要大括号{}进行包裹
* 标识符用来命名变量、类型等，第一个字符必须是字母或下划线而不能是数字。
* 备注格式与 C/C++ 相同

Go 代码中会使用到的 25 个关键字或保留字：

||||||
|-|-|-|-|-|
| break | default | func | interface | select |
| case | defer | go | map | struct |
| chan | else | goto | package | switch |
| const | fallthrough | if | range | type |
| continue | for | import | return | var |

还有 36 个预定义标识符：

||||||
|-|-|-|-|-|
| append | bool | byte | cap | close | complex | complex64 | complex128 | uint16 |
| copy | false | float32 | float64 | imag | int | int8 | int16 | uint32 |
| int32 | int64 | iota | len | make | new | nil | panic | uint64 |
| print | println | real | recover | string | true | uint | uint8 | uintptr |

# 数据类型

* 布尔型 
	常量 true 或者 false。一个简单的例子：var b bool = true

* 数字类型
	整型 int 和浮点型 float，并且原生支持复数，其中位的运算采用补码。更详细的信息看文章末尾。

* 字符串类型
	使用UTF-8编码标识Unicode文本

* 派生类型:

	*   (a) 指针类型（Pointer）
	*   (b) 数组类型
	*   (c) 结构化类型(struct)
	*   (d) Channel 类型
	*   (e) 函数类型 
	*   (f) 切片类型 
	*   (g) 接口类型（interface）
	*   (h) Map 类型

# 变量

声明变量的一般形式是使用 var 关键字：

	var identifier type

## 变量声明

操作符 := 可以高效地创建一个新的变量，是使用变量的首选形式，但是只能被用在函数体内，不可以用于全局变量的声明与赋值。

	var a int  =  10  // 指定变量类型，声明后若不赋值，使用默认值。
	var b =  10 		// 根据值自行判定变量类型。
	c :  =  10  		// 注意 :=左侧的变量不应该是已经声明过的，否则会导致编译错误。

多变量声明

	//类型相同多个变量, 非全局变量  
	var vname1, vname2, vname3 type
	vname1, vname2, vname3 = v1, v2, v3 

	var vname1, vname2, vname3 = v1, v2, v3
	
	vname1, vname2, vname3 := v1, v2, v3 

	// 这种因式分解关键字的写法一般用于声明全局变量
	var  ( 
		vname1 v_type1
    	vname2 v_type2 
	)

# 常量

常量的定义格式：

	const identifier [type]  = value

多个相同类型的声明可以简写为：

	const c_name1, c_name2 = value1, value2

常量还可以用作枚举：

	const  (  
		Unknown  =  0  
		Female  =  1  
		Male  =  2  
	)

iota，特殊常量，可以认为是一个可以被编译器修改的常量。每当 iota 在新的一行被使用时，它的值都会自动加 1。

# 运算符

与 C/C++ 相当接近，不写了。[速查手册](http://www.runoob.com/go/go-operators.html)

# 条件循环语句

条件语句

	if  布尔表达式  {  
		/* 在布尔表达式为 true 时执行 */  
	}  else  {  
		/* 在布尔表达式为 false 时执行 */  
	}

	switch var1 {  
		case val1:  ...  
		case val2:  ...  
		default:  ...  
	}

	var c1, c2, c3 chan int  
	var i1, i2 int  

	select  {  
		case i1 =  <-c1: 
			fmt.Printf("received ", i1,  " from c1\n")  
		case c2 <- i2: 
			fmt.Printf("sent ", i2,  " to c2\n")  
		
		default: 
			fmt.Printf("no communication\n")  
	}

循环语句

	package main
	
	import "fmt"
	
	func main() {
	
	   var b int = 15
	   var a int
	
	   numbers := [6]int{1, 2, 3, 5} 
	
	   /* for 循环 */
	   for a := 0; a < 10; a++ {
	      fmt.Printf("a 的值为: %d\n", a)
	   }
	
	   for a < b {
	      a++
	      fmt.Printf("a 的值为: %d\n", a)
	      }
	
	   for i,x:= range numbers {
	      fmt.Printf("第 %d 位 x 的值 = %d\n", i,x)
	   }   
	}


## 附录：数字类型

整型：

| 序号 | 类型和描述 |
|-|-|
| 1 | **uint8** 无符号 8 位整型 (0 到 255) |
| 2 | **uint16** 无符号 16 位整型 (0 到 65535) |
| 3 | **uint32** 无符号 32 位整型 (0 到 4294967295) |
| 4 | **uint64** 无符号 64 位整型 (0 到 18446744073709551615) |
| 5 | **int8** 有符号 8 位整型 (-128 到 127) |
| 6 | **int16** 有符号 16 位整型 (-32768 到 32767) |
| 7 | **int32** 有符号 32 位整型 (-2147483648 到 2147483647) |
| 8 | **int64** 有符号 64 位整型 (-9223372036854775808 到 9223372036854775807) |

浮点型：

| 序号 | 类型和描述 |
|-|-|
| 1 | **float32** IEEE-754 32位浮点型数 |
| 2 | **float64** IEEE-754 64位浮点型数 |
| 3 | **complex64** 32 位实数和虚数 |
| 4 | **complex128** 64 位实数和虚数 |

其他数字类型

| 序号 | 类型和描述 |
|-|-|
| 1 | **byte** 类似 uint8 |
| 2 | **rune** 类似 int32 |
| 3 | **uint** 32 或 64 位 |
| 4 | **int** 与 uint 一样大小 |
| 5 | **uintptr** 无符号整型，用于存放一个指针 |

# 参考资料

* [Go 语言教程](http://www.runoob.com/go/go-tutorial.html)
