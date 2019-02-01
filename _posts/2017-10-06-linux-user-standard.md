---
layout: post
title: Linux 使用规范 | 收集
category: tech
tags: php laravel
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

这一篇也是收集类型的文章，网上并没有看到一篇完整的规范。所以当我发现有不错的规范，就将它记录下来。


# 用户使用规范

1.  **不要修改系统级配置文件，请添加自定义配置文件到系统级配置目录中。**

    例如：一般在配置文件的同级目录下都会有一个`配置文件名.d`的配置目录，它们是为了防止多用户多服务环境配置冲突问题。

    ​ proc 内核参数配置，不要直接修改配置文件`/etc/sysctl.conf`，应该以业务或服务名命名配置文件（如 `99-app-sysctl.conf`)，然后将其放入/etc/sysctl.d目录。

    ​ 同理配置ulimit也一样 , 请不要修改`/etc/security/limits.conf` 配置文件，而是应该以业务或服务名命名配置文件（如 `99-app-limits.conf`)，然后将其放入`/etc/security/limits.d/`目录。

    ​ 同理配置全局Shell的环境变量，请不要修改/etc/profile或/etc/bashrc文件，而是应该以业务或单独命名配置文件（如eleme.sh),然后将其放置在/etc/profile.d目录。

2.  **最小范围定义环境变量 (Less better than more !)**

    例如：程序启动需要的环境变量，写在程序启动脚本里。

    ​ 用户需要的环境变量，写在用户的`~/.bashrc`里。

    ​ 需要多个程序公用的环境变量，写在独立的文件中，然后使用`source`命令带入程序启动脚本里。

    ​ 如果变量不可变，请用`readonly`修饰它。

    ​ 如果变量需要子进程或子shell继承，请用`export`修饰它。

3.  **cp 命令好过mv命令，mv命令好过rm命令。**

    例如：如果需要把文件放在新的位置，请先确认是否需要删除原有文件，如果不需要删除，请使用cp命令。如果需要删除原有文件，将其使用mv改名为`filename.bak-$(date %F-%T)`。目前的系统磁盘远远大于我们需要的空间量，保存一个文件的原始位置备份，有助于我们快速恢复。

4.  **创建计划任务时（cron），请为你的计划任务设置优先级（nice）。**

    例如：计划任务均为后台执行程序，运行过程中会与其他运行任务争抢资源，如果你不想由于执行计划任务导致此设备上的其他任务运行缓慢，请在命令前加上`nice -n 10`，没有其他任务运行时它运行飞快，有其他任务运行时它会让出资源。

5.  **创建计划任务时（cron），请注意命令路径问题，请使用全路径运行程序。**

    例如：`crontab -e -u USERNAME`时，默认没有环境变量设置，请自定义PATH等变量​

6.  **当你程序打不开、写不了、无法创建文件和目录时，请检查其父目录权限。**

    例如： `/var/log`目录权限`root.root 755`，你要想让你的程序写日志进去，请自行创建`/var/log/程序名`目录，保证运行程序的用户有写入的权限。

7.  **命令敲完回车前请确认输入是否正确，命令执行完请确认命令回显。**

    例如：如果你的网络设置命令执行错误，直接会导致网络断开，你会被堡垒机踢出或冻结输入框。这时应该第一时间联系基础运维，他们还有IPMI控制卡连接方式帮你救回来。

8.  **文件名和目录区分大小写，请保持所有名称都是小写字母**

9.  **清空日志文件的正确方法是`>./logfile.log`，而不是`rm -rf ./logfile.log`**


# 管理员配置规范

## 一 服务器安装规范

1.1 时区及locale设置

```
在安装的时候通常都会提示选择时区及locale。

可参考：
时区     —— Asia/PRC
locale  —— en.US_UTF-8

```

1.2 网卡命名

