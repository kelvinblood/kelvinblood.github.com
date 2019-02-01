---
layout: post
title: linux命令列表
category: tech
tags: linux linux-command
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

# 一. 启动,关机,登入,登出相关命令

    [login] 登录

    [logout] 登出

    [exit] 登出

    [shutdown] 停止系统

    [halt] 停止系统

    [reboot] 重启动

    [poweroff] 切断电源

    [sync] 把内存里的内容写入磁盘

    [lilo] 安装lilo启动管理程序

    [grub] 安装lilo启动管理程序

# 二. Shell相关命令

    [chsh] 切换Shell

    [history] 显示命令履历

    [alias] 设置命令别名

    [unalias] 取消命令别名

    [which] 显示命令所在位置

    [type] 查询命令种类

    [echo] 显示字符串或者变量内容

    [set] 设置/显示Shell变量

    [printenv] 显示环境变量

    [export] 设置环境变量

    [env] 设置临时环境变量

    [unset] 释放环境变量

    [setenv] 设置环境变量

    [unsetenv] 释放环境变量

    [source] 执行文件当中的命令

    [man] 查询命令手册

    [info] 查询超文本命令手册

    [whatis] 显示命令简介

    [apropos] 通过关键字查询手册


# 三. 用户管理相关命令

    [su] 切换到其他用户

    [useradd] 追加用户

    [adduser] 追加用户

    [userdel] 删除用户

    [usermod] 修改用户设置

    [chfn] 修改用户私人信息

    [groupadd] 追加组

    [groupdel] 删除组

    [groupmod] 修改组设置

    [passwd] 更改密码

    [whoami] 显示用户名

    [logname] 显示登录用户帐号

    [users] 显示所有登录用户信息

    [who] 查询登录用户信息

    [w] 查询登录用户信息

    [id] 显示指定用户的ID信息

    [groups] 显示指定用户的所属组

    [finger] 显示指定用户的个人信息

    [mesg] 开关与他人收发消息

    [write] 给其他用户发消息

    [wall] 给所有用户发消息

    [talk] 和其他用户聊天

# 四. 系统消息相关命令

    [top] 提供了实时的对系统处理器的状态监视

    [date] 显示/设置当前时间

    [uptime] 显示系统运行时间

    [arch] 显示机器的核心构架（如i386）

    [uname] 显示操作系统信息

    [tty] 显示终端名

    [last] 显示登录/登出在履历

    [lastb] 显示非法登录信息

    [dumpkeys] 显示当前键盘配置

    [loadkeys] 变更键盘配置

    [df] 查询磁盘使用信息

    [du] 查询磁盘使用信息

    [dmesg] 显示系统启动消息

    [script] 保存输入输出到文件

# 五. 文件操作相关命令

    [ls] 显示文件列表

    [tree] 显示目录树

    [pwd] 显示当前路径

    [cd] 更改当前路径

    [pushd] 追加路径到目录堆栈

    [popd] 从目录堆栈删除路径

    [dirs] 显示目录堆栈的内容

    [mkdir] 创建路径

    [rmdir] 删除路径

    [cp] 复制文件/目录

    [rm] 删除文件/目录

    [mv] 移动文件/目录，修改文件名

    [chown] 更改文件/目录的所有者

    [chgrp] 修改文件/目录的所有组

    [chmod] 修改文件/目录的权限

    [touch] 更改文件时间

    [ln] 建立文件/目录链接

    [find] 查找文件

    [whereis] 显示文件存在的路径名

    [file] 查询文件种类

    [size] 查询文件大小

