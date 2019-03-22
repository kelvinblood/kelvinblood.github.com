---
layout: post
title: kubernetes 调度之节点标签/污点、应用容忍/nodeSelector/配额/反亲和/lifecycle
category: tech
tags: kubernetes
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

平时常给节点添加标签/污染，还有给应用添加容忍、配额和反亲和，这篇文章记录一些常用的命令，方便查阅。

本文中的特性基于kubernetes 1.10.

结尾待续。

# 节点标签

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

# 污点和容忍

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

# 选择节点

pod选择制定节点运行，一般

```
        "nodeSelector": {
          "app": "cmp"
        },
```

