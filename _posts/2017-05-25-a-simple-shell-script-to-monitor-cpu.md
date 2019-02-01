---
layout: post
title:  一个简单的监控 CPU 的脚本
category: tech
tags: linux shell
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

最近服务器经常出现 CPU 100%，然后超负荷运行的情况。

![](https://cdn.kelu.org/blog/2017/05/20170527200218.jpg)

按照朋友的经验，可能是数据库的问题。查了一下，果然是，虽然目前还不知道是什么原因。

目前就做了一个临时处理，查看 CPU 是否异常，异常的话就重启 postgresql。并生成标记文件 tmp，停止监控。每隔半小时会删除标记文件 tmp，继续监控。

    #!/bin/bash

    cpu=`vmstat| sed -n '3p' | awk '{print $13}'`;

    if [ $cpu -gt 95 ]; then
        if [ ! -e /tmp/restart_postgres.tmp ]; then
          touch /tmp/restart_postgres.tmp

          service postgresql restart;
          echo "cpu: $cpu . service postgresql restart";
        fi
    fi


