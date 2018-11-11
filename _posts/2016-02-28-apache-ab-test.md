---
layout: post
title: 使用 apache ab 做网站压力测试【转】
category: tech
tags: linux apache ab-test
---

1、先查看一下版本信息 ab -V（注意是大写的V）

![](https://cdn.kelu.org/blog/2016/02/blog_2016-02-28-354734927.jpg)


 2、我们也可以使用小写的v查看下ab命令的一些属性 ab -v


![](https://cdn.kelu.org/blog/2016/02/blog_2016-02-28-232544892.jpg)


3、现在我们就对51CTO的网站进行一次压力测试吧，使用命令ab -n1000 -c10 http://www.51cto.com/index.php，其中 -n1000 表示总请求数 -c10表示并发用户数为10 http://www.51cto.com/index.php 表示请求的URL，下面是测试的结果，其中我们最关心的三个指标，我已经注释出来了。



    [t1@a1 test]$ ab -n1000 -c10 http://www.51cto.com/index.php
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/
    
    Benchmarking www.51cto.com (be patient)
    Completed 100 requests
    Completed 200 requests
    Completed 300 requests
    Completed 400 requests
    Completed 500 requests
    Completed 600 requests
    Completed 700 requests
    Completed 800 requests
    Completed 900 requests
    Completed 1000 requests
    Finished 1000 requests
    
    1.     /*WEB服务器用的是Tengine */
    
    Server Software:        Tengine
    Server Hostname:        www.51cto.com
    Server Port:            80
    
    Document Path:          /index.php
    Document Length:        705 bytes
    
    Concurrency Level:      10
    Time taken for tests:   11.770 seconds
    Complete requests:      1000
    Failed requests:        51
       (Connect: 0, Receive: 0, Length: 51, Exceptions: 0)
    Write errors:           0
    Non-2xx responses:      1000
    Total transferred:      1174340 bytes
    HTML transferred:       1028289 bytes
    2.    /*大家最关心的指标之一，指的是吞吐率
    3.    每秒事务数，后面括号中的 mean 表示这是一个平均值*/  
    
    Requests per second:    84.96 [#/sec] (mean)
    4.    /*大家最关心的指标之二，指的是用户平均请求等待时间
    5.    平均事务响应时间 ，后面括号中的 mean 表示这是一个平均值*/ 
    
    Time per request:       117.700 [ms] (mean)
    6.    /*大家最关心的指标之三，指的是服务器平均请求处理时间
    
    Time per request:       11.770 [ms] (mean, across all concurrent requests)
    Transfer rate:          97.44 [Kbytes/sec] received
    
    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:       38   71 174.0     39    1046
    Processing:    39   42  17.5     40     395
    Waiting:       38   41  10.9     40     283
    Total:         77  113 175.0     79    1090
    
    Percentage of the requests served within a certain time (ms)
      50%     79
      66%     82
      75%     83
      80%     83
      90%     86
      95%     89
      98%   1084
      99%   1086
     100%   1090 (longest request)
    
    
    

4、为了使结果更有对比性，我们将并发用户更改为100个进行压力测试，我这里只将三个指标贴出来。
4、为了使结果更有对比性，我们将并发用户更改为100个进行压力测试，我这里只将三个指标贴出来。


    Requests per second:    190.95 [#/sec] (mean)  
    Time per request:       523.694 [ms] (mean)  
    Time per request:       5.237 [ms] (mean, across all concurrent requests) 

5、将并发用户改为200个进行测试


    Requests per second:    186.00 [#/sec] (mean)  
    Time per request:       1149.433 [ms] (mean)  
    Time per request:       5.747 [ms] (mean, across all concurrent requests)  

6、500个并发用户时的情况


    Requests per second:    180.99 [#/sec] (mean)  
    Time per request:       2631.662 [ms] (mean)  
    Time per request:       5.263 [ms] (mean, across all concurrent requests)  

我们来分析下测试的结果，先对比下吞吐率，当并发用户的时候吞吐率最高为190 reqs/s,当并发用户数为200,500 吞吐率下降了，随之用户的等待时间更是明显增加了，已经有2s的等待时间了。这说明性能明显下降了。当然分析这个测试结果并不是说明51CTO的网站的并发用户只能在500左右，因为这个测试还不是在他们的服务器上面去测试，经过了网络带宽会对这个测试的结果有很大的影响。另外我们在生产环境下测试的时候，最好能将测试结果做成报表，这样可以非常清晰地对比出问题来。

---

转载自：

* [apache ab test使用 - 博客园](http://www.cnblogs.com/super-d2/p/3831155.html)