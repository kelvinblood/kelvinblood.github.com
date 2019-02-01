---
layout: post
title: 一个简单的局域网服务器互联案例(1)
category: tech
tags: linux
style: summer
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

用了一天时间安装服务器和组建局域网，记录一下过程。

# 背景

组建一个由4台服务器组成的局域网，提供给开发人员使用，要求安装CentOS 7系统，部署好docker环境。

# 搭建
	
![组网示意图](https://cdn.kelu.org/blog/2017/10/lan1.jpg)

## 安装CentOS

最简便的方法是，在官网下载好CentOS镜像，写入U盘，从U盘启动的方式，将系统安装到目标的服务器中。

## 配置路由器

1. 配置LAN地址

	为了不和上一级路由器冲突，局域网内最好避免选择诸如192.168.1.1这样的IP地址段。

	想了一下最后用了“172.10.1.1”的IP段。

	![配置LAN地址](https://cdn.kelu.org/blog/2017/10/lan2.jpg)

1. 配置IP与Mac映射

	在路由器不设定IP与Mac映射时，每当有新的设备连接到网络是，路由器DHCP会随机选择一个可用的IP提供给设备。

	开发环境里我们尽量避免这种不确定性带来的麻烦。

	![配置IP与Mac映射](https://cdn.kelu.org/blog/2017/10/lan3.jpg)

	在这里我配置了100-103，一共4台机器。

## 配置第一台服务器 - 100

1. docker ce
	
	CentOS 下使用的是 yum 命令，更新一下。

		yum update

	发现速度不慢，就不更改源地址了。
	
	然后安装`docker ce`

		yum install -y yum-utils device-mapper-persistent-data lvm2
		yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
		yum-config-manager --enable docker-ce-edge
		yum-config-manager --enable docker-ce-test
		yum install docker-ce


2. 使用密钥登录服务器

	* 生成密钥
		密码登录的方式还是不太安全的，也麻烦(尤其是那种超级复杂的root密码)。使用以下命令生成密钥对。

			ssh-keygen -b 1024 -t rsa -C 'xxx@xxx.com' -f /root/.ssh/xxx@xxx.com # xxx@xxx.com是你的邮箱名

		之后会在 `/root/.ssh` 目录下生成两个文件：公钥`xxx@xxx.com.pub`和密钥`xxx@xxx.com`，生成的私钥文件的默认权限是600。

	* 修改ssh配置文件

			vi /etc/ssh/sshd_config

		CentOS默认的配置文件有两个地方需要修改。	

		一是监听地址，默认只允许本地登录：
		
			ListenAddress 0.0.0.0
			ListenAddress ::

		二是允许密钥登录和允许root用户登录：
			
			PasswordAuthentication yes #使用密码 no为不使用密码 
			PermitRootLogin yes
			StrictModes yes
			
			RSAAuthentication yes
			PubkeyAuthentication yes
			AuthorizedKeysFile .ssh/authorized_keys #ssh文件位置 

			IgnoreRhosts yes
			RhostsRSAAuthentication no
			HostbasedAuthentication no
			
			PermitEmptyPasswords no
			
			ChallengeResponseAuthentication no

		修改完成后重启 sshd 服务：

			systemctl restart sshd

	* 配置局域网内其他服务器的ssh登录信息: `vi ~/.ssh/config`

			Host    100
			  HostName        172.10.1.100
			  Port            22
			  User            root
			  IdentityFile    ~/.ssh/xxx@xxx.com
			Host    101
			  HostName        172.10.1.101
			  Port            22
			  User            root
			  IdentityFile    ~/.ssh/xxx@xxx.com
			Host    102
			  HostName        172.10.1.102
			  Port            22
			  User            root
			  IdentityFile    ~/.ssh/xxx@xxx.com
			Host    103
			  HostName        172.10.1.103
			  Port            22
			  User            root
			  IdentityFile    ~/.ssh/xxx@xxx.com

	* 设置开机自动启动
		
		很奇怪为什么 CentOS 不默认启动 ssh

			chkconfig sshd on

		![配置IP与Mac映射](https://cdn.kelu.org/blog/2017/10/lan4.jpg)	

## 部署剩下三台服务器

因为都是重复性工作，写了一个安装脚本，批量在新机器上跑就可以了。以下两个脚本都放到github上了，项目地址是: 
<https://github.com/kelvinblood/gist>

主要思路是现在100机器上讲ssh的配置文件传到其他机器上去，其他机器再进行自动配置。

1. 在100的机器上，运行以下脚本[`ssh_old.sh`](https://github.com/kelvinblood/gist/blob/master/ssh_old.sh)：

		#!/bin/bash
		
		. /etc/profile
		
		cp /etc/ssh/sshd_config ~/.ssh/
		cd /tmp
		tar -czvf ssh.tgz ~/.ssh/* /etc/ssh/sshd_config ~/ssh_new.sh ~/ssh_old.sh 
		
		scp ssh.tgz root@100:/tmp
		scp ssh.tgz root@101:/tmp
		scp ssh.tgz root@102:/tmp
		scp ssh.tgz root@103:/tmp

2. 在其他机器上运行以下脚本[`ssh_new.sh`](https://github.com/kelvinblood/gist/blob/master/ssh_new.sh)：

		#!/bin/bash
		
		. /etc/profile
		
		cd /tmp
		
		if [ -e '/tmp/root' ]; then
			rm -rf /tmp/root
		fi
		
		tar -xzvf ssh.tgz
		
		cd root
		if [ -e '/root/.ssh' ]; then
			rm -rf /root/.ssh
		fi
		
		mv .ssh ~/
		mv ~/.ssh/sshd_config /etc/ssh/sshd_config
		
		systemctl restart sshd
		chkconfig sshd on

		yum update
		yum install -y yum-utils device-mapper-persistent-data lvm2
		yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
		yum-config-manager --enable docker-ce-edge
		yum-config-manager --enable docker-ce-test
		yum install docker-ce

至此，4台机器均配置ok了。

# 使用

## 使用putty登录服务器

putty 是 Windows 下一个 ssh 登录服务器的软件。下载地址：

| Binary | Platform | Signature | Date |
| --- | --- | --- | --- |
| [putty-0.70-installer.msi](https://www.ssh.com/a/putty-0.70-installer.msi) | Windows (any) | [GPG signature](https://www.ssh.com/a/putty-0.70-installer.msi.gpg) | 2017-07-08 |
| [putty-64bit-0.70-installer](https://www.ssh.com/a/putty-64bit-0.70-installer.msi) | Windows (64-bit) | [GPG signature](https://www.ssh.com/a/putty-64bit-0.70-installer.msi.gpg) | 2017-07-08 |
	
安装后找到软件 puttygen，载入在上边的密钥，生成putty格式的密钥：

![生成putty格式的密钥](https://cdn.kelu.org/blog/2017/10/lan5.jpg)

使用刚才生成的密钥就可以快速登录服务器。putty具体的使用方法就不介绍了。大概如下图配置即可：

![](https://cdn.kelu.org/blog/2017/10/lan6.jpg)

![](https://cdn.kelu.org/blog/2017/10/lan7.jpg)

## 服务器间相互登录

在任意一台机器上使用

	ssh 100
	ssh 101
	ssh 102
	ssh 103

都可以快速登录。

# 小吐槽

使用了这么久的linux，都是走debian系的，这是第一次接触centos系的，命令还是不太习惯。不过查一下也就懂了。

# 参考资料

* [Get Docker CE for CentOS](https://docs.docker.com/engine/installation/linux/docker-ce/centos/#install-using-the-repository)