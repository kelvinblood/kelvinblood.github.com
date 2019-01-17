---
layout: post
title: Kubernetes Calico NetworkPolicy 设置入门
category: tech
tags: docker kubernetes calico 
typora-copy-images-to: ./
---

![img](https://cdn.kelu.org/blog/tags/k8s.jpg)

本文参考/翻译了这篇文章：<https://qiita.com/sugimount/items/39bbdbccfb000b62a5b4>

NetworkPolicy 相对复杂，需要一些时间来了解如何配置它。在这篇文章中，我将解释如何设置NetworkPolicy。

# 概要

创建两个命名空间，并从以下方面检测 NetworkPolicy

- demo 1 Namespace 和 demo 2 Namespace 之间的通信
- demo1 Namespace 的内部通信

我将使用下面几个yaml文件进行设置，可以在这里下载：<http://cdn.kelu.org/blog/2018/10/netpo.tgz>

![54150790425](D:\GitHub\kelvinblood.github.com\_posts\1541507904254.png)



# 配置图

![img](D:\GitHub\kelvinblood.github.com\_posts\68747470733a2f2f71696974612d696d6167652d73746f72652e73332e616d617a6f6e6177732e636f6d2f302f3130343234372f39363030303963662d303062392d613737322d626138662d3661323531393732656263302e706e67.png)



# 环境准备

![54150796399](D:\GitHub\kelvinblood.github.com\_posts\1541507963992.png)

### 创建命名空间

namespace-demo1.yaml

```
apiVersion: v1
kind: Namespace
metadata:
  name: demo1
  labels:
    nsname: demo1
```

namespace-demo2.yaml

```
apiVersion: v1
kind: Namespace
metadata:
  name: demo2
  labels:
    nsname: demo2
```

### 创建nginx

nginx_demo1.yaml

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-test
  namespace: demo1
spec:
  selector:
    matchLabels:
      app: nginx-test
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx-test
    spec:
      containers:
      - name: nginx
        image: nginx
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        ports:
        - containerPort: 80
      restartPolicy: Always
---
kind: Service
apiVersion: v1
metadata:
  labels:
    app: nginx-test
  name: nginx-test
  namespace: demo1
spec:
  type: NodePort
  ports:
  - port: 8080
    targetPort: 80
    nodePort: 32003
  selector:
    app: nginx-test
```

nginx_demo2.yaml

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-test
  namespace: demo2
spec:
  selector:
    matchLabels:
      app: nginx-test
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx-test
    spec:
      containers:
      - name: nginx
        image: nginx
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        ports:
        - containerPort: 80
      restartPolicy: Always
---
kind: Service
apiVersion: v1
metadata:
  labels:
    app: nginx-test
  name: nginx-test
  namespace: demo2
spec:
  type: NodePort
  ports:
  - port: 8080
    targetPort: 80
    nodePort: 32004
  selector:
    app: nginx-test
```

### 创建busybox

busybox_demo1.yaml

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: busybox-deployment
  namespace: demo1
spec:
  selector:
    matchLabels:
      app: busybox
  replicas: 1
  template:
    metadata:
      labels:
        app: busybox
    spec:
      containers:
      - name: busybox
        image: busybox:latest
        command: [ "/bin/sh" ]
        tty: true
```

busybox_demo2.yaml

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: busybox-deployment
  namespace: demo2
spec:
  selector:
    matchLabels:
      app: busybox
  replicas: 1
  template:
    metadata:
      labels:
        app: busybox
    spec:
      containers:
      - name: busybox
        image: busybox:latest
        command: [ "/bin/sh" ]
        tty: true
```

至此，我们分别在两个namespace里创建了 nginx 的deployment和service ，以及用于验证访问是否通畅的 busybox deployment

```
kubectl get deploy,svc,po -n demo1 -owide
kubectl get deploy,svc,po -n demo2 -owide
```

![54150944057](D:\GitHub\kelvinblood.github.com\_posts\1541509440577.png)

我们记下了demo1和demo2中pod的ip：

```
demo1:
NAME                                      IP             NODE
pod/busybox-deployment-86645fc6cd-v7sdp   10.244.3.98    rqkubelocal04
pod/nginx-test-5b859654c4-9dzbg           10.244.3.106   rqkubelocal04
pod/nginx-test-5b859654c4-s4sbd           10.244.3.102   rqkubelocal04

demo2:
NAME                                    IP             NODE
pod/busybox-deployment-86645fc6cd-k6p5r 10.244.3.100   rqkubelocal04
pod/nginx-test-5b859654c4-2b4qx         10.244.3.105   rqkubelocal04
pod/nginx-test-5b859654c4-9vrcq         10.244.3.94    rqkubelocal04
```



# 确认状态

确认 demo1 和 demo2 中的nginx均可内部访问、互访以及nodeport外部访问。

* demo1 -> demo1，demo1->demo2，**pod ip** 访问

  ![54150977091](D:\GitHub\kelvinblood.github.com\_posts\1541509770911.png)

  ​

* demo1 -> demo1，demo1->demo2， **ClusterIP** 访问

  ```
  wget http://nginx-test.demo1:8080
  wget http://nginx-test.demo2:8080
  ```

* demo1 -> demo1，demo1->demo2， **NodePort**访问

  ```
  wget http://10.19.0.232:32003
  wget http://10.19.0.232:32004
  ```



# 设定DefaultNetworkPolicy

* fdsaf a

* fdsa 

  ```
  kubectl exec -it centos-deployment-7d7d7bcb56-thjvk curl http://10.1.7.7/
  ```

  ​

