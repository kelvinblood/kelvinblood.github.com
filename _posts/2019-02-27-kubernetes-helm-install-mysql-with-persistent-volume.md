---
layout: post
title: 使用 helm 安装 MySQL (包括持久化存储)
category: tech
tags: docker kubernetes helm mysql
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

# 背景

本文介绍如何使用 helm 安装 mysql ，使用本地存储的方式。

# 1. 安装storage

```
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: local-storage-mysql
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
```

在这里起了名叫 `local-storage-mysql` 的 storage class。

在这里我们使用了 `WaitForFirstConsumer` 延迟绑定pv，直到 pod 被调度。

# 2. 安装pv绑定

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: local-pv-mysql
spec:
  capacity:
    storage: 8Gi
  # volumeMode field requires BlockVolume Alpha feature gate to be enabled.
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  storageClassName: local-storage-mysql
  persistentVolumeReclaimPolicy: Retain
  local:
    path: /app/kelu/local-storage/mysql
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - keludev06
```

在这里我们在 keludev06 这台机器上创建了文件夹 `/app/kelu/local-storage/mysql` 用于持久化存储。

在这里我们必须定义 nodeAffinity，Kubernetes Scheduler 需要使用 PV 的 nodeAffinity 描述信息来保证 Pod 能够调度到有对应 local volume 的机器上。

# 3. 修改 values.yaml

去到官网维护的MySQL目录： <https://github.com/helm/charts/tree/master/stable/mysql> ，下载 [values.yaml](https://github.com/helm/charts/raw/master/stable/mysql/values.yaml) 文件。

搜索 persistence ，填充 storage class的内容。

![55135198291](C:\Users\kelu\AppData\Local\Temp\1551351982911.png)

# 4. 安装

![55135211037](C:\Users\kelu\AppData\Local\Temp\1551352110376.png)

```
helm search mysql
helm install --name mysql -f values.yaml stable/mysql --namespace kelu
```

安装到 kelu 这个namespace下。



# 参考资料

* [深度解析Kubernetes Local Persistent Volume](https://my.oschina.net/jxcdwangtao/blog/1934004)
* <https://github.com/helm/charts/blob/master/stable/mysql/values.yaml>