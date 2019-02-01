---
layout: post
title: Debian 生成新的交换分区
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

先看我在推特上的这条吐槽：

<https://twitter.com/kelvinbloodzz/status/881719864989065217>

![](https://cdn.kelu.org/blog/2017/07/20.49.33.jpg)

嘛，事情是这样的。 我在阿里云的机器上编译 PHP，编译到中途就报了错误——内存不足。于是就纳闷了，这问题咋解决啊，难道要我换台机器？虚拟内存在哪呢？然后就是这样了：

![](https://cdn.kelu.org/blog/2017/07/11.42.08.jpg)

才知道原来阿里云没有为我们默认创建交换分区。这个，算是个坑吧。

所以下面来看怎么添加交换分区。

给linux增加swap主要有两种方法，1是增加swap文件，2是增加swap分区。

在你有单独硬盘可以挂载的时候，才可以用第二种方式。具体根据你的环境操作来选吧。

# 增加 swap 文件

* free查看系统内存及交换分区的使用率

        用法：free  -m   #以兆为单位查看
        free –m
    
* 使用虚拟设备生成空文件

        dd  if=/dev/zero  of=目录/文件名  bs=容量  count=次数
        dd  if=/dev/zero of=/swapfile bs=100M count=10  #表示增加1G虚拟内存

* 生成交换分区文件

        mkswap  /swapfile 

* 激活交换分区

        swapon /swapfile
        swapon -s //检查是否生效
   
* 交换分区永久生效

    在文件/etc/rc.local中添加一行

        swapon   /swapfile    #重启系统生效

如果要去掉这个新的交换分区，用如下命令：

    /sbin/swapoff   /swapfile 

# 增加 swap 分区
# 增加 swap 分区

* 设置分区

        mkswap  /dev/sdc

* 激活分区

        swapon /dev/sdc
        swapon -s //检查是否生效
   
* 交换分区永久生效

        echo /dev/sdc swap swap defaults 0 0  >> /etc/fstab //将/dev/sdc自动挂载成Swap写入fstab文件里
    
# 常见错误

1. 在 openvz 的机器中，你可能会遇到这样一个错误：

		swapon: /swapfile: swapon failed: Operation not permitted
	
	对于这个问题我还没有好的解决办法，如果你有解决办法的话欢迎和我联系。


# 参考资料

* [为debian增加swap - bi119aTe5hXk's Blog](https://blog.bi119ate5hxk.net/2017/05/14/%E4%B8%BAdebian%E5%A2%9E%E5%8A%A0swap/)