---
layout: post
title: Linux系统和性能监控之CPU篇 | 转
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

编者注：本文由sanotes.net站长tonnyom在2009年8月翻译自Linux System and Performance Monitoring系列文章。本文是系列的第一篇，讲述CPU方面的性能监控。

前言: 网上其实有很多关于这方面的文章，那为什么还会有此篇呢，有这么几个原因，是我翻译的动力，第一，概念和内容虽然老套，但都讲得很透彻，而且还很全面.第二，理论结合实际，其中案例分析都不错.第三，不花哨，采用的工具及命令都是最基本的，有助于实际操作。但本人才疏学浅，译文大多数都是立足于自己对原文的理解，大家也可以自己去[OSCAN](http://en.oreilly.com/oscon2009/public/schedule/detail/7519)上找原文，如果有什么较大出入，还望留言回复，甚是感激!

## **1.0 性能监控介绍**

性能优化就是找到系统处理中的瓶颈以及去除这些的过程，多数管理员相信看一些相关的"cook book"就可以实现性能优化，通常通过对内核的一些配置是可以简单的解决问题，但并不适合每个环境，性能优化其实是对OS 各子系统达到一种平衡的定义，这些子系统包括了:

> CPU
> Memory
> IO
> Network

这些子系统之间关系是相互彼此依赖的,任何一个高负载都会导致其他子系统出现问题.比如:

1.  大量的页调入请求导致内存队列的拥塞
2.  网卡的大吞吐量可能导致更多的 CPU开销
3.  大量的CPU开销又会尝试更多的内存使用请求
4.  大量来自内存的磁盘写请求可能导致更多的 CPU 以及 IO问题

所以要对一个系统进行优化,查找瓶颈来自哪个方面是关键,虽然看似是某一个子系统出现问题,其实有可能是别的子系统导致的.

**1.1 确定应用类型**

基于需要理解该从什么地方来入手优化瓶颈,首先重要的一点,就是理解并分析当前系统的特点,多数系统所跑的应用类型,主要为2种:

IO Bound(译注:IO 范畴): 在这个范畴中的应用,一般都是高负荷的内存使用以及存储系统,这实际上表示IO 范畴的应用,就是一个大量数据处理的过程.IO 范畴的应用不对CPU以及网络发起更多请求(除非类似NAS这样的网络存储硬件).IO 范畴的应用通常使用CPU 资源都是为了产生IO 请求以及进入到内核调度的sleep 状态.通常数据库软件(译注:mysql,oracle等)被认为是IO 范畴的应用类型.

CPU Bound(译注:CPU 范畴): 在这个范畴中的应用,一般都是高负荷的CPU 占用. CPU 范畴的应用,就是一个批量处理CPU 请求以及数学计算的过程.通常web server,mail server,以及其他类型服务被认为是CPU 范畴的应用类型.

**1.2 确定基准线统计**

系统利用率情况,一般随管理员经验以及系统本身用途来决定.唯一要清楚的就是,系统优化希望达成什么效果,以及哪些方面是需要优化,还有参考值是什么?因此就建立一个基准线,这个统计数据必须是系统可用性能状态值,用来比较不可用性能状态值.

在以下例子中,1个系统性能的基准线快照,用来比较当高负荷时的系统性能快照.

	# vmstat 1

	procs memory swap io system cpu
	r b swpd free buff cache si so bi bo in cs us sy wa id
	1 0 138592 17932 126272 214244 0 0 1 18 109 19 2 1 1 96
	0 0 138592 17932 126272 214244 0 0 0 0 105 46 0 1 0 99
	0 0 138592 17932 126272 214244 0 0 0 0 198 62 40 14 0 45
	0 0 138592 17932 126272 214244 0 0 0 0 117 49 0 0 0 100
	0 0 138592 17924 126272 214244 0 0 0 176 220 938 3 4 13 80
	0 0 138592 17924 126272 214244 0 0 0 0 358 1522 8 17 0 75
	1 0 138592 17924 126272 214244 0 0 0 0 368 1447 4 24 0 72
	0 0 138592 17924 126272 214244 0 0 0 0 352 1277 9 12 0 79

	# vmstat 1
	procs memory swap io system cpu
	r b swpd free buff cache si so bi bo in cs us sy wa id
	2 0 145940 17752 118600 215592 0 1 1 18 109 19 2 1 1 96
	2 0 145940 15856 118604 215652 0 0 0 468 789 108 86 14 0 0
	3 0 146208 13884 118600 214640 0 360 0 360 498 71 91 9 0 0
	2 0 146388 13764 118600 213788 0 340 0 340 672 41 87 13 0 0
	2 0 147092 13788 118600 212452 0 740 0 1324 620 61 92 8 0 0
	2 0 147360 13848 118600 211580 0 720 0 720 690 41 96 4 0 0
	2 0 147912 13744 118192 210592 0 720 0 720 605 44 95 5 0 0
	2 0 148452 13900 118192 209260 0 372 0 372 639 45 81 19 0 0
	2 0 149132 13692 117824 208412 0 372 0 372 457 47 90 10 0 0

从上面第一个结果可看到,最后一列(id) 表示的是空闲时间,我们可以看到,在基准线统计时,CPU 的空闲时间在79% - 100%.在第二个结果可看到,系统处于100%的占用率以及没有空闲时间.从这个比较中,我们就可以确定是否是CPU 使用率应该被优化.

## **2.0 安装监控工具**

多数 *nix系统都有一堆标准的监控命令.这些命令从一开始就是*nix 的一部分.Linux 则通过基本安装包以及额外包提供了其他监控工具,这些安装包多数都存在各个Linux 发布版本中.尽管还有其他更多的开源以及第三方监控软件,但本文档只讨论基于Linux 发布版本的监控工具.

本章将讨论哪些工具怎样来监控系统性能.

> 工具     描述                                           Base  是否在软件源仓库中
> vmstat   all purpose performance tool                  yes   yes
> mpstat   provides statistics per CPU                   no    yes
> sar      all purpose performance monitoring tool       no    yes
> iostat   provides disk statistics                      no    yes
> netstat  provides network statistics                   yes   yes
> dstat    monitoring statistics aggregator              no    in most distributions
> iptraf   traffic monitoring dashboard                  no    yes
> netperf  Network bandwidth tool                        no    In some distributions
> ethtool  reports on Ethernet interface configuration   yes   yes
> iperf    Network bandwidth tool                        no    yes
> tcptrace Packet analysis tool                          no    yes

## **3.0 CPU 介绍**

CPU 利用率主要依赖于是什么资源在试图存取.内核调度器将负责调度2种资源种类:线程(单一或者多路)和中断.调度器去定义不同资源的不同优先权.以下列表从优先级高到低排列:

Interrupts(译注:中断) - 设备通知内核,他们完成一次数据处理的过程.例子,当一块网卡设备递送网络数据包或者一块硬件提供了一次IO 请求.

Kernel(System) Processes(译注:内核处理过程) - 所有内核处理过程就是控制优先级别.

User Processes(译注:用户进程) - 这块涉及"userland".所有软件程序都运行在这个user space.这块在内核调度机制中处于低优先级.

从上面,我们可以看出内核是怎样管理不同资源的.还有几个关键内容需要介绍,以下部分就将介绍context(译注:上下文切换),run queues(译注:运行队列)以及utilization(译注:利用率).

**3.1 上下文切换**

多数现代处理器都能够运行一个进程(单一线程)或者线程.多路超线程处理器有能力运行多个线程.然而,Linux 内核还是把每个处理器核心的双核心芯片作为独立的处理器.比如,以Linux 内核的系统在一个双核心处理器上,是报告显示为两个独立的处理器.

一个标准的Linux 内核可以运行50 至 50,000 的处理线程.在只有一个CPU时,内核将调度并均衡每个进程线程.每个线程都分配一个在处理器中被开销的时间额度.一个线程要么就是获得时间额度或已抢先获得一些具有较高优先级(比如硬件中断),其中较高优先级的线程将从区域重新放置回处理器的队列中.这种线程的转换关系就是我们提到的上下文切换.

每次内核的上下文切换,资源被用于关闭在CPU寄存器中的线程和放置在队列中.系统中越多的上下文切换,在处理器的调度管理下,内核将得到更多的工作.

**3.2 运行队列**

每个CPU 都维护一个线程的运行队列.理论上,调度器应该不断的运行和执行线程.进程线程不是在sleep 状态中(译注:阻塞中和等待IO中)或就是在可运行状态中.如果CPU 子系统处于高负荷下,那就意味着内核调度将无法及时响应系统请求.导致结果,可运行状态进程拥塞在运行队列里.当运行队列越来越巨大,进程线程将花费更多的时间获取被执行.

比较流行的术语就是"load",它提供当前运行队列的详细状态.系统 load 就是指在CPU 队列中有多少数目的线程,以及其中当前有多少进程线程数目被执行的组合.如果一个双核系统执行了2个线程,还有4个在运行队列中,则 load 应该为 6\. top 这个程序里显示的load averages 是指1,5,15 分钟以内的load 情况.

**3.3 CPU 利用率**

CPU 利用率就是定义CPU 使用的百分比.评估系统最重要的一个度量方式就是CPU 的利用率.多数性能监控工具关于CPU 利用率的分类有以下几种:

User Time(译注:用户进程时间) - 关于在user space中被执行进程在CPU 开销时间百分比.

System Time(译注:内核线程以及中断时间) - 关于在kernel space中线程和中断在CPU 开销时间百分比.

Wait IO(译注:IO 请求等待时间) - 所有进程线程被阻塞等待完成一次IO 请求所占CPU 开销idle的时间百分比.

Idle(译注:空闲) - 一个完整空闲状态的进程在CPU 处理器中开销的时间百分比.

## **4.0 CPU 性能监控**

理解运行队列,利用率,上下文切换对怎样CPU 性能最优化之间的关系.早期提及到,性能是相对于基准线数据的.在一些系统中,通常预期所达到的性能包括:

Run Queues - 每个处理器应该运行队列不超过1-3 个线程.例子,一个双核处理器应该运行队列不要超过6 个线程.

CPU Utiliation - 如果一个CPU 被充分使用,利用率分类之间均衡的比例应该是

65% - 70% User Time
30% - 35% System Time
0% - 5% Idle Time

Context Switches - 上下文切换的数目直接关系到CPU 的使用率,如果CPU 利用率保持在上述均衡状态时,大量的上下文切换是正常的.

很多Linux 上的工具可以得到这些状态值,首先就是 vmstat 和 top 这2个工具.

**4.1 vmstat 工具的使用**

vmstat 工具提供了一种低开销的系统性能观察方式.因为 vmstat 本身就是低开销工具,在非常高负荷的服务器上,你需要查看并监控系统的健康情况,在控制窗口还是能够使用vmstat 输出结果.这个工具运行在2种模式下:average 和 sample 模式.sample 模式通过指定间隔时间测量状态值.这个模式对于理解在持续负荷下的性能表现,很有帮助.下面就是

vmstat 运行1秒间隔的示例:

# vmstat 1

	procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
	r b swpd free buff cache si so bi bo in cs us sy id wa
	0 0 104300 16800 95328 72200 0 0 5 26 7 14 4 1 95 0
	0 0 104300 16800 95328 72200 0 0 0 24 1021 64 1 1 98 0
	0 0 104300 16800 95328 72200 0 0 0 0 1009 59 1 1 98 0
	
	> Table 1: The vmstat CPU statistics
	> Field Description
	> r The amount of threads in the run queue. These are threads that are runnable, but the CPU is not available to execute them.
	> 当前运行队列中线程的数目.代表线程处于可运行状态,但CPU 还未能执行.
	> b This is the number of processes blocked and waiting on IO requests to finish.
	> 当前进程阻塞并等待IO 请求完成的数目
	> in This is the number of interrupts being processed.
	> 当前中断被处理的数目
	> cs This is the number of context switches currently happening on the system.
	> 当前kernel system中,发生上下文切换的数目
	> us This is the percentage of user CPU utilization.
	> CPU 利用率的百分比
	> sys This is the percentage of kernel and interrupts utilization.
	> 内核和中断利用率的百分比
	> wa This is the percentage of idle processor time due to the fact that ALL runnable threads are blocked waiting on IO.
	> 所有可运行状态线程被阻塞在等待IO 请求的百分比
	> id This is the percentage of time that the CPU is completely idle.
	> CPU 空闲时间的百分比

**4.2 案例学习:持续的CPU 利用率**

在这个例子中,这个系统被充分利用

# vmstat 1

	procs memory swap io system cpu
	r b swpd free buff cache si so bi bo in cs us sy wa id
	3 0 206564 15092 80336 176080 0 0 0 0 718 26 81 19 0 0
	2 0 206564 14772 80336 176120 0 0 0 0 758 23 96 4 0 0
	1 0 206564 14208 80336 176136 0 0 0 0 820 20 96 4 0 0
	1 0 206956 13884 79180 175964 0 412 0 2680 1008 80 93 7 0 0
	2 0 207348 14448 78800 175576 0 412 0 412 763 70 84 16 0 0
	2 0 207348 15756 78800 175424 0 0 0 0 874 25 89 11 0 0
	1 0 207348 16368 78800 175596 0 0 0 0 940 24 86 14 0 0
	1 0 207348 16600 78800 175604 0 0 0 0 929 27 95 3 0 2
	3 0 207348 16976 78548 175876 0 0 0 2508 969 35 93 7 0 0
	4 0 207348 16216 78548 175704 0 0 0 0 874 36 93 6 0 1
	4 0 207348 16424 78548 175776 0 0 0 0 850 26 77 23 0 0
	2 0 207348 17496 78556 175840 0 0 0 0 736 23 83 17 0 0
	0 0 207348 17680 78556 175868 0 0 0 0 861 21 91 8 0 1

根据观察值,我们可以得到以下结论:

1,有大量的中断(in) 和较少的上下文切换(cs).这意味着一个单一的进程在产生对硬件设备的请求.

2,进一步显示某单个应用,user time(us) 经常在85%或者更多.考虑到较少的上下文切换,这个应用应该还在处理器中被处理.

3,运行队列还在可接受的性能范围内,其中有2个地方,是超出了允许限制.

**4.3 案例学习:超负荷调度**

在这个例子中,内核调度中的上下文切换处于饱和

# vmstat 1
	procs memory swap io system cpu
	r b swpd free buff cache si so bi bo in cs us sy wa id
	2 1 207740 98476 81344 180972 0 0 2496 0 900 2883 4 12 57 27
	0 1 207740 96448 83304 180984 0 0 1968 328 810 2559 8 9 83 0
	0 1 207740 94404 85348 180984 0 0 2044 0 829 2879 9 6 78 7
	0 1 207740 92576 87176 180984 0 0 1828 0 689 2088 3 9 78 10
	2 0 207740 91300 88452 180984 0 0 1276 0 565 2182 7 6 83 4
	3 1 207740 90124 89628 180984 0 0 1176 0 551 2219 2 7 91 0
	4 2 207740 89240 90512 180984 0 0 880 520 443 907 22 10 67 0
	5 3 207740 88056 91680 180984 0 0 1168 0 628 1248 12 11 77 0
	4 2 207740 86852 92880 180984 0 0 1200 0 654 1505 6 7 87 0
	6 1 207740 85736 93996 180984 0 0 1116 0 526 1512 5 10 85 0
	0 1 207740 84844 94888 180984 0 0 892 0 438 1556 6 4 90 0

根据观察值,我们可以得到以下结论:

1,上下文切换数目高于中断数目,说明kernel中相当数量的时间都开销在上下文切换线程.

2,大量的上下文切换将导致CPU 利用率分类不均衡.很明显实际上等待io 请求的百分比(wa)非常高,以及user time百分比非常低(us).

3,因为CPU 都阻塞在IO请求上,所以运行队列里也有相当数目的可运行状态线程在等待执行.

**4.4 mpstat 工具的使用**

如果你的系统运行在多处理器芯片上,你可以使用 mpstat 命令来监控每个独立的芯片.Linux 内核视双核处理器为2 CPU's,因此一个双核处理器的双内核就报告有4 CPU's 可用.

mpstat 命令给出的CPU 利用率统计值大致和 vmstat 一致,但是 mpstat 可以给出基于单个处理器的统计值.

	# mpstat –P ALL 1
	Linux 2.4.21-20.ELsmp (localhost.localdomain) 05/23/2006
	
	05:17:31 PM CPU %user %nice %system %idle intr/s
	05:17:32 PM all 0.00 0.00 3.19 96.53 13.27
	05:17:32 PM 0 0.00 0.00 0.00 100.00 0.00
	05:17:32 PM 1 1.12 0.00 12.73 86.15 13.27
	05:17:32 PM 2 0.00 0.00 0.00 100.00 0.00
	05:17:32 PM 3 0.00 0.00 0.00 100.00 0.00

**4.5 案例学习: 未充分使用的处理量**

在这个例子中,为4 CPU核心可用.其中2个CPU 主要处理进程运行(CPU 0 和1).第3个核心处理所有内核和其他系统功能(CPU 3).第4个核心处于idle(CPU 2).

使用 top 命令可以看到有3个进程差不多完全占用了整个CPU 核心.

	# top -d 1
	top - 23:08:53 up 8:34, 3 users, load average: 0.91, 0.37, 0.13
	Tasks: 190 total, 4 running, 186 sleeping, 0 stopped, 0 zombie
	Cpu(s): 75.2% us, 0.2% sy, 0.0% ni, 24.5% id, 0.0% wa, 0.0% hi, 0.0%
	si
	Mem: 2074736k total, 448684k used, 1626052k free, 73756k buffers
	Swap: 4192956k total, 0k used, 4192956k free, 259044k cached
	
	PID USER PR NI VIRT RES SHR S %CPU %MEM TIME+ COMMAND
	15957 nobody 25 0 2776 280 224 R 100 20.5 0:25.48 php
	15959 mysql 25 0 2256 280 224 R 100 38.2 0:17.78 mysqld
	15960 apache 25 0 2416 280 224 R 100 15.7 0:11.20 httpd
	15901 root 16 0 2780 1092 800 R 1 0.1 0:01.59 top
	1 root 16 0 1780 660 572 S 0 0.0 0:00.64 init

	# mpstat –P ALL 1
	Linux 2.4.21-20.ELsmp (localhost.localdomain) 05/23/2006
	
	05:17:31 PM CPU %user %nice %system %idle intr/s
	05:17:32 PM all 81.52 0.00 18.48 21.17 130.58
	05:17:32 PM 0 83.67 0.00 17.35 0.00 115.31
	05:17:32 PM 1 80.61 0.00 19.39 0.00 13.27
	05:17:32 PM 2 0.00 0.00 16.33 84.66 2.01
	05:17:32 PM 3 79.59 0.00 21.43 0.00 0.00
	
	05:17:32 PM CPU %user %nice %system %idle intr/s
	05:17:33 PM all 85.86 0.00 14.14 25.00 116.49
	05:17:33 PM 0 88.66 0.00 12.37 0.00 116.49
	05:17:33 PM 1 80.41 0.00 19.59 0.00 0.00
	05:17:33 PM 2 0.00 0.00 0.00 100.00 0.00
	05:17:33 PM 3 83.51 0.00 16.49 0.00 0.00
	
	05:17:33 PM CPU %user %nice %system %idle intr/s
	05:17:34 PM all 82.74 0.00 17.26 25.00 115.31
	05:17:34 PM 0 85.71 0.00 13.27 0.00 115.31
	05:17:34 PM 1 78.57 0.00 21.43 0.00 0.00
	05:17:34 PM 2 0.00 0.00 0.00 100.00 0.00
	05:17:34 PM 3 92.86 0.00 9.18 0.00 0.00
	
	05:17:34 PM CPU %user %nice %system %idle intr/s
	05:17:35 PM all 87.50 0.00 12.50 25.00 115.31
	05:17:35 PM 0 91.84 0.00 8.16 0.00 114.29
	05:17:35 PM 1 90.82 0.00 10.20 0.00 1.02
	05:17:35 PM 2 0.00 0.00 0.00 100.00 0.00
	05:17:35 PM 3 81.63 0.00 15.31 0.00 0.00
	
	你也可以使用 ps 命令通过查看 PSR 这列，检查哪个进程在占用了哪个CPU.
	
	# while :; do ps -eo pid,ni,pri,pcpu,psr,comm | grep 'mysqld'; sleep 1;
	done
	PID NI PRI %CPU PSR COMMAND
	15775 0 15 86.0 3 mysqld
	PID NI PRI %CPU PSR COMMAND
	15775 0 14 94.0 3 mysqld
	PID NI PRI %CPU PSR COMMAND
	15775 0 14 96.6 3 mysqld
	PID NI PRI %CPU PSR COMMAND
	15775 0 14 98.0 3 mysqld
	PID NI PRI %CPU PSR COMMAND
	15775 0 14 98.8 3 mysqld
	PID NI PRI %CPU PSR COMMAND
	15775 0 14 99.3 3 mysqld

**4.6 结论**

监控 CPU 性能由以下几个部分组成:

1,检查system的运行队列,以及确定不要超出每个处理器3个可运行状态线程的限制.

2,确定CPU 利用率中user/system比例维持在70/30

3,当CPU 开销更多的时间在system mode,那就说明已经超负荷并且应该尝试重新调度优先级

4,当I/O 处理得到增长,CPU 范畴的应用处理将受到影响

原文：[http://www.sanotes.net/html/y2009/370.html](http://www.sanotes.net/html/y2009/370.html)
