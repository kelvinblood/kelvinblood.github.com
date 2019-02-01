---
layout: post
title: Linux命令之 dig
category: tech
tags: linux linux-command
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

dig的全称是 (domain information groper)。它是一个用来灵活探测DNS的工具。它会打印出DNS name server的回应。它灵活性好、易用、输出清晰，经常被 DNS 管理员作为 DNS 问题的故障诊断工具。

可以直接使用网页接口体验: <https://www.diggui.com/>

# 安装

debian系：

```
apt-get install dnsutils
```

centos系:

```
yum install bind-utils
```

# 用法

```
@<服务器地址>：指定进行域名解析的域名服务器；
-b<ip地址>：当主机具有多个IP地址，指定使用本机的哪个IP地址向域名服务器发送域名查询请求；
-f<文件名称>：指定dig以批处理的方式运行，指定的文件中保存着需要批处理查询的DNS任务信息；
-P：指定域名服务器所使用端口号；
-t<类型>：指定要查询的DNS数据类型；默认情况下是A，也可以设置MX等类型;
-x<IP地址>：执行逆向域名查询；
-4：使用IPv4；
-6：使用IPv6；
-h：显示指令帮助信息。
```

dig最下面显示了查询所用的时间及DNS服务器，时间，数据大小。对于排查DNS问题很有用。


```
YUKI.N > dig sina.com
; <<>> DiG 9.9.5-9+deb8u15-Debian <<>> sina.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 27993

;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0
;; QUESTION SECTION:
;sina.com.                      IN      A
;; ANSWER SECTION:
sina.com.               46      IN      A       66.102.251.33

;; Query time: 3 msec
;; SERVER: 100.100.2.138#53(100.100.2.138)
;; WHEN: Tue Mar 27 21:17:51 CST 2018
;; MSG SIZE  rcvd: 42
```

# 精简输出

1. 使用+nocmd的话，可以节省输出dig版本信息。

2. 使用+short的话，仅会输出最精简的CNAME信息和A记录，其他都不会输出。

3. 使用+nocomment的话，可以节省输出dig的详情注释信息。

4. 使用+nostat的话，最后的统计信息也不会输出。

   ​

# 常用用法

* 只输出A记录(写脚本的时候容易获取ip地址)

  ```
  dig jpuyy.com +short
  ```


* 只输出mx记录

  ```
  dig mx jpuyy.com +short
  ```


* 只输出NS记录

  ```
  dig ns jpuyy.com
  ```


* 查询SOA( Start of Autority ) 返回主DNS服务器

  ```
  dig soa jpuyy.com
  ```


* 指定dns查询

  ```
  dig +short @8.8.8.8 jpuyy.com
  ```

* 跟踪dig全过程

  +trace，当使用这个查询选项后，dig会从根域查询一直跟踪直到查询到最终结果，并将整个过程信息输出出来。

  ```
  dig +trace cdn.kelu.org
  ```

* 逆向查询 -x。可以查询IP地址到域名的映射关系。

  ```
  dig -x 193.0.14.129
  ```

* TCP代替UDP

  ```
  dig +tcp www.baidu.com
  ```


# 参考资料

* [《dig挖出DNS的秘密》-linux命令五分钟系列之三十四](http://roclinux.cn/?p=2449)
