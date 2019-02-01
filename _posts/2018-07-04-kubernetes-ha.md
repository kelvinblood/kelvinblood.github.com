---
layout: post
title: 使用 kubeadm 部署 kubernetes HA
category: tech
tags: docker kubernetes
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

这篇文章记录在测试环境中部署 kubernetes 1.10 的 HA的过程。

# Master 节点高可用的思路

非常感谢这个博主得文章，得以一览 k8s HA 的思路——《[关于Kubernetes Master高可用的一些策略](https://jishu.io/kubernetes/kubernetes-master-ha/)》

先看下 kubernetes 的架构：

![](https://cdn.kelu.org/blog/2018/07/kubernetes-architecture.jpg)

为了实现没有单点故障的目标，在 kubernetes 内部，需要为以下几个组件建立高可用方案：

- [etcd](https://github.com/coreos/etcd) 集群的数据中心，用于存放集群的配置以及状态信息，非常重要，如果数据丢失那么集群将无法恢复；因此高可用集群部署首先就是 etcd 是高可用集群。 

  如果你有3个节点，那么最多允许1个节点失效；当你有5个节点时，就可以允许有2个节点失效。

  同时，增加节点还可以让etcd集群具有更好的读性能。因为etcd的节点都是实时同步的，每个节点上都存储了所有的信息，所以增加节点可以从整体上提升读的吞吐量。

- [kube-apiserver](https://kubernetes.io/docs/admin/kube-apiserver/) 集群核心，集群API接口、集群各个组件通信的中枢。由于 apiserver 是无状态的，每个master节点的apiserver都是active的，并处理来自Load Balance分配过来的流量；

- [kube-controller-manager](https://kubernetes.io/docs/admin/kube-controller-manager/) 集群状态管理器 （内部自选举）。当集群状态与期望不同时，kcm会努力让集群恢复期望状态。默认kubeadm安装情况下–leader-elect参数已经设置为true，保证master集群中只有一个kube-controller-manager处于活跃状态；

- [kube-scheduler](https://kubernetes.io/docs/admin/kube-scheduler/) 集群Pod的调度中心（内部自选举）；默认 kubeadm 安装情况下 –leader-elect 参数已经设置为 true，保证 master 集群中只有一个 kube-scheduler 处于活跃状态；

- [kube-dns](https://github.com/kubernetes/dns) 

etcd 的高可用，在前篇的文章里我已经有介绍 ——《[etcd ha](/tech/2018/07/02/etcd-ha.html)》。本文介绍其他几个组件的高可用。

# 准备

本文的操作系统环境为 `CentOS Linux release 7.3.1611 (Core)`

目前已在 10.19.0.55-57 上装好 etcd，并部署好 vip 10.19.0.230，接下来的目的是在55-57上安装 k8s master 作为ha。

为了保证未来安装时环境保持一致，使用 rpm 包安装 kubeadm kubectl kubelet 组件。

```
kubeadm-1.10.2-0.x86_64.rpm  
kubectl-1.10.2-0.x86_64.rpm  
kubelet-1.10.2-0.x86_64.rpm  
kubernetes-cni-0.6.0-0.x86_64.rpm
```

```
yum install *
```

# 安装第一台master

安装过程与先前安装 k8s集群相似——[《kubernetes 安装入门(centos)》](/tech/2018/05/09/k8s-install-tutorial.html)。

1. 修改 kubeadm.conf

   ```
   $ vi /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
   # 修改 "cgroup-driver"值 由systemd变为cgroupfs
   # 原因是 cgroup-driver参数要与docker的一致，否则就会出问题
   Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs"

   # 第九行增加swap-on=false
   Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"
   ```

2. 启动Docker与kubelet服务

   ```
   systemctl enable kubelet && systemctl start kubelet
   ```

3. 使用 config.yaml 进行初始化配置

   ```
   apiVersion: kubeadm.k8s.io/v1alpha1
   kind: MasterConfiguration
   etcd:
     endpoints:
     - https://10.19.0.55:2379
     - https://10.19.0.56:2379
     - https://10.19.0.57:2379
     caFile: /app/allblue/etcd/ssl/ca.pem
     certFile: /app/allblue/etcd/ssl/server.pem
     keyFile: /app/allblue/etcd/ssl/server-key.pem
     dataDir: /app/allblue/etcddata
   networking:
     podSubnet: 10.244.0.0/16
   kubernetesVersion: 1.10.0
   api:
     advertiseAddress: "10.19.0.230"
   token: "b99a00.a144ef80536d4344"
   tokenTTL: "0s"
   apiServerCertSANs:
   - 10.19.0.55
   - 10.19.0.56
   - 10.19.0.57
   - 10.19.0.230
   featureGates:
     CoreDNS: true
   imageRepository: "10.18.1.230:80/k8s.gcr.io"
   ```

   使用上述的配置文件，如下安装第一台master：

   ```
   kubeadm init --config cfg/config.yaml --ignore-preflight-errors Swap

   echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/bash_profile
   echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/bashrc
   ```

   由于是测试环境，机器内存较为紧张，将swap关闭容易导致系统宕机，故而不按照官方推荐的关闭 swap。

   另外，在这里我们提前将安装需要的经镜像存储在本地Harbor镜像仓库中，也可以使用下面的脚本提前下载到本地：

   ```
   images=(kube-proxy-amd64:v1.10.0
   kube-scheduler-amd64:v1.10.0
   kube-controller-manager-amd64:v1.10.0
   kube-apiserver-amd64:v1.10.0
   etcd-amd64:3.1.12 pause-amd64:3.1
   kubernetes-dashboard-amd64:v1.8.3
   k8s-dns-sidecar-amd64:1.14.8
   k8s-dns-kube-dns-amd64:1.14.8
   k8s-dns-dnsmasq-nanny-amd64:1.14.8
   flannel:v0.9.1-amd64
   heapster-amd64:v1.4.2)
   for imageName in ${images[@]} ; do
     docker pull 10.18.1.230:80/k8s.gcr.io/$imageName
     docker tag 10.18.1.230:80/k8s.gcr.io/$imageName k8s.gcr.io/$imageName
     docker rmi 10.18.1.230:80/k8s.gcr.io/$imageName
   done

   docker tag k8s.gcr.io/flannel:v0.9.1-amd64 flannel:v0.9.1-amd64
   ```

4. 安装flannel网络

   ```
   mkdir -p /etc/cni/net.d/
   cat <<EOF> /etc/cni/net.d/10-flannel.conf
   {
   "name": "cbr0",
   "type": "flannel",
   "delegate": {
   "isDefaultGateway": true
   }
   }
   EOF

   mkdir /usr/share/oci-umount/oci-umount.d -p
   mkdir -p /run/flannel/

   cat <<EOF> /run/flannel/subnet.env
   FLANNEL_NETWORK=10.244.0.0/16
   FLANNEL_SUBNET=10.244.1.0/24
   FLANNEL_MTU=1450
   FLANNEL_IPMASQ=true
   EOF

   kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml
   ```

5. 复制 master 1 证书到另外两台机器：

   ```
   cp -r /etc/kubernetes/pki .
   ```

# 安装剩余master

1. 将master 1 中的证书导入到本地：

   ```
   mkdir -p /etc/kubernetes/
   cp -r pki /etc/kubernetes/

   ```

2. 其它步骤参考第一台配置即可。

3. 检测系统可用性。

   ```
   echo "kubectl get node"
   kubectl get node
   echo ""
   echo "kubectl get cs"
   kubectl get cs
   echo ""
   echo "kubectl get po --all-namespaces"
   kubectl get po --all-namespaces
   ```

# 添加节点

在master节点查看节点添加命令。

```
kubeadm token create --print-join-command
```

# 扩展kube-dns

为了避免故障，要将 kube-dns的`replicas`值设为2或者更多，并用`anti-affinity`将他们部署在不同的Node节点上。

![](https://cdn.kelu.org/blog/2018/07/20180713150040.jpg)

# 安装ingress

我使用了traefik 作为 ingress 的实现，官网 https://docs.traefik.io/，以下按照 user-guide 进行安装：

```
    # 创建角色和rbac绑定
    $ kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-rbac.yaml
    
    # ServiceAccount, DaemonSet(直接绑定主机端口)，service
    $ kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-ds.yaml
```

需要注意的是，官方最近修改的 `traefik-ds.yaml` 修改了两个地方，并不能正常使用，可以参考左侧进行修改。

![](https://cdn.kelu.org/blog/2018/07/20180713144457.jpg)

# 安装helm

参考文章[《kubernetes helm 入门》](https://blog.kelu.org/tech/2018/05/05/k8s-helm-tutorial.html)

# 安装dashboard

参考文章[《kubernetes 安装入门(centos)》](https://blog.kelu.org/tech/2018/05/09/k8s-install-tutorial.html)


# 参考资料

* [一步步打造基于Kubeadm的高可用Kubernetes集群](https://tonybai.com/2017/05/15/setup-a-ha-kubernetes-cluster-based-on-kubeadm-part1/)
* [关于Kubernetes Master高可用的一些策略](https://jishu.io/kubernetes/kubernetes-master-ha/)
* [使用Kubeadm搭建Kubernetes HA（1.10.1）](https://blog.csdn.net/chenleiking/article/details/80136449)