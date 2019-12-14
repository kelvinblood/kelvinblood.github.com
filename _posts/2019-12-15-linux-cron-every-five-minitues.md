---
layout: post
title: cron 每五分钟运行
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

如下，使用系统默认crontab，在头一个`*`后添`/5`即可。

```
*/5 * * * * /var/local/cron/every_five_minute.sh >> /var/local/log/cron/every_five_minute.log 2>&1 
```

