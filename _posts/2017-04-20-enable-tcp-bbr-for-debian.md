---
layout: post
title: Debian 开启BBR TCP加速
category: tech
tags: linux google
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

BBR 已经出来将近半年了。 它解决问题的出发点在于：

* 在有一定丢包率的网络链路上充分利用带宽，最大优化网络速度.。
* 降低网络链路上的 buffer 占用率，从而降低延迟。

关于 BBR 加速原理的细节，可以参考知乎这篇文章，讲的很详细。[《Linux Kernel 4.9 中的 BBR 算法与之前的 TCP 拥塞控制相比有什么优势？》][1]

这篇文章我记录一下开启过程。事先提个醒，在生产环境中不轻易升级内核。就我实践的结果，这次升级把我的Docker搞坏了，服务无法启动。

# 安装

在 [Kernel.Ubuntu.com](http://kernel.ubuntu.com/~kernel-ppa/mainline/)找到版本号文件夹,amd64 的 linux-image 中含有 generic 这个 deb 包的。以我Debian 64位的系统，于是安装过程如下：

    wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10/linux-image-4.10.0-041000-generic_4.10.0-041000.201702191831_amd64.deb
    dpkg -i     dpkg -i linux-image-4.10.0-041000-generic_4.10.0-041000.201702191831_amd64.deb

安装完成后重启。

# 开启BBR

    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf

    sysctl -p
    
如果以下命令输出有bbr,那么已经成功开启BBR.

    sysctl net.ipv4.tcp_available_congestion_control

如果以下命令输出有tcp-bbr,那么BBR正在运行.

    lsmod | grep bbr


# 关闭BBR

执行完以下命令,重启后即可.

    sed -i '/net\.core\.default_qdisc=fq/d' /etc/sysctl.conf
    sed -i '/net\.ipv4\.tcp_congestion_control=bbr/d' /etc/sysctl.conf
    sysctl -p
    
# 相关问题
    
如果是租用的云服务器，要注意确认系统内核是否被改过，有无影响。例如如果是linode的服务器，要注意将启动配置修改成使用grub2内核模式启动。

![](https://cdn.kelu.org/blog/2017/04/20170427204755.jpg)

# 参考资料
    
* [Linux Kernel 4.9 中的 BBR 算法与之前的 TCP 拥塞控制相比有什么优势？][1]
* [Debian 8 X64 升级内核并开启BBR TCP加速](https://segmentfault.com/a/1190000008221792)

[1]: https://www.zhihu.com/question/53559433/answer/135903103
