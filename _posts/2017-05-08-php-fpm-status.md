---
layout: post
title:  启动php-fpm状态页
category: tech
tags: php
---

![](https://cdn.kelu.org/blog/tags/php.jpg)

上一篇写了 nginx 状态页，这一篇写一下 php-fpm 状态页。

# 开启

在你的 php-fpm.conf 的项目配置中打开如下配置:

    pm.status_path = /_status 
    
重启 php-fpm。

nginx 中也添加配置，大概如下面这样：

     location = /_status {
         fastcgi_pass                               unix:/var/local/fpm-pools/wechat/php-fpm.sock;
         include                                    fastcgi.conf;
         fastcgi_param           SCRIPT_NAME        /_status;
     }

将请求传给socket，再由php-fpm进行内容生成。生成的内容大致如下：

    pool:                 wechat
    process manager:      dynamic
    start time:           06/May/2017:14:59:51 +0800
    start since:          363832
    accepted conn:        27141
    listen queue:         0
    max listen queue:     0
    listen queue len:     0
    idle processes:       2
    active processes:     1
    total processes:      3
    max active processes: 10
    max children reached: 0
    slow requests:        65
    
内容解释：
    
* pool – fpm池子名称，大多数为www
* process manager – 进程管理方式,值：static, dynamic or ondemand. dynamic
* start time – 启动日期,如果reload了php-fpm，时间会更新
* start since – 运行时长
* accepted conn – 当前池子接受的请求数
* listen queue – 请求等待队列，如果这个值不为0，那么要增加FPM的进程数量
* max listen queue – 请求等待队列最高的数量
* listen queue len – socket等待队列长度
* idle processes – 空闲进程数量
* active processes – 活跃进程数量
* total processes – 总进程数量
* max active processes – 最大的活跃进程数量（FPM启动开始算）
* max children reached - 大道进程最大数量限制的次数，如果这个数量不为0，那说明你的最大进程数量太小了，请改大一点。
* slow requests – 启用了php-fpm slow-log，缓慢请求的数量

另外 php-fpm 状态页还可以带参数，可以带get参数json、xml、html，并且可以分别和full做一个组合。

full详解

* pid – 进程PID，可以单独kill这个进程. You can use this PID to kill a long running process.
* state – 当前进程的状态 (Idle, Running, …)
* start time – 进程启动的日期
* start since – 当前进程运行时长
* requests – 当前进程处理了多少个请求
* request duration – 请求时长（微妙）
* request method – 请求方法 (GET, POST, …)
* request URI – 请求URI
* content length – 请求内容长度 (仅用于 POST)
* user – 用户 (PHP_AUTH_USER) (or ‘-’ 如果没设置)
* script – PHP脚本 (or ‘-’ if not set)
* last request cpu – 最后一个请求CPU使用率。
* last request memorythe - 上一个请求使用的内存

php-fpm状态页可以使用zabbix或者nagios统一进行监控。
