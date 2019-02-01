---
layout: post
title:  nslookup 查看域名 dns 地址
category: tech
tags: linux
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

域名是需要DNS才能正常解析的。最近我有个域名在 dnspod 上老是无法解析，提示 NS 地址还未修改，头疼。于是查看了域名 dns 解析地址，易名中国真是坑（应该就是他的锅吧。

nslookup命令，是Linux里非常常用的网络命令，简而言之就是“查DNS信息用的”。 作者是Andrew Cherenson， 他是一位计算机科学的高材生，曾经就读于哈佛大学和加州大学伯克利分校。 目前就职于ChoiceStream公司。

windows 下：

    nslookup -qt=ns xxx.org
    
显示：    
    
    服务器:  cache-nn.gxcc.net
    Address:  221.7.128.68

    *** cache-nn.gxcc.net 找不到 xxx: Non-existent domain
    
Linux 下：

    nslookup
    
显示：    
    
    > xxx.org
    Server:         100.100.2.136
    Address:        100.100.2.136#53
    
    ** server can't find xxx: NXDOMAIN


如果是正确的情况，应该这么显示

    服务器:  cache-nn.gxcc.net                     
    Address:  221.7.128.68                                                                        

    非权威应答:                                    
    kelu.org        nameserver = f1g1ns2.dnspod.net
    kelu.org        nameserver = f1g1ns1.dnspod.net

或者

    > kelu.org
    Server:         100.100.2.136
    Address:        100.100.2.136#53

    Non-authoritative answer:
    Name:   kelu.org
    Address: 47.52.46.212

