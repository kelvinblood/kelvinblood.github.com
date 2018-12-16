---
layout: post
title: kubernetes 批量删除pod
category: tech
tags: docker kubernetes
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)



kubernetes 由于各种各样问题驱逐容器时，很容易留下很多个状态为 fail 的 pod。 一个一个删除也不现实，使用下面简单的命令，快速删除namespace为xxx下状态为 Failed 的容器。

```
kubectl get pods --field-selector=status.phase=Failed -n xxx | cut -d' ' -f 1 | xargs kubectl delete pod -n xxx
```



# 参考资料

* [working-with-objects/field-selectors](https://kubernetes.io/docs/concepts/overview/working-with-objects/field-selectors/)