---
layout: post
title: 深度解密京东登月平台基础架构 - 京东
category: product
tags: docker kubernetes 
---

近日，京东发布登月机器学习平台，并在京东云上线，正式对外提供人工智能服务。登月机器学习平台的上线代表着京东人工智能技术从应用级服务到基础算法的全面对外开放，实践着京东RaaS（零售即服务）的发展策略。今天我们邀请了AI与大数据部的工程师为大家深度解密京东登月平台基础架构。

从2016年9月开始，京东AI基础平台部基于Kubernetes和Docker构建机器学习平台的底层架构，后续逐步完善和优化了网络、GPU管理、存储、日志、监控、权限管理等功能。目前集群管理的容器实例数量有5K+，至今已上线运行了20多个AI前向服务（50多个API），同时为后向训练提供支持，在618大促中表现高效稳定。

架构

登月平台的基础架构以Docker+Kubernetes为中心，底层基础设施包括CPU、GPU、FPGA计算资源，IB、OPA高速互联网络以及多样化的文件系统，之上是机器学习框架和算法库，最上层是业务应用。管理中心包括权限管理、任务管理、流程管理、监控中心、日志中心。

平台整体设计思想是Kubernetes调度一切，应具有以下特性（为了方便起见所有的inference类型的应用我们称为App，所有training类型的应用我们称为Job）：

- **高可用、负载均衡。**大量的inference App运行在容器中，需要保证App能够稳定高效的对外提供服务。

- **应用打包与隔离。**研究人员、开发人员将自己的代码打包成image，方便的进行CI/CD，透明的将自己的App运行于平台中。

- **自动扩容/缩容，training/inference用同一批机器调度。**白天有许多活跃的用户，平台应该扩展更多inference App，而到了晚上，应该将更多的资源分配给training Job。

- **作为大数据调度平台。**平台不仅可以原生的调度Tensorflow/Caffe/XGBoost/MXNet等机器学习、深度学习工具包，也应该将Hadoop/Spark系列的大数据生态系统调度在Kubernetes中。

- **支持丰富的硬件资源类型。**根据不同的App，Job类型，应该使用不同的硬件资源以提高加速比，平台不仅需要支持CPU、GPU，还应该支持FPGA，InfiniBand，OPA等专用高速计算资源。

- **最大化利用整个集群资源。**显而易见，对于平台来说已经不再区分是inference App还是training Job，所有的计算资源都统一在一个大的资源池中。

- **推行数据隔离架构，保证数据安全。**通过网络优势将数据和计算进行分离，提供更高级别的数据access权限。

