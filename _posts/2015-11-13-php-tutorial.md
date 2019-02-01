---
layout: post
title: php备忘
category: tech
tags: php tutorial
---

同上一篇javascript入门，用了这么久的PHP，也还没正经地总结过。记录些容易忘记的。本文的信息并不完整。

## 基本知识

### 语法

	PHP 脚本以 <?php 开头，以 ?> 结尾。
	PHP 支持三种常见注释：`//` `#` 和`/* */`。
	PHP 大小写敏感，类型松散的语言。
	变量$，常量const(php5+)，define("x",200)(php4-).函数function xxx。
	
	有三种不同的变量作用域：local（局部）global（全局）static（静态）
	数据类型：字符串、整数、浮点数、逻辑、数组、对象class、null。
	逻辑运算，与或非 && || !
	
	echo - 能够输出一个以上的字符串.
	print - 只能输出一个字符串，并始终返回 1

### 字符串

	strlen();			// 计算长度
	strpos($str,'o');	// 计算位置
	substr($str, 2, 3);	// 截取字符串
	str_split($str,2);	// 分割字符串
	explode(' ',$str);	// 分割字符串
	$str.'some string';	// 连接字符串.,直接吧变量包含在""内也OK
	print_r();

### 数组
PHP的数组可以存所有类型的数据

位置的方式初始化

	$myArr = array("Volvo","BMW","SAAB");
	$myArr = array();
	myArr[0] = 'hello';

key-value的方式初始化（PHP的数组不仅可以当数组用，还可以当map用）

	$myArr=array("Peter"=>"35","Ben"=>"37","Joe"=>"43");
	$myArr=array(0=>"35","Ben"=>"37","Joe"=>"43");
	myArr[kv] = 'key-value';

	array_push($str,"text");
	
数组内容用var_dump查看如下

	array(3) {
	  [0] => string(5) "Volvo"
	  [1] => string(3) "BMW"
	  [2] => string(4) "SAAB"
	}



	
### 对象

后续待补...

	object(medoo)#6 (13) {
	  ["database_type":protected] => string(5) "mysql"
	  ["charset":protected] => string(4) "utf8"
	  ["database_name":protected] => string(3) ""
	  ["server":protected] => string(9) "localhost"
	  ["username":protected] => string(4) "root"
	  ["password":protected] => string(14) ""
	  ["database_file":protected] => NULL
	  ["socket":protected] => NULL
	  ["port":protected] => NULL
	  ["option":protected] => array(0) {
	  }
	  ["logs":protected] => array(0) {
	  }
	  ["debug_mode":protected] => bool(false)
	  ["pdo"] => object(PDO)#7 (0) {
	  }
	}

	
### 语句

	常用的语句，外加foreach

	foreach(array_expression as $value) statement
	foreach(array_expression as $key => $value) statement

### 类(php5添加的)

	include		加载失败显示warning(包含)
	require		加载失败显示error(依赖)
	require_once	加载一次
	
	require 'myNamespace/xxx.php'

	class Hello{
		const constNum = 200;
		private $_age,$_name;
		
		public funciton __construct($age,$name){
			$this->_age = $age;
			...
		}
		public function helloPHP(){ _age......}
		public static function staticPHP(){ Hello::constNum......}
	}
	
	$h = new \myNamespace\Hello();
	$h->helloPHP();
	
	Hello::staticPHP();
	Hello::constNum;
	
	
	// 继承
	class newHello extends Hello(){
		public funciton __construct($age,$name){
				parent::__construct($age,$name)
				...
			}
	}
	
## 常用函数

### 时间函数
	time()
	date()
### json
	json数据是一串字符串，它们包含json数组与json对象，区别是：
	数组里都是单个的值，对象是key-value。
	数组：
	[1,2,3,{"h":"hello"},[7,8,9]]
	对象：
	{"t":"test","k":"value",[12,34]}

数组里可以存对象，对象里也可以存数组。

	json_encode	
	json_decode($json)	// 转为对象
	json_decode($json,true)// 转为数组

### 文件操作

写：

	$f = fopen("date","w");
	fwrite($f,'string');
	fclose($f);

	$f = @fopen("date","w"); //取消警告
	
读：

	$f = fopen("date","w");
	$content = fgets($f);	// 读取一行
	// 一直读
	while(!feof($$f)){
	}
	
	echo $content;
	fclose($f);
	或者
	$allContent = file_get_contents('fileName');

## 会话管理

	cookie
	session




