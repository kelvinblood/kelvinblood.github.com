---
layout: post
title: 部署 kubernetes 的一些问题收集
category: tech
tags: docker kubernetes
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

这篇文章记录在部署 kubernetes 1.10 过程中遇到的一些问题。

安装遇到的很多问题都是版本问题，故而常常会看到这张图：

![](https://cdn.kelu.org/blog/2018/07/20180717085949.jpg)

# cri-tools 版本问题

在增加 kubernetes 节点时，冒出这个错误。

```
configmaps "kubelet-config-1.11" is forbidden: cannot get configmaps in the namespace "kube-system"

[ERROR CRI]: unable to check if the container runtime at "/var/run/dockershim.sock" is running: fork/exec /usr/bin/crictl -r /var/run/dockershim.sock info: no such file or directory
```

解决办法：

卸载 cri-tools

```
apt-get remove cri-tools
yum remove cri-tools
```

参考：[kubeadm init/join CRI preflight check fails unnecessarily#814](https://github.com/kubernetes/kubeadm/issues/814)