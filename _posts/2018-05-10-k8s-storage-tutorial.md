---
layout: post
title: kubernetes storage入门
category: tech
tags: kubernetes docker
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

这篇文章记录如何使用 kubernetes 的存储资源，包括volume、pv&pvc等。

# 一、Volume

Volume 的生命周期独立于容器，Pod 中的容器可能被销毁和重建，但 Volume 会被保留。

Volume 提供了对各种 backend 的抽象，容器在使用 Volume 读写数据的时候不需要关心数据到底是存放在本地节点的文件系统还是云硬盘上。对它来说，所有类型的 Volume 都只是一个目录。

## 1. emptyDir 

最基础的 Volume 类型。

emptyDir Volume 的生命周期与 Pod 一致。对于容器来说是持久的，对于 Pod 则不是。当 Pod 从节点删除时，Volume 的内容也会被删除。但如果只是容器被销毁而 Pod 还在，则 Volume 不受影响。Pod 中的所有容器都可以共享 Volume，它们可以指定各自的 mount 路径。

根据这个特性，emptyDir 特别适合 Pod 中的容器需要临时共享存储空间的场景。

![](https://cdn.kelu.org/blog/2018/05/725.jpg)



## 2. hostPath Volume

hostPath Volume 的作用是将 Docker Host 文件系统中已经存在的目录 mount 给 Pod 的容器。持久性比 emptyDir 强。不过一旦 Host 崩溃，hostPath 也就没法访问了。

hostPath Volume 实际上增加了 Pod 与节点的耦合，限制了 Pod 的使用。不过那些需要访问 Kubernetes 或 Docker 内部数据的应用则需要使用 hostPath。

比如 kube-apiserver 和 kube-controller-manager 就是这样的应用

```
kubectl edit --namespace=kube-system pod kube-apiserver-k8s-master
```

![](https://cdn.kelu.org/blog/2018/05/729.jpg)



## 3. 外部 Storage Provider

如果 Kubernetes 部署在诸如 AWS、GCE、Azure 等公有云上，可以直接使用云硬盘作为 Volume，也可以使用主流的分布式存储，比如 Ceph、GlusterFS 等。

相对于 emptyDir 和 hostPath，这些 Volume 类型的最大特点就是不依赖 Kubernetes。Volume 的底层基础设施由独立的存储系统管理，与 Kubernetes 集群是分离的。数据被持久化后，即使整个 Kubernetes 崩溃也不会受损。

![](https://cdn.kelu.org/blog/2018/05/730.jpg)

![](https://cdn.kelu.org/blog/2018/05/731.jpg)



Volume 提供了非常好的数据持久化方案，不过在可管理性上还有不足。下面介绍的 PV & PVC 可以在更高层次上对存储进行管理。

# 二、PV & PVC

引自 [cloudman6](https://steemit.com/kubernetes/@cloudman6/nfs-persistentvolume-kubernetes-38)

> Volume 提供了非常好的数据持久化方案，不过在可管理性上还有不足。
>
> 拿前面 AWS EBS 的例子来说，要使用 Volume，Pod 必须事先知道如下信息：
>
> 1. 当前 Volume 来自 AWS EBS。
> 2. EBS Volume 已经提前创建，并且知道确切的 volume-id。
>
> Pod 通常是由应用的开发人员维护，而 Volume 则通常是由存储系统的管理员维护。开发人员要获得上面的信息：
>
> 1. 要么询问管理员。
> 2. 要么自己就是管理员。
>
> 这样就带来一个管理上的问题：应用开发人员和系统管理员的职责耦合在一起了。如果系统规模较小或者对于开发环境这样的情况还可以接受。但当集群规模变大，特别是对于生成环境，考虑到效率和安全性，这就成了必须要解决的问题。
>
> Kubernetes 给出的解决方案是 PersistentVolume 和 PersistentVolumeClaim。
>
> PersistentVolume (PV) 是外部存储系统中的一块存储空间，由管理员创建和维护。与 Volume 一样，PV 具有持久性，生命周期独立于 Pod。
>
> PersistentVolumeClaim (PVC) 是对 PV 的申请 (Claim)。PVC 通常由普通用户创建和维护。需要为 Pod 分配存储资源时，用户可以创建一个 PVC，指明存储资源的容量大小和访问模式（比如只读）等信息，Kubernetes 会查找并提供满足条件的 PV。
>
> 有了 PersistentVolumeClaim，用户只需要告诉 Kubernetes 需要什么样的存储资源，而不必关心真正的空间从哪里分配，如何访问等底层细节信息。这些 Storage Provider 的底层信息交给管理员来处理，只有管理员才应该关心创建 PersistentVolume 的细节信息。
>
> Kubernetes 支持多种类型的 PersistentVolume，比如 AWS EBS、Ceph、NFS 等，完整列表请参考 <https://kubernetes.io/docs/concepts/storage/persistent-volumes/#types-of-persistent-volumes>

## 1. 三个概念： pv ，storageclass， pvc

- pv － 持久化卷， 支持本地存储和网络存储， 例如hostpath，ceph rbd， nfs等，只支持两个属性， capacity和accessModes。其中capacity只支持size的定义，不支持iops等参数的设定，accessModes有三种
  - ReadWriteOnce（被单个node读写）
  - ReadOnlyMany（被多个nodes读）
  - ReadWriteMany（被多个nodes读写）
- storageclass－另外一种提供存储资源的方式， 提供更多的层级选型， 如iops等参数。 但是具体的参数与提供方是绑定的。 如aws和gce它们提供的storageclass的参数可选项是有不同的。
- pvc － 对pv或者storageclass资源的请求， pvc 对 pv 类比于pod 对不同的cpu， mem的请求。

下文以nfs为例，安装方式可以查看[关联文章](/tech/2018/05/06/nfs-install.html)

## 2. PV

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mypv1
spec:
  capacity:
    storage: 20Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: mysqlpv
  mountOptions:
    - hard
    - nfsvers=4
  nfs:
    path: /
    server: 172.10.1.100
    
kubectl apply -f mysql-pv.yml    
```

```
kubectl get pv

NAME      CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM     STORAGECLASS   REASON    AGE
mysqlpv   20Gi       RWO            Recycle          Available             mysqlpv                  12m
```

## 3. pvc

```
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  ports:
  - port: 3306
  selector:
    app: mysql
  clusterIP: None
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pv-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 6Gi
  storageClassName: mysqlpv
---
apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: mysql
spec:
  selector:
    matchLabels:
      app: mysql
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - image: mysql:5.6
        name: mysql
        env:
          # Use secret in real usage
        - name: MYSQL_ROOT_PASSWORD
          value: password
        ports:
        - containerPort: 3306
          name: mysql
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-persistent-storage
        persistentVolumeClaim:
          claimName: mysql-pv-claim
  
kubectl apply -f mysql-deployment.yml
```

检查PV和PVC的信息

```
kubectl get pv

NAME      CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS    CLAIM                    STORAGECLASS   REASON    AGE
mysqlpv   20Gi       RWO            Recycle          Bound     default/mysql-pv-claim   mysqlpv                  14m


kubectl describe pvc mysql-pv-claim
```

新建一个pod进入MySQL实例

```
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -ppassword
```

测试

```
mysql> create database test;
mysql> show databases;
```

此时可以在nfs的共享目录中发现相应的文件。

## 4. 修改pv回收策略

将 pv 的字段 persistentVolumeReclaimPolicy: Recycle 修改为 persistentVolumeReclaimPolicy: Retain 即可。删除pvc时将不会删除在pv上生成的数据。

```
kubectl apply -f mysql-pv.yml 
```

PV 还支持 `Delete` 的回收策略，会删除 PV 在 Storage Provider 上对应存储空间。NFS 的 PV 不支持 `Delete`，支持 `Delete` 的 Provider 有 AWS EBS、GCE PD、Azure Disk、OpenStack Cinder Volume 等。

## 5. 回收pv

```
kubectl delete -f mysql-deployment.yml
```

此时可以看到 PV 状态会一直处于 `Released`，不能被其他 PVC 申请。

为了重新使用存储资源，可以删除并重新创建 `mypv1`。删除操作只是删除了 PV 对象，存储空间中的数据并不会被删除。

# 三、 StorageClass

PV 的动态供给由 StorageClass 实现。可以将其理解为配置文件。

上面例子中，创建 PV然后通过 PVC 申请并在 Pod 中使用的方式叫做静态供给（Static Provision）。

与之对应的是动态供给（Dynamical Provision）—— 没有满足 PVC 条件的 PV，会动态创建 PV。

相比静态供给，动态供给不需要提前创建 PV，减少了管理员的工作量，效率高。

动态供给是通过 StorageClass 实现的，StorageClass 定义了如何创建 PV。

# 参考资料

* [在kubernetes中运行单节点有状态MySQL应用](https://scotch.io/@ykfq/kubernetesmysql)
* [k8s学习笔记之持久化存储](https://zhuanlan.zhihu.com/p/29706309)
* [Kubernetes之存储调研整理](https://yucs.github.io/2017/12/14/2017-12-14-kubernetes_volume/)
* [Kubernetes中的存储 - IBM](https://www.ibm.com/developerworks/community/wikis/form/anonymous/api/wiki/0be57f75-2769-40b2-9ea4-99fbec0f9073/page/5145e8c8-4833-4e5b-b623-d73d579c562e/attachment/85e05b23-0fb5-4068-992b-65c8110c58f5/media/Kubernetes%E7%AC%AC%E5%85%AD%E8%AE%B2.pdf)