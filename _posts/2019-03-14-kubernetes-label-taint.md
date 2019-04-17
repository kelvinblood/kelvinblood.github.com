---
layout: post
title: kubernetes 调度实践之节点标签/污点、应用容忍/nodeSelector/配额/反亲和/lifecycle
category: tech
tags: kubernetes
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

平时常给节点添加标签/污染，还有给应用添加容忍、配额和反亲和，这篇文章记录一些常用的命令，方便查阅。

本文中的特性基于kubernetes 1.10.

# 一、节点标签

节点标签的用处主要是便于标识每台机器由哪个应用团队使用，也可用于调度方面。

添加：

```
kubectl label nodes <node-name> app=wechat.kelu.org
```

删除：

命令行最后指定 Label 的 key 名并与一个减号相连：

```
kubectl label nodes <node-name> app- 
```

修改：

加上--overwrite参数：

```
kubectl label nodes <node-name> app=blog.kelu.org --overwrite
```

# 二、污点和容忍

污点和容忍常搭配用来做容器调度的，可以将某几台机器指定用于特定的应用。需要注意的是，默认情况下污点和容忍对daemonset不生效。

为节点添加污点：

```
kubectl taint node <node-name> app=blog.kelu.org:NoSchedule
```

为 deployment 添加容忍，与 yaml 文件的containers平级

```
"tolerations": [
          {
            "key": "app",
            "operator": "Equal",
            "value": "blog.kelu.org",
            "effect": "NoSchedule"
          }
        ]
```

其中effect的值可以为`NoSchedule` ,`PreferNoSchedule` ,`NoExecute`。

查看节点的描述：

```
kubectl describe nodes <node-name>
```

删除污点：

```
kubectl taint nodes <node-name> app:NoSchedule-
```

# 三、选择节点

pod选择制定节点运行

```
        "nodeSelector": {
          "app": "app=blog.kelu.org"
        },
```

# 四、资源限制

可以通过  `ResourceQuota` 和 `LimitRange` 对namespace里的pod进行限制。 `ResourceQuota` 是 namespace 中所有 Pod 占用资源的 request 和 limit， `LimitRange` 是 namespace 中单个 Pod 的默认资源 request 和 limit。

同时，也可以在 deployment 中对单个 pod 进行限制。

### ResourceQuota限制资源占用

```
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-resources
  namespace: spark-cluster
spec:
  hard:
    pods: "20"
    requests.cpu: "20"
    requests.memory: 100Gi
    limits.cpu: "40"
    limits.memory: 200Gi
```

### ResourceQuota限制资源数量

```
apiVersion: v1
kind: ResourceQuota
metadata:
  name: object-counts
  namespace: spark-cluster
spec:
  hard:
    configmaps: "10"
    persistentvolumeclaims: "4"
    replicationcontrollers: "20"
    secrets: "10"
    services: "10"
    services.loadbalancers: "2"
```

### LimitRange 配置单个 Pod 的 CPU和内存

```
apiVersion: v1
kind: LimitRange
metadata:
  namespace: blog
  name: mem-cpu-res-limit
spec:
  limits:
  - default:
      memory: 5G
      cpu: 5
    defaultRequest:
      memory: 1Gi
      cpu: 1
    max:
      memory: 1024Mi
      cpu: 1
    min:
      memory: 128Mi
      cpu: 0.5
    type: Container    
```

- `default`：即该命名空间配置resourceQuota时，创建容器的默认限额上限
- `defaultRequest`：即该命名空间配置resourceQuota时，创建容器的默认请求上限
- `max`：即该命名空间下创建容器的资源最大值
- `min`：即该命名空间下创建容器的资源最小值

### 在 deployment 中对 pod 限制

```
apiVersion: extensions/v1beta1
kind: Deployment
spec:
  template:
    spec:
      containers:
      - name: xxx
        image: xxx
        resources:
          limits:
            cpu: 4
            memory: 5Gi
          requests:
            cpu: 100m
            memory: 1Gi
```

# 五、亲和性调度

`Affinity` 是“亲和性”， `Anti-Affinity`，翻译成“互斥”或“反亲和”。

我们常用反亲和来让同一类Pod平均分布在不同的机器上。

目前有两种主要的 node affinity：

* `requiredDuringSchedulingIgnoredDuringExecution` ：pod 必须部署到满足条件的节点上，如果没有满足条件的节点，就不断重试；
* `preferredDuringSchedulingIgnoredDuringExecution` ：优先部署在满足条件的节点上，如果没有满足条件的节点，就忽略这些条件，按照正常逻辑部署。

###  requiredDuringSchedulingIgnoredDuringExecution

```
     affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchLabels:
                io.service: blog
            "topologyKey": "kubernetes.io/hostname"
```

### preferredDuringSchedulingIgnoredDuringExecution

```
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                - key: io.service
                  operator: In
                  values:
                  - blog
              topologyKey: kubernetes.io/hostname
```

更详细的说明请参考官方文档：

- [Kubernetes Doc: Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/)
- [Node affinity and NodeSelector 设计文档](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/nodeaffinity.md)
- [pod affinity and anti-affinity 设计文档](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/podaffinity.md)

# 六、lifecycle

在容器调度时，如果容器正在处理请求，粗暴的杀死会造成应用的不稳定。为了应对这种情况，让Pod更优雅地退出/调度，kubernetes 提供了lifecycle 的特性。目前 lifecycle 可以在容器生命周期定义了两个钩子:

* PostStart, 在容器创建后运行（不能保证会在entrypoint前运行）
* PreStop 在容器终止前调用

我们可以通过 PreStop 钩子，通过延迟容器终止，让容器运行完可能的请求再退出：

```
apiVersion: extensions/v1beta1
kind: Deployment
spec:
  template:
    spec:
      containers:
      - name: xxx
        image: xxx
	    lifecycle:
          preStop:
            exec:
              command: ["sleep","5s"]
```

延迟退出的时间需要更多的应用测试来把握。

# 参考资料

* [Kubernetes中的ResourceQuota和LimitRange配置资源限额](https://jimmysong.io/posts/kubernetes-resourcequota-limitrange-management/)
* [kubernetes 亲和性调度](https://cizixs.com/2017/05/17/kubernetes-scheulder-affinity/)
* [容器生命周期的钩子](https://k8smeetup.github.io/docs/concepts/containers/container-lifecycle-hooks/)

