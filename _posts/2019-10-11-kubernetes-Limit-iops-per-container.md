---
layout: post
title: kubernetes 限制磁盘IO
category: tech
tags: kubernetes
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

磁盘 IO 限制 在 IaaS 层是一个基本功能，在 docker 中也有实现。

参考这篇文章: [《限制容器的_Block_IO_每天5分钟玩转_Docker_容器技术 - IBM developerworks》]([https://www.ibm.com/developerworks/community/blogs/132cfa78-44b0-4376-85d0-d3096cd30d3f/entry/限制容器的_Block_IO_每天5分钟玩转_Docker_容器技术_29](https://www.ibm.com/developerworks/community/blogs/132cfa78-44b0-4376-85d0-d3096cd30d3f/entry/%E9%99%90%E5%88%B6%E5%AE%B9%E5%99%A8%E7%9A%84_Block_IO_%E6%AF%8F%E5%A4%A95%E5%88%86%E9%92%9F%E7%8E%A9%E8%BD%AC_Docker_%E5%AE%B9%E5%99%A8%E6%8A%80%E6%9C%AF_29))

Block IO 指的是磁盘的读写，实际上 docker 是通过 cgroups 做了限制，通过设置权重、限制 bps 和 iops 的方式控制容器读写磁盘的带宽。
`--device-read-bps`，限制读某个设备的 bps。
`--device-write-bps`，限制写某个设备的 bps。
`--device-read-iops`，限制读某个设备的 iops。
`--device-write-iops`，限制写某个设备的 iops。

```
docker run -it --device-write-bps /dev/sda:30MB ubuntu /bin/bash

time dd if=/dev/zero of=test.out bs=1M count=800 oflag=direct
```

不清楚是什么原因，kubernetes 一直未把 io 限速加入到系统功能中。社区中相关的 issue 和 pull request 已经多到不行了，例如：

* [Limit iops per container #70980](<https://github.com/kubernetes/kubernetes/pull/70980>)
* [add blkio support #70573](<https://github.com/kubernetes/kubernetes/pull/70573>)
* [limiting bandwidth and iops per container. #27000](<https://github.com/kubernetes/kubernetes/issues/27000>)

然而一直未合并至主分支。

由于我使用的为 1.10 某版本的kubernetes，参考了这位朋友的提交，完成了对 block io 的支持 [honglei24](https://github.com/honglei24)/[kubernetes](<https://github.com/honglei24/kubernetes/commit/2dd942adf9e822a51e84cb21b8ae7136c4fc54cd>)。

修改完成代码之后根据之前 [《kubernetes 的编译、打包和发布(v1.10)》](/tech/2019/01/30/developer-build-kubernetes.html)，编译完成。

使用时按照代码也可以猜出来用法了：

以下注释表示限制磁盘写的速度为30M:

```
annotations: 
  BlkioDeviceWriteBps: '/dev/sda:31457280'
```

