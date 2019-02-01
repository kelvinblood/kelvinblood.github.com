---
layout: post
title:  nginx开启IPV6支持配置
category: tech
tags: nginx
---
![](https://cdn.kelu.org/blog/tags/nginx.jpg)

## 查看nginx是否支持ipv6

	YUKI.N > /usr/share/openresty/nginx/sbin/nginx -V
	nginx version: openresty/1.9.7.1
	built by gcc 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.5)
	built with OpenSSL 1.0.2g  1 Mar 2016
	TLS SNI support enabled
	configure arguments: --prefix=/usr/share/openresty/nginx 

没有出现--with-ipv6,说明当前的nginx不支持ipv6，需要重新编译nginx，配置里面增加--with-ipv6。

如何安装可以参考我的安装脚本： **[KeluLinuxKit](https://github.com/kelvinblood/KeluLinuxKit)**

## 同时监听IPV4和IPV6
	server  {
		listen  [::]:80;
		...
	}

## 只监听IPV6

	server  {
		listen  [::]:80  default  ipv6only=on;
		...
	}

## 监听指定IPV6地址

	server  {
		listen  [3608:f0f0:3002:31::1]:80;
		...
	}

