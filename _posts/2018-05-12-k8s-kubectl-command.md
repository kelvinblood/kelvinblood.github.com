---
layout: post
title: kubernetes kubectl 命令行
category: tech
tags: kubernetes docker
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

本文记录常用的kubectl命令行。

官方参考手册：<https://kubernetes.io/docs/reference/>

蚂蚁金服的 Jimmy Song(宋净超) 主导了一个Kubernetes Handbook 的开源项目，里面有官方手册中这一部分的中文参考，对英文苦手的可以看看：<https://jimmysong.io/kubernetes-handbook/guide/command-usage.html>

在此之前我们可以先看看命令行的帮助：

```
kubectl help
```

![](https://cdn.kelu.org/blog/2018/05/20180518094851.jpg)

从帮助给我们划分了几个 kubectl 的命令主题：

* 入门命令
* 部署命令 deployment
* 集群管理命令 cluster
* 问题定位命令
* 高级命令
* 设置命令
* 其它

下文的分类是我自己分配的，不按照帮助的显示顺序。

# 自动补全

```
$ source <(kubectl completion bash) # setup autocomplete in bash, bash-completion package should be installed first.
$ source <(kubectl completion zsh)  # setup autocomplete in zsh

或者永久性设置（bash）：
kubectl completion bash >> ~/.bashrc
source ~/.bashrc

(zsh):
plugins=(kubectl)
source <(kubectl completion zsh)
```

# 帮助命令

```
$ kubectl help
$ kubectl explain pods,svc                       # get the documentation for pod and svc manifests
```

# 入门命令

1. 增

   kubectl create

   kubectl run

   也可以用 kubectl apply

   ```
   $ kubectl create -f ./my-manifest.yaml           # create resource(s)
   $ kubectl create -f ./my1.yaml -f ./my2.yaml     # create from multiple files
   $ kubectl create -f ./dir                        # create resource(s) in all manifest files in dir
   $ kubectl create -f https://git.io/vPieo         # create resource(s) from url

   $ kubectl run nginx --image=nginx                # start a single instance of nginx
   ```

2. 删

   ```
   $ kubectl delete -f ./pod.json                                              # Delete a pod using the type and name specified in pod.json
   $ kubectl delete pod,service baz foo                                        # Delete pods and services with same names "baz" and "foo"
   $ kubectl delete pods,services -l name=myLabel                              # Delete pods and services with label name=myLabel
   $ kubectl delete pods,services -l name=myLabel --include-uninitialized      # Delete pods and services, including uninitialized ones, with label name=myLabel
   $ kubectl -n default delete pv --all                                      # 删除 default 下所有的pv
   $ kubectl delete node xxx                                                 # 删除 node
   ```

3. 查

   kubectl get xxx

   kubectl describe nodes xxx

   ```
   # 查询资源
   $ kubectl get services                          # List all services in the namespace
   $ kubectl get pods --all-namespaces             # List all pods in all namespaces
   $ kubectl get pods -o wide                      # List all pods in the namespace, with more details
   $ kubectl get deployment my-dep                 # List a particular deployment
   $ kubectl get pods --include-uninitialized      # List all pods in the namespace, including uninitialized ones

   # 资源详细描述
   $ kubectl describe nodes my-node
   $ kubectl describe pods my-pod

   # 排序
   $ kubectl get services --sort-by=.metadata.name
   $ kubectl get pods --sort-by='.status.containerStatuses[0].restartCount'

   # 选择标签
   $ kubectl get pods --selector=app=cassandra rc -o \
     jsonpath='{.items[*].metadata.labels.version}'
   $ kubectl get pods --field-selector=status.phase=Running

   # ExternalIPs
   $ kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="ExternalIP")].address}'

   # 列出所有密钥
   $ kubectl get pods -o json | jq '.items[].spec.containers[].env[]?.valueFrom.secretKeyRef.name' | grep -v null | sort | uniq

   # 列出事件按时间排序
   $ kubectl get events --sort-by=.metadata.creationTimestamp
   ```

4. 改

   用于更新 API 对象的命令有： 

   kubectl patch, 

   kubectl annotate, 

   kubectl edit, 

   kubectl replace, 

   kubectl scale, 

   kubectl apply,

   kubectl expose

   * 更改pod

     ```
     # 从json文件滚动升级pods的镜像
     $ kubectl rolling-update frontend-v1 -f frontend-v2.json       

     # 重命名 + 升级pod镜像
     $ kubectl rolling-update frontend-v1 frontend-v2 --image=image:v2  

     # 回滚pod
     $ kubectl rolling-update frontend-v1 frontend-v2 --rollback

     # 从json文件替换pod
     $ cat pod.json | kubectl replace -f - 

     # 强制替换pod
     $ kubectl replace --force -f ./pod.json

     # 暴露端口
     $ kubectl expose rc nginx --port=80 --target-port=8000

     # 更新pod镜像
     $ kubectl get pod mypod -o yaml | sed 's/\(image: myimage\):.*$/\1:v4/' | kubectl replace -f -

     $ kubectl label pods my-pod new-label=awesome                      # Add a Label
     $ kubectl annotate pods my-pod icon-url=http://goo.gl/XXBTWq       # Add an annotation
     $ kubectl autoscale deployment foo --min=2 --max=10                # Auto scale a deployment "foo"

     $ kubectl edit svc/docker-registry                      # Edit the service named docker-registry
     $ KUBE_EDITOR="nano" kubectl edit svc/docker-registry   # Use an alternative editor
     ```

   * patch 补丁

     `kubectl patch` 命令接受 YAML 或 JSON 格式的补丁，且补丁能够以文件或直接以命令行参数的形式进行传递

     kubectl patch 命令拥有一个 type 参数，可以将其设置为以下值：

     | 参数值    | 合并类型                                                     |
     | --------- | ------------------------------------------------------------ |
     | json      | [JSON 补丁, RFC 6902](https://tools.ietf.org/html/rfc6902)   |
     | merge     | [JSON 合并补丁, RFC 7386](https://tools.ietf.org/html/rfc7386) |
     | strategic | 默认值，策略性合并补丁                                       |

     使用JSON 合并补丁更新一个列表，必须重新定义整个列表。新的列表会完全替换掉原先的列表。

     ```
     # 策略性合并补丁
     $ kubectl patch node k8s-node-1 -p '{"spec":{"unschedulable":true}}' 
     $ kubectl patch deployment patch-demo --patch "$(cat patch-file.yaml)"
     $ kubectl patch pod valid-pod -p '{"spec":{"containers":[{"name":"kubernetes-serve-hostname","image":"new image"}]}}'

     # 查看补丁情况
     # kubectl get deployment patch-demo --output yaml

     $ kubectl patch pod valid-pod --type='json' -p='[{"op": "replace", "path": "/spec/containers/0/image", "value":"new image"}]'
     $ kubectl patch deployment valid-deployment  --type json   -p='[{"op": "remove", "path": "/spec/template/spec/containers/0/livenessProbe"}]'

     # 增加新值
     $ kubectl patch sa default --type='json' -p='[{"op": "add", "path": "/secrets/1", "value": {"name": "whatever" } }]'
     ```

   * scale

     ```
     $ kubectl scale --replicas=3 rs/foo                                 # Scale a replicaset named 'foo' to 3
     $ kubectl scale --replicas=3 -f foo.yaml                            # Scale a resource specified in "foo.yaml" to 3
     $ kubectl scale --current-replicas=2 --replicas=3 deployment/mysql  # If the deployment named mysql's current size is 2, scale mysql to 3
     $ kubectl scale --replicas=5 rc/foo rc/bar rc/baz                   # Scale multiple replication controllers

     ```

5. 资源类型

   | 资源类型                     | 简写          |
   | ---------------------------- | ------------- |
   | `all`                        |               |
   | `certificatesigningrequests` | `csr`         |
   | `clusterrolebindings`        |               |
   | `clusterroles`               |               |
   | `componentstatuses`          | `cs`          |
   | `configmaps`                 | `cm`          |
   | `controllerrevisions`        |               |
   | `cronjobs`                   |               |
   | `customresourcedefinition`   | `crd`, `crds` |
   | `daemonsets`                 | `ds`          |
   | `deployments`                | `deploy`      |
   | `endpoints`                  | `ep`          |
   | `events`                     | `ev`          |
   | `horizontalpodautoscalers`   | `hpa`         |
   | `ingresses`                  | `ing`         |
   | `jobs`                       |               |
   | `limitranges`                | `limits`      |
   | `namespaces`                 | `ns`          |
   | `networkpolicies`            | `netpol`      |
   | `nodes`                      | `no`          |
   | `persistentvolumeclaims`     | `pvc`         |
   | `persistentvolumes`          | `pv`          |
   | `poddisruptionbudgets`       | `pdb`         |
   | `podpreset`                  |               |
   | `pods`                       | `po`          |
   | `podsecuritypolicies`        | `psp`         |
   | `podtemplates`               |               |
   | `replicasets`                | `rs`          |
   | `replicationcontrollers`     | `rc`          |
   | `resourcequotas`             | `quota`       |
   | `rolebindings`               |               |
   | `roles`                      |               |
   | `secrets`                    |               |
   | `serviceaccount`             | `sa`          |
   | `services`                   | `svc`         |
   | `statefulsets`               | `sts`         |
   | `storageclasses`             | `sc`          |

6. 输出格式

    `-o` 或者 `-output` 标签

| Output format                       | Description                                                  |
| ----------------------------------- | ------------------------------------------------------------ |
| `-o=custom-columns=<spec>`          | Print a table using a comma separated list of custom columns |
| `-o=custom-columns-file=<filename>` | Print a table using the custom columns template in the `<filename>` file |
| `-o=json`                           | Output a JSON formatted API object                           |
| `-o=jsonpath=<template>`            | Print the fields defined in a [jsonpath](https://kubernetes.io/docs/reference/kubectl/jsonpath) expression |
| `-o=jsonpath-file=<filename>`       | Print the fields defined by the [jsonpath](https://kubernetes.io/docs/reference/kubectl/jsonpath) expression in the `<filename>` file |
| `-o=name`                           | Print only the resource name and nothing else                |
| `-o=wide`                           | Output in the plain-text format with any additional information, and for pods, the node name is included |
| `-o=yaml`                           | Output a YAML formatted API object                           |

7. 输出debug级别

    `-v` 或者 `--v` 标志

| 级别    | 描述                                                         |
| ------- | ------------------------------------------------------------ |
| `--v=0` | Generally useful for this to ALWAYS be visible to an operator. |
| `--v=1` | A reasonable default log level if you don’t want verbosity.  |
| `--v=2` | Useful steady state information about the service and important log messages that may correlate to significant changes in the system. This is the recommended default log level for most systems. |
| `--v=3` | Extended information about changes.                          |
| `--v=4` | Debug level verbosity.                                       |
| `--v=6` | Display requested resources.                                 |
| `--v=7` | Display HTTP request headers.                                |
| `--v=8` | Display HTTP request contents.                               |
| `--v=9` | Display HTTP request contents without truncation of contents. |

# 问题定位命令

1. 集群信息

   ```
   $ kubectl cluster-info                                                  # 集群信息
   $ kubectl cluster-info dump                                             # 更详细的集群信息
   $ kubectl cluster-info dump --output-directory=/path/to/cluster-state   # 输出到文件

   $ kubectl config current-context
   ```

2. top

   ```
   $ kubectl top pod POD_NAME --containers               # Show metrics for a given pod and its containers
   $ kubectl top node my-node                                              # Show metrics for a given node
   ```

3. 维护模式

   ```
   $ kubectl cordon my-node                                                # 设置节点不可调度
   $ kubectl drain my-node                                                 # 将节点的pod 平滑 迁移到其他节点
   $ kubectl uncordon my-node                                              # 取消节点不可调度。

   # 参考 Kubernetes中的Taint和Toleration（污点和容忍）： https://jimmysong.io/posts/kubernetes-taint-and-toleration/
   # Taint（污点）和 Toleration（容忍）可以作用于 node 和 pod 上，其目的是优化 pod 在集群间的调度，
   # 具有 taint 的 node 和 pod 是互斥关系，而具有节点亲和性关系的 node 和 pod 是相吸的。

   # 为 node1 设置 taint：
   kubectl taint nodes node1 key1=value1:NoSchedule
   kubectl taint nodes node1 key1=value1:NoExecute
   kubectl taint nodes node1 key2=value2:NoSchedule
   # 删除 taint：
   kubectl taint nodes node1 key1:NoSchedule-
   kubectl taint nodes node1 key1:NoExecute-
   kubectl taint nodes node1 key2:NoSchedule-

   # 为 pod 设置 toleration
   只要在 pod 的 spec 中设置 tolerations 字段即可，可以有多个 key：
   tolerations:
   - key: "key1"
     operator: "Equal"
     value: "value1"
     effect: "NoSchedule"
   - key: "key1"
     operator: "Equal"
     value: "value1"
     effect: "NoExecute"
   - key: "node.alpha.kubernetes.io/unreachable"
     operator: "Exists"
     effect: "NoExecute"
     tolerationSeconds: 6000
   value 的值可以为 NoSchedule、PreferNoSchedule 或 NoExecute。
   tolerationSeconds 是当 pod 需要被驱逐时，可以继续在 node 上运行的时间。
   ```

4. Pods 互动

   kubectl logs 

   kubectl attach 

   kubectl exec 

   ```
   $ kubectl logs my-pod                                 # dump pod logs (stdout)
   $ kubectl logs my-pod -c my-container                 # dump pod container logs (stdout, multi-container case)
   $ kubectl logs -f my-pod --namespace="xx"                             # stream pod logs (stdout)
   $ kubectl logs -f my-pod -c my-container              # stream pod container logs (stdout, multi-container case)
   $ kubectl run -i --tty busybox --image=busybox -- sh  # Run pod as interactive shell
   $ kubectl attach my-pod -i                            # Attach to Running Container

   $ kubectl exec my-pod -- ls /                         # Run command in existing pod (1 container case)
   $ kubectl exec my-pod -c my-container -- ls /         # Run command in existing pod (multi-container case)

   ```

5. 暴露端口

   kubectl port-forward  暴露本地端口给pod

   kubectl proxy  使API server监听在本地端口

   ```
   $ kubectl port-forward my-pod 5000:6000               # Listen on port 5000 on the local machine and forward to port 6000 on my-pod

   $ kubectl proxy --address='0.0.0.0'  --accept-hosts='^*$'
   ```

