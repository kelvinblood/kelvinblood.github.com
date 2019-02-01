---
layout: post
title: kubernetes 简介
category: tech
tags: virtualization kubernetes docker
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

kubernetes 网上的资料良莠不均，刚开始表示完全不知道从何入手。最近在入门中，将一些资料做了整理，精简了大部分得出了这一篇文章。可以参照文末参考资料查看原文。当前最新版的k8s版本为：1.10.

# 一 什么是Kubernetes？

Kubernetes（k8s）是 google 开源的一套自动化容器管理平台，前身是 Borg，用于容器的部署、自动化调度和集群管理。

## 为什么使用容器？

传统的应用部署方式是通过插件或脚本来安装应用。这样做的缺点是应用的运行、配置、管理、所有生存周期将与当前操作系统绑定，这样做并不利于应用的升级更新/回滚等操作，当然也可以通过创建虚机的方式来实现某些功能，但是虚拟机非常重，并不利于可移植性。

新的方式是通过部署容器方式实现，每个容器之间互相隔离，每个容器有自己的文件系统 ，容器之间进程不会相互影响，能区分计算资源。相对于虚拟机，容器能快速部署，由于容器与底层设施、机器文件系统解耦的，所以它能在不同云、不同版本操作系统间进行迁移。

![为什么使用容器](https://cdn.kelu.org/blog/2018/05/why_containers.svg)

## kubernetes能做什么？

Kubernetes能提供一个以“**容器为中心的基础架构**”，可以在物理或虚拟机的Kubernetes集群上运行容器化应用，满足在生产环境中运行应用的一些常见需求：负载均衡、服务发现、高可用、滚动升级、自动伸缩等。

## kubernetes不能做什么？

- Kubernetes不提供中间件（如message buses）、数据处理框架（如Spark）、数据库(如Mysql)或者集群存储系统(如Ceph)作为内置服务。但这些应用都可以运行在Kubernetes上面。
- Kubernetes 不部署源码不编译应用。持续集成的 (CI)工作流方面，不同的用户有不同的需求和偏好的区域，因此，我们提供分层的 CI工作流，但并不定义它应该如何工作。
- Kubernetes 允许用户选择自己的日志、监控和报警系统。
- Kubernetes 不提供或授权一个全面的应用程序配置 语言/系统。
- Kubernetes 不提供任何机器配置、维护、管理或者自修复系统。

## Kubernetes是什么意思？

Kubernetes 实际上是一个希腊词κυβερνήτης, 意思是"船的舵手"。*K8s*是将中间8个字母“ubernete”替换为“8”的缩写。

# 二 Kubernetes 架构

一个K8s集群是由分布式存储（etcd）、服务节点（Node）和控制节点（Master）构成的。所有的集群状态都保存在etcd中，Master节点上则运行集群的管理控制模块。Node节点是真正运行应用容器的主机节点，在每个Minion节点上都会运行一个Kubelet代理，控制该节点上的容器、镜像和存储卷等。

![](https://cdn.kelu.org/blog/2018/05/000.jpg)



Master 节点：:

Master 是 Kubernetes Cluster 的大脑，运行着如下 Daemon 服务：

* kube-apiserver

  Kubernetes Cluster 的前端接口，各种客户端工具（CLI 或 UI）以及 Kubernetes 其他组件可以通过它管理 Cluster 的各种资源。

* kube-scheduler

  负责决定将 Pod 放在哪个 Node 上运行。Scheduler 在调度时会充分考虑 Cluster 的拓扑结构，当前各个节点的负载，以及应用对高可用、性能、数据亲和性的需求。

* kube-controller-manager

  负责管理 Cluster 各种资源，保证资源处于预期的状态。

* etcd

  负责保存 Kubernetes Cluster 的配置信息和各种资源的状态信息。当数据发生变化时，etcd 会快速地通知 Kubernetes 相关组件。

* Pod 网络

  Pod 要能够相互通信，Kubernetes Cluster 必须部署 Pod 网络，flannel 是其中一个可选方案。

Node节点：

Node 是 Pod 运行的地方，Kubernetes 支持 Docker、rkt 等容器 Runtime。 Node上运行的 Kubernetes 组件有 

* kubelet

  kubelet 是 Node 的 agent，当 Scheduler 确定在某个 Node 上运行 Pod 后，会将 Pod 的具体配置信息（image、volume 等）发送给该节点的 kubelet，kubelet 根据这些信息创建和运行容器，并向 Master 报告运行状态。

* kube-proxy

  service 在逻辑上代表了后端的多个 Pod，外界通过 service 访问 Pod。

   kube-proxy 就是负责将访问 service 的 TCP/UPD 数据流转发到后端的容器。如果有多个副本，kube-proxy 会实现负载均衡。

* Pod 网络





K8s在实现上述架构时基于以下架构理念：

- 只有API Server与存储通信，其他模块通过API Server访问集群状态。这样第一，是为了保证集群状态访问的安全。第二，是为了隔离集群状态访问的方式和后端存储实现的方式：API Server是状态访问的方式，不会因为后端存储技术etcd的改变而改变。加入以后将etcd更换成其他的存储方式，并不会影响依赖依赖API Server的其他K8s系统模块。
- 一个工作节点被攻破不能导致整个K8s集群被攻破。这是所有分布式系统架构设计中都应该考虑的问题。
- 考虑网络随时可能断开的情况，没有新配置声明时各模块按照之前的配置声明继续工作。在K8s集群中，所有的配置管理操作都声明式而非命令式的，因为声明式操作对于网络故障等分布式系统常见的故障情况更加稳定。
- 各个模块在内存中缓存自己的相关状态以提高系统性能。
- 需要监控某个系统状态来做下一步动作的时候，优先考虑观察通知模式，其次再考虑轮询模式，这也是为了提高系统的响应速度。

## 分层架构

Kubernetes设计理念和功能其实就是一个类似Linux的分层架构，如下图所示

![img](https://cdn.kelu.org/blog/2018/05/kubernetes2.jpg)

- 核心层：Kubernetes最核心的功能，对外提供API构建高层的应用，对内提供插件式应用执行环境
- 应用层：部署（无状态应用、有状态应用、批处理任务、集群应用等）和路由（服务发现、DNS解析等）
- 管理层：系统度量（如基础设施、容器和网络的度量），自动化（如自动扩展、动态Provision等）以及策略管理（RBAC、Quota、PSP、NetworkPolicy等）
- 接口层：kubectl命令行工具、客户端SDK以及集群联邦
- 生态系统：在接口层之上的庞大容器集群管理调度的生态系统，可以划分为两个范畴
  - Kubernetes外部：日志、监控、配置管理、CI、CD、Workflow、FaaS、OTS应用、ChatOps等
  - Kubernetes内部：CRI、CNI、CVI、镜像仓库、Cloud Provider、集群自身的配置和管理等



# Kubernetes的核心技术概念

API对象是K8s集群中的管理操作单元。K8s集群系统每支持一项新功能，引入一项新技术，一定会新引入对应的API对象，支持对该功能的管理操作。

每个API对象都有3大类属性：

* 元数据metadata，用来标识API对象，每个对象都至少有3个元数据：namespace，name和uid。

  除此以外还有各种各样的标签labels用来标识和匹配不同的对象，例如用户可以用标签env来标识区分不同的服务部署环境，分别用env=dev、env=testing、env=production来标识开发、测试、生产的不同服务。

* 规范spec

  规范描述了用户期望K8s集群中的分布式系统达到的理想状态（Desired State），例如用户可以通过复制控制器Replication Controller设置期望的Pod副本数为3。

* 状态status

  status描述了系统实际当前达到的状态（Status），例如系统当前实际的Pod副本数为2；那么复制控制器当前的程序逻辑就是自动启动新的Pod，争取达到副本数为3。



K8s中所有的配置都是通过API对象的spec去设置的，也就是用户通过配置系统的理想状态来改变系统，这是k8s重要设计理念之一，即所有的操作都是声明式（Declarative）的而不是命令式（Imperative）的。

声明式操作在分布式系统中的好处是稳定，不怕丢操作或运行多次，例如设置副本数为3的操作运行多次也还是一个结果，而给副本数加1的操作就不是声明式的，运行多次结果就错了。


# 概念

1. Pod

   Pod是在K8s集群中运行部署应用或服务的最小单元，每个 Pod 包含一个或多个容器。Pod 中的容器会作为一个整体被 Master 调度到一个 Node 上运行。

2.  Controller

   Kubernetes 通常不会直接创建 Pod，而是通过 Controller 来管理 Pod 的。Controller 中定义了 Pod 的部署特性，比如有几个副本，在什么样的 Node 上运行等。为了满足不同的业务场景，Kubernetes 提供了多种 Controller。

   * Deployment 管理 Pod 的多个副本，并确保 Pod 按照期望的状态运行。
   * ReplicaSet  实现了 Pod 的多副本管理。
   * DaemonSet 用于每个 Node 最多只运行一个 Pod 副本的场景。
   * StatefuleSet 保证 Pod 的每个副本在整个生命周期中名称是不变的。而其他 Controller 不提供这个功能，当某个 Pod 发生故障需要删除并重新启动时，Pod 的名称会发生变化。同时 StatefuleSet 会保证副本按照固定的顺序启动、更新或者删除。
   * Job ：用于运行结束就删除的应用。而其他 Controller 中的 Pod 通常是长期持续运行。

3. Service

   Deployment 可以部署多个副本，每个 Pod 都有自己的 IP，每次销毁重启时IP都会发生变化。

   而 Service 定义了外界访问一组特定 Pod 的方式。Service 有自己的 IP 和端口，Service 为 Pod 提供了负载均衡。

   Kubernetes 运行容器（Pod）与访问容器（Pod）这两项任务分别由 Controller 和 Service 执行。

4. Namespace

   Namespace 为K8s集群提供虚拟的隔离作用。Namespace 可以将一个物理的 Cluster 逻辑上划分成多个虚拟 Cluster，每个 Cluster 就是一个 Namespace。不同 Namespace 里的资源是完全隔离的。



# 用 kubeadm 创建 Cluster

这里只做一些概念描述，具体步骤会再开一篇新文章描述。这部分摘自《[部署 k8s Cluster（上）- 每天5分钟玩转 Docker 容器技术（118）](http://www.cnblogs.com/CloudMan6/p/8269620.html)》有删减。

* kubelet 运行在 Cluster 所有节点上，负责启动 Pod 和容器。

* kubeadm 用于初始化 Cluster。

* kubectl 是 Kubernetes 命令行工具。

  通过 kubectl 可以部署和管理应用，查看各种资源，创建、删除和更新各种组件。

1. 初始化master

   ```
   kubeadm init --apiserver-advertise-address 192.168.56.105 --pod-network-cidr=10.244.0.0/16

   --apiserver-advertise-address 指明用 Master 的哪个 interface 与 Cluster 的其他节点通信。如果 Master 有多个 interface，建议明确指定，如果不指定，kubeadm 会自动选择有默认网关的 interface。

   --pod-network-cidr 指定 Pod 网络的范围。Kubernetes 支持多种网络方案，而且不同网络方案对 --pod-network-cidr 有自己的要求，这里设置为 10.244.0.0/16 是因为我们将使用 flannel 网络方案，必须设置成这个 CIDR。在后面的实践中我们会切换到其他网络方案，比如 Canal。
   ```

   初始化做的事情有:

   ① kubeadm 执行初始化前的检查。

   ② 生成 token 和证书。

   ③ 生成 KubeConfig 文件，kubelet 需要这个文件与 Master 通信。

   ④ 安装 Master 组件，会从 goolge 的 Registry 下载组件的 Docker 镜像，这一步可能会花一些时间，主要取决于网络质量。

   ⑤ 安装附加组件 kube-proxy 和 kube-dns。

   ⑥ Kubernetes Master 初始化成功。

   ⑦ 提示如何配置 kubectl。

   ⑧ 提示如何安装 Pod 网络。

   ⑨ 提示如何注册其他节点到 Cluster。

2. 配置 kubectl

3. 安装 Pod 网络

   要让 Kubernetes Cluster 能够工作，必须安装 Pod 网络，否则 Pod 之间无法通信。

   Kubernetes 支持多种网络方案，例如 flannel 和 Canal。

4. 注册其他节点到 Cluster

几乎所有的 Kubernetes 组件本身也运行在 Pod 里，kubelet 是唯一没有以容器形式运行的 Kubernetes 组件，它在 Ubuntu 中通过 Systemd 运行。


附录：

# 云计算与弹性伸缩

从云计算的定义出发，云计算系统一个基本特性就是计算能力的弹性和伸缩性。弹性和伸缩性的意思是能够根据实际的需要，随时增多或减少计算能力。弹性伸缩针对不同的处理对象，有不同的伸缩模式，如下图，分别处于X、Y、Z轴3个不同维度。

1. 对于同一类事物的无状态服务，数据不需要持久化，处理结果不需要保存在信息系统中，可以通过X轴计算实例的**水平复制**进行伸缩，这就是Kubernetes系统中Replication Controller和ReplicaSet所完成的功能；举例说明，一个电子商务系统的下订单服务，本身只是做订单处理但不存储数据的无状态服务，这个微服务就可以用水平复制的模式来伸缩。

2. 对于同一类事物的有状态服务，数据存储的内容各不相同，身份也各不相同，可以通过Z轴存储实例的**数据分片**进行伸缩，这就是Kuberenetes的PetSet或者StatefulSet所完成的功能；举例说明，下订单服务的订单数据存储在MySQL数据库中，要想增加订单数据存储的能力，就需要对针对订单数据库表进行数据分片。

   > tips: 何为数据分片（segment，fragment， shard， partition），就是按照一定的规则，将数据集划分成相互独立、正交的数据子集，然后将数据子集分布到不同的节点上。注意，数据分片需要按照一定的规则，不同的分布式应用有不同的规则，但都遵循同样的原则：按照最主要、最频繁使用的访问方式来分片。)

3. 对于不同类别事物的处理，则需要通过Y轴的功能分割来进行伸缩，Y轴的分割也称为**垂直分割**；举例说明，一个完整的电子商务系统，可以根据业务功能分割成用户管理、购物车管理、订单管理、产品目录管理、库存管理、支付管理、配送管理等多个独立的微服务。需要说明的是，**功能分割（Y轴）是水平复制（X轴）和数据分片（Z轴）的前提**，只有通过功能分割解耦将不同的事物分割出来，才能针对同一事物进行水平复制或数据分片。

![4bd0da72f12b4c47834228a74a169ca219208981](https://cdn.kelu.org/blog/2018/05/4b.jpg)

### 容器与微服务架构

微服务架构的理念，是将一个完整的应用，按照业务拆分成彼此独立的模块以支撑服务的独立开发、部署和伸缩。

微服务分割也就是业务功能分割。微服务分割和传统软件模块分割的一大区别是，

微服务分割强调领域数据模型的分割，也就是数据存储服务的分割，以保证不同微服务之间没有持久化数据方面的依赖性，从而使得不同的微服务真正可以在运行时独立进行部署和伸缩。

传统的软件模块分割，比较多的是考虑代码的重用性和各模块开发的独立性，但因为并没有为超高用户压力的弹性要求做准备，比较少考虑数据持久化层面的伸缩性。

而如前所述，Y轴业务功能分割是Z轴数据分片的前提，因此要想真正应对超高用户压力的弹性计算要求，进行业务功能分割是第一步。

# 参考资料

* [Kubernetes中文社区 中文文档](http://docs.kubernetes.org.cn/)
* [Kubernetes与云原生应用](http://www.infoq.com/cn/articles/kubernetes-and-cloud-native-applications-part01)
* [Kubernetes Documentation](https://kubernetes.io/)
* [使用 Kubernetes 进行可扩展微服务](https://cn.udacity.com/course/scalable-microservices-with-kubernetes--ud615)
* [awesome-kubernetes](https://ramitsurana.github.io/awesome-kubernetes/)
* [k8s 重要概念 - 每天5分钟玩转 Docker 容器技术（117）](http://www.cnblogs.com/CloudMan6/p/8252204.html)
* <https://steemit.com/@cloudman6>