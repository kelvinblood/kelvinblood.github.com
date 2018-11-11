---
layout: post
title: HAProxy 简介
category: tech
tags: linux haproxy
---
![](https://cdn.kelu.org/blog/tags/haproxy.jpg)

血衫平时会玩一些日服韩服游戏，有的游戏还会限定某个地区的IP才能够接入。对于一些对丢包率特别敏感的游戏（比如舰队Collection），在游戏时就必须搭建一个中继服务器，从本地直连到丢包率低的中继服务器，再连接到目标服务器，这样我们就能够形成一条丢包率较低的线路。

`HAProxy`是一款HTTP/TCP负载均衡器，使用 HAProxy 可以达到中继服务器的效果(算是杀鸡用牛刀的一个案例Orz)。

这篇文章介绍 Haproxy 的基本功能特性和它的简单应用。

# 介绍

HAProxy提供了L4(TCP)和L7(HTTP)两种负载均衡能力，具备丰富的功能。HAProxy的社区非常活跃，具备媲美商用负载均衡器的性能和稳定性，它当前不仅仅是免费负载均衡软件的首选，更几乎成为了唯一选择。

## HAProxy的核心功能

*   负载均衡：L4和L7两种模式，支持RR/静态RR/LC/IP Hash/URI Hash/URL_PARAM Hash/HTTP_HEADER Hash等丰富的负载均衡算法
*   健康检查：支持TCP和HTTP两种健康检查模式
*   会话保持：对于未实现会话共享的应用集群，可通过Insert Cookie/Rewrite Cookie/Prefix Cookie，以及上述的多种Hash方式实现会话保持
*   SSL：HAProxy可以解析HTTPS协议，并能够将请求解密为HTTP后向后端传输
*   HTTP请求重写与重定向
*   监控与统计：HAProxy提供了基于Web的统计信息页面，展现健康状态和流量数据。基于此功能，使用者可以开发监控程序来监控HAProxy的状态

## HAProxy的关键特性

*   采用单线程、事件驱动、非阻塞模型，减少上下文切换的消耗，能在1ms内处理数百个请求。并且每个会话只占用数KB的内存。
*   大量精细的性能优化，如O(1)复杂度的事件检查器、延迟更新技术、Single-buffereing、Zero-copy forwarding等等，这些技术使得HAProxy在中等负载下只占用极低的CPU资源。
*   HAProxy大量利用操作系统本身的功能特性，使得其在处理请求时能发挥极高的性能，通常情况下，HAProxy自身只占用15%的处理时间，剩余的85%都是在系统内核层完成的。
*   HAProxy作者在8年前（2009）年使用1.4版本进行了一次测试，单个HAProxy进程的处理能力突破了10万请求/秒，并轻松占满了10Gbps的网络带宽。

HAProxy的大部分工作都是在操作系统内核完成的，所以HAProxy的稳定性主要依赖于操作系统，作者建议使用2.6或3.x的Linux内核，对sysctls参数进行精细的优化，并且确保主机有足够的内存。这样HAProxy就能够持续满负载稳定运行数年之久。

# 安装

Debian 系的安装非常简单：

```
sudo apt-get -y install haproxy

```

编辑文件`/etc/haproxy/haproxy.cfg`，全文替换：

```
global
    ulimit-n  51200

defaults
    log    global
    mode    tcp
    option    dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000

frontend ss-in
    bind *:relay_server_port  # 中继端口，或端口范围，30000-40000
    default_backend ss-out

backend ss-out
    server server1 proxy_server_ip:proxy_server_port maxconn 20480 # 目标服务器，可以带上对方的端口号。不带的话则是与中继端口一一对应
```

# 使用命令

	启动：service haproxy start
	停止：service haproxy stop
	重启：service haproxy restart
	重载：service haproxy reload
	状态：service haproxy status

# 参考资料

* [HAProxy从零开始到掌握](http://www.jianshu.com/p/c9f6d55288c0)
* [利用Haproxy进行SS代理中继](https://ayase.moe/2017/02/01/haproxy-in-proxy-relay/)
* [负载均衡：haproxy，slb以及node-slb](https://cnodejs.org/topic/55921e6950946a072452564d)
* [HAProxy用法详解 全网最详细中文文档](http://www.ttlsa.com/linux/haproxy-study-tutorial/)
* [从无到有，境无止尽！](https://doub.io/ss-jc26/)

以下内容是haproxy 更详细的描述，转载自 [keontang - notes](https://github.com/keontang/notes)










### HAProxy 反向代理的使用  
---
HAProxy 是一款高性能的反向代理软件，它可以基于四层或七层进行反向代理，尤其适合于高负载且需要进行七层处理的 Web 站点。  
相较与 Nginx，HAProxy 更专注与反向代理，因此它可以支持更多的选项，更精细的控制，更多的健康状态检测机制和负载均衡算法。  
#### 性能  
HAproxy 主要借助于现代操作系统上几种常见的技术来实现性能的最大化。  

- 单进程、事件驱动模型，降低了上下文切换和内存的开销  
- O(1) 时间检查器，允许其在高并发连接中对任何连接的时间实现即使探测。  
- 单缓冲（single buffering）机制能以不复制任何数据的方式完成读写操作，借助 splice() 系统调用，可以实现零复制转发。  
- 树型存储，使用作者多年前开发的弹性二叉树，实现 O(log(N)) 的低开销  

在生产环境中，通常将 HAProxy 作为七层负载均衡器，实现 Web 集群的负载均衡，动静分离等功能。  

#### 配置 HAProxy  
HAProxy 的配置文件位于 `/etc/haproxy/haproxy.cfg`。HAProxy 配置处理主要来源有三类：  

1\. 命令行参数  
2\. `global` 配置端，用于设定全局配置参数  
3\. `proxy` 相关配置端，如 `default`，`listen`，`frontend` 和 `backend`  

HAProxy 中，涉及时间单位的配置参数的默认后缀一般是毫秒，也可以使用 s（秒），m（分钟），h（小时），d（天）等单位  

##### 全局配置  
全局配置为 `global` 配置中的参数，有进程管理及安全相关的参数  

`chroot <DIR>`  
修改 HAProxy 的工作目录至指定的目录并在放弃权限之前执行 chroot() 操作，可以提升 haproxy 的安全级别  

`daemon`  
以守护进程方式运行  

`log <address> <facility> [max level [min level]]`  
定义日志位置  

`nbproc <NUMBER>`  
指定启动的 HAProxy 进程个数，默认启动一个进程，建议启动一个进程即可  

`uid <UID>`  
指定以 UID 身份的用户运行 HAProxy  

`maxconn <NUMBER>`  
设定每个 HAProxy 进程所接受的最大并发连接数  

`spread-checks <0..50, inpercent>`  
在haproxy后端有着众多服务器的场景中，在精确的时间间隔后统一对众服务器进行健康状况检查可能会带来意外问题；此选项用于将其检查的时间间隔长度上增加或减小一定的随机时长  

`ulimit-n`  
设定每进程能够打开的最大文件描述符数，默认情况下棋会自动进行计算，不推荐手动设置  

##### 代理配置  
代理配置可在一下配置段中定义：  

- `default`：用于为所有其它配置段提供默认参数  
- `frontend`：用于定义一系列监听的套接字，这些套接字可接受客户端请求并与之建立连接  
- `backend`：用于定义一系列后端服务器，代理将会将对应客户端的请求转发至这些服务器  
- `listen`： 通过关联前端和后端定义了一个完整的代理  

###### 前后端连接模型  
在 HTTP 模式下，HAProxy 与前后端的连接方式取决于 frontend 和 backend 的连接选项。HAProxy 支持 5 中连接模型：  

- KAL: keep alive（option http-keep-alive），这是默认的模式，所有的请求和响应都会被 HAProxy 处理，且允许在没有请求和响应时保持空闲的连接  
- TUN：tunnel（option http-tunnel）：这是 1.0 ~ 1.5-dev21 的默认模式，类似于隧道，HAProxy 仅处理第一个请求和响应，剩余的报文将直接转发而不进行处理。尽量不要使用这个模式，因为它在日志记录和 HTTP 处理上有很多问题。  
- PCL：passive close（option httpclose），这和 tunnel 模式类似，区别是 HAProxy 会在发往客户端的响应报文和发往服务器的请求报文中加入 "Connection: close" 首部，使得客户端和后端主机在完成与 HAProxy 的一次通信后主动的关闭连接。  
- SCL：server close（option http-server-close），HAProxy 在接收到后端服务器的响应后就立即断开与后端服务器的连接，而与客户端的连接则使用保持连接。  
- FCL：forced close（option forceclose），HAProxy 每完成一次与客户端/服务器的通信（请求+响应）后就主动关闭连接。  
- `max-keep-alive-queue <value>`  
用于设定后端主机保持连接数的阈值，当某后端主机的保持连接队列超过此值后，HAProxy 会将向此主机请求的保持连接调度至其他主机。默认值 -1 表示不限制， 0 表示禁用保持连接。

###### 负载均衡  
- `balance <algorithm> [ <arguments> ]`  
定义负载均衡算法，可用于“defaults”、“listen” 和 “backend”。用于在负载均衡场景中挑选一个server，其仅应用于持久信息不可用的条件下或需要将一个连接重新派发至另一个服务器时。支持的算法有：  
    - roundrobin：基于权重进行轮叫，在服务器的处理时间保持均匀分布时，这是最平衡、最公平的算法。此算法是动态的，这表示其权重可以在运行时进行调整，不过，在设计上，每个后端服务器仅能最多接受4128个连接  
    - static-rr：基于权重进行轮叫，与roundrobin类似，但是为静态方法，在运行时调整其服务器权重不会生效；不过，其在后端服务器连接数上没有限制  
    - leastconn：新的连接请求被派发至具有最少连接数目的后端服务器；在有着较长时间会话的场景中推荐使用此算法，如LDAP、SQL等，其并不太适用于较短会话的应用层协议，如HTTP；此算法是动态的，可以在运行时调整其权重  
    - source：将请求的源地址进行hash运算，并由后端服务器的权重总数相除后派发至某匹配的服务器；这可以使得同一个客户端IP的请求始终被派发至某特定的服务器；不过，当服务器权重总数发生变化时，如某服务器宕机或添加了新的服务器，许多客户端的请求可能会被派发至与此前请求不同的服务器；常用于负载均衡无cookie功能的基于TCP的协议；其默认为静态，不过也可以使用hash-type修改此特性  
    - uri：对URI的左半部分("?"标记之前的部分)或整个URI进行hash运算，并由服务器的总权重相除后派发至某匹配的服务器；这可以使得对同一个URI的请求总是被派发至某特定的服务器，除非服务器的权重总数发生了变化；此算法常用于代理缓存或反病毒代理以提高缓存的命中率；需要注意的是，此算法仅应用于HTTP后端服务器场景；其默认为静态算法，不过也可以使用hash-type修改此特性  
    - url_param：通过为URL指定的参数在每个HTTP GET请求中将会被检索；如果找到了指定的参数且其通过等于号“=”被赋予了一个值，那么此值将被执行hash运算并被服务器的总权重相除后派发至某匹配的服务器；此算法可以通过追踪请求中的用户标识进而确保同一个用户ID的请求将被送往同一个特定的服务器，除非服务器的总权重发生了变化；如果某请求中没有出现指定的参数或其没有有效值，则使用轮叫算法对相应请求进行调度；此算法默认为静态的，不过其也可以使用hash-type修改此特性  
    - hdr()：对于每个HTTP请求，通过指定的HTTP首部将会被检索；如果相应的首部没有出现或其没有有效值，则使用轮叫算法对相应请求进行调度；其有一个可选选项“use_domain_only”，可在指定检索类似Host类的首部时仅计算域名部分(比如通过www.magedu.com来说，仅计算magedu字符串的hash值)以降低hash算法的运算量；此算法默认为静态的，不过其也可以使用hash-type修改此特性  

- `hash-type <method>`  
用于定义将hash码映射至后端服务器的方法：  
    - map-based：hash表是一个包含了所有在线服务器的静态数组。其hash值将会非常平滑，会将权重考虑在列，但其为静态方法，当一台服务器宕机或添加了一台新的服务器时，大多数连接将会被重新派发至一个与此前不同的服务器上，对于缓存服务器的工作场景来说，此方法不甚适用。  
    - consistent：hash表是一个由各服务器填充而成的树状结构；基于hash键在hash树中查找相应的服务器时，最近的服务器将被选中。此方法是动态的，添加一个新的服务器时，仅会对一小部分请求产生影响，因此，尤其适用于后端服务器为cache的场景。  

###### 健康状态检查  
- `option httpchk [method] [uri] [version]`  
默认情况下，HAProxy 的后端主机健康状态检查是基于 TCP 连接来检查的。当使用 option httpchk 后，将使用一个 HTTP 请求来检查后端主机健康状态，2xx 和 3xx 的响应码表示健康状态，其他响应码或无响应表示服务器故障。  
检查端口和间隔在 server 配置中指定。  
```
backend https_relay
    mod tcp
    option httpchk OPTIONS * HTTP/1.1
    server apache1 192.168.1.1:443 check port 80
```

- `http-check disable-on-404`  
使用此选项后，返回 HTTP 404 状态码的后端主机将会从负载均衡列表中移除，但是仍能够继续处理已建立的连接。这可以用于手动的平滑下限。如果服务器重新开始返回 2xx 或 3xx 的状态码，将会重新被加入至负载均衡主机列表。  

- `http-check expect [!] <match> <pattern>`  
此选项用于对 HTTP 检查返回的页面进行内容匹配或返回状态码匹配  

match 指定匹配方式，status 表示精确匹配状态码，rstatus 表示使用正则表达式匹配状态码，string 表示精确匹配响应实体字符串，rstring 表示使用正则表达式匹配响应实体。同时还可以使用 "!" 表示取反，如 ! status，返回内容的大小受 tune.chksize 参数限制，默认为 16384 字节。  

```
http-check expect ! string SQL Error
如果遇到 SQL Error 的页面测健康状态为故障
```

###### 端口指定  
- `bind [<address>]:<port_range> [, ...]`  
此指令仅能用于frontend和listen区段，用于定义一个或几个监听的套接字。  

###### 工作模式  
- `mode {tcp | http | health}`  
设定实例的运行模式或协议。当实现内容交换时，前端和后端必须工作于同一种模式(一般说来都是HTTP模式)，否则将无法启动实例。  

###### 指定后端主机  
- `use_backend <backend> <if | unless> <condition>`  
用于指定匹配某 condition 时使用的后端主机  

- `default_backend <backend>`  
指定默认情况下的后端主机  

例：  
```
use_backend     dynamic  if  url_dyn
use_backend     static   if  url_css url_img extension_img
default_backend dynamic
```

- `server <name> <address>[:port] [param*]`  
为后端声明一个主机，不能用于 default 和 frontend 段  

name：为此服务器指定的内部名称，其将出现在日志及警告信息中；如果设定了"http-send-server-name"，它还将被添加至发往此服务器的请求首部中  

address：此服务器的地址  

[:port]：指定将连接请求所发往的此服务器时的目标端口  

[param]：为此服务器设定的一系参数，下面仅说明几个常用的参数：  

- backup：设定为备用服务器，仅在负载均衡场景中的其它server均不可用于启用此server  
- check：启动对此server执行健康状态检查，其可以借助于额外的其它参数完成更精细的设定  
- cookie ：为指定server设定cookie值，此处指定的值将在请求入站时被检查，第一次为此值挑选的server将在后续的请求中被选中，其目的在于实现持久连接的功能  
- maxconn：指定此服务器接受的最大并发连接数；如果发往此服务器的连接数目高于此处指定的值，其将被放置于请求队列，以等待其它连接被释放  
- maxqueue：设定请求队列的最大长度  
- observe：通过观察服务器的通信状况来判定其健康状态，默认为禁用，其支持的类型有“layer4”和“layer7”，“layer7”仅能用于http代理场景  
- weight：权重，默认为1，最大值为256，0表示不参与负载均衡  

###### 服务器状态输出  
`stats enable`  
开启状态输出页面  

`stats hide-version`  
隐藏 HAProxy 版本报告  

`stats realm`  
启用认证领域  

`stats auth <USER:PASSWORD>`  
认证的用户名和密码  

`stats uri URI`  
输出页面的 URI  

例如：  
```
listen status *:8080
    stats enable
    stats hide-version
    stats uri   /haproxy?stats
    stats realm  HAProxy\ Statistics
    stats auth  statsadmin:password
```

###### 日志  
`option httplog`  
启用记录HTTP请求、会话状态和计时器的功能  

`option logasap`  
启用或禁用提前将 HTTP 请求记入日志，而不等待 HTTP 报文传输完毕  

`option forwardfor`  
在发往服务器的请求中插入 X-Forwarded-For 首部用于记录客户端的 IP  

###### ACL 访问控制  
haproxy的ACL用于实现基于请求报文的首部、响应报文的内容或其它的环境状态信息来做出转发决策，这大大增强了其配置弹性。其配置法则通常分为两步，首先去定义ACL，即定义一个测试条件，而后在条件得到满足时执行某特定的动作，如阻止请求或转发至某特定的后端。定义ACL的语法格式如下。  

`acl <aclname> <criterion> [flags] [operator] <value> ...`  

```
<aclname>：ACL名称，区分字符大小写，且其只能包含大小写字母、数字、-(连接线)、_(下划线)、.(点号)和:(冒号)；haproxy中，acl可以重名，这可以把多个测试条件定义为一个共同的acl
<criterion>：测试标准，即对什么信息发起测试；测试方式可以由[flags]指定的标志进行调整；而有些测试标准也可以需要为其在<value>之前指定一个操作符[operator]
[flags]：目前haproxy的acl支持的标志位有3个：
    -i：不区分<value>中模式字符的大小写
    -f：从指定的文件中加载模式
    --：标志符的强制结束标记，在模式中的字符串像标记符时使用
<value>：acl测试条件支持的值有以下四类：
    - 整数或整数范围：如1024:65535表示从1024至65535；仅支持使用正整数(如果出现类似小数的标识，其为通常为版本测试)，且支持使用的操作符有5个，分别为eq、ge、gt、le和lt
    - 字符串：支持使用“-i”以忽略字符大小写，支持使用“\”进行转义，如果在模式首部出现了-i，可以在其之前使用“--”标志位
    - 正则表达式：其机制类同字符串匹配
    - IP地址及网络地址
```

**常用的测试标准**  
`be_sess_rate <integer>`  
用于测试指定的backend上会话创建的速率(即每秒创建的会话数)  

如：  
```
backend dynamic
    mode http
    acl being_scanned be_sess_rate gt 50
    redirect location /error_pages/denied.html if being_scanned
```

`hdr(HEADER) <string>`  
用于匹配请求报文中的指定首部  

`method <string>`  
用于匹配请求报文中使用的方法  

`path_beg <string>`  
用于测试请求的URL是否以 string 指定的模式开头  

`path_end <string>`  
用于测试请求的URL是否以 string 指定的模式结尾  

`path_reg <string>`  
用于测试请求的URL是否能以正则表达式 string 匹配  

**一个配置示例**  
```
global
    log         127.0.0.1 local2
    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     4000
    user        haproxy
    group       haproxy
    daemon

    # turn on stats unix socket
    stats socket /var/lib/haproxy/stats

defaults
    mode                    http
    log                     global
    option                  httplog
    option                  dontlognull
    option http-server-close
    option forwardfor       except 127.0.0.0/8
    option                  redispatch
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    timeout http-keep-alive 10s
    timeout check           10s
    maxconn                 30000

listen stats
    mode http
    bind 0.0.0.0:1080
    stats enable
    stats hide-version
    stats uri     /haproxyadmin?stats
    stats realm   Haproxy\ Statistics
    stats auth    admin:admin
    stats admin if TRUE

frontend http-in
    bind *:80
    mode http
    log global
    option httpclose
    option logasap
    option dontlognull
    acl url_static       path_beg       -i /static /images /javascript /stylesheets
    acl url_static       path_end       -i .jpg .jpeg .gif .png .css .js

    use_backend static_servers          if url_static
    default_backend dynamic_servers

backend static_servers
    balance roundrobin
    server imgsrv1 172.16.200.7:80 check maxconn 6000
    server imgsrv2 172.16.200.8:80 check maxconn 6000

backend dynamic_servers
    cookie srv insert nocache
    balance roundrobin
    server websrv1 172.16.200.7:80 check maxconn 1000 cookie websrv1
    server websrv2 172.16.200.8:80 check maxconn 1000 cookie websrv2
```









