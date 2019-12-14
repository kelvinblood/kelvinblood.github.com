---
layout: post
title: GoAccess：轻量级nginx日志分析工具
category: tech
tags: nginx
---
![](https://cdn.kelu.org/blog/tags/nginx.jpg)

# 什么是GoAccess

GoAccess是一个开源的基于终端的快速日志分析器。
Github地址:<https://github.com/allinurl/goaccess>
官网地址: <https://goaccess.io/>
说明文档: <https://goaccess.io/man>

中国中国站：<https://goaccess.cc/>

它既支持命令行界面，也可以输出html界面。

# 为什么选择 GoAccess

其实一开始我是锚定了 ELK/EFK 技术栈的，因为在公司已经在使用这一套了，效果确实也很好。但自己安装后发现，作为个人开发者，钱少+运维成本高，还是先暂时远离 elastic 这一套技术栈了，goaccess 开箱即用、够用就好。

# GoAccess界面

![1576306600313](https://cdn.kelu.org/blog/2019/12/1576306600313.jpg)

![1576306703602](https://cdn.kelu.org/blog/2019/12/1576306703602.jpg)

# 使用

一般来说，我现在使用软件都不会再进行安装了，全部使用容器化方式运行，更好管理。

对goaccess我也是用容器化方式部署。

### 1 创建目录结构

```
goaccess/
├── data
│   └── goaccess.conf
├── docker-compose.yml
└── report
    └── a.html
└── logs
    └── a.log
    └── b.log
```

/goaccess.conf: goaccess 配置文件

/docker-compose.yml: docker-compose 配置

/logs/a.log: 待分析的 nginx 日志文件

/report/index.html: 分析出的报告文件，通过 nginx 访问

 

### 2 docker-compose.yml 文件

```
version: "3.2"
services:
  goaccess:
    image: kelvinblood/goaccess:v201912
    network_mode: bridge
    container_name: goaccess
#    command:
#    - goaccess
#    - --no-global-config
#    - --config-file=/srv/data/goaccess.conf
#    - --num-tests=0
    entrypoint: ["/bin/sh"]
    tty: true
    volumes:
    - ./data:/srv/data
    - ./report:/srv/report
    - ./logs:/srv/logs
    - /etc/localtime:/etc/localtime:ro
    - /etc/timezone:/etc/timezone:ro
```

有几点需要注意的：

1. 通过时区设置，使导出的文件与本地时间相同。
2. 我自己编译了一个 goaccess 版本，主要用于中文输出，在dockerfile中设置了  `ENV LANG zh_CN.UTF-8` 配置。
3. 我设置了默认不运行，通过 docker exec 的方式导出分析文件，所以修改了默认的 entrypoint。



### 3. goaccess配置

在默认的配置文件后增加三行配置：

```
time-format %H:%M:%S
date-format %d/%b/%Y
log-format %h %^[%d:%t %^] "%r" %s %b "%R" "%u"
```

同时修改 nginx 的日志格式，参考这一篇文章——[《Nginx 日志按天分割》](/tech/2019/12/14/nginx-log-split-daily.html) 中log_format的部分。

goaccess默认配置文件可在容器中获得，位于`/etc/goaccess/goaccess.conf`，可以先运行容器后再copy出来：

```
docker-compose up -d
docker exec -it goaccess /bin/sh
cp /etc/goaccess/goaccess.conf /src/data
```

![1576308588084](https://cdn.kelu.org/blog/2019/12/1576308588084.jpg)

最后在配置文件末添加刚才提到的三行配置。



### 4. 根据日志文件导出分析结果

在这里血衫对日志做了按天分割，你有需求也可以依葫芦画瓢，或者把我日期部分忽略掉即可：

```
time=`date "+%Y-%m-%d"`

docker exec goaccess goaccess --no-global-config --config-file=/srv/data/goaccess.conf --output=/srv/report/a_$time.html --log-file=/srv/logs/a_$time.log

# 如果没有日期分割，使用以下命令
docker exec goaccess goaccess --no-global-config --config-file=/srv/data/goaccess.conf --output=/srv/report/a.html --log-file=/srv/logs/a.log

# 如果要同时分析多个文件：
docker exec goaccess goaccess --no-global-config --config-file=/srv/data/goaccess.conf --output=/srv/report/a.html -f a.log b.log c.log
```

结合 Linux 的定时任务，你还可以设计一个自动更新的统计。

# 参考资料

* [goaccess 中文站](<https://goaccess.cc/>)
* [Set Up Goaccess with Docker](<https://yuansmin.github.io/2019/set-up-goaccess-with-docker/>)