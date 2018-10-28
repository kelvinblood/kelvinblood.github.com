---
layout: post
title: shell入门
category: tech
tags: linux shell tutorial
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

这篇文章主要是网上搜集整理的资料，在shell的在平时使用中需要的最基本的入门知识，没有涉及grep、sed、awk以及各种正则表达式。

## hello world

	#!/bin/bash 
	echo Hello World

脚本写完之后在shell中运行



	$ chmod u+x hello
	$ ./hello

就可以看到结果了。

## 输入输出

在 Linux 系统中：标准输入(stdin)默认为键盘输入；标准输出(stdout)默认为屏幕输出；标准错误输出(stderr)默认也是输出到屏幕（上面的 std 表示 standard）。

在 BASH 中使用这些概念时一般将标准输出表示为 1，将标准错误输出表示为 2。

	$ ls > ls_result			# 写入
	$ ls -l >> ls_result		# 追加写入
	$ find /home -name lost* 2> err_result 	# 重定向错误输出到文件
	$ find /home -name lost* > all_result 2>& 1	# 标准输出连同错误输出重定向到文件
	$ find /home -name lost* 2> /dev/null	# 不显示错误信息

## 变量	

* 变量赋值时，'='左右两边都不能有空格；
* BASH 中的语句结尾不需要分号（";"）；
* 除了在变量赋值和在FOR循环语句头中，BASH 中的变量使用必须在变量前加"$"符号，可一个使用更为标准的变量引用方式${STR}

BASH 中的变量既不需要定义，也就没有类型一说，一个变量即可以被定义为一个字符串，也可以被再定义为整数。如果对该变量进行整数运算，他就被解释为整数；如果对他进行字符串操作，他就被看作为一个字符串。

整数运算一般通过 let 和 expr 这两个指令来实现，如对变量 x 加 1 可以写作：`let "x = $x + 1"` 或者 x=`expr $x + 1`

## 比较操作符

### 整数变量和字符串变量

|对应的操作 | 整数操作 | 字符串操作|
|- | -|
|相同 | -eq | =|
|不同 | -ne | !=|
|大于 | -gt | >|
|小于 | -lt | <|
|大于或等于 | -ge | |
|小于或等于 | -le | |
|为空 | -z|
|不为空 | -n|


比较字符串 a 和 b 是否相等就写作：if [ $a = $b ]  
判断字符串 a 是否为空就写作： if [ -z $a ]  
判断整数变量 a 是否大于 b 就写作：if [ $a -gt $b ]  
更细致的文档推荐在字符串比较时尽量不要使用 -n ，而用 ! -z 来代替。  

### 判断文件属性

|运算符 | 含义（ 满足下面要求时返回 TRUE ）|
|-|-|
|-e file | 文件 file 已经存在|
|-f file | 文件 file 是普通文件|
|-s file | 文件 file 大小不为零|
|-d file | 文件 file 是一个目录|
|-r file | 文件 file 对当前用户可以读取|
|-w file | 文件 file 对当前用户可以写入|
|-x file | 文件 file 对当前用户可以执行|
|-g file | 文件 file 的 GID 标志被设置|
|-u file | 文件 file 的 UID 标志被设置|
|-O file | 文件 file 是属于当前用户的|
|-G file | 文件 file 的组 ID 和当前用户相同|
|file1 -nt file2 | 文件 file1 比 file2 更新|
|file1 -ot file2 | 文件 file1 比 file2 更老|

if [ -x /root ] 可以用于判断 /root 目录是否可以被当前用户进入。


## 基本流程控制 

###  if...then...else

 if 条件语句 [ ] 左右两个都要有一个空格。

	if [ $1 -gt 90 ] 
	then 
	    echo "Good, $1" 
	elif [ $1 -gt 70 ] && [ $1 -lt 90]
	then 
	    echo "OK, $1" 
	else 
	    echo "Bad, $1" 
	fi
	
	当shell提醒integer expression expected时，可使用字符串比较，使得程序得以正确地运行通过。例如
	if [ $cpuLoad > '50' ] || [ $memUsed > '800' ] || [ $ioSumRate > '25' ];

### for

	for day in Sun Mon Tue Wed Thu Fri Sat 
	do 
		echo $day 
	done 
	
	while

### while & until

	while [ condition ]
	do
		statments
	done
	
	until [ condition is TRUE ]
	do
		statments
	done

### case

	echo "Hit a key, then hit return." 
	read Keypress 
	
	case "$Keypress" in 
	[a-z] ) echo "Lowercase letter";; 
	[A-Z] ) echo "Uppercase letter";; 
	[0-9] ) echo "Digit";; 
	* ) echo "Punctuation, whitespace, or other";; 
	esac 

## 函数

	square() { 
		let "res = $1 * $1" 
		return $res 
	} 

