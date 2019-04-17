---
layout: post
title: 蘑菇街 K8S 为什么不选择 flannel 网络模型 - koala bear
category: tech
tags: kubernetes network
---
![](https://cdn.kelu.org/blog/tags/network.jpg)

> 博主是蘑菇街的员工，写了不少kubernetes的文章。这篇的原文链接：<http://wsfdl.com/kubernetes/2018/07/09/why_not_flanneld.html>

基于 UDP 的 flannel 网络模型具有简单易用，不依赖底层网络的特点，所以很多入门者偏向选择 flannel 作为 K8S 的网络方案。我们曾考虑尽量采用原生的网络模型，但是在实际生产环境下，受限于 overlay 网络和其它网络的互通性，以及 overlay 网络的性能等问题，我们摒弃了 flannel。

## flannel 基本介绍

关于 flannel 的介绍和基本原理，[官网](https://coreos.com/flannel/docs/latest/)和各类博客的做了非常详细的介绍，此处不再累述。Flannel 网络平面下的 pod 之间具有良好的互通性，但是 pod 和 K8S 外部的 IP 互通性欠佳，所以本节重点介绍 flannel 中的 pod 和 K8S 外部 IP 互通原理。

### Pod 访问 K8S 外部 IP

当 pod 访问 K8S 外部 IP 时，pod 的报文在计算节点以 SNAT 的形式访问外部 IP，所以外部 IP 感知到的是计算节点的 IP，而非 pod 的 IP。如下例子，当报文经 SNAT 后，src IP 由 192.168.0.2 修改为 10.0.0.2；src port 由 43345 修改为 47886。

```
+--------------------------+
|  Node 10.0.0.2           |
| +-----------------+      |                 +--------------+
| | Pod 192.168.0.2 | SNAT |  ------------>  | Dst 10.0.0.3 |
| +-----------------+      |                 +--------------+
+--------------------------+
报文中的 IP／Port 信息
src: 192.168.0.2:43345                       src: 10.0.0.2:47886
dst: 10.0.0.3:80                             dst: 10.0.0.3:80
```

### K8S 外部 IP 访问 pod

外部 IP 无法直接访问 K8S 中的 pod，为了解决这个问题，K8S 引入了 service 和 ingress，其中 service 为 4 层的概念，支持 UDP 和 TCP；ingress 为 7 层概念，支持 http。

虽然 service 支持 cluster IP, node port, loadbalancer 等模式，但是 cluster IP 仅限于 pod 之间的访问；node port 基于 DNAT 为外部服务访问容器提供了入口； loadbalancer 依赖云厂商；而 ingress 仅支持 7 层协议，不满足 rpc 调用等场景，所以相比而言 node port 模式更为简便可行。

K8S 分配计算节点上的某个端口，并映射到容器的某个端口，当外部服务访问容器时，只需要访问相对应的计算节点端口，该端口收到报文后，将目的 ip 和 端口替换为容器的 ip 和端口，最终将报文转发到容器。

```
                                 +--------------------------+
                                 |  Node 10.0.0.2           |
+--------------+                 |      +-----------------+ |                 
| Src 10.0.0.3 |  ------------>  | DNAT | Pod 192.168.0.2 | |
+--------------+                 |      +-----------------+ |
                                 +--------------------------+
报文 IP／Port 信息
src: 10.0.0.3:43345               src: 10.0.0.3:43345
dst: 10.0.0.2:47886               dst: 192.168.0.2:80
```

## 采用 flannel 的缺点

业务方接入 K8S 是一个循序渐进灰度的过程，而非一刀切。在现有的电商技术栈下，业务方之间存在大量的上下游依赖，而且依赖关系相对复杂。我们梳理在 flannel 网络模型下，业务方接入过程中极有可能遇上的问题。

### 服务发现问题

服务发现是重要的中间件之一，常见的开源项目有 dubbo 和 zookeeper 等。公司自研了类似 dubbo 的组件，并且接入了大量的业务。

首先简要介绍服务发现的基本过程，provider 作为服务提供方，它启动后向注册中心注册信息，如 IP 和 port 等等；consumer 作为消费者，它首先访问注册中心获取 provider 的基本信息，然后基于该信息访问 provider。

```
                         +-----------+ 
                      _  |  注册中心  |  _
     2. get provider  /| +-----------+ |\ 1. register
        basic info   /                   \
    +----------+    /                     \    +----------+                              
    | consumer | --+  3. access provider   +-- | provider |
    +----------+      ------------------>      +----------+
```

让我们设想一种场景，当 provider 先接入 K8S 后，每当 provider 向 register 注册时，它获取本地的 IP 并把该 IP 注册到中心。consumer 访问注册中心，拿到 provider 的 IP 后，却发现这个 IP 并不可达，如此严重影响了业务方接入 K8S。

有人会想到，是否可以先接入 consumer，然后再接入注册中心和 provider 呢？事实上，电商体系的链路比较长，依赖复杂，某个应用既有可能是上游业务的 consumer，同时也是下游业务的 provider，导致业务方无法平滑接入。虽然 K8S 也实现了服务发现功能，但是和我们自研的服务发现功能差距较大，涉及到大量的改造，成本和风险过高。

### 额外的端口管理问题

某些不需要服务发现的业务方接入到 K8S 后，需要通过 node port 暴露服务入口。那么问题来了，为了避免端口冲突，暴露的端口往往是随机的，这就要求业务方需要额外的增加端口管理，动态维护 pod 对应宿主机端口信息。此外，这也给业务方的下游增加了复杂性，因为下游可能要经常变更访问的端口号。

### 用户体验问题

业务方常常需要 SSH 登陆到容器中定位问题。当容器运行在 flannel 网络模型下时，业务方访问容器的方式主要有三种：1. 通过 node port 访问，这种情况下需要业务方维护随机端口，增加了管理和使用的复杂性；2. 通过跳板机访问，这种方式需要引入了跳板机器；3. 通过 kube exec，这种情况下需要完善权限控制的机制，且 K8S 地升级会中断 SSH 连接。无论采用哪种方式，都带来额外的维护成本。

我们常常用 ping 包来检查目的主机是否可达，有些甚至用 ping 来作为主机是否宕机的标志。处于 flannel 下的 pod 无法被 ping 通，这也容易业务方的误解，增加沟通成本。

### flannel 性能问题

最后，flannel 还潜在网络性能问题，主要因为：

- 运行在用户态，增加了数据拷贝流程。每次处理报文时，需要将报文从内核态拷贝到用户态处理，处理完后再拷贝到内核态。
- 基于 UDP 封装的 overlay 报文，带来额外的封包和解包操作。
- 引入 service，增长网络链路。service 默认是通过 iptables 实现的，当条目过多时，iptables 存在性能问题。

从官网的[测试结果](https://github.com/coreos/flannel/issues/738)来看，采用 flannel 容器的网络带宽降低了 50%。从博文 [networking-solutions-for-kubernetes](http://machinezone.github.io/research/networking-solutions-for-kubernetes/) 测试结果来看，flannel 有一定概率出现较大的 latency，这将给公司某些对时延敏感的业务，如交易支付链路带来致命的影响。

## 感想

在私有云场景下，业务接入 PaaS 是一个循序渐进的过程，更是一个不断演讲的过程。为了让业务尽可能平滑的接入，PaaS 应适当考虑业务原场景和使用习惯，尽可能的避免业务方大幅度修改逻辑，如此业务方接入更为顺畅，沟通成本也更低。一些更高级的需求，如服务发现，故障恢复等等，可以待业务方接入之后再逐步用起来。

网络模型的选择是重中之重，让 Pod 和虚拟机物理机处于一个扁平互通的网络非常有必要，首先它避免了缺乏互通性带来的各种问题，降低业务的接入成本。其次，可以避免引入 service 模块，降低维护成本和潜在的性能风险。

和虚拟机一样，蘑菇街基于 neutron 的 VLAN 模型为容器提供网络，这使得容器的网络和虚拟机物理机在逻辑上处于同一个平面，互相可达，且 neutron 作为一个成熟的组件，稳定性高；社区基于 BGP 协议的 calico 等网络模型 ，也是一个潜在的选择，但是节点路由的数目与容器数目相同，不适合大规模场景。



# 参考资料

* [记一次 K8S 自研网络插件的泛洪问题](http://wsfdl.com/kubernetes/2018/12/12/network_flooding.html)
* [实现一个简单的SOCK V5代理服务器---协议](http://wsfdl.com/python/2016/08/19/SS5_protocol.html)
* [同局域网下的 Iptables DNAT](http://wsfdl.com/%E8%B8%A9%E5%9D%91%E6%9D%82%E8%AE%B0/2017/01/12/iptables_snat.html)
* [kubernetes的网络数据包流程](https://zhuanlan.zhihu.com/p/28289080)
* [Kubernetes网络原理](https://www.huweihuang.com/article/kubernetes/kubernetes-network/)

