---
layout: post
title: Shell 拉起进程后获得 pid，$0,$?,$!等用法
category: tech
tags: linux shell
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

起因是在前一篇《Linux 网络监控与统计实例》(/tech/2017/04/13/linux-network-monitor-and-stats-example.html)中杀死 tcpdump 的代码在流量监控项目中是有bug的，源码如下：

    #tcpdump监听网络
    tcpdump -v -i $eth -tnn > /tmp/tcpdump_temp 2>&1 &
    sleep 10
    clear
    kill `ps aux | grep tcpdump | grep -v grep | awk '{print $2}'`

这个代码中最后一句 kill 的结果实质上是杀死正在运行中的 tcpdump。然而如果系统中原先已存在tcpdump，就会造成不可预期的结果。

比较适当的做法是记录运行 tcpdump 时的 pid，最后再 kill 掉。相关的代码其实非常简单：

    $! # Shell最后运行的后台Process的PID

所以代码调整后的结果就是

    # tcpdump监听网络
    tcpdump -v -i $eth -tnn > $tmpfile1 2>&1 &
    local pid=$!
    sleep 60
    kill $pid

除了 `$!`, Shell 还有下面这些特殊的用法：

|  变量 | 说明 |
|---|---|
| $$ | Shell本身的PID（ProcessID） |
| $! | Shell最后运行的后台Process的PID |
| $? | 最后运行的命令的结束代码（返回值） |
| $- | 使用Set命令设定的Flag一览 |
| $* | 所有参数列表。如"$*"用「"」括起来的情况、以"$1 $2 … $n"的形式输出所有参数。 |
| $@ | 所有参数列表。如"$@"用「"」括起来的情况、以"$1" "$2" … "$n" 的形式输出所有参数。 |
| $# | 添加到Shell的参数个数 |
| $0 | Shell本身的文件名 |
| $1～$n | 添加到Shell的各参数值。$1是第1参数、$2是第2参数…。 |
| !! | 上一个运行的命令 |
| n! | history中第n个运行的命令 |
    
    
# 参考资料
    
* [如何在启动一个进程时获取其PID？ - Ubuntu 论坛](http://forum.ubuntu.com.cn/viewtopic.php?f=21&t=260541)    
