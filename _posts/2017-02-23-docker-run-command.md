---
layout: post
title: Docker run命令
category: tech
tags: docker
---

![](https://cdn.kelu.org/blog/tags/docker.jpg)

Docker会在隔离的容器中运行进程。当运行 docker run 命令时，Docker会启动一个进程，并为这个进程分配其独占的文件系统、网络资源和以此进程为根进程的进程组。

docker run可以控制一个容器运行时的行为，它可以覆盖docker build在构建镜像时的一些默认配置，这也是为什么run命令相比于其它命令有如此多的参数的原因。

命令格式

最基本的docker run命令的格式如下：

    $ sudo docker run [OPTIONS] IMAGE[:TAG] [COMMAND] [ARG...]

docker run [OPTIONS]可以让用户完全控制容器的生命周期，并允许用户覆盖执行docker build时所设定的参数，甚至也可以修改本身由Docker所控制的内核级参数。

OPTIONS总起来说可以分为两类：

1. 设置运行方式：
    
    * 决定容器的运行方式，前台执行还是后台执行 -d -a -t -i
    * 设置containerID --name --cidfile
    * IPC(命名空间) --ipc
    * 设置网络参数
    * 设置容器的CPU和内存参数；
        - 设置权限和LXC参数；
            
1. 设置镜像的默认资源，也就是说用户可以使用该命令来覆盖在镜像构建时的一些默认配置。

先对照几个例子：

    $ docker run -d -p 54285:54285 oddrationale/docker-shadowsocks -s 0.0.0.0 -p 54285 -k yourpasswd -m aes-256-cfb
    $ docker run -d --name web -p 8080:80 joshhu/webdemo


# 前台vs后台 -d -a -t -i

当我们启动一个容器时，首先需要确定这个容器是运行在前台还是运行在后台。

如果在docker run后面追加-d=true或者-d，那么容器将会运行在后台模式。此时所有I/O数据只能通过网络资源或者共享卷组来进行交互。因为容器不再监听你执行docker run的这个终端命令行窗口。但你可以通过执行docker attach来重新附着到该容器的回话中。

在前台模式下（不指定-d参数即可），Docker会在容器中启动进程，同时将当前的命令行窗口附着到容器的标准输入、标准输出和标准错误中：

    -a=[]          　　　　 : Attach to `STDIN`, `STDOUT` and/or `STDERR`
    -t=false        　　  : Allocate a pseudo-tty
    --sig-proxy=true　: Proxify all received signal to the process (non-TTY mode only)
    -i=false        　　  : Keep STDIN open even if not attached


如果在执行run命令时没有指定-a参数，那么Docker默认会挂载所有标准数据流，包括输入输出和错误，你可以单独指定挂载哪个标准流。

    $ sudo docker run -a stdin -a stdout -i -t ubuntu /bin/bash

如果要进行交互式操作（例如Shell脚本），那我们必须使用-i -t参数同容器进行数据交互。但是当通过管道同容器进行交互时，就不需要使用-t参数，例如下面的命令：

    echo test | docker run -i busybox cat

# 容器识别 --name --cidfile

1. Name --name

    可以通过三种方式为容器命名：
      
    1. 使用UUID长命名（"f78375b1c487e03c9438c729345e54db9d20cfa2ac1fc3494b6eb60872e74778"）
    2. 使用UUID短命令（"f78375b1c487"）
    3. 使用Name("evil_ptolemy")

    这个UUID标示是由Docker deamon生成的。如果你在执行docker run时没有指定--name，那么deamon会自动生成一个随机字符串UUID。但是对于一个容器来说有个name会非常方便，当你需要连接其它容器时或者类似需要区分其它容器时，使用容器名称可以简化操作。

1. PID --cidfile

    如果在使用Docker时有自动化的需求，你可以将containerID输出到指定的文件中（PIDfile），类似于某些应用程序将自身ID输出到文件中，方便后续脚本操作。
    --cidfile="": Write the container ID to the file



# Image[:tag]

当一个镜像的名称不足以分辨这个镜像所代表的含义时，你可以通过tag将版本信息添加到run命令中，以执行特定版本的镜像。例如: docker run ubuntu:14.04

# 命名空间 --ipc

默认情况下，所有容器都开启了IPC命名空间。

    --ipc=""  : Set the IPC mode for the container,
            'container:<name|id>': reuses another container's IPC namespace
            'host': use the host's IPC namespace inside the container

IPC（POSIX/SysV IPC）命名空间提供了相互隔离的命名共享内存、信号灯变量和消息队列。

共享内存可以提高进程数据的交互速度。共享内存一般用在数据库和高性能应用（C/OpenMPI、C++/using boost libraries）上或者金融服务上。如果需要容器中部署上述类型的应用，那么就应该在多个容器直接使用共享内存了。

# 网络设置

默认情况下，所有的容器都开启了网络接口，同时可以接受任何外部的数据请求。

    -h HOSTNAME or --hostname=HOSTNAME --配置容器主机名
    --link=CONTAINER_NAME:ALIAS --添加到另一个容器的连接
    --net=bridge|none|container:NAME_or_ID|host --配置容器的桥接模式
    -p SPEC or --publish=SPEC --映射容器端口到宿主主机
    -P or --publish-all=true|false --映射容器所有端口到宿主主机
    --dns=[]         : Set custom dns servers for the container
    --add-host=""    : Add a line to /etc/hosts (host:IP)
    --mac-address="" : Sets the container's Ethernet device's MAC address

例如开篇的例子：

    $ docker run -d --name web -p 8080:80 joshhu/webdemo

    -p 8080:80 把 host 的 8080端口流量转发到 web 的80端口。

# Clean up (--rm)

默认情况下，每个容器在退出时，它的文件系统也会保存下来，这样一方面调试会方便些，因为你可以通过查看日志等方式来确定最终状态。另外一方面，你也可以保存容器所产生的数据。但是当你仅仅需要短暂的运行一个容器，并且这些数据不需要保存，你可能就希望Docker能在容器结束时自动清理其所产生的数据。

注意：--rm 和 -d不能共用！

    --rm=false: Automatically remove the container when it exits (incompatible with -d)
    
    
# 安全设置 --security-opt

    --security-opt="label:user:USER"   : Set the label user for the container
    --security-opt="label:role:ROLE"   : Set the label role for the container
    --security-opt="label:type:TYPE"   : Set the label type for the container
    --security-opt="label:level:LEVEL" : Set the label level for the container
    --security-opt="label:disable"     : Turn off label confinement for the container
    --secutity-opt="apparmor:PROFILE"  : Set the apparmor profile to be applied  to the container

# 性能设置 -m -c

    -m="": Memory limit (format: <number><optional unit>, where unit = b, k, m or g)
    -c=0 : CPU shares (relative weight)

# 运行时特权 LXC设置

      --cap-add: Add Linux capabilities
      --cap-drop: Drop Linux capabilities
      --privileged=false: Give extended privileges to this container
      --device=[]: Allows you to run devices inside the container without the --privileged flag.
      --lxc-conf=[]: (lxc exec-driver only) Add custom lxc options --lxc-conf="lxc.cgroup.cpuset.cpus = 0,1"

# 重写Dockerfile

这些参数中，有四个是无法被覆盖的：FROM、MAINTAINER、RUN和ADD，其余参数都可以通过docker run进行覆盖。

1. CMD (Default Command or Options)
1. ENTRYPOINT (Default Command to Execute at Runtime)
1. EXPOSE (Incoming Ports)
1. ENV (Environment Variables)
1. VOLUME (Shared Filesystems)
1. USER
1. WORKDIR 　　

# 参考资料

* [Docker run 命令的使用方法 - dockone.io][dockone]

[dockone]: http://dockone.io/article/152
