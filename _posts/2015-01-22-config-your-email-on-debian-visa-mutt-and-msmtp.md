---
layout: post
title: 配置mutt和msmtprc从debian中发邮件
category: tech
tags: linux mail
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

服务器发送邮件主要有两种方式。一种是搭建一个MTA(邮件传输代理)，使用sendmail或POSTFIX进行发送。具体的方法可以看Linode给的Guide，非常的详细。以这种方式搭建要考虑清楚自己是否真的需要一个邮件服务器，因为搭建的过程十分繁琐枯燥。Linode的文档也是一再强调这一点。另一种方式就是本文的mutt+msmpt。特点是轻量，够用。(υ◉ω◉υ)

## 安装

	apt-get install mutt msmtp

## 配置mutt
/etc/Muttrc是全局的，也可以用在用户目录下`～/.muttrc`配置。



	set sendmail="/usr/bin/msmtp"
	set use_from=yes
	set realname="kelu" # 发件人名字
	set from=kelu@kelu.org # 发件人地址
	set envelope_from=yes
	
	set charset="utf-8"
	#set send_charset="gb2312"
	set send_charset="utf-8"
	set locale = "zh_CN.UTF-8"
	set content_type = "text/html\;charset=utf-8"

## 配置.msmtprc

同样，msmtprc也是可以在/etc/msmtprc或者用户目录下的`~/.msmtprc`进行配置。
	
	account default
	host smtp.163.com  --> email server 地址
	from kelu@kelu.org
	auth login # 用plain似乎也没问题？有空再看
	user kelu@kelu.org
	password kelu.org
	logfile ~/.msmtp.log
	
	.msmtprc文件需要600权限，如果不是600权限会无法使用

使用以上的配置已经可以使用一些普通的国内邮箱进行信息发送了。但是如果你使用了gmail的话，需要多做出一些配置才可以。以下是我的设置，配置的方法也是参考了不少网站才找到的。例如[Virtage Devblog](http://devblog.virtage.com/2013/05/email-sending-from-ubuntu-server-via-google-apps-smtp-with-msmtp/)
最后正确的配置方法来自[archlinux的bbs](https://bbs.archlinux.org/viewtopic.php?id=89575)

	# Default settings that all others account inherit
	defaults
	
	# Logging - uncomment either syslog or logfile, having both uncommented disables logging at all.
	#syslog on
	# Or to log to log own file
	logfile  /var/log/msmtp.log
	
	keepbcc  on
	
	# Gmail/Google Apps (configure as may as you want)
	account  gmail
	host   smtp.gmail.com
	port   587
	protocol smtp
	auth on
	from pbrisbin@gmx.com
	user pbrisbin@gmx.com
	password XXXXX
	tls on
	tls_nocertcheck
	
	# Default account to use
	account default : gmail

一如那位配置好的用户所说的，`works like a dream` ʕ•̫͡•ʔ→ʕ•̫͡•̫͡•ʔ→ʕ•̫͡•=•̫͡•ʔ→ʕ•̫͡•ʔʕ•̫͡•ʔ→ʕ•̫͡•̫͡•ʔ ʕ•̫͡•̫͡•ʔ


发邮件给foo@google.com,并带有一个附件

	mutt -s "主题" foo@google.com -a 附件.txt < 邮件内容.txt

## 扩展

配置好邮件之后就可以发送一些vps的状态邮件给自己啦，还有很多种可能性，比如流量突然升高啊，登陆ssh发邮件提醒啊之类的。

比如在`/etc/ssh/sshrc`中添加以下信息：

	echo "$USER@`hostname` `date +%Y-%m-%d\ %H:%M` login from ${SSH_CLIENT%% *}" | mutt -s "$USER `date +%Y-%m-%d\ %H:%M` login from ${SSH_CLIENT%% *}" XXXXXX@kelu.org &

当有人登陆服务器时候发邮件提醒。