```
eth0 配置内网IP
eth1 配置外网IP

目前线上基本是保持了这样规则, 可以继续保持并严格遵守.

这里存在两种情况
一是只有内网IP，没有公网IP, 二是只有公网IP，没有内网IP。

对于第一种情况，网卡命名能保证上面的规则，而对于第二种情况，因为只有一个接口，在安装的时候，会把公网绑定在eth0接口，也就是规则对应的内网接口(eth0)
需要注意的是，对于这种情况需要手工去修改系统udev rules，让其绑定在正确的接口上(eth1)。

```

1.3 主机命名

```
主机类型-应用名-项目-机房名称

主机类型: l,w,n(linux,windows,network) 
应用名:   php,mysql,mongodb等
项目：    wap,mall,shop等
机房名称： xx01,xx02

```

1.4 分区规则

```
众所周知，越是靠磁盘外部的柱面，读写越快。因为磁盘每次旋转时读写头可以覆盖较多的区域，所以从性能考虑，应该把读写比较频繁的分区分到磁盘靠后的位置。

格式化时文件系统采用ext4，fstab配置文件可参考
UUID=ad82fb31-4b6d-4e9a-9835-52a8f93abcec /     ext4 errors=remount-ro 0       1
UUID=5d794c5e-2ddb-4aaa-88dc-8ae8cfaf9d76 /data ext4 noatime,nodiratime,errors=remount-ro 1
一个通常的磁盘分区结构：
swap       32G
/          50G
/data      剩余空间
/tmp       1-4G(tmpfs，非磁盘分区)

说明：首先swap分区并不是教科书所写的内存X2，也不是完全不分。对大型应用的服务器可能还会加到64G或者更大，对大多数服务器建议保持在32G-64G既可。
这样划分的目的在于，比如8G内存的服务器，如果swap分区为16G。当消耗完物理内存，开始使用swap进行交换的时候，如果swap空间也被消耗完的话，最后会引发内核的oom-killer机制，这是相当危险的。至于swap使用频率，可以通过内核参数去调整，比如可以让内核在物理内存占用还剩10%的时候去使用swap，或者60%的时候去使用，但并非完全关闭。

/分区预留50G，目前线上服务器，还划分了/var, /usr等分区，比如以下是一台线上服务器的物理分区实例:
/dev/sda1             989M  170M  769M  19% /
/dev/sda9             430G   56G  374G  14% /home
/dev/sda7             8.0G  601M  7.5G   8% /usr
/dev/sda6              10G  6.3G  3.8G  63% /var
none                  1.0G  388M  637M  38% /tmp

可以看到分区情况大致是: / 1G /usr 8G /var 10G, 整个系统会占掉20G左右的分区，多分区对磁盘性能有一定提升。但相对扩容就不太不便。所以在考虑到保持服务器原有分区结构的情况下，可考虑采用扩大各分区容量的方案。

线上服务器参考分区结构(注意分区顺序):
/swap    32G+
/        50G
/home    剩余空间
/tmp     4G(内存分区)

data分区，因为开发遗留的问题，目前线上服务器实质是使用/home作为data分区，这里需要注意的是data分区的界定必须统一，且长期保持。比如可以以/data为挂载点作为data分区，可以/home作为data分区，或者/var作为data分区, 这些都是习惯问题，但是必须统一，目前线上存在不一致的情况，虽然大多数都是以/home作为data分区，但有个别却是使用/var作为data分区，这点以后需注意。

分区的4k对齐
4k对齐的原理可以通过IBM官方网站去了解，我这只写下对应的的分区步骤。在分区的时候应该考虑到这个问题，4k对齐的磁盘性能比非对齐的大致提升在5%-10%左右。
fdisk -H 224 -S 56 /dev/sdx   #创建分区
fdisk -lu /dev/sdx            #验证对齐

```

1.5 添加root用户的公钥

```
/root/.ssh/authorized_keys

开启ssh服务，关闭密码验证，并添加root用户的公钥。

以上主要是涉及系统安装过程中，需要设置地方的一个通用参考及标准。一个良好的系统初始环境对自动化化运维起着不可忽视的作用，比如：
按照以上规范设置网卡接口，可以直接通过批量管理工具获取所有线上服务器内网及外网IP。
磁盘分区可以让大数据存放在固定的位置，便于日志的集中收集，分析，避免频繁的磁盘报警。
而主机命名对自动化配置及自动化监控的分组管理都有非常重要的作用。

```

