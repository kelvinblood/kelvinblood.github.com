---
layout: post
title: kubernetes helm 入门
category: tech
tags: kubernetes docker
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

这篇文章记录如何安装和使用helm。

# 什么是 helm

Kubernetes是容器集群管理系统，每个成功的软件平台都有一个优秀的打包系统，比如 Debian、Ubuntu 的 apt，Redhat、Centos 的 yum。而 Helm 则是 Kubernetes 上的包管理器。

helm相当于一个应用商店，将一个在云上部署的应用相关的组件全部打包起来，进行安装、升级、管理等。

在kubernetes中，我们部署一个标准的应用，以下的应用基本都会使用到：

1. Service
2. Secret
3. PVC
4. Deployment
5. ConfigMap
6. ...

helm 有几个概念名词：chart，release和repository。chart就是包，而release代表一个运行实例，Repository是用于发布和存储 Chart 的存储库。

helm 的工作，就是将这些yaml配置在更高一个层次，统一起来管理：

1. 新建chart。
2. 更新chart。
3. 在kubernetes中安装和卸载release。
4. 更新、回滚和测试release。



# helm 架构

helm 包含两个组件：helm 客户端 和 tiller 服务器：

* helm客户端负责管理chart
* tiller服务器负责管理release
* Repository 是 Chart 存储库，Helm 客户端通过 HTTP 协议来访问存储库中 Chart 的索引文件和压缩包。

