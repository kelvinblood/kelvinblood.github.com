---
layout: post
title: supervisor 安装与配置
category: tech
tags: linux python
---

![](https://cdn.kelu.org/blog/tags/python.jpg)

Supervisor是一个进程控制系统，由python编写。可以很方便的用来启动、重启、关闭进程（不仅仅是 Python 进程）。 它有以下一些特点

* 可以配置同时启动的进程数，而不需要一个个启动
* 可以根据程序的退出码来判断是否需要自动重启
* 可以配置进程初始化的环境，包括目录，用户，umask，关闭进程所需要的信号等等
* 有web界面进行管理

下面简单介绍一下 supervisor 的安装使用过程。更复杂的 group 等设置可以参考我文末的参考资料。

# 安装

使用python包管理工具pip进行安装：

    pip install supervisor

# 配置

安装完 supervisor 之后，运行echo_supervisord_conf 命令输出默认的配置项，重定向到一个配置文件里：

    echo_supervisord_conf > /etc/supervisord.conf

下面是我经过简化过的配置：

    [unix_http_server]
    file=/tmp/supervisor.sock   ; (the path to the socket file)
    
    [supervisord]
    logfile=/var/local/log/supervisor/supervisord.log ; (main log file;default $CWD/supervisord.log)
    logfile_maxbytes=50MB        ; (max main logfile bytes b4 rotation;default 50MB)
    logfile_backups=10           ; (num of main logfile rotation backups;default 10)
    loglevel=info                ; (log level;default info; others: debug,warn,trace)
    pidfile=/tmp/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
    nodaemon=false               ; (start in foreground if true;default false)
    minfds=1024                  ; (min. avail startup file descriptors;default 1024)
    minprocs=200                 ; (min. avail process descriptors;default 200)
    
    [rpcinterface:supervisor]
    supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface
    
    [supervisorctl]
    serverurl=unix:///tmp/supervisor.sock ; use a unix:// URL  for a unix socket
    
    [include]
    files = /etc/supervisor/*.conf

然后新建文件夹来存放各种进程的配置文件：

    mkdir /etc/supervisor

目前我是用来管理 laravel 的进程，在 `/etc/supervisor/` 里添加文件 `laravel-wechat.conf`

    [program:wechat]
    directory = /var/local/fpm-pools/wechat/www ; 程序的启动目录
    command = php /var/local/fpm-pools/wechat/www/artisan queue:work --sleep=3 --daemon --tries=3
    process_name=%(program_name)s_%(process_num)02d
    autostart = true     ; 在 supervisord 启动的时候也自动启动
    ;startsecs = 5        ; 启动 5 秒后没有异常退出，就当作已经正常启动了
    autorestart = true   ; 程序异常退出后自动重启
    startretries = 3     ; 启动失败自动重试次数，默认是 3
    user = www-data          ; 用哪个用户启动
    redirect_stderr = true  ; 把 stderr 重定向到 stdout，默认 false
    numprocs = 8
    stdout_logfile_maxbytes = 20MB  ; stdout 日志文件大小，默认 50MB
    stdout_logfile_backups = 20     ; stdout 日志文件备份数
    ; stdout 日志文件，需要注意当指定目录不存在时无法正常启动，所以需要手动创建目录（supervisord 会自动创建日志文件）
    stdout_logfile = /var/local/log/wechat/wechat.queue.log
    
    ; 可以通过 environment 来添加需要的环境变量，一种常见的用法是修改 PYTHONPATH
    ; environment=PYTHONPATH=$PYTHONPATH:/path/to/somewhere

启动后命令行界面输入 `supervisorctl` 进入控制界面，如下则说明 supervisor 启动成功、laravel 进程配置成功
     
![](https://cdn.kelu.org/blog/2017/04/2017-04-24-11.40.26.jpg)

# 启动 supervisord

    # 使用默认的配置文件 /etc/supervisord.conf
    supervisord
    # 明确指定配置文件
    supervisord -c /etc/supervisord.conf
    # 使用 user 用户启动 supervisord
    supervisord -u user

# supervisorctl 命令介绍

    # 停止某一个进程，program_name 为 [program:x] 里的 x
    supervisorctl stop program_name
    # 启动某个进程
    supervisorctl start program_name
    # 重启某个进程
    supervisorctl restart program_name
    # 结束所有属于名为 groupworker 这个分组的进程 (start，restart 同理)
    supervisorctl stop groupworker:
    # 结束 groupworker:name1 这个进程 (start，restart 同理)
    supervisorctl stop groupworker:name1
    # 停止全部进程，注：start、restart、stop 都不会载入最新的配置文件
    supervisorctl stop all
    # 载入最新的配置文件，停止原有进程并按新的配置启动、管理所有进程
    supervisorctl reload
    # 根据最新的配置文件，启动新配置或有改动的进程，配置没有改动的进程不会受影响而重启
    supervisorctl update

注意：显示用 stop 停止掉的进程，用 reload 或者 update 都不会自动重启。

# 开机自动启动 Supervisord

Supervisord 默认情况下并没有被安装成服务，它本身也是一个进程。

    # 下载脚本
    sudo su - root -c "sudo curl https://gist.githubusercontent.com/howthebodyworks/176149/raw/d60b505a585dda836fadecca8f6b03884153196b/supervisord.sh > /etc/init.d/supervisord"
    # 设置该脚本为可以执行
    sudo chmod +x /etc/init.d/supervisord
    # 设置为开机自动运行
    sudo update-rc.d supervisord defaults
    # 试一下，是否工作正常
    service supervisord stop
    service supervisord start 

# 参考资料

* [使用Supervisor来管理你的Laravel队列](http://yansu.org/2014/03/22/managing-your-larrvel-queue-by-supervisor.html)    
* [使用 supervisor 管理进程](http://liyangliang.me/posts/2015/06/using-supervisor/)    
* [Python 进程管理工具 Supervisor 使用教程](http://www.restran.net/2015/10/04/supervisord-tutorial/)    
* [queue:listen not working - laravel - github issue](https://github.com/laravel/framework/issues/579)    
