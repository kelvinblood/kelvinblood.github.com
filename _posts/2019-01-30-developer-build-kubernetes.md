---
layout: post
title: kubernetes 的编译、打包和发布(v1.10)
category: tech
tags: go kubernetes
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

这是一篇 kubernetes 编译的简单备忘，以1.10.11为例。

编译主要参考文档为官方文档：<https://github.com/kubernetes/kubernetes/blob/master/build/README.md>

# 下载源码

下载v1.10.11源码

```
git clone -b v1.10.11 https://github.com/kubernetes/kubernetes.git
cd kubernetes

# 或者自由切换到其它分支
git branch
git tag | grep v1.10
git checkout v1.10.11
```

源码有100多万文件、将近700M，下载比较慢，需要一些耐心。

![1571366044132](assets/1571366044132.png)



# 修改源码

这一块就各显神通了。



# 运行编译环境

使用容器运行一个编译环境，将代码文件映射到目的文件夹

```
docker run -it --rm -v $(pwd):/usr/lib/go/src/k8s.io/kubernetes kelvinblood/go-kube-build:v1.11 sh
```



# 单模块编译

以kubeadm为例，进入cmd文件夹进行编译即可。

```
cd /usr/lib/go/src/k8s.io/kubernetes/cmd/kubeadm
go build 
```



# 参考资料

* [kubernetes的编译、打包、发布](https://www.lijiaocn.com/%E9%A1%B9%E7%9B%AE/2017/05/15/Kubernetes-compile.html)
* [Development Guide](https://github.com/kubernetes/community/blob/master/contributors/devel/development.md)
* [Building Kubernetes](https://github.com/kubernetes/kubernetes/blob/dcdd114d0a4f1f440e84f0eeabb9a0ffcda336b4/build/README.md)
* <https://yq.aliyun.com/articles/630682>
* [和我一步步部署 kubernetes 集群](https://k8s-install.opsnull.com/)