## 二 文件管理规范

2.1 文件层次

```
文件层次优先参照FHS标准及Debian标准, 其次参照BSD标准.

注: FHS:   Linux文件系统层次标准 
    BSD:   软件包通常位于: /usr/local/$package
    SYS V: 软件包通常位于: /opt/$package

FHS标准:
/bin     基本命令执行文件
/boot    boot loader 的静态链接文件
/dev     设备文件
/etc     主机特定的系统配置
/home    用户目录
/lib     基本共享库以及内核模块
/media   用于移动介质的挂载点
/mnt     用于临时挂载文件系统
/proc    系统信息的虚拟目录(2.4 和 2.6 内核)
/root    root 用户的目录
/sbin    基本系统命令执行文件
/sys     系统信息的虚拟目录(2.6 内核)
/tmp     临时文件
/usr     第二级目录
/var     不断变化的数据
/srv     系统提供的用于 service 的数据
/opt     附加的应用程序软件包

Debian标准:
/etc/default/$package   ---- 服务启动开关
/etc/network/interface  ---- 网络配置
.......

BSD标准
/usr/local/script/      ---- 系统管理日常脚本
/usr/local/cron/        ---- cron执行脚本
/usr/local/firewall/    ---- 防火墙规则

建立单独的数据目录(data分区)
data分区(/data或/home, 这里根据线上情况以/home为准)
data分区主要作为数据分区，比如web程序目录，mysql目录，一些较大的日志文件存放等。
/home/mysql/data        ---- mysql data目录
/home/mysql/log         ---- mysql 日志目录
/home/redis/data        ---- redis data目录
/home/redis/log         ---- redis 日志目录
.......
/home/www               ---- web目录
/home/backup            ---- 备份目录

说明：
FHS标准与DEBIAN标准
文件层次上, DEBIAN本身也是遵守FHS标准, 但由于众多发行版的差异性, 会有一些细节的不同. 比如centos/redhat 网络配置位于
/etc/sysconfig/network-scripts/ifcfg-ethX, 所以我们更应该遵循这种发行版自己的守则, 而不是简单的在rc.local里面通过命令或者脚本去配置网络, 这方面LVS的配置, 大多数人都习惯将内核参数修改和网络配置保存到脚本, 独立执行. 不是很严谨, 所以有Debian标准一说, 在软件管理及系统配置上更应该遵守这样的标准.

BSD标准
通常在编译一个软件的时候, 比如nginx, 指定--prefix=/usr/local/nginx这样的参数, 最后文件层次会如下
/usr/local/nginx/etc
/usr/local/nginx/bin
/usr/local/nginx/sbin
/usr/local/nginx/var
/usr/local/nginx/lib

这是标准的BSD文件层次结构, 在软件管理和系统配置上是不建议采用这样的方式, 更合理的是通过Debian的包管理机制打包发布. 而为便于系统管理所编写的通用脚本等不通过Debian包管理机制所管理的东西, 则
建议存放在/usr/local/script或/usr/local下对应的目录。

```

2.2 通用环境

```
/etc/vim/vimrc          vim通用配置
/etc/bash.bashrc        bash通用配置
/etc/bash.function      bash自定义函数
/etc/bash.alias         bash命令别名

```

2.3 文件修改

```
系统及服务配置文件通常都是通过自动配置工具分发, 便于回滚

在手动修改配置文件应遵循以下原则
默认配置文件    ---- xxxx.orig
  在没有任何改动的情况下以orig扩展名做一次备份并保留注释，以供参考
修改配置文件    ---- xxxx.$date
  对当前配置文件做出修改时, 建议首先以xxxx.$date的命名方式对其做一次备份.
当前配置文件
  建议移除相关注释及空行, 在有缩进的情况下以四个空格作为缩进，以保证阅读的清爽性.

```

