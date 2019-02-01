---
layout: post
title: 使用shell操作数据库
category: tech
tags: linux shell database mysql
---

我一般都是用phpmyadmin连接MySQL。偶尔使用shell登陆MySQL时，一些命令常常忘记，于是记录一些MySQL基础的连接操作命令。

## 交互式

	mysql --version		// MySQL版本
	mysql -uroot -p		// 登陆，随后输入密码。

`mysql> show database;`
	
	+--------------------+
	| Database           |
	+--------------------+
	| information_schema |
	| mysql              |
	| performance_schema |
	+--------------------+
	3 rows in set (0.00 sec)

	mysql> use kelu
	Database changed
	mysql> show tables;
	+----------------+
	| Tables_in_kelu  |
	+----------------+
	| vpn_chargeRec  |
	| vpn_online     |
	| vpn_record     |
	| vpn_subAccount |
	| vpn_user       |
	+----------------+
	5 rows in set (0.00 sec)
	
	mysql> source xxx.sql
	

## 脚本

首先，定义一些基本的配置。

	#!/bin/bash  
	HOSTNAME="127.0.0.1"  
	PORT="3306"  
	USERNAME="root"  
	PASSWORD="root"  
	DBNAME="mydb"  
	TABLENAME="test"  
	  
接着就是基本的CURD操作.



### 创建数据库
	create_db_sql="create database IF NOT EXISTS ${DBNAME}"
	mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} -e "${create_db_sql}" 
 
### 创建表
	create_table_sql="create table IF NOT EXISTS ${TABLENAME} (  name varchar(20), id int(11) default 0 )"
	mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${create_table_sql}"
 
### 插入数据
	 insert_sql="insert into ${TABLENAME} (username,starttime) values('$PEERNAME','$STARTTIME')"
	 mysql -h${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${insert_sql}"
 
### 查询数据
	select_sql="select id,starttime from ${TABLENAMEPRE} where username='$PEERNAME' AND IFACE='$PPP_IFACE' AND TTY='$PPP_TTY'"
	result=`mysql -h${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${select_sql}"`
  
### 更新数据
	update_sql="update ${TABLENAME} set id=3"
	mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${update_sql}"
 
### 删除数据
	delete_sql="delete from ${TABLENAMEPRE} where id='$idPre'"
	mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${delete_sql}"
