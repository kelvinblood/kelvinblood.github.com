---
layout: post
title: 一个简单的局域网服务器互联案例(3) —— 一键生成新用户
category: tech
tags: linux
style: summer
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

接上篇。

# 背景

在前面的系列里我完成了服务器安装、访问配置、局域网组建和普通网段下对开发网段的访问。一个可用的雏形已经成型。

不过里面还缺少一些东西，其中一个就是开发用户的管理。共用root账号进行服务器操作，虽说可行，也简单粗暴了一些。基本的用户管理也是应该有的。

所以这一篇主要完成在4台机器中创建新用户，并快捷生成密钥的脚本。系统环境为CentOS 7.

# 过程

脚本的逻辑

1. 生成一个带有默认密码的用户
1. 将用户加入`wheel`组，使之拥有sudo权限(centos下wheel用户组有sudo权限)
1. 生成密钥
1. 生成config文件并修改文件属性
1. 在其它服务器上生成同名账号
1. 将生成的密钥和配置文件同步到其他服务器上去
1. 在其他机器上修改文件用户组
1. 修改本机文件用户组

脚本已经放到github上了:<https://github.com/kelvinblood/gist/blob/master/addUser.sh>
	
	#!/bin/bash
	
	. /etc/profile
	
	
	VERSION=' Version 0.0.1, 2017年10月12日, Copyright (c) 2017 kelvinblood';
	
	usage () {
	    echo '没有帮助';
	}
	
	
	
	if [ "$#" -eq 0 ]; then
	    usage
	    exit 0
	fi
	
	case $1 in
	    -h|h|help )
	        usage
	        exit 0;
	        ;;
	    -v|v|version )
	        echo $VERSION;
	        exit 0;
	        ;;
	esac
	
	if [ "$EUID" -ne 0 ]; then
	    echo "必需以root身份运行，请使用sudo等命令"
	    exit 1;
	fi
	
	USERNAME=$1
	PASSWDCH="$USERNAME:Qweewq"
	
	
	if [ -e "/home/$USERNAME" ]; then
	    echo '该账户home目录已存在'
	    exit 0
	fi
	
	useradd $USERNAME -d /home/$USERNAME -G wheel;
	echo $PASSWDCH | chpasswd
	
	if [ -e "/home/$USERNAME/.ssh" ]; then
	    rm -rf "/home/$USERNAME/.ssh"
	fi
	
	
	mkdir /home/$USERNAME/.ssh
	cd /home/$USERNAME/.ssh
	
	sudo ssh-keygen -b 1024 -t rsa -C $USERNAME -f "/home/$USERNAME/.ssh/$USERNAME"
	touch authorized_keys
	touch config
	
	cat $USERNAME.pub >> authorized_keys
	chmod 400 authorized_keys
	
	cat >> config << EOF
	# add by weikelu
	Host    100
	  HostName        172.10.1.100
	  Port            22
	  User            $USERNAME
	  IdentityFile    /home/$USERNAME/.ssh/$USERNAME
	Host    101
	  HostName        172.10.1.101
	  Port            22
	  User            $USERNAME
	  IdentityFile    /home/$USERNAME/.ssh/$USERNAME
	Host    102
	  HostName        172.10.1.102
	  Port            22
	  User            $USERNAME
	  IdentityFile    /home/$USERNAME/.ssh/$USERNAME
	Host    103
	  HostName        172.10.1.103
	  Port            22
	  User            $USERNAME
	  IdentityFile    /home/$USERNAME/.ssh/$USERNAME
	EOF
	
	###########################################################
	
	ssh 101 "useradd $USERNAME -d /home/$USERNAME -G wheel"
	ssh 101 "echo $PASSWDCH | chpasswd"
	
	cd /home/$USERNAME/.ssh
	
	ssh 101 "mkdir /home/$USERNAME/.ssh"
	scp config 101:"/home/$USERNAME/.ssh/config"
	scp $USERNAME 101:"/home/$USERNAME/.ssh/$USERNAME"
	scp authorized_keys 101:"/home/$USERNAME/.ssh/authorized_keys"
	ssh 101 "chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh"
	
	###########################################################
	
	ssh 102 "useradd $USERNAME -d /home/$USERNAME -G wheel"
	ssh 102 "echo $PASSWDCH | chpasswd"
	
	cd /home/$USERNAME/.ssh
	
	ssh 102 "mkdir /home/$USERNAME/.ssh"
	scp config 102:"/home/$USERNAME/.ssh/config"
	scp $USERNAME 102:"/home/$USERNAME/.ssh/$USERNAME"
	scp authorized_keys 102:"/home/$USERNAME/.ssh/authorized_keys"
	ssh 102 "chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh"
	
	###########################################################
	
	ssh 103 "useradd $USERNAME -d /home/$USERNAME -G wheel"
	ssh 103 "echo $PASSWDCH | chpasswd"
	
	cd /home/$USERNAME/.ssh
	
	ssh 103 "mkdir /home/$USERNAME/.ssh"
	scp config 103:"/home/$USERNAME/.ssh/config"
	scp $USERNAME 103:"/home/$USERNAME/.ssh/$USERNAME"
	scp authorized_keys 103:"/home/$USERNAME/.ssh/authorized_keys"
	ssh 103 "chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh"

	###########################################################

	chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh



测试过程中顺手写了一个删除用户的脚本，也一并放上来，[`delUser.sh`](https://github.com/kelvinblood/gist/blob/master/delUser.sh)
	
	#!/bin/bash
	
	. /etc/profile
	
	
	VERSION=' Version 0.0.1, 2017年10月12日, Copyright (c) 2017 kelvinblood';
	
	usage () {
	    echo '没有帮助';
	}
	
	
	
	if [ "$#" -eq 0 ]; then
	    usage
	    exit 0
	fi
	
	case $1 in
	    -h|h|help )
	        usage
	        exit 0;
	        ;;
	    -v|v|version )
	        echo $VERSION;
	        exit 0;
	        ;;
	esac
	
	if [ "$EUID" -ne 0 ]; then
	    echo "必需以root身份运行，请使用sudo等命令"
	    exit 1;
	fi
	
	USERNAME=$1
	
	userdel $USERNAME
	rm -rf /home/$USERNAME
	
	ssh 101 "userdel $USERNAME"
	ssh 101 "rm -rf /home/$USERNAME"
	
	ssh 102 "userdel $USERNAME"
	ssh 102 "rm -rf /home/$USERNAME"
	
	ssh 103 "userdel $USERNAME"
	ssh 103 "rm -rf /home/$USERNAME"