## 三 包管理规范

3.1 包管理

```
采用自动部署工具(bcfg2, salt, puppet等)管理软件包，尽量避免手动直接安装。

只保留安全补丁升级，避免系统库, 内核及相应服务升级。

建立官方仓库的本地镜像及私有仓库。

线上，线下环境版本必须统一, 扩展版本也必须完全保持一致.

```

3.2 包安装

```
尽量采用官方源，及稳定的三方源安装相应软件包。

如必须源码编译，务必遵照Debian官方打包方式进行打包，以保持FHS规范以便于自动化管理。

自打包程序通过严格测试及审核后才可放入私有仓库。

说明:
GCC保持默认的o2就好，不要修改CFLAG，以稳定为优先原则。
使用Debian的官方打包机制打包，勿用checkinstall直接打包。

```

3.3 基础包参考列表(debian)

dnsutils iputils-ping locales man-db mtr-tiny p7zip-full python-dev python-libxml2 chkconfig vim sudo tcpdump ipmitool curl sysstat

## 四 帐号管理规范

4.1 帐号安全及管理

```
root                  特权帐号, 能执行任何操作, 无任何限制。
xxxx                 堡垒机默认帐号, 应该加上权限限制, 否则sudo -i后和root没任何区别。 
                      但可以适当放宽, 因为这是针对sa的帐号。
xxxx                   ops默认帐号，对系统有只读权限，并对/etc/init.d/下面的daemon有重启权限。
xxxx                   dba默认帐号，需做限制，只保留数据库相关的权限。
xxxx                   开发默认帐号，只提供chroot最小系统访问权限。
xxxx                   日志查询帐号，只提供chroot最小系统sftp权限。

首先应明确各个职位的职责，sa是系统管理员，需要对所维护的整个系统负责，dba是数据库管理员，需要对所管理的db负责，同样dev只需对开发程序负责，所以生产线不应该给开发开放系统权限，但可开放查询日志权限。dba由于只负责数据库的维护，所以只需开放相关的权限。

帐号安全方面，所有帐号必须禁用密码登录。远程ssh必须做访问限制，不能直接对公网开放。同时使用root帐号必须通过专门的中间机登录，目前这些我们还有待改进。

对所有帐号的历史操作记录，必须以文件的形式做备份。这样的目地是在发生故障的时候，能定位到当时的操作，首先排除掉我们自己的原因。然后再排查db，程序，缩短问题定位时间。

说明：
权限限制：1、可通过sudo   2、 ssh + chroot

```

## 五 日志管理规范
5.1 系统日志

```
/var/log/syslog
/var/log/message
/var/log/kern.log
/var/log/cron.log
/var/log/user.log
/var/log/auth.log
/var/log/daemon.log

系统日志一般syslog-ng或rsyslogd都会做好默认的分类，但默认配置所有类型的日志信息都会写到/var/log/syslog，在排错的时候，可能会大量的cron日志，snmpd日志充斥，看着很冗余，建议将cron的单独切分到cron.log，snmpd切分到snmpd.log，以此类推，不在syslog保留相关信息。

```

5.2 应用日志

```
nginx日志目录： /home/logs/nginx
    $server_name.access.log
    $server_name.error.log

mysql日志目录： /home/logs/mysql
    mysql-err.log
    mysql-slow.log

mongo日志目录： /home/logs/mongodb
这基本是线上的日志结构，不需要更改，其他服务可以此类推

```

5.3 日志切分

```
系统日志以7天作为切分，始终只保留7天的日志记录
服务日志默认以15天作为切分，但需根据具体的需求做适当的调整，比如nginx的access.log在打开后会非常占磁盘空间，可调整为1-2天。
```

# 参考资料

* [linux系统的命令使用规范](http://www.linuxde.net/2011/08/540.html)
* [Linux 系统使用规范](http://blog.kissingwolf.com/2017/04/11/Linux-系统使用规范)
* [服务器部署及管理规范](http://www.jslink.org/linux/rules.html)
