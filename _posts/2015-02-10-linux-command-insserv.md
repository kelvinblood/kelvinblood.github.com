---
layout: post
title: Linux命令之insserv
category: tech
tags: linux linux-command
---

之前在卸载pureftp时候，使用了`update-rc.d pureftpd remove`，收到了这样一个提醒：`update-rc.d: using dependency based boot sequencing`
网上搜索了一番原来Debian已经使用了insserv来代替update-rc.d。

于是顺便记录一下Linux的开机启动管理。

linux下，services的启动、停止等通常是通过/etc/init.d的目录下的脚本来控制的。要添加一个自动启动的服务，先将启动脚本放在/etc/init.d，然后使用insserv来启用这个服务，例如：

	insserv myserver #添加服务  
	insserv -r myserver #删除服务  
	insserv -d myserver #使用默认的runlevels  



启动脚本里边要定义启动文件的metadata，参考pptpd脚本中的`INIT INFO`

	  1 #!/bin/sh
	  2 ### BEGIN INIT INFO
	  3 # Provides:          pptpd
	  4 # Required-Start:    $remote_fs $syslog
	  5 # Required-Stop:     $remote_fs $syslog
	  6 # Default-Start:     2 3 4 5
	  7 # Default-Stop:      0 1 6
	  8 ### END INIT INFO
	  9 # Copyright Rene Mayrhofer, Gibraltar, 1999
	 10 # This script is distibuted under the GPL
	 11
	 12 PATH=/bin:/usr/bin:/sbin:/usr/sbin
	 13 DAEMON=/usr/sbin/pptpd
	 14 PIDFILE=/var/run/pptpd.pid
	 15 FLAGS="defaults 50"
	 16
	 17 case "$1" in
	 18   start)
	 19     echo -n "Starting PPTP Daemon: "
	 20     start-stop-daemon --start --quiet --pidfile $PIDFILE --exec $DAEMON \
	 21     ▸   -- < /dev/null > /dev/null
	 22     echo "pptpd."
	 23     ;;
	 24   stop)
	 25     echo -n "Stopping PPTP: "
	 26     start-stop-daemon --stop --quiet --pidfile $PIDFILE --exec $DAEMON
	 27     echo "pptpd."
	 28     ;;
	 29   force-reload|restart)

insserv的命令格式如下：

	insserv [<options>] [init_script|init_directory]
	Available options:
	  -h, --help       This help.
	  -r, --remove     Remove the listed scripts from all runlevels.
	  -f, --force      Ignore if a required service is missed.
	  -v, --verbose    Provide information on what is being done.
	  -p <path>, --path <path>  Path to replace /etc/init.d.
	  -o <path>, --override <path> Path to replace /etc/insserv/overrides.
	  -c <config>, --config <config>  Path to config file.
	  -n, --dryrun     Do not change the system, only talk about it.
	  -d, --default    Use default runlevels a defined in the scripts
	  

卸载pureftp的过程：

* service pureftpd stop
* rm -rf /home/wwwroot/ftp/
* rm -rf /usr/local/pureftpd/
* insserv -r pureftpd
* rm -f /etc/init.d/pureftpd
* 再删除ftpuser数据库