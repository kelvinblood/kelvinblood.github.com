---
layout: post
title: tomcat 与 nginx，apache的区别
category: tech
tags: linux nginx
---
![](https://cdn.kelu.org/blog/tags/nginx.jpg)

[Apache HTTP Server Project](https://httpd.apache.org/): 一款开源的HTTP服务器软件，来自apache基金会；

Nginx 也是一款开源的HTTP服务器软件（当然它也可以作为邮件代理服务器、通用的TCP代理服务器），来自俄罗斯。

HTTP服务器通常运行在服务器之上，绑定服务器的IP地址并监听某一个tcp端口来接收并处理HTTP请求，这样客户端（IE, Firefox，Chrome等浏览器）就能够通过HTTP协议来获取服务器上的网页（HTML格式）、文档（PDF格式）、音频（MP4格式）、视频（MOV格式）等等资源。

然而 Apache HTTP Server 和 Nginx 本身不支持生成动态页面，但它们可以通过其他模块来支持（例如通过Shell、PHP、Python脚本程序来动态生成内容）。

如果想要使用Java程序来动态生成资源内容，需要使用 Java Servlet 技术以及衍生的 Java Server Pages 技术。而 Tomcat 就是支持运行Servlet/JSP应用程序的容器，能够**动态**的生成资源并返回到客户端。

虽然 Tomcat 也可以认为是HTTP服务器，但基于动静态资源分离和方便 tomcat 水平扩展的原则，Tomcat 通常仍然会和 Nginx 或 apache 配合在一起使用。
