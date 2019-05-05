---
layout: post
title: kubernetes 无法删除pods
category: tech
tags: kubernetes
typora-copy-images-to: 5
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

可以看到这个namespace下面存在很多个 `terminating` 的容器。

![1556609128712](https://cdn.kelu.org/blog/2019/05/1556609128712.jpg)

我以第一个 6876d46bcshq6w 容器为例，直接在节点上使用 docker ps | grep 6876d46bcshq6w ，也能看到这个容器已经正常运行了9天：

![1556610392653](https://cdn.kelu.org/blog/2019/05/1556610392653.jpg)

查看系统日志中，也可看到kubelet的报错日志：

```
Apr 28 04:16:50 LinkFinUAT08 kubelet: W0428 04:16:50.745406   69358 prober.go:103] No ref for container "docker://4e4948e24eb7f376e707acea02be456e5d3d1b35c481e918c5d57a19c454f86d" (xxxx-6876d46bcshq6w-xxxxx)
```

强制删除：

```
kubectl delete pod <PODNAME> --grace-period=0 --force --namespace <NAMESPACE>
```

此时在kubernetes 管理界面已经找不到这个容器了。

但，我在节点上仍然能看到这个容器，stop和rm都是不起作用的：

```
docker stop xxx && docker rm xxx
```

该容器仍然坚挺地运行着。



（待续



# 参考资料

* [Pods stuck at terminating status](https://stackoverflow.com/questions/35453792/pods-stuck-at-terminating-status)

* <https://kubernetes.io/docs/concepts/workloads/pods/pod/>

  