- 多租户安全保证。

  平台接入公有云，需要支持multi-tenancy的架构，不同的用户共享计算资源的池子，但是彼此在网络级别、文件系统级别、Linux内核级别都相互隔离。

  ​

  ![img](https://cdn.kelu.org/blog/2018/10/2017080731.jpg)

  登月平台架构

网络

Kubernetes自身不具备网络组件，需要使用第三方网络插件实现。前期我们调研了Flannel、Weave、Calico三种容器网络，并做了性能对比测试。由于Flannel、Weave都是overlay网络，均采用隧道方式，网络通信包传输过程中都有封包拆包处理，因此性能大打折扣；而Calico基于BGP路由方式实现，没有封包拆包和NAT，性能堪比物理机网络。

另外，Calico是纯三层的数据中心解决方案，主机之间二层通信使用的是物理机的MAC地址，避免了ARP风暴。除了路由方式，Calico也支持IPIP的隧道方式；如果使用BGP方式，需要机房的网络设备开启BGP功能。

公有云上需要解决的一个重要问题就是多租户网络隔离，我们使用了Kubernetes自身的NetworkPolicy和Calico的网络策略实现。给每个用户分配一个单独的Namespace，Namespace内部的Pod间可以通信，但Namespace之间的Pod不允许通信。Kubernetes的NetworkPolicy只支持对“入流量”（ingress）作限制，而Calico的网络策略作了更多的扩展，支持对“出流量”（egress）作限制，而且还具备更精细的规则控制，如协议、端口号、ICMP、源网段、目的网段等。

大部分容器网络给容器分配的IP只对集群内部可见，而登月平台上很多前向服务对外提供RPC接口，需要将容器IP暴露到集群外部。经调研之后选用了Cisco开源的Contiv项目，它的底层原理是用OVS打通了容器的跨主机通信，我们使用的是它的VLAN模式，相对于基于隧道技术实现的overlay网络来说，这是underlay网络，它不是构建于物理机的网络之上，而是与物理机位于同一网络层面，这种网络的性能接近于物理网络。

存储

Kubernetes本身不提供存储功能，而是通过存储插件与第三方存储系统实现，Kubernetes支持二十多种存储后端，我们选用了Glusterfs。

Glusterfs是面向文件的分布式存储系统，架构和部署都很简单，社区版已经足够稳定，它的特点是：弹性、线性横向扩展、高可靠。Glusterfs在架构上消除了大多数文件系统对元数据服务的依赖，取而代之的是以弹性哈希算法实现文件定位，优化了数据分布，提高了数据访问并行性，极大地提升了性能和扩展性。

Kubernetes的Volume支持静态分配和动态分配两种方式。静态分配指的是由管理员手动添加和删除后端存储卷，动态分配则是使用Kubernetes的StorageClass结合Heketi服务实现。Heketi是Glusterfs的卷的管理服务，对外提供REST接口，可以动态创建、销毁Glusterfs Volume。

Glusterfs虽然性能很好，却不适合存储海量小文件，因为它只在宏观上对数据分布作了优化，却没在微观上对文件IO作优化。登月平台上大多数前向服务都是图像识别应用，需要将图片和识别结果保存下来，用作训练数据，进行算法的迭代优化。我们在调研之后采用了SeaweedFS作为小文件存储系统。

SeaweedFS的设计思想源于Facebook的Haystack论文，架构和原理都很简单，性能极好，部署和维护也很方便。SeaweedFS对外提供REST接口，结合它的filer服务可实现目录管理，我们在此基础上实现了批量上传和下载功能。SeaweedFS具有rack-aware和datacenter-aware功能，可根据集群的拓扑结构（节点在机架和数据中心的分布情况）实现更可靠的数据冗余策略。目前登月平台上很多图像服务已经接入SeaweedFS，每天存储的图片数量达到600万张，存储量以每天30G的速度增长。

因为多数计算任务都会使用HDFS，所以HDFS也是登月平台必不可少的存储组件。为了提高数据读写速度，我们引入Alluxio作为HDFS的cache层，跟直接读写HDFS相比，性能提升了几十倍。

在文件系统的多租户隔离方面，使用Kerberos和Ranger对HDFS作安全管理，Kerberos提供了身份验证，Ranger提供了权限校验。而Glusterfs的Volume使用mount方式挂载到容器中，本身就可将用户限定在特定卷中，因此可变相支持多租户隔离。

GPU资源管理

平台当前使用的Kubernetes 是1.4版本，当时社区还没有加入对多GPU的支持，我们就自己开发了多GPU管理，包括：GPU探测与映射，cuda driver管理与映射，GPU健康检查和状态监控，GPU-aware调度等。GPU-aware调度可根据GPU型号、显存大小、空闲的GPU数量等条件合理地调度应用程序，以保证资源利用率最大化。

负载均衡

登月平台的前向服务对外提供的通信接口有RPC和HTTP两种。RPC服务可以通过注册中心和RPC Client实现负载均衡，HTTP服务使用的是Kubernetes 社区的ingress组件实现负载均衡。Ingress的本质是对Nginx作了封装。用户只需将Ingress规则配置到Kubernetes里，指定服务的Host、Path与Kubernetes的Service之间的映射关系，然后Ingress-controller实时监控规则的变化，并生成Nginx配置文件，将Nginx程序reload，流量就会被分发到Serivce对应的Pod上。

CI/CD

我们选用Gitlab+Jenkins+Harbor作为持续集成/部署的组件。开发者将代码提交至Gitlab，由Jenkins触发编译、打包的规则，并生成Docker镜像push到Harbor上。当用户执行上线操作后，镜像被拉取到Kubernetes集群的Worker节点上，启动容器。平台使用Harbor搭建了私有仓库和mirror仓库，为了加速拉取镜像的速度，在不同机房作了复制仓库。

日志

在日志采集方面，我们采用了业界普遍的解决方案EFK：容器将日志打到标准输出，由docker daemon落盘存到宿主机的文件里，然后经Fluentd收集，发给Kafka，再经Fluentd转发到Elasticsearch，最后通过Kibana展示给用户作查询和分析。之所以中间加了Kafka，一是对流量起到削峰填谷的作用，二是方便业务方直接从Kafka上消费日志导入第三方系统处理。

监控

我们采用的是Heapster+Influxdb+Grafana监控组件。Heapster定期从每个Node上拉取Kubelet暴露出的metric数据，经过聚合汇总之后写入Influxdb，最终由Grafana展示出来。Heapster提供了Container、Pod、Namespace、Cluster、Node级别的metric统计，我们对Heapster作了修改，加入了Service级别的metric聚合，以便用户从应用的维度查看监控。

Kubernetes调度Spark

重点说一下Spark on Kubernetes。该开源项目由Google发起，旨在将Spark能够原生的调度在Kubernetes中，和YARN、Mesos调度框架类似。

业界有一种比较简单的做法，就是将Spark Standalone模式运行在Docker中，由Kubernetes进行调度。

该做法具有以下缺点：

- Standalone本身就是一种调度模式，却跑在另一种调度平台中，架构上重叠拖沓。
- Standalone模式跑在Kubernetes中经过实际测试，很多机器学习任务性能会有30%以上的衰减。
- 需要预先设定Worker的数量，Executor进程和Worker进程跑在同一个Container中，相互影响。
- 无法完成多租户的隔离。在同一个Docker中Worker可以启动不同用户的Executor，安全性很差。

为了解决上述问题，Kubernetes需要原生支持调度Spark，架构图如下：

![img](https://cdn.kelu.org/blog/2018/10/2017080732.jpg)

Native Spark on Kubernetes架构

从Kubernetes的角度出发，把Driver和Executor分别Container化，完成原生调度，架构清晰。

继承了Docker的计算资源隔离性，并且通过Kubernetes的Namespace概念，可以将不同的Job从网络上彻底隔离。

可以保持多版本并行，Spark-submit提交任务的时，可根据用户需求定义不同版本的Driver和Executor。

从Cluster模式的角度来观察Spark on Kubernetes，显而易见的结论是，我们已经不再有一个所谓的“Spark Cluster”，取而代之的是Kubernetes调度了一切，Spark Job可以无缝地与其他应用对接，真正形成了一个大的调度平台。

当前的社区的版本是非生产环境下的，我们团队为此做了大量的benchmark测试，稳定性测试等等。为了支持更多的需求，如multi-tenancy，python job， 我们修改了部分代码，维护了京东的一套版本。

计算与数据分离

在Hadoop生态圈，数据本地性一直被津津乐道。但是在容器化、云的领域，大家都在推崇存储中心化，数据和计算分离，现在有越来越多的公司正在将存储和计算相分离，这主要是得益于网络带宽的飞速发展。不说专有网络，就说通用的25G网络，还有RDMA和SPDK等新技术的使用，让我们具备了存储计算分离的能力。

从架构的角度看有如下意义：

- 1、多租户场景，数据安全性得到保证，实现物理上的隔离。
- 2、部署机房可以灵活多变，计算资源和存储资源可以分机房部署。当然，如果需要性能保证，可以加入中间件例如Alluxio。
- 3、平台可以方便的部署在用户网络，而不改变其数据结构。例如联通、工商银行等。

对于Tensorflow/Caffe/MXNet框架来说，Glusterfs可以直接满足需求。而对于Spark框架，我们直接用HDFS和Spark相分离的计算架构，经过大量的Benchmark，10G网络下LR，KMEANS，Decision Tree，Native Bayes等MLlib算法，数据分离与数据本地性对比，性能损失在3%左右。这样一来，所有的机器学习/深度学习框架都可以统一架构，将计算和存储相分离。

Kubernetes作为容器集群管理工具，为应用平台提供了基于云原生的微服务支持，其活跃的社区吸引了广大开发者的热情关注，刺激了容器周边生态的快速发展，同时为众多互联网企业采用容器集群架构升级内部IT平台设施，构建高效大规模计算体系提供了技术基础。

AI基础平台部是一个专注、开放的team，致力于打造安全高效的机器学习平台架构，为登月算法平台提供底层支持，研究方向主要为Kubernetes，AI算法工程化，大数据系统虚拟化等方向。

感谢Intel公司在Spark on k8s，BigDL等领域为我们提供了有力支持和宝贵经验。