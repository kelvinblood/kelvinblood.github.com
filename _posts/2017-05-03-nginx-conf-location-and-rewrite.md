---
layout: post
title:  转载 | nginx location 总结、rewrite 规则写法与其它通用配置 
category: tech
tags: nginx
---

![](https://cdn.kelu.org/blog/tags/nginx.jpg)

本文转自[《nginx配置location总结及rewrite规则写法》](http://seanlook.com/2015/05/17/nginx-location-rewrite/)与[《nginx服务器安装及配置文件详解》](http://seanlook.com/2015/05/17/nginx-install-and-config/)，有删减。

# 1. location正则写法

示例：

    location  = / {
      # 精确匹配 / ，主机名后面不能带任何字符串
      [ configuration A ]
    }
    location  / {
      # 因为所有的地址都以 / 开头，所以这条规则将匹配到所有请求
      # 但是正则和最长字符串会优先匹配
      [ configuration B ]
    }
    location /documents/ {
      # 匹配任何以 /documents/ 开头的地址，匹配符合以后，还要继续往下搜索
      # 只有后面的正则表达式没有匹配到时，这一条才会采用这一条
      [ configuration C ]
    }
    location ~ /documents/Abc {
      # 匹配任何以 /documents/Abc 开头的地址，匹配符合以后，还要继续往下搜索
      # 只有后面的正则表达式没有匹配到时，这一条才会采用这一条
      [ configuration CC ]
    }
    location ^~ /images/ {
      # 匹配任何以 /images/ 开头的地址，匹配符合以后，停止往下搜索正则，采用这一条。
      [ configuration D ]
    }
    location ~* \.(gif|jpg|jpeg)$ {
      # 匹配所有以 gif,jpg或jpeg 结尾的请求
      # 然而，所有请求 /images/ 下的图片会被 config D 处理，因为 ^~ 到达不了这一条正则
      [ configuration E ]
    }
    location /images/ {
      # 字符匹配到 /images/，继续往下，会发现 ^~ 存在
      [ configuration F ]
    }
    location /images/abc {
      # 最长字符匹配到 /images/abc，继续往下，会发现 ^~ 存在
      # F与G的放置顺序是没有关系的
      [ configuration G ]
    }
    location ~ /images/abc/ {
      # 只有去掉 config D 才有效：先最长匹配 config G 开头的地址，继续往下搜索，匹配到这一条正则，采用
        [ configuration H ]
    }
    location ~* /js/.*/\.js
    
* =开头表示精确匹配
    如 A 中只匹配根目录结尾的请求，后面不能带任何字符串。
* ^~ 开头表示uri以某个常规字符串开头，不是正则匹配
* ~ 开头表示区分大小写的正则匹配;
* ~* 开头表示不区分大小写的正则匹配
* / 通用匹配, 如果没有其它匹配,任何请求都会匹配到

顺序 no优先级：

    (location =) > (location 完整路径) > (location ^~ 路径) > (location ~,~* 正则顺序) > (location 部分起始路径) > (/)

个人觉得至少有三个匹配规则定义，如下：

    #直接匹配网站根，通过域名访问网站首页比较频繁，使用这个会加速处理，官网如是说。
    #这里是直接转发给后端应用服务器了，也可以是一个静态首页
    # 第一个必选规则
    location = / {
        proxy_pass http://tomcat:8080/index
    }
    
    # 第二个必选规则是处理静态文件请求，这是nginx作为http服务器的强项
    # 有两种配置模式，目录匹配或后缀匹配,任选其一或搭配使用
    location ^~ /static/ {
        root /webroot/static/;
    }
    location ~* \.(gif|jpg|jpeg|png|css|js|ico)$ {
        root /webroot/res/;
    }
    
    #第三个规则就是通用规则，用来转发动态请求到后端应用服务器
    #非静态文件请求就默认是动态请求，自己根据实际把握
    #毕竟目前的一些框架的流行，带.php,.jsp后缀的情况很少了
    location / {
        proxy_pass http://tomcat:8080/
    }
    
    
参考资料：

* <http://tengine.taobao.org/book/chapter_02.html>
* <http://nginx.org/en/docs/http/ngx_http_rewrite_module.html>

# 2 Rewrite规则

rewrite功能就是，使用nginx提供的全局变量或自己设置的变量，结合正则表达式和标志位实现url重写以及重定向。rewrite只能放在server{},location{},if{}中，并且只能对域名后边的除去传递的参数外的字符串起作用，例如 http://seanlook.com/a/we/index.php?id=1&u=str 只对/a/we/index.php重写。语法rewrite regex replacement [flag];

如果相对域名或参数字符串起作用，可以使用全局变量匹配，也可以使用proxy_pass反向代理。

表明看rewrite和location功能有点像，都能实现跳转，主要区别在于rewrite是在同一域名内更改获取资源的路径，而location是对一类路径做控制访问或反向代理，可以proxy_pass到其他机器。很多情况下rewrite也会写在location里，它们的执行顺序是：

* 执行server块的rewrite指令
* 执行location匹配
* 执行选定的location中的rewrite指令

如果其中某步URI被重写，则重新循环执行1-3，直到找到真实存在的文件；循环超过10次，则返回500 Internal Server Error错误。

### 2.1 flag标志位

* last : 相当于Apache的[L]标记，表示完成rewrite
* break : 停止执行当前虚拟主机的后续rewrite指令集
* redirect : 返回302临时重定向，地址栏会显示跳转后的地址
* permanent : 返回301永久重定向，地址栏会显示跳转后的地址

因为301和302不能简单的只返回状态码，还必须有重定向的URL，这就是return指令无法返回301,302的原因了。这里 last 和 break 区别有点难以理解：

* last一般写在server和if中，而break一般使用在location中
* last不终止重写后的url匹配，即新的url会再从server走一遍匹配流程，而break终止重写后的匹配
* break和last都能组织继续执行后面的rewrite指令

### 2.2 if指令与全局变量

if判断指令

语法为if(condition){...}，对给定的条件condition进行判断。如果为真，大括号内的rewrite指令将被执行，if条件(conditon)可以是如下任何内容：

* 当表达式只是一个变量时，如果值为空或任何以0开头的字符串都会当做false
* 直接比较变量和内容时，使用=或!=
* ~正则表达式匹配，~*不区分大小写的匹配，!~区分大小写的不匹配

    -f和!-f用来判断是否存在文件
    -d和!-d用来判断是否存在目录
    -e和!-e用来判断是否存在文件或目录
    -x和!-x用来判断文件是否可执行

    if ($http_user_agent ~ MSIE) {
        rewrite ^(.*)$ /msie/$1 break;
    } //如果UA包含"MSIE"，rewrite请求到/msid/目录下
    if ($http_cookie ~* "id=([^;]+)(?:;|$)") {
        set $id $1;
    } //如果cookie匹配正则，设置变量$id等于正则引用部分
    if ($request_method = POST) {
        return 405;
    } //如果提交方法为POST，则返回状态405（Method not allowed）。return不能返回301,302
    if ($slow) {
        limit_rate 10k;
    } //限速，$slow可以通过 set 指令设置
    if (!-f $request_filename){
        break;
        proxy_pass  http://127.0.0.1;
    } //如果请求的文件名不存在，则反向代理到localhost 。这里的break也是停止rewrite检查
    if ($args ~ post=140){
        rewrite ^ http://example.com/ permanent;
    } //如果query string中包含"post=140"，永久重定向到example.com
    location ~* \.(gif|jpg|png|swf|flv)$ {
        valid_referers none blocked www.jefflei.com www.leizhenfang.com;
        if ($invalid_referer) {
            return 404;
        } //防盗链
    }
    
全局变量

下面是可以用作if判断的全局变量

* $args ： #这个变量等于请求行中的参数，同$query_string
* $content_length ： 请求头中的Content-length字段。
* $content_type ： 请求头中的Content-Type字段。
* $document_root ： 当前请求在root指令中指定的值。
* $host ： 请求主机头字段，否则为服务器名称。
* $http_user_agent ： 客户端agent信息
* $http_cookie ： 客户端cookie信息
* $limit_rate ： 这个变量可以限制连接速率。
* $request_method ： 客户端请求的动作，通常为GET或POST。
* $remote_addr ： 客户端的IP地址。
* $remote_port ： 客户端的端口。
* $remote_user ： 已经经过Auth Basic Module验证的用户名。
* $request_filename ： 当前请求的文件路径，由root或alias指令与URI请求生成。
* $scheme ： HTTP方法（如http，https）。
* $server_protocol ： 请求使用的协议，通常是HTTP/1.0或HTTP/1.1。
* $server_addr ： 服务器地址，在完成一次系统调用后可以确定这个值。
* $server_name ： 服务器名称。
* $server_port ： 请求到达服务器的端口号。
* $request_uri ： 包含请求参数的原始URI，不包含主机名，如：”/foo/bar.php?arg=baz”。
* $uri ： 不带请求参数的当前URI，$uri不包含主机名，如”/foo/bar.html”。
* $document_uri ： 与$uri相同。
* 例：http://localhost:88/test1/test2/test.php
* $host：localhost
* $server_port：88
* $request_uri：http://localhost:88/test1/test2/test.php
* $document_uri：/test1/test2/test.php
* $document_root：/var/www/html
* $request_filename：/var/www/html/test1/test2/test.php

### 2.3 常用正则

* . ： 匹配除换行符以外的任意字符
* ? ： 重复0次或1次
* + ： 重复1次或更多次
* * ： 重复0次或更多次
* \d ：匹配数字
* ^ ： 匹配字符串的开始
* $ ： 匹配字符串的介绍
* {n} ： 重复n次
* {n,} ： 重复n次或更多次
* [c] ： 匹配单个字符c
* [a-z] ： 匹配a-z小写字母的任意一个

小括号()之间匹配的内容，可以在后面通过$1来引用，$2表示的是前面第二个()里的内容。正则里面容易让人困惑的是\转义特殊字符。

### 2.4 rewrite实例

    http {
        # 定义image日志格式
        log_format imagelog '[$time_local] ' $image_file ' ' $image_type ' ' $body_bytes_sent ' ' $status;
        # 开启重写日志
        rewrite_log on;
        server {
            root /home/www;
            location / {
                    # 重写规则信息
                    error_log logs/rewrite.log notice;
                    # 注意这里要用‘’单引号引起来，避免{}
                    rewrite '^/images/([a-z]{2})/([a-z0-9]{5})/(.*)\.(png|jpg|gif)$' /data?file=$3.$4;
                    # 注意不能在上面这条规则后面加上“last”参数，否则下面的set指令不会执行
                    set $image_file $3;
                    set $image_type $4;
            }
            location /data {
                    # 指定针对图片的日志格式，来分析图片类型和大小
                    access_log logs/images.log mian;
                    root /data/images;
                    # 应用前面定义的变量。判断首先文件在不在，不在再判断目录在不在，如果还不在就跳转到最后一个url里
                    try_files /$arg_file /image404.html;
            }
            location = /image404.html {
                    # 图片不存在返回特定的信息
                    return 404 "image not found\n";
            }
    }

对形如/images/ef/uh7b3/test.png的请求，重写到/data?file=test.png，于是匹配到location /data，先看/data/images/test.png文件存不存在，如果存在则正常响应，如果不存在则重写tryfiles到新的image404 location，直接返回404状态码。

例2：

    rewrite ^/images/(.*)_(\d+)x(\d+)\.(png|jpg|gif)$ /resizer/$1.$4?width=$2&height=$3? last;
    
对形如/images/bla_500x400.jpg的文件请求，重写到/resizer/bla.jpg?width=500&height=400地址，并会继续尝试匹配location。

参考资料：

* <http://www.nginx.cn/216.html>
* <http://www.ttlsa.com/nginx/nginx-rewriting-rules-guide/>
* 老僧系列nginx之rewrite规则快速上手
* <http://fantefei.blog.51cto.com/2229719/919431>


# 3. nginx.conf配置文件

Nginx配置文件主要分成四部分：main（全局设置）、server（主机设置）、upstream（上游服务器设置，主要为反向代理、负载均衡相关配置）和 location（URL匹配特定位置后的设置），每部分包含若干个指令。main部分设置的指令将影响其它所有部分的设置；server部分的指令主要用于指定虚拟主机域名、IP和端口；upstream的指令用于设置一系列的后端服务器，设置反向代理及后端服务器的负载均衡；location部分用于匹配网页位置（比如，根目录“/”,“/images”,等等）。他们之间的关系式：server继承main，location继承server；upstream既不会继承指令也不会被继承。它有自己的特殊指令，不需要在其他地方的应用。

当前nginx支持的几个指令上下文：

### 3.1 通用

下面的nginx.conf简单的实现nginx在前端做反向代理服务器的例子，处理js、png等静态文件，jsp等动态请求转发到其它服务器tomcat：

    user  www www;
    worker_processes  2;
    error_log  logs/error.log;
    #error_log  logs/error.log  notice;
    #error_log  logs/error.log  info;
    pid        logs/nginx.pid;
    events {
        use epoll;
        worker_connections  2048;
    }
    http {
        include       mime.types;
        default_type  application/octet-stream;
        #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
        #                  '$status $body_bytes_sent "$http_referer" '
        #                  '"$http_user_agent" "$http_x_forwarded_for"';
        #access_log  logs/access.log  main;
        sendfile        on;
        # tcp_nopush     on;
        keepalive_timeout  65;
      # gzip压缩功能设置
        gzip on;
        gzip_min_length 1k;
        gzip_buffers    4 16k;
        gzip_http_version 1.0;
        gzip_comp_level 6;
        gzip_types text/html text/plain text/css text/javascript application/json application/javascript application/x-javascript application/xml;
        gzip_vary on;
      
      # http_proxy 设置
        client_max_body_size   10m;
        client_body_buffer_size   128k;
        proxy_connect_timeout   75;
        proxy_send_timeout   75;
        proxy_read_timeout   75;
        proxy_buffer_size   4k;
        proxy_buffers   4 32k;
        proxy_busy_buffers_size   64k;
        proxy_temp_file_write_size  64k;
        proxy_temp_path   /usr/local/nginx/proxy_temp 1 2;
      # 设定负载均衡后台服务器列表 
        upstream  backend  { 
                  #ip_hash; 
                  server   192.168.10.100:8080 max_fails=2 fail_timeout=30s ;  
                  server   192.168.10.101:8080 max_fails=2 fail_timeout=30s ;  
        }
      # 很重要的虚拟主机配置
        server {
            listen       80;
            server_name  itoatest.example.com;
            root   /apps/oaapp;
            charset utf-8;
            access_log  logs/host.access.log  main;
            #对 / 所有做负载均衡+反向代理
            location / {
                root   /apps/oaapp;
                index  index.jsp index.html index.htm;
                proxy_pass        http://backend;  
                proxy_redirect off;
                # 后端的Web服务器可以通过X-Forwarded-For获取用户真实IP
                proxy_set_header  Host  $host;
                proxy_set_header  X-Real-IP  $remote_addr;  
                proxy_set_header  X-Forwarded-For  $proxy_add_x_forwarded_for;
                proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
                
            }
            #静态文件，nginx自己处理，不去backend请求tomcat
            location  ~* /download/ {  
                root /apps/oa/fs;  
                
            }
            location ~ .*\.(gif|jpg|jpeg|bmp|png|ico|txt|js|css)$   
            {   
                root /apps/oaapp;   
                expires      7d; 
            }
            location /nginx_status {
                stub_status on;
                access_log off;
                allow 192.168.10.0/24;
                deny all;
            }
            location ~ ^/(WEB-INF)/ {   
                deny all;   
            }
            #error_page  404              /404.html;
            # redirect server error pages to the static page /50x.html
            #
            error_page   500 502 503 504  /50x.html;
            location = /50x.html {
                root   html;
            }
        }
      ## 其它虚拟主机，server 指令开始
    }
    
### 3.2 常用指令说明

3.2.1 main全局配置

nginx在运行时与具体业务功能（比如http服务或者email服务代理）无关的一些参数，比如工作进程数，运行的身份等。

    woker_processes 2
    在配置文件的顶级main部分，worker角色的工作进程的个数，master进程是接收并分配请求给worker处理。这个数值简单一点可以设置为cpu的核数grep ^processor /proc/cpuinfo | wc -l，也是 auto 值，如果开启了ssl和gzip更应该设置成与逻辑CPU数量一样甚至为2倍，可以减少I/O操作。如果nginx服务器还有其它服务，可以考虑适当减少。

    worker_cpu_affinity
    也是写在main部分。在高并发情况下，通过设置cpu粘性来降低由于多CPU核切换造成的寄存器等现场重建带来的性能损耗。如worker_cpu_affinity 0001 0010 0100 1000; （四核）。

    worker_connections 2048
    写在events部分。每一个worker进程能并发处理（发起）的最大连接数（包含与客户端或后端被代理服务器间等所有连接数）。nginx作为反向代理服务器，计算公式 最大连接数 = worker_processes * worker_connections/4，所以这里客户端最大连接数是1024，这个可以增到到8192都没关系，看情况而定，但不能超过后面的worker_rlimit_nofile。当nginx作为http服务器时，计算公式里面是除以2。

    worker_rlimit_nofile 10240
    写在main部分。默认是没有设置，可以限制为操作系统最大的限制65535。

    use epoll
    写在events部分。在Linux操作系统下，nginx默认使用epoll事件模型，得益于此，nginx在Linux操作系统下效率相当高。同时Nginx在OpenBSD或FreeBSD操作系统上采用类似于epoll的高效事件模型kqueue。在操作系统不支持这些高效模型时才使用select。

##### 3.2.2 http服务器

与提供http服务相关的一些配置参数。例如：是否使用keepalive啊，是否使用gzip进行压缩等。

    sendfile on
    开启高效文件传输模式，sendfile指令指定nginx是否调用sendfile函数来输出文件，减少用户空间到内核空间的上下文切换。对于普通应用设为 on，如果用来进行下载等应用磁盘IO重负载应用，可设置为off，以平衡磁盘与网络I/O处理速度，降低系统的负载。

    keepalive_timeout 65 : 长连接超时时间，单位是秒，这个参数很敏感，涉及浏览器的种类、后端服务器的超时设置、操作系统的设置，可以另外起一片文章了。长连接请求大量小文件的时候，可以减少重建连接的开销，但假如有大文件上传，65s内没上传完成会导致失败。如果设置时间过长，用户又多，长时间保持连接会占用大量资源。

    send_timeout : 用于指定响应客户端的超时时间。这个超时仅限于两个连接活动之间的时间，如果超过这个时间，客户端没有任何活动，Nginx将会关闭连接。

    client_max_body_size 10m
    允许客户端请求的最大单文件字节数。如果有上传较大文件，请设置它的限制值

    client_body_buffer_size 128k
    缓冲区代理缓冲用户端请求的最大字节数
    模块http_proxy：
    这个模块实现的是nginx作为反向代理服务器的功能，包括缓存功能（另见文章）

    proxy_connect_timeout 60
    nginx跟后端服务器连接超时时间(代理连接超时)
    proxy_read_timeout 60
    连接成功后，与后端服务器两个成功的响应操作之间超时时间(代理接收超时)

    proxy_buffer_size 4k
    设置代理服务器（nginx）从后端realserver读取并保存用户头信息的缓冲区大小，默认与proxy_buffers大小相同，其实可以将这个指令值设的小一点

    proxy_buffers 4 32k
    proxy_buffers缓冲区，nginx针对单个连接缓存来自后端realserver的响应，网页平均在32k以下的话，这样设置

    proxy_busy_buffers_size 64k
    高负荷下缓冲大小（proxy_buffers*2）

    proxy_max_temp_file_size
    当 proxy_buffers 放不下后端服务器的响应内容时，会将一部分保存到硬盘的临时文件中，这个值用来设置最大临时文件大小，默认1024M，它与 proxy_cache 没有关系。大于这个值，将从upstream服务器传回。设置为0禁用。

    proxy_temp_file_write_size 64k
    当缓存被代理的服务器响应到临时文件时，这个选项限制每次写临时文件的大小。proxy_temp_path（可以在编译的时候）指定写到哪那个目录。

    proxy_pass，proxy_redirect见 location 部分。

    模块http_gzip：

    gzip on : 开启gzip压缩输出，减少网络传输。
    gzip_min_length 1k ： 设置允许压缩的页面最小字节数，页面字节数从header头得content-length中进行获取。默认值是20。建议设置成大于1k的字节数，小于1k可能会越压越大。
    gzip_buffers 4 16k ： 设置系统获取几个单位的缓存用于存储gzip的压缩结果数据流。4 16k代表以16k为单位，安装原始数据大小以16k为单位的4倍申请内存。
    gzip_http_version 1.0 ： 用于识别 http 协议的版本，早期的浏览器不支持 Gzip 压缩，用户就会看到乱码，所以为了支持前期版本加上了这个选项，如果你用了 Nginx 的反向代理并期望也启用 Gzip 压缩的话，由于末端通信是 http/1.0，故请设置为 1.0。
    gzip_comp_level 6 ： gzip压缩比，1压缩比最小处理速度最快，9压缩比最大但处理速度最慢(传输快但比较消耗cpu)
    gzip_types ：匹配mime类型进行压缩，无论是否指定,”text/html”类型总是会被压缩的。
    gzip_proxied any ： Nginx作为反向代理的时候启用，决定开启或者关闭后端服务器返回的结果是否压缩，匹配的前提是后端服务器必须要返回包含”Via”的 header头。
    gzip_vary on ： 和http头有关系，会在响应头加个 Vary: Accept-Encoding ，可以让前端的缓存服务器缓存经过gzip压缩的页面，例如，用Squid缓存经过Nginx压缩的数据。。


##### 3.2.3 server虚拟主机

http服务上支持若干虚拟主机。每个虚拟主机一个对应的server配置项，配置项里面包含该虚拟主机相关的配置。在提供mail服务的代理时，也可以建立若干server。每个server通过监听地址或端口来区分。

    listen
    监听端口，默认80，小于1024的要以root启动。可以为listen *:80、listen 127.0.0.1:80等形式。

    server_name
    服务器名，如localhost、www.example.com，可以通过正则匹配。

    模块http_stream
    这个模块通过一个简单的调度算法来实现客户端IP到后端服务器的负载均衡，upstream后接负载均衡器的名字，后端realserver以 host:port options; 方式组织在 {} 中。如果后端被代理的只有一台，也可以直接写在 proxy_pass 。

##### 3.2.4 location

http服务中，某些特定的URL对应的一系列配置项。

    root /var/www/html
    定义服务器的默认网站根目录位置。如果locationURL匹配的是子目录或文件，root没什么作用，一般放在server指令里面或/下。

    index index.jsp index.html index.htm
    定义路径下默认访问的文件名，一般跟着root放

    proxy_pass http:/backend
    请求转向backend定义的服务器列表，即反向代理，对应upstream负载均衡器。也可以proxy_pass http://ip:port。

    proxy_redirect off;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

### 3.3 其它
##### 访问控制 allow/deny

Nginx 的访问控制模块默认就会安装，而且写法也非常简单，可以分别有多个allow,deny，允许或禁止某个ip或ip段访问，依次满足任何一个规则就停止往下匹配。如：

    location /nginx-status {
      stub_status on;
      access_log off;
    #  auth_basic   "NginxStatus";
    #  auth_basic_user_file   /usr/local/nginx-1.6/htpasswd;
      allow 192.168.10.100;
      allow 172.29.73.0/24;
      deny all;
    }
    
我们也常用 httpd-devel 工具的 htpasswd 来为访问的路径设置登录密码：

    # htpasswd -c htpasswd admin
    New passwd:
    Re-type new password:
    Adding password for user admin
    # htpasswd htpasswd admin    //修改admin密码
    # htpasswd htpasswd sean    //多添加一个认证用户
    
这样就生成了默认使用CRYPT加密的密码文件。打开上面nginx-status的两行注释，重启nginx生效。

2.3.2 列出目录 autoindex

Nginx默认是不允许列出整个目录的。如需此功能，打开nginx.conf文件，在location，server 或 http段中加入autoindex on;，另外两个参数最好也加上去:

* autoindex_exact_size off; 默认为on，显示出文件的确切大小，单位是bytes。改为off后，显示出文件的大概大小，单位是kB或者MB或者GB
* autoindex_localtime on;

默认为off，显示的文件时间为GMT时间。改为on后，显示的文件时间为文件的服务器时间

    location /images {
      root   /var/www/nginx-default/images;
      autoindex on;
      autoindex_exact_size off;
      autoindex_localtime on;
      }
      
参考资料：

* <http://liuqunying.blog.51cto.com/3984207/1420556>
* <http://nginx.org/en/docs/ngx_core_module.html#worker_cpu_affinity>
* <http://wiki.nginx.org/HttpCoreModule#sendfile>
