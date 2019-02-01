---
layout: post
title: 从 k8s changelog 了解 k8s
category: tech
tags: docker kubernetes
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

本文从 k8s 的更新日志中了解 k8s 的变迁,，从版本跨度从1.2-1.10。GitHub 地址：<https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG.md>。

# v1.0 - 201507

Google宣布成立CNCF基金会，Kubernetes 1.0正式发布。已投入生产的Kubernetes有着如下特性：

APP服务，网络，存储

- 在生产环境中部署和管理工作负载，包括DNS、负载均衡、扩展、应用级别的健康检查和服务记录。
- 与各种本地和网络卷的状态应用支持，如谷歌计算引擎永久磁盘，AWS弹性块存储和NFS。
- 在pod中部署容器，pod与容器密切相关，支持简单更新和回滚。
- 用命令执行检查和调试应用，通过CLI和UI进行端口转发，日志收集，资源监控。

集群管理

- 实时升级以及扩展。
- 通过命名空间分割集群，更深层次的管控资源。例如，你可以将集群细分给不同的应用或测试生产环境。

性能和稳定性

- API响应速度快，平均容器调用时间小于5秒。
- 扩展测试，每个集群中，容器1000秒，节点100秒。
- 稳定的API

# v1.1 - 201511

# v1.2 - 201603

1. 显著增加集群规模

   支撑的集群规模增加400%。单个节点性能提升四倍。

2. 简化应用部署和管理

   1. Dynimic Configuration 功能（动态配置）。
   2. TurnKey Deployments 应用部署和滚动升级的自动化。

3. 自动化集群管理

   1. 在同一个云平台上实现跨区扩展。一个Service下的Pod会自动扩展到其它可用区，从而做到跨区容错。
   2. 简化One-Pod-Per-Node应用的部署管理（通过Extensions API中的DaemonSet API实现）。Kubernetes的调度机制能够保证一个应用每个节点上运行同样的Pod，并且只运行一个，比如logging agent。
   3. 支持TLS和7层网络（通过Extensions API中的ingress API实现，目前为Beta版）。基于TLS和基于HTTP的七层网络路由，Kubernetes可以更方便地集成到传统的网络环境中。
   4. 支持Graceful Node Shutdown（及Node Drain）。新增的“kubelet drain”命令可以很优雅地将pod从某些节点驱逐出去，从而为节点维护做准备（比如升级kernel
   5. 支持自定义Autoscaling的指标（通过Autoscaling API中的HorizontalPodAutoscaler API实现）。Horizontal Pod Autoscaling支持自定义模版（目前为Alpha版），允许用户指定应用级别的指标和应用自动伸缩的阈值。
   6. 新的控制台（dashboard）具备与kubelet commandline类似的功能，允许用户通过一种新方式与kubernetes集群交互。

其它重要的改进

* Job在v1.1中为Beta版，在1.2中可以投入生产环境。
* Kube-Proxy默认采用基于iptables的方式。
* 可以在kubelet中设置系统保留资源来提高Node节点的稳定性。参数为 –system-reserved 和 –kube-reserved。
* Liveness和readiness探针支持更多的参数选项，包括periodSeconds、successThreshold和failureThreshold。
* 新的ReplicaSet API（Extensions API中，目前处于Beta版）
* 命令kubelet run默认产生Deployments（而不是ReplicationControllers）和Jobs（而不是Pods）对象。
* Pods能够使用环境变量中的Secret数据，并将其作为commandline参数传递给container
* 产生Heapster的稳定版，并支持最多1000个节点：更多的监控指标、减少延迟、减少CPU和内存消耗（大约4M每个节点）。

# v1.3 - 201607

该版本包含的特性主要是为了实现两个用户愿望：

* 一个是跨集群、区域和云边界部署服务；
* 另一个是在容器中运行更为多样化的工作负载，包括有状态服务。

新特性：

- 提升规模和自动化——允许用户根据应用程序需求自动向上和向下扩展他们的服务。简化集群的自动向上和向下扩展，并且将每个集群的最大节点数量提升至原来的两倍。

