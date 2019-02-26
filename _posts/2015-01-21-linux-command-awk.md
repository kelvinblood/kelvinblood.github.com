---
layout: post
title: Linux命令之awk
category: tech
tags: linux linux-command awk
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

本文大部分引用自[《GAWK 入门：AWK 语言基础》- IBM developerWorks](http://www.ibm.com/developerworks/cn/education/aix/au-gawk/)

Awk是一种处理结构数据并输出格式化结果的编程语言， Awk 是其作者 "Aho,Weinberger,Kernighan" 的简称。

Awk通常被用来进行格式扫描和处理。通过扫描一个或多个文件中的行，查看是否匹配指定的正则表达式，并执行相关的操作。awk 适合于文本处理和报表生成，它还有许多精心设计的特性，允许进行需要特殊技巧程序设计。awk 的语法较为常见。它借鉴了某些语言的一些精华部分，如 C 语言、python 和 bash（虽然在技术上，awk 比 python 和 bash 早创建）。awk 是那种一旦学会了就会成为您战略编码库的主要部分的语言。

## 主要特性

* Awk以记录和字段的方式来查看文本文件
* 和其他编程语言一样，Awk 包含变量、条件和循环
* Awk能够进行运算和字符串操作
* Awk能够生成格式化的报表数据


## 语法
Awk从一个文件或者标准输入中读取数据，并输出结果到标准输出中。   
        
    awk '/search pattern1/ {Actions}    
         /search pattern2/ {Actions}' file    
* search pattern是正则表达式
* Actions 输出的语法
* 在Awk 中可以存在多个正则表达式和多个输出定义
* file 输入文件名
* 单引号的作用是包裹起来防止shell截断

## 工作方式
* Awk 一次读取文件中的一行
* 对于一行，按照给定的正则表达式的顺序进行匹配，如果匹配则执行对应的 Action
* 如果没有匹配上则不执行任何动作
* 在上诉的语法中， Search Pattern 和 Action 是可选的，但是必须提供其中一个
* 如果 Search Pattern 未提供，则对所有的输入行执行 Action 操作
* 如果 Action 未提供，则默认打印出该行的数据
* {} 这种 Action 不做任何事情，和未提供的 Action 的工作方式不一样
* Action 中的语句应该使用分号分隔


## 默认行为

默认的时候awk 打印文件中的每一行

    $ awk '{print;}' hello.txt 

由于匹配的正则表达式未给出，因此后续的Action 适用所有的行， Action 中的 print 没有任何参数的情况下将打印整行，注意其中的 Action 必须使用 {} 括起来。


## 操作符(awk操作符与C语言类似)
    +        加
    -        减
    *        乘
    /        除
    %        取余
    ^        幂运算
    ++        自加1
    --        自减1
    +=        相加后赋值给变量(x+=9等同于x=x+9)
    -=        相减后赋值给变量(x-=9等同于x=x-9)
    *=        相乘后赋值给变量(x*=9等同于x=x*9)
    /=        相除后赋值给变量(x/=9等同于x=x/9)
    >        大于
    <        小于
    >=        大于等于
    <=        小于等于
    ==        等于
    !=        不等于
    ~        匹配
    !~        不匹配
    &&        与
    ||        或
      ^2 			＃2次方
      **2			＃2次方


函数名称|返回值
-|-
atan2(x,y)|y,x范围内的余切
cos(x)|余弦函数
exp(x)|求幂
int(x)|取整
log(x)|自然对数
rand()|随机数
sin(x)|正弦
sqrt(x)|平方根
srand(x)|x是rand()函数的种子

## BEGIN 和 END    

    BEGIN { Actions}    
    {ACTION} # Action for everyline in a file    
    END { Actions }  

在BEGIN 节中的 Actions 会在读取文件中的行之前被执行。

而END 节中的 Actions 会在读取并处理文件中的所有行后被执行。
awk 非常善于处理分成多个逻辑字段的文本，而且让您可以毫不费力地引用 awk 脚本中每个独立的字段。

	# 使用 -F 选项来指定 ":" 作为字段分隔符。
	$ awk -F":" '{ print "username: " $1 "/t/tuid:" $3" }' /etc/passwd 

## 外部脚本
将脚本作为命令行自变量传递给 awk 对于小的单行程序来说是非常简单的，而对于多行程序，它就比较复杂。您肯定想要在外部文件中撰写脚本。然后可以向 awk 传递 -f 选项，以向它提供此脚本文件。

	$ awk -f myscript.awk myfile.in
	# 只打印包含浮点数的行。
	/[0-9]+/.[0-9]*/ { print }
		
	# 如果当前行的第一个字段不等于 fred，awk 将继续处理文件而不对当前行执行 print
	$1 == "fred" { print $3 }
		
	#如果某一行的第五个字段包含字符序列 root，那么将只打印这一行中的第三个字段
	$5 ~ /root/ { print $3 }

## 条件语句

awk 还提供了非常好的类似于 C 语言的 if 语句。如果您愿意，可以使用 if 语句重写前一个脚本：

	# 如果某一行的第五个字段包含字符序列 root
	{
		if ( $5 ~ /root/ ) {
		print $3
		} else {
		}
	}

awk 还允许使用布尔运算符 "||"（逻辑与）和 "&&"（逻辑或），以便创建更复杂的布尔表达式。只打印第一个字段等于 foo 且第二个字段等于 bar 的那些行。

	( $1 == "foo" ) && ( $2 == "bar" ) { print }

## 内置变量

	ARGC        命令行参数个数
	FILENAME    当前输入文档的名称
	FNR        当前输入文档的当前记录编号，尤其当有多个输入文档时有用
	NR        总行数
	NF        当前记录的字段个数
	FS        字段分隔符
	OFS        输出字段分隔符，默认为空格
	ORS        输出记录分隔符，默认为换行符\n
	RS        输入记录分隔符，默认为换行符\n		
默认awk读取数据以空格或制表符作为分隔符，但可以通过-F或FS(field separator)变量来改变分隔符。

## 变量传递
### shell传入awk
1."'$var'"

	#!/bin/bash
	var="test"
	awk 'BEGIN{print "'$var'"}'

这种写法要求变量var中不含有空格。若var中含有空格，那么就要用 “‘“$var”’”

2.export变量，然后用ENVIRON［“var”］

	#!/bin/bash
	var="test"
	export var
	awk 'BEGIN{print ENVIRON["var"]}'

3.使用-v选项。

	#!/bin/bash
	var="test"
	awk -v nvar="$var" 'BEGIN{print nvar}'

### awk传入shell
1.让awk将变量值按一定格式输出到STDOUT上，然后由shell解析
2.eval

	$ unset a
	$ eval $(awk 'BEGIN{print "a=1"}')
	$ echo $a
	
	#!/bin/bash
	var1="test"
	var2="along"
	eval $(awk 'BEGIN{print "var1=along;var2=test"}')
	echo "var1:"$var1
	echo "var2:"$var2
	./awktest.sh 
	var1:along
	var2:test

关于eval的用法血衫今后再写一下。


## 例子

	awk  '/^$/ {print x+=1}'   test.txt                    备注：统计所有空白行
	awk  '/^$/ {x+=1}  END {print x}'   test.txt        备注：打印总空白行个数
	awk -F:  '$1~/root/   {print  $3}'   /etc/passwd     备注：打印root的ID号
	awk -F:  '$3>500  {print  $1}'      /etc/passwd     备注：列出计算机中ID号大于500的用户名
	awk 'BEGIN { x="123"; print x-2 }' ＃将字符串转换为数值来运算
	awk 'BEGIN {sum=0} {sum+=$0} END{print sum/FNR}' file.txt # 求平均数
	
	docker images -a | awk '{ print $1":"$2 }'  # 打印所有镜像名
	
	分组求平均：
	awk -F" " '{sum2[$1] += $2; sum3[$1] += $3; cnt[$1] += 1} END{for (i in sum2) print i, sum2[i]/cnt[i], sum3[i]/cnt[i]}' gav.txt
