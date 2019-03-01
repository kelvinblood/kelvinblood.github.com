---
layout: post
title: 使用 helm 安装 Redis (包括持久化存储)
category: tech
tags: docker kubernetes helm redis
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

# 背景

本文介绍如何使用 helm 安装 redis，使用本地存储的方式。

# 1. 安装storage

```
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: local-storage-redis
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
```

在这里起了名叫 `local-storage-redis` 的 storage class。

在这里我们使用了 `WaitForFirstConsumer` 延迟绑定pv，直到 pod 被调度。

# 2. 安装pv绑定

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: local-pv-redis
spec:
  capacity:
    storage: 8Gi
  # volumeMode field requires BlockVolume Alpha feature gate to be enabled.
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  storageClassName: local-storage-redis
  persistentVolumeReclaimPolicy: Retain
  local:
    path: /app/kelu/local-storage/redis
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - keludev05
```

在这里我们在 keludev05 这台机器上创建了文件夹 `/app/kelu/local-storage/redis` 用于持久化存储。

在这里我们必须定义 nodeAffinity，Kubernetes Scheduler 需要使用 PV 的 nodeAffinity 描述信息来保证 Pod 能够调度到有对应 local volume 的机器上。

# 3. 修改 values.yaml

去到helm维护的 Redis 目录： <https://github.com/helm/charts/tree/master/stable/redis> ，下载 [values.yaml](https://github.com/helm/charts/raw/master/stable/redis/values.yaml) 文件。也可以看下他们的 readme，看看还有哪些推荐配置项。

搜索 persistence ，填充 storage class的内容。

![55135270788](https://cdn.kelu.org/blog/2019/02/1551352707888.jpg)

# 4. 安装

```
helm search redis
helm install --name redis -f values.yaml stable/redis --namespace kelu
```

安装到 kelu 这个namespace下。



# 参考资料

* [深度解析Kubernetes Local Persistent Volume](https://my.oschina.net/jxcdwangtao/blog/1934004)
* <https://github.com/helm/charts/blob/master/stable/redis/values.yaml>