- 有状态应用程序的alpha支持—— Kubernetes API新增了一个“[PetSet](http://kubernetes.io/docs/user-guide/petset/)”对象：

- - 多次重启也不会变化的永久性主机名；
  - 自动为每个容器配置永久性磁盘，可以在容器生命周期结束后继续存在；
  - 组内唯一标识，允许群集和群首选举；
  - 初始化容器，对启动集群应用程序至关重要。

- 简化本地开发——引入了[Minikube](https://github.com/kubernetes/minikube)，只要一条命令，开发人员就可以在笔记本上启动一个本地Kubernetes集群，而且与一个完整Kubernetes集群的API兼容。

- 支持[rkt](https://github.com/coreos/rkt)容器镜像和OCI&[CNI ](https://github.com/containernetworking/cni)容器标准。

- 更新dashboard UI。

# v1.4 - 201609

- 创建kubernetes集群只需要两条命令
- 增强了对有状态应用的支持
- 增加了集群联盟(Federation)API
  - 跨kubernetes集群均匀的调度任务负载
  - 将一个最便宜的kubernetes集群的工作负载进行最大化，如果超出了这个kubernetes集群的承受能力，那么将额外的工作负载路由到一个更昂贵的kubernetes集群中
  - 根据应用地理区域需求，调度工作负载到不同的kubernetes集群中，对于不同的终端用户，提供更高的带宽和更低的延迟。
- 支持容器安全控制
- 增强包括调度在内的Kubernetes基础架构
- 通过Kubernetes DashBoard UI已经可以实现90%的命令行操作

# v1.5 - 201612

1、API 机制

- [beta] kube-apiserver支持OpenAPI从alpha移动到beta, 第一个non-go客户端是基于此特性。

2、应用

- [Stable]当replica sets不能创建Pods时，它们将通过API报告失败的详细底层原因。
- [Stable] kubectl apply现可通过–prune删除不再需要的资源
- [beta] Deployments现可通过API升级到新版本，而之前是无法通过滚动来进行升级的
- [beta] StatefulSets（原PetSet）允许要求持久化identity或单实例存储的工作负载从而在Kubernetes创建和管理。
- [beta]为了提供安全保障，集群不会强行删除未响应节点上的Pods，如果用户通过CLI强行删除Pods会收到警告。

3、认证

- [Alpha]改进了基于角色的访问控制alpha API。（包括一组默认的集群角色）
- [Beta]添加了对Kubelet API访问的认证/授权机制。

4、AWS

- [stable]角色出现在kubectl get nodes的结果里。

5、集群生命周期

- [alpha] 提升了kubeadm二进制包的交互和可用性，从而更易于新建一个运行集群。

6、集群运维

- [alpha] 在GCE上使用kube-up/kube-down脚本来创建/移除集群高可用（复制）的主节点。

7、联邦

- [beta] 支持联邦ConfigMaps。
- [alpha] 支持联邦Daemonsets。
- [alpha] 支持联邦Deployments。
- [alpha]集群联邦：为联邦资源添加对于DeleteOptions.OrphanDependents的支持。
- [alpha]引入新命令行工具：kubefed，简化联邦控制台的部署以及集群注册/注销体验。

8、网络

- [stable]服务可以通过DNS名称被其他服务引用，而不是只有在pods里才可以。
- [beta]为NodePort类型和LoadBalancer的服务保留源IP的选项。
- [stable]启用beta ConfigMap参数支持的DNS水平自动伸缩

9、节点

- [alpha]支持在容器运行时启用用户命名空间重映射的时候，保留对宿主用户命名空间的访问。
- [alpha]引入了v1alpha1版本的CRI(容器运行时接口) API，它允许可插拔的容器运行时；现有一个已经就绪的用于测试和反馈的docker-CRI集成。
- [alpha]Kubelet基于QoS层在每个Pod的CGroup层级里启动容器。
- [beta]Kubelet集成了memcg提示消息API，来检测是否超过阈值。
- [beta]引入了Beta版本的容器化节点一致性测试: gcr.io/google_containers/node-test:0.2。从而让用户验证node设置。

10、调度

- [alpha]添加了对不透明整数资源(node级)的审计支持。
- [beta] PodDisruptionBudget已经升级到Beta版，当想要应用SLO时，可以用来安全地drain节点。

11、UI

- [stable]Dashboard UI如今显示面向用户的对象及它们的资源使用情况。

12、Windows

- [alpha]添加了对Windows Server 2016节点和调度Windows Server Container的支持。

# v1.6 - 201703

1. 扩大集群规模，加强集群联邦功能

   将Kubernetes底层架构预设改成etcd v3版本，可支持的集群规模也扩大至5,000个节点，可支持的Pod规模也增加到15万个

2. 靠角色访问控制机制加强安全

   直接用API来取得不同账号的权限管理政策，来控制使用者账号或服务，可将系统资源指派给特定命名空间，让所属账号来存取。

3. 储存动态分配

   PV PVC StorageClass

4. 强化使用者对Pod的控制

   指定每个Pod一个节点标签（Node Label），限制Pod只能在特定节点中运行，也可以将Pod排除于特定节点上运作。

5. 更新容器Runtime接口及常驻程序

# v1.7 - 20170629

转自<https://jimmysong.io/kubernetes-handbook/appendix/kubernetes-1.7-changelog.html>

2017年6月29日，kuberentes1.7发布。该版本的kubernetes在安全性、存储和可扩展性方面有了很大的提升。改版本的详细更新文档请查看[Changelog](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG-1.7.md)。

这些新特性中包含了安全性更高的加密的secret、pod间通讯的网络策略，限制kubelet访问的节点授权程序以及客户端/服务器TLS证书轮换。

对于那些在Kubernetes上运行横向扩展数据库的人来说，这个版本有一个主要的特性，可以为StatefulSet添加自动更新并增强DaemonSet的更新。我们还宣布了对本地存储的Alpha支持，以及用于更快地缩放StatefulSets的突发模式。

此外，对于高级用户，此发行版中的API聚合允许使用用于自定义的API与API server同时运行。其他亮点包括支持可扩展的准入控制器，可插拔云供应商程序和容器运行时接口（CRI）增强功能。

## 新功能

**安全**

- [Network Policy API](https://kubernetes.io/docs/concepts/services-networking/network-policies/) 提升为稳定版本。用户可以通过使用网络插件实现的网络策略来控制哪些Pod之间能够互相通信。
- [节点授权](https://kubernetes.io/docs/admin/authorization/node/)和准入控制插件是新增加的功能，可以用于限制kubelet可以访问的secret、pod和其它基于节点的对象。
- [加密的Secret](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/)和etcd中的其它资源，现在是alpha版本。
- [Kubelet TLS bootstrapping](https://kubernetes.io/docs/admin/kubelet-tls-bootstrapping/)现在支持客户端和服务器端的证书轮换。
- 由API server存储的[审计日志](https://kubernetes.io/docs/tasks/debug-application-cluster/audit/)现在更具可定制性和可扩展性，支持事件过滤和webhook。它们还为系统审计提供更丰富的数据。

**有状态负载**

- [StatefulSet更新](https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/#updating-statefulsets)是1.7版本的beta功能，它允许使用包括滚动更新在内的一系列更新策略自动更新诸如Kafka，Zookeeper和etcd等有状态应用程序。
- StatefulSets现在还支持对不需要通过[Pod管理策略](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#pod-management-policies)进行排序的应用程序进行快速扩展和启动。这可以是主要的性能改进。
- [本地存储](https://kubernetes.io/docs/concepts/storage/volumes/#local)（alpha）是有状态应用程序最常用的功能之一。用户现在可以通过标准的PVC/PV接口和StatefulSet中的StorageClass访问本地存储卷。
- DaemonSet——为每个节点创建一个Pod，现在有了更新功能，在1.7中增加了[智能回滚和历史记录](https://kubernetes.io/docs/tasks/manage-daemon/rollback-daemon-set/)功能。
- 新的[StorageOS Volume插件](https://kubernetes.io/docs/concepts/storage/volumes/#storageos)可以使用本地或附加节点存储中以提供高可用的集群范围的持久卷。

**可扩展性**

- 运行时的[API聚合](https://kubernetes.io/docs/concepts/api-extension/apiserver-aggregation/)是此版本中最强大的扩展功能，允许高级用户将Kubernetes风格的预先构建的第三方或用户创建的API添加到其集群中。
- [容器运行时接口](https://github.com/kubernetes/community/blob/master/contributors/devel/container-runtime-interface.md)（CRI）已经增强，可以使用新的RPC调用从运行时检索容器度量。 [CRI的验证测试](https://github.com/kubernetes/community/blob/master/contributors/devel/cri-validation.md)已经发布，与[containerd](http://containerd.io/)进行了Alpha集成，现在支持基本的生命周期和镜像管理。参考[深入介绍CRI](http://blog.kubernetes.io/2016/12/container-runtime-interface-cri-in-kubernetes.html)的文章。

**其它功能**

- 引入了对[外部准入控制器](https://kubernetes.io/docs/admin/extensible-admission-controllers/)的Alpha支持，提供了两个选项，用于向API server添加自定义业务逻辑，以便在创建对象和验证策略时对其进行修改。
- [基于策略的联合资源布局](https://kubernetes.io/docs/tasks/federation/set-up-placement-policies-federation/)提供Alpha版本，用于根据自定义需求（如法规、定价或性能）为联合（federated）集群提供布局策略。

**弃用**

- 第三方资源（TPR）已被自定义资源定义（Custom Resource Definitions，CRD）取代，后者提供了一个更清晰的API，并解决了TPR测试期间引发的问题和案例。如果您使用TPR测试版功能，则建议您[迁移](https://kubernetes.io/docs/tasks/access-kubernetes-api/migrate-third-party-resource/)，因为它将在Kubernetes 1.8中被移除。

# v1.8 - 20170928

2017年9月28日，kubernetes1.8版本发布。该版本中包括了一些功能改进和增强，并增加了项目的成熟度，将强了kubernetes的治理模式，这些都将有利于kubernetes项目的持续发展。

聚焦安全性

Kubernetes1.8的[基于角色的访问控制（RBAC）](https://en.wikipedia.org/wiki/Role-based_access_control)成为stable支持。RBAC允许集群管理员[动态定义角色](https://kubernetes.io/docs/admin/authorization/rbac/)对于Kubernetes API的访问策略。通过[网络策略](https://kubernetes.io/docs/concepts/services-networking/network-policies/)筛选出站流量的Beta支持，增强了对入站流量进行过滤的现有支持。 RBAC和网络策略是强化Kubernetes内组织和监管安全要求的两个强大工具。

Kubelet的传输层安全性（TLS）[证书轮换](https://kubernetes.io/docs/admin/kubelet-tls-bootstrapping/)成为beta版。自动证书轮换减轻了集群安全性运维的负担。

聚焦工作负载支持

Kubernetes 1.8通过apps/v1beta2组和版本推动核心工作负载API的beta版本。Beta版本包含当前版本的Deployment、DaemonSet、ReplicaSet和StatefulSet。 工作负载API是将现有工作负载迁移到Kubernetes以及开发基于Kubernetes的云原生应用程序提供了基石。

对于那些考虑在Kubernetes上运行大数据任务的，现在的工作负载API支持运行kubernetes[原生支持的Apache Spark](https://apache-spark-on-k8s.github.io/userdocs/)。

批量工作负载，比如夜间ETL工作，将从[CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)的beta版本中受益。

[自定义资源定义（CRD）](https://kubernetes.io/docs/concepts/api-extension/custom-resources/)在Kubernetes 1.8中依然为测试版。CRD提供了一个强大的机制来扩展Kubernetes和用户定义的API对象。 CRD的一个用例是通过Operator Pattern自动执行复杂的有状态应用，例如[键值存储](https://github.com/coreos/etcd-operator)、数据库和[存储引擎](https://rook.io/)。随着稳定性的继续推进，预计将继续加强对CRD的[验证](https://kubernetes.io/docs/tasks/access-kubernetes-api/extend-api-custom-resource-definitions/#validation)。

更多

Volume快照、PV调整大小、自动taint、pod优先级、kubectl插件等！

# v1.9 - 20171215

2017年12月15日，kubernetes1.9版本发布。Kubernetes依然按照每三个月一个大版本发布的速度稳定迭代，这是今年发布的第四个版本，也是今年的最后一个版本，该版本最大的改进是Apps Workloads API成为稳定版本，这消除了很多潜在用户对于该功能稳定性的担忧。还有一个重大更新，就是测试支持了Windows了，这打开了在kubernetes中运行Windows工作负载的大门。

* Workloads API GA

  [apps/v1 Workloads API](https://kubernetes.io/docs/reference/workloads-18-19/)成为GA（General Availability），且默认启用。 Apps Workloads API将**DaemonSet**、**Deployment**、**ReplicaSet**和**StatefulSet** API组合在一起，作为Kubernetes中长时间运行的无状态和有状态工作负载的基础。

  Deployment和ReplicaSet是Kubernetes中最常用的两个对象，经过一年多的实际使用和反馈后，现在已经趋于稳定。[SIG apps](https://github.com/kubernetes/community/tree/master/sig-apps)同时将这些经验应用到另外的两个对象上，使得DaemonSet和StatefulSet也能顺利毕业走向成熟。v1（GA）意味着已经生产可用，并保证长期的向后兼容。

* Windows支持（beta）

  Kubernetes最初是为Linux系统开发的，但是用户逐渐意识到容器编排的好处，我们看到有人需要在Kubernetes上运行Windows工作负载。在12个月前，我们开始认真考虑在Kubernetes上支持Windows Server的工作。 [SIG-Windows](https://github.com/kubernetes/community/tree/master/sig-windows)现在已经将这个功能推广到beta版本，这意味着我们可以评估它的[使用情况](https://kubernetes.io/docs/getting-started-guides/windows/)。

* 增强存储

  kubernetes从第一个版本开始就支持多种持久化数据存储，包括常用的NFS或iSCSI，以及对主要公共云和私有云提供商的存储解决方案的原生支持。随着项目和生态系统的发展，Kubernetes的存储选择越来越多。然而，为新的存储系统添加volume插件一直是一个挑战。

  **容器存储接口（CSI）**是一个跨行业标准计划，旨在降低云原生存储开发的障碍并确保兼容性。 [SIG-Storage](https://github.com/kubernetes/community/tree/master/sig-storage)和[CSI社区](https://github.com/container-storage-interface/community)正在合作提供一个单一接口，用于配置、附着和挂载与Kubernetes兼容的存储。

  Kubernetes 1.9引入了容器存储接口（CSI）的alpha实现，这将使挂载新的volume插件就像部署一个pod一样简单，并且第三方存储提供商在开发他们的解决方案时也无需修改kubernetes的核心代码。

  由于该功能在1.9版本中为alpha，因此必须明确启用该功能，不建议用于生产使用，但它为更具扩展性和基于标准的Kubernetes存储生态系统提供了清晰的路线图。

* 其它功能

  自定义资源定义（CRD）校验，现在已经成为beta，默认情况下已启用，可以用来帮助CRD作者对于无效对象定义给出清晰和即时的反馈。

  SIG Node硬件加速器转向alpha，启用GPU，从而实现机器学习和其他高性能工作负载。

  CoreDNS alpha可以使用标准工具来安装CoreDNS。

  kube-proxy的IPVS模式进入beta版，为大型集群提供更好的可扩展性和性能。

  社区中的每个特别兴趣小组（SIG）继续提供其所在领域的用户最迫切需要的功能。有关完整列表，请访问[发行说明](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG.md#v190)。

# v1.10 - 20180326

2018年3月26日，kubernetes1.10版本发布，这是2018年发布的第一个版本。该版本的Kubernetes主要提升了Kubernetes的成熟度、可扩展性与可插入性。

该版本提升了三大关键性功能的稳定度，分别为存储、安全与网络。另外，此次新版本还引入了外部kubectl凭证提供程序（处于alpha测试阶段）、在安装时将默认的DNS服务切换为CoreDNS（beta测试阶段）以及容器存储接口（简称CSI）与持久化本地卷的beta测试版。

下面再分别说下三大关键更新。

* 存储
  * CSI（容器存储接口）迎来Beta版本，可以通过插件的形式安装存储。
  * 持久化本地存储管理也迎来Beta版本。
  * 对PV的一系列更新，可以自动阻止Pod正在使用的PVC的删除，阻止已绑定到PVC的PV的删除操作，这样可以保证所有存储对象可以按照正确的顺序被删除。
* 安全
  * kubectl可以对接不同的凭证提供程序
  * 各云服务供应商、厂商以及其他平台开发者现在能够发布二进制插件以处理特定云供应商IAM服务的身价验证
* 网络
  * 将原来的kube-dns切换为CoreDNS