![](https://cdn.kelu.org/blog/2018/05/helm-arch.jpg)

# helm安装

1. helm客户端

   ```
   curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
   helm version

   # 安装helm命令补全脚本
   cd ~ && helm completion bash > .helmrc && echo "source .helmrc" >> .bashrc
   ```

2. tiller服务器

   创建tiller的`serviceaccount`和`clusterrolebinding`

   ```
   kubectl create serviceaccount --namespace kube-system tiller
   kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
   ```

   然后安装helm服务端tiller

   ```
   helm init -i xxxx/k8s.gcr.io/tiller:v2.9.0
   ```

   使用`-i`指定自己的镜像，因为官方的镜像因为某些原因无法拉取。

   为应用程序设置`serviceAccount`：

   ```
   kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
   ```

   检查是否安装成功：

   ```
   $ kubectl -n kube-system get pods|grep tiller
   tiller-deploy-f5597467b-wdwfl      1/1       Running   0          2h
   $ helm version
   Client: &version.Version{SemVer:"v2.9.0", GitCommit:"f6025bb9ee7daf9fee0026541c90a6f557a3e0bc", GitTreeState:"clean"}
   Server: &version.Version{SemVer:"v2.9.0", GitCommit:"f6025bb9ee7daf9fee0026541c90a6f557a3e0bc", GitTreeState:"clean"}
   ```

tips：

> 安装出问题时使用  helm reset  && helm init 重置安装。

3. 使用第三方的 Chart 存储库

   ```
   helm repo add 存储库名 存储库URL
   helm repo update
   ```

   关于 Helm 相关命令的说明，您可以参阅 [Helm 文档](https://docs.helm.sh/helm/#helm-repo-add)

   鉴于国内使用镜像非常不方便Σ(っ °Д °;)っ，请添加国内的镜像进行使用[kube-charts-mirror](https://github.com/BurdenBear/kube-charts-mirror) 

   ```
   helm repo add stable https://burdenbear.github.io/kube-charts-mirror/
   ```

4. 使用helm安装应用例子

   * 安装好pv或者storageclass

     ```
     apiVersion: v1
     kind: PersistentVolume
     metadata:
       name: helm-mysql
     spec:
       capacity:
         storage: 8Gi
       accessModes:
         - ReadWriteOnce
       persistentVolumeReclaimPolicy: Retain
       mountOptions:
         - hard
         - nfsvers=4
       nfs:
         path: /helm-mysql
         server: 172.10.1.100

     kubectl apply -f helm-mysql-pv.yml
     ```

   * 安装mysql

     ```
     helm install stable/mysql --name helm-mysql
     helm list
     ```


# helm的使用

参考官方文档。<https://docs.helm.sh/>

## 自定义chart

创建一个Chart的骨架：

```
helm create testapi-chart
```

目录结构如下所示，我们主要关注目录中的这三个文件即可：Chart.yaml、values.yaml和NOTES.txt。

```
testapi-chart
├── charts
├── Chart.yaml
├── templates
│   ├── deployment.yaml
│   ├── _helpers.tpl
│   ├── NOTES.txt
│   └── service.yaml
└── values.yaml
```

打开Chart.yaml，填写应用的详细信息

打开并根据需要编辑values.yaml

对Chart进行校验

```
helm lint testapi-chart
```

对Chart进行打包：

```
helm package testapi-chart --debug

Successfully packaged chart and saved it to: /var/local/k8s/helm/alpine-0.1.0.tgz
[debug] Successfully saved /var/local/k8s/helm/alpine-0.1.0.tgz to /root/.helm/repository/local
```

安装本地repository中的chart

```
helm search local
helm install --name example local/mychart --set service.type=NodePort
```

使用Helm serve命令启动一个repo server，该server缺省使用’$HELM_HOME/repository/local’目录作为Chart存储，并在8879端口上提供服务。

```
helm serve --address 0.0.0.0:8879 &
```

启动本地repo server后，将其加入Helm的repo列表。

```
helm repo add local http://127.0.0.1:8879
"local" has been added to your repositories
```

现在再查找testapi chart包，就可以找到了。

## chart 搜索

```
helm search
```

## 添加源

添加中国的源：

```
helm repo add stable https://burdenbear.github.io/kube-charts-mirror/
```

参考 <https://github.com/BurdenBear/kube-charts-mirror>

## 常用命令行

```
helm list
helm search
helm search mysql --versions
helm repo list
helm serve &
```

# monocular 安装

因为没能把nginx-ingress安装成功，最后选择了Træfik-ingress

## Træfik-ingress 安装

官网 <https://docs.traefik.io/>，以下按照 user-guide 进行安装，其实就是两个命令行：

```
# 创建角色和rbac绑定
$ kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-rbac.yaml

# ServiceAccount, DaemonSet(直接绑定主机端口)，service
$ kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-ds.yaml
```

就可以看到效果了：

```
curl $(minikube ip)
404 page not found
```

 traefik 



参照GitHub的教程进行安装：

* [Install](https://github.com/kubernetes-helm/monocular)

- [Configuration](https://github.com/kubernetes-helm/monocular/blob/master/deployment/monocular/README.md#configuration)
- [Deployment](https://github.com/kubernetes-helm/monocular/blob/master/deployment/monocular/README.md)
- [Development](https://github.com/kubernetes-helm/monocular/blob/master/docs/development.md)

## config

我创建了一个自己的配置文件，使用 kubernetes helm 国内镜像的配置 custom.yaml 

```
$ cat > custom.yaml <<EOF
ingress:
  hosts:
  - monocular.local
  annotations:
    traefik.frontend.rule.type: PathPrefixStrip
    kubernetes.io/ingress.class: traefik 
api:
  config:
    repos:
      - name: monocular
        url: https://kubernetes-helm.github.io/monocular
        source: https://github.com/kubernetes-helm/monocular/tree/master/charts     
EOF
```

## 添加 repo

```
helm repo add monocular https://kubernetes-helm.github.io/monocular

# 2018年10月12日 更新，上面那个地址已经不能用了，我今天改成了下面这个：
helm repo add monocular https://helm.github.io/monocular
```

## 安装pv

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: monocular-mongodb
spec:
  capacity:
    storage: 8Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  mountOptions:
    - hard
    - nfsvers=4
  nfs:
    path: /monocular
    server: 172.10.1.100
    
$ kubectl apply -f monocular-pv.yml    
```

## 安装 monocular

```
helm install monocular/monocular --name monocular --set controller.hostNetwork=true -f custom.yaml
```

如果出现错误，重新来过的话，清空重置：

```
helm del --purge monocular
kubectl delete pv monocular-mongodb
```

获得 ingress 地址：

```
$ kubectl get ingress monocular-monocular

NAME                  HOSTS           ADDRESS   PORTS     AGE
monocular-monocular   monocular.local            80        9s
```

访问后自定义域名后界面如下：

![](https://cdn.kelu.org/blog/2018/05/monocular.gif)

# 参考资料

* [Error: no available release name found #3055](https://github.com/kubernetes/helm/issues/3055)
* [利用 Helm 简化 Kubernetes 应用部署](https://www.alibabacloud.com/help/zh/doc-detail/58587.htm)
* https://docs.helm.sh/
* [Monocular UI](https://github.com/kubernetes-helm/monocular)
* <https://jimmysong.io/kubernetes-handbook/>
* [kubernetes-helm部署及本地repo搭建](https://blog.csdn.net/liukuan73/article/details/79319900)
* [DockOne微信分享（一六九）：Helm：强大的Kubernetes包管理工具](http://dockone.io/article/5269)
* [Kuberentes Helm 介紹](https://kairen.github.io/2017/03/25/kubernetes/helm-quickstart/)