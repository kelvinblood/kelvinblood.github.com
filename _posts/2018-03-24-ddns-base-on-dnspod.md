---
layout: post
title: 基于 dnspod 的 ddns 脚本 —— KeluDdnsKit
category: tech
tags: dns
---
![](https://cdn.kelu.org/blog/tags/dns.jpg)

# DDNS是什么

DDNS（Dynamic Domain Name Server）是动态域名服务的缩写。

DDNS是将用户的动态IP地址映射到一个固定的域名解析服务上，用户每次连接网络的时候客户端程序就会通过信息传递把该主机的动态IP地址传送给位于服务商主机上的服务器程序，服务器程序负责提供DNS服务并实现动态域名解析。

　　![DDNS](https://cdn.kelu.org/blog/2018/03/20160621164657407.jpg)

动态域名服务的对象是指IP是动态的，是变动的。普通的DNS都是基于静态IP的，有可能是一对多或多对多，IP都是固定的一个或多个。但DDNS的IP是变动的、随机的。

DDNS 有很多用处，其中最常见的用法类似于 keepalived 的效果：用来防止单点故障。

# KeluDdnsKit

今天在 dnspod 的 api 的基础上添加节点存活的检测并自动修改的功能。可以在 github 上查看源码：**[KeluDdnsKit](https://github.com/kelvinblood/KeluDdnsKit)** 

具体实现与上边的图片描述是不同的。并没有 DDNS Client这个节点，由 DDNS server 检测节点存活再动态修改 dns server 记录。

## 用法

1. 复制`dns.conf.example`到同一目录下的`dns.conf`，填充 api 的访问密钥。
2. 复制`domain.list.example`到同一目录下的`domain.list`，填写需要 ddns 的域名。

执行时直接运行`ddnspod.sh`，默认无限 check domain.list 中的域名，并自动选择可用节点。

配置文件格式：

```
# 按`TokenID,Token`格式填写
arToken="12345,7676f344eaeaea9074c123451234512d"

# 每行一个域名
test.org www
```
## 效果图

![keluddnskit](https://cdn.kelu.org/blog/2018/03/keluddnskit.jpg)

## todo

* 将这个项目容器化，使用更加方便
* 增加默认配置恢复功能。