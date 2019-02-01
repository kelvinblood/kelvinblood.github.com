---
layout: post
title: ping 时记录时间戳
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

参考 stackoverflow这篇问答：[How do I timestamp every ping result?](https://stackoverflow.com/questions/10679807/how-do-i-timestamp-every-ping-result)

```
ping www.google.fr | while read pong; do echo "$(date): $pong"; done
```

将输出如下内容：

```
Wed Jun 26 13:09:23 CEST 2013: PING www.google.fr (173.194.40.56) 56(84) bytes of data.
Wed Jun 26 13:09:23 CEST 2013: 64 bytes from zrh04s05-in-f24.1e100.net (173.194.40.56): icmp_req=1 ttl=57 time=7.26 ms
Wed Jun 26 13:09:24 CEST 2013: 64 bytes from zrh04s05-in-f24.1e100.net (173.194.40.56): icmp_req=2 ttl=57 time=8.14 ms
```

