---
layout: post
title: helm 安装报错 - error forwarding socat not found
category: tech
tags: helm
---
![](https://cdn.kelu.org/blog/tags/helm.jpg)

今天在一个新环境上安装helm，出现了如下报错：

```bash
root@node01:~# helm version
Client: &version.Version{SemVer:"v2.5.0", GitCommit:"012cb0ac1a1b2f888144ef5a67b8dab6c2d45be6", GitTreeState:"clean"}
E0711 10:09:50.160064   10916 portforward.go:332] an error occurred forwarding 33491 -> 44134: error forwarding port 44134 to pod tiller-deploy-542252878-15h67_kube-system, uid : unable to do port forwarding: socat not found.
Error: cannot connect to Tiller
```

参考 github 上的 issue [helm needs socat on the nodes of the k8s cluster](https://github.com/helm/helm/issues/966)，需要在所有节点安装 socat 包：

```bash
yum install socat
```
