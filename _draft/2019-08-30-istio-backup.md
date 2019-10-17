---
layout: post
title: istio 备忘
category: tech
tags: istio service_mesh
---
![](https://cdn.kelu.org/blog/tags/istio.jpg)

最近接触了一些 istio 的文章，在这里做个学习记录，方便个人回忆起来。

首先是istio的官网：<https://istio.io/zh/>

# service mesh

istio是 service mesh 概念落地的一个产品。那么什么是 service mesh 呢。

![kubernetes vs service mesh](https://jimmysong.io/istio-handbook/images/006tNc79ly1fz6c7pj4sqj31hk0rejuz.jpg)

service mesh 其实是对 pod 流量做了劫持，更细粒度地控制流量。在 kubernetes 中使用 kube-proxy 做流量转发，只不过 `kube-proxy` 拦截的是进出 Kubernetes 节点的流量，而 service mesh 拦截的是进出 Pod 的流量。

### service mesh劣势

将原先 `kube-proxy` 方式的路由转发功能置于每个 pod 中，将导致大量的配置分发、同步和最终一致性问题。为了细粒度地进行流量管理，必将添加一系列新的抽象，从而会进一步增加用户的学习成本。

### service mesh优势

`kube-proxy` 的设置都是全局生效的，无法对每个服务做细粒度的控制，而 Service Mesh 通过 sidecar proxy 的方式将 Kubernetes 中对流量的控制从 service 一层抽离出来，可以做更多的扩展。

### 解决了什么问题

服务网格（Service Mesh）这个术语通常用于描述构成这些应用程序的微服务网络以及应用之间的交互。随着规模和复杂性的增长，服务网格越来越难以理解和管理。

它的需求包括服务发现、负载均衡、故障恢复、指标收集和监控以及通常更加复杂的运维需求，例如 A/B 测试、金丝雀发布、限流、访问控制和端到端认证等。

Istio 提供了一个完整的解决方案，通过为整个服务网格提供行为洞察和操作控制来满足微服务应用程序的多样化需求。

# istio

Istio 服务网格逻辑上分为**数据平面**和**控制平面**。

- **数据平面**由一组以 sidecar 方式部署的智能代理（[Envoy](https://www.envoyproxy.io/)）组成。这些代理可以调节和控制微服务及 [Mixer](https://istio.io/zh/docs/concepts/policies-and-telemetry/) 之间所有的网络通信。
- **控制平面**负责管理和配置代理来路由流量。此外控制平面配置 Mixer 以实施策略和收集遥测数据。

下图显示了构成每个面板的不同组件：

![基于 Istio 的应用程序架构概览](https://istio.io/docs/concepts/what-is-istio/arch.svg)



# 一些资料

### [Service Mesh架构反思：数据平面和控制平面的界线该如何划定](<https://skyao.io/post/201804-servicemesh-architecture-introspection/>)

>为了让mixer能够工作，就需要envoy从每次请求中获取信息，然后发起两次对mixer的请求：
>
>1. 在转发请求之前：这时需要做前提条件检查和配额管理，只有满足条件的请求才会做转发
>2. 在转发请求之后：这时要上报日志等，术语上称为遥感信息，**Telemetry**，或者**Reporting**。
>
>
>
>... ...
>
>
>
>> 后端基础服务为构建的服务提供各种支持功能。这些功能包括访问控制系统、计量收集捕获系统、配额执行系统、计费系统等。传统服务会直接和这些后端系统打交道，与后端紧密耦合，并集成其中的个性化语义和用法。
>>
>> Mixer在应用程序代码和基础架构后端之间提供通用中介层。它的设计将策略决策移出应用层，用运维人员能够控制的配置取而代之。应用程序代码不再将应用程序代码与特定后端集成在一起，而是与Mixer进行相当简单的集成，然后Mixer负责与后端系统连接。
>>
>> Mixer的设计目的是改变层次之间的边界，以此来降低总体的复杂性。从服务代码中剔除策略逻辑，改由运维人员进行控制。
>
>非常优秀的设计，从系统架构上没得说，解开应用和后端基础设施的耦合，好处多多，这也是我们爱Istio的重要理由。
>
>但是，注意，这段文字解释的是：为什么要将这些功能从应用里面搬出来放进去service mesh和mixer。这点我举双手赞成，而我的疑问在于：这些逻辑从应用中移动到service mesh之后，为什么要放mixer中，而不是proxy？
>
>这就涉及到第二代service mesh的核心设计了：原有的sidecar被归结为data plane，然后在data plane上增加control plane。那么，最最重要的设计问题就来了，在这个架构中，从职责分工和部署上：
>
>**data plane和control plane的界限在哪里？**
>
>## Istio的选择
>
>当前，istio在这个问题上，选择的是非常理想化的划分方式：
>
>- data plane 只负责转发，其中部分数据来自Pilot和Auth。
>- 和后端基础设施相关的功能放置在mixer中，通过各种adapter实现
>
>这个方式架构清晰，职责分明，在不考虑性能时，无可挑剔。

### [Service Mesh - 熊人族猛男](https://krizss.github.io/post/2019/02/service-mesh/)

![rpc_1](https://krizss.github.io/images/2019/02/rpc_1.png)

> 在计算机网络发展的初期, 开发人员需要在自己的代码中处理服务器之间的网络连接问题, 包括流量控制, 缓存队列, 数据加密等. 在这段时间内底层网络逻辑和业务逻辑是混杂在一起. 随着技术的发展,TCP/IP 等网络标准的出现解决了流量控制等问题.尽管网络逻辑代码依然存在,但已经从应用程序里抽离出来,成为操作系统网络层的一部分, 形成了经典的网络分层模式.

![rpc_2](https://krizss.github.io/images/2019/02/rpc_2.png)



### [istio流量管理实现机制深度解析 - 赵化冰](https://zhaohuabing.com/post/2018-09-25-istio-traffic-management-impl-intro/)