# 六. 文件编辑相关命令

    [cat] 显示文件内容

    [tee] 输出到文件和屏幕

    [more] 分屏显示文件内容

    [less] 分屏显示文件内容

    [head] 显示文件头部内容

    [tail] 显示文件尾部内容

    [fold] 折叠显示长行

    [sort] 排列文件的行

    [cmp] 比较文件内容

    [diff] 显示文件差异

    [nkf] 更改日语文件编码

    [dd] 变更文件之后复制

    [wc] 统计文本单词数，文件大小等

    [split] 分割文件

    [paste] 以行连接文件

    [join] 以字段连接文件

    [grep] 查询文字

    [uniq] 过滤重复部分显示文件内容

    [tr] 替换文字

    [sed] 替换文字

    [vi] vi文字编辑器

# 七. 压缩/解压缩相关命令

    [tar] 压缩/解压缩文件

    [compress] 压缩/解压缩文件

    [uncompress] 解压缩

    [gzip] 压缩/解压缩文件

    [gunzip] 解压缩

    [zcat] 显示压缩文件的内容

    [lha] 压缩/解压缩文件

    [uuencode] 把二进制文件编码为文本文件

    [uudecode] 把经过编码的文本文件还原为二进制文件

# 八. MS-DOS工具集

    [mtools]命令

    [mdir] 显示文件列表

    [mcd] 改变当前目录

    [mmd] 新建目录

    [mrd] 删除目录

    [mdeltree] 删除目录树

    [mcopy] 复制文件

    [mdel] 删除文件

    [mmove] 移动文件

    [mren] 更改文件或目录名

    [mattrib] 修改文件属性

    [mtype] 显示文件内容

    [mdu] 查询文件或目录大小

    [minfo] 显示磁盘信息

    [mformat] 以MS-DOS方式格式化磁盘

    [mlabel] 设置磁盘标签

# 九. 控制外部设备相关命令

    [mount] mount上设备

    [umount] 解除已经mount上的设备

    [eject] 弹出（CD/DVD等）

    [fdformat] 格式化软盘

    [fdisk] 配置/显示硬盘分区

    [mkfs] 格式化磁盘分区

    [fsck] 检查/修复磁盘错误

    [lpr] 打印到打印机

    [lprm] 中断打印任务

    [lpq] 显示打印任务的状态

    [lpc] 管理/控制打印任务

    [ifconfig] 显示/设定NIC配置

# 十. 进程及任务管理相关命令

    [ps] 显示正在运行的进程

    [jobs] 显示后台运行任务

    [fg] 把任务切换到前台

    [bg] 把任务切换到后台

    [kill] 中止进程或任务

    [killall] 中止进程或任务

    [wait] 等待进程或任务的结束

    [at] 设置定时执行任务

    [atq] 显示尚未执行的任务

    [atrm] 删除定时执行任务

    [batch] 在系统负荷减轻的时候执行任务

    [nice] 改变优先度并执行任务

    [nohup] 在后台执行任务，Logout之后也不退出

    [sleep] 休眠一定的时间

    [crond] 用来定期执行程序的命令

    [screen] 可以在多个进程之间多路复用一个物理终端的窗口管理器

# 十一. 网络管理相关命令

    [netstat] 显示当前网络连接状况

    [route] 显示/设置路由

    [host] 显示网络主机情况

    [hostname] 显示/设置当前主机的名字

    [ping] 确认和远程机器的连接情况

    [traceroute] 显示路由信息

    [rwho] 查询网上机器的登陆用户

    [ruptime] 查询网上机器的系统运行时间

    [rlogin] 登陆到远程机器

    [telnet] 用telnet登陆到远程机器

    [rsh] 给远程机器发送命令

    [rcp] 在远程机器之间复制文件

    [mail] 收取邮件

    [sendmail] 发送邮件

    [mailq] 确认邮件队列

    [ftp] 用ftp传输文件

# 十二. 其他命令

    [cal] 显示日历

    [clear] 清屏

    [gcc] 编译C语言代码

    [as] 汇编

    [bc] 计算

    [rpm] Redhat的包管理

    [dpkg] Debian的包管理

    [installpkg] Slackware的包安装（删除命令则是removepkg）

    [xf86setup ,turboxfg,Xconfigurator] 配置X服务

    [startx] 启动 X-Window 图形界面