## 特殊保留字
### 保留变量

	$IFS　　这个变量中保存了用于分割输入参数的分割字符，默认识空格。 
	$HOME 　这个变量中存储了当前用户的根目录路径。 
	$PATH 　这个变量中存储了当前 Shell 的默认路径字符串。 
	$PS1　　表示第一个系统提示符。 
	$PS2　　表示的二个系统提示符。 
	$PWD　　表示当前工作路径。 
	$EDITOR 表示系统的默认编辑器名称。 
	$BASH 　表示当前 Shell 的路径字符串。
	$0, $1, $2, ... 
	表示系统传给脚本程序或脚本程序传给函数的第0个、第一个、第二个等参数。
	$#　　　表示脚本程序的命令参数个数或函数的参数个数。
	$$　　　表示该脚本程序的进程号，常用于生成文件名唯一的临时文件。 
	$?　　　表示脚本程序或函数的返回状态值，正常为 0，否则为非零的错误号。
	$*　　　表示所有的脚本参数或函数参数。
	$@　　　和 $* 涵义相似，但是比 $* 更安全。
	$!　　　表示最近一个在后台运行的进程的进程号。
	$RANDOM 一个大小在 1 到 65536 之间的随机整数

### 符号

	算术运算符 
		+ - * / % 表示加减乘除和取余运算
		+= -= *= /= 同 C 语言中的含义
	位操作符
		<< <<= >> >>= 表示位左右移一位操作
		& &= | |= 表示按位与、位或操作
		~ ! 表示非操作
		^ ^= 表示异或操作
	关系运算符 
		< > <= >= == != 表示大于、小于、大于等于、小于等于、等于、不等于操作
		&& || 逻辑与、逻辑或操作

### 变量的特殊操作

	${var-default} 表示如果变量 $var 还没有设置，则保持 $var 没有设置的状态，并返回后面的默认值 default。
	${var=default} 表示如果变量 $var 还没有设置，则取后面的默认值 default。 
	${var+otherwise} 表示如果变量 $var 已经设置，则返回 otherwise 的值，否则返回空( null )。
	${var?err_msg} 表示如果变量 $var 已经设置，则返回该变量的值，否则将后面的 err_msg 输出到标准错误输出上。

还有下面一些用法，这些用法主要用于从文件路径字符串中提取有用信息：

	${var#pattern}, ${var##pattern} 用于从变量 $var 中剥去最短（最长）的和 pattern 相匹配的最左侧的串。
	${var%pattern}, ${var%%pattern} 用于从变量 $var 中剥去最短（最长）的和 pattern 相匹配的最右侧的串。
	${var:pos} 表示去掉变量 $var 中前 pos 个字符。
	${var:pos:len} 表示变量 $var 中去掉前 pos 个字符后的剩余字符串的前 len 个字符。
	${var/pattern/replacement} 表示将变量 $var 中第一个出现的 pattern 模式替换为 replacement 字符串。
	${var//pattern/replacement} 表示将变量 $var 中出现的所有 pattern 模式全部都替换为 replacment 字符串。

## 程序界面

BASH 中提供了一个小的语句格式，可以让程序快速的设计出一个字符界面的用户交互选择的菜单，该功能就是由 select 语句来实现的。
	
	OPTIONS="Hello Quit" 
	select opt in $OPTIONS; do 
	if [ "$opt" = "Quit" ]; then 
	echo done 
	exit 
	elif [ "$opt" = "Hello" ]; then 
	echo Hello World 
	else 
	clear 
	echo bad option 
	fi 
	done 

BASH 中通过 read 函数来实现读取用户输入的功能

	echo Please enter your name
	read NAME 
	echo "Hi! $NAME !"

也可以通过文本输入。要求在需要键盘输入的命令后，直接加上 << 符号，然后跟上一个自定义的字符串，在该串后按顺序输入本来应该由键盘输入的所有字符，在所有需要输入的字符都结束后，重复一遍自定义的字符串，表示该输入到此结束。

	passwd="aka@tsinghua" 
	ftp -n localhost <<(U •́ .̫ •̀ U)
	user anonymous $passwd
	(U •́ .̫ •̀ U)


​	
## 一些特殊的惯用法

* 在 BASH 中 () 一对括号一般被用于求取括号中表达式的值或命令的执行结果，如：(a=hello; echo $a) ，其作用相当于 `...` 

* : 有两个含义，一是表示空语句，有点类似于 C 语言中的单个 ";" 。表示该行是一个空命令，如果被用在 while/until 的头结构中，则表示值 0，会使循环一直进行下去

		while : 
		do 
		operation
		done

* : 还可以用于求取后面变量的值

		: ${HOSTNAME?} {USER?} {MAIL?} 
		echo $HOSTNAME 
		echo $USER 
		echo $MAIL 
	
* 在 BASH 中 export 命令用于将系统变量输出到外层的 Shell 中。
* bash -x bash-script 命令，可以查看一个出错的 BASH 脚本到底错在什么地方，可以帮助程序员找出脚本中的错误。
* trap 语句可以在 BASH 脚本出错退出时打印出一些变量的值，以供程序员检查。trap 语句必须作为继 "#!/bin/bash" 后的第一句非注释代码，一般 trap 命令被写作： trap 'message $checkvar1 $checkvar2' EXIT 。
