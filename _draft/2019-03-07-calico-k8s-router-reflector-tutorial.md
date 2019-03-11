---
layout: post
title: calico 入门
category: tech
tags: network calico
---
![](https://cdn.kelu.org/blog/tags/network.jpg)

# 运行确认步骤

确认ipvs成功

```bash
ipvsadm -ln 
```

查看k8s成功启用：
```bash
kubectl get all -n kube-system
kubectl logs -n kube-system kube-proxy-xxx
```

显示日志：
```bash
I0307 07:52:31.282984       1 feature_gate.go:226] feature gates: &{{} map[]}
I0307 07:52:31.306218       1 server_others.go:183] Using ipvs Proxier.
W0307 07:52:31.321634       1 proxier.go:304] IPVS scheduler not specified, use rr by default
I0307 07:52:31.321811       1 server_others.go:209] Tearing down inactive rules.
I0307 07:52:31.377552       1 server.go:444] Version: v1.10.11
I0307 07:52:31.395650       1 conntrack.go:98] Set sysctl 'net/netfilter/nf_conntrack_max' to 196608
I0307 07:52:31.395746       1 conntrack.go:52] Setting nf_conntrack_max to 196608
I0307 07:52:31.395953       1 conntrack.go:98] Set sysctl 'net/netfilter/nf_conntrack_tcp_timeout_established' to 86400
I0307 07:52:31.396035       1 conntrack.go:98] Set sysctl 'net/netfilter/nf_conntrack_tcp_timeout_close_wait' to 3600
I0307 07:52:31.396402       1 config.go:102] Starting endpoints config controller
I0307 07:52:31.396431       1 controller_utils.go:1019] Waiting for caches to sync for endpoints config controller
I0307 07:52:31.396432       1 config.go:202] Starting service config controller
I0307 07:52:31.396489       1 controller_utils.go:1019] Waiting for caches to sync for service config controller
I0307 07:52:31.496666       1 controller_utils.go:1026] Caches are synced for service config controller
I0307 07:52:31.496675       1 controller_utils.go:1026] Caches are synced for endpoints config controller
```

查看 calico-node 日志，确认使用模式：
* AS号
* IP池
* IPIP模式是否开启
* 检查kube-proxy支持ipvs，启用 felix kube-proxy ipvs 支持

```bash
2019-03-07 07:53:14.285 [INFO][9] startup.go 256: Early log level set to info
2019-03-07 07:53:14.285 [INFO][9] startup.go 274: Using stored node name from /var/lib/calico/nodename
2019-03-07 07:53:14.285 [INFO][9] startup.go 284: Determined node name: k8s001
2019-03-07 07:53:14.286 [INFO][9] startup.go 97: Skipping datastore connection test
2019-03-07 07:53:14.287 [INFO][9] startup.go 367: Building new node resource Name="k8s001"
2019-03-07 07:53:14.287 [INFO][9] startup.go 382: Initialize BGP data
2019-03-07 07:53:14.288 [INFO][9] startup.go 584: Using autodetected IPv4 address on interface eth0: 10.18.1.11/16
2019-03-07 07:53:14.288 [INFO][9] startup.go 452: Node IPv4 changed, will check for conflicts
2019-03-07 07:53:14.289 [INFO][9] startup.go 647: No AS number configured on node resource, using global value
2019-03-07 07:53:14.290 [INFO][9] startup.go 149: Setting NetworkUnavailable to False
2019-03-07 07:53:14.313 [INFO][9] startup.go 536: CALICO_IPV4POOL_NAT_OUTGOING is true (defaulted) through environment variable
2019-03-07 07:53:14.313 [INFO][9] startup.go 781: Ensure default IPv4 pool is created. IPIP mode: off
2019-03-07 07:53:14.315 [INFO][9] startup.go 791: Created default IPv4 pool (172.18.0.0/16) with NAT outgoing true. IPIP mode: off
2019-03-07 07:53:14.315 [INFO][9] startup.go 530: FELIX_IPV6SUPPORT is false through environment variable
2019-03-07 07:53:14.321 [INFO][9] startup.go 181: Using node name: k8s001
Calico node started successfully

...

2019-03-07 07:53:15.453 [INFO][65] driver.go 43: Using internal (linux) dataplane driver.
2019-03-07 07:53:15.454 [INFO][65] driver.go 47: Kube-proxy in ipvs mode, enabling felix kube-proxy ipvs support.

```

大概两秒钟就能启动完成，在我这里看刷了500行日志。

### 使用 calicoctl 命令确认 peer type
```bash
$ calicoctl node status

Calico process is running.

IPv4 BGP status
+--------------+-------------------+-------+----------+-------------+
| PEER ADDRESS |     PEER TYPE     | STATE |  SINCE   |    INFO     |
+--------------+-------------------+-------+----------+-------------+
| 10.18.1.12   | node-to-node mesh | up    | 07:56:53 | Established |
| 10.18.1.13   | node-to-node mesh | up    | 07:56:54 | Established |
+--------------+-------------------+-------+----------+-------------+

IPv6 BGP status
No IPv6 peers found.
```

node-to-node mesh，全互联模式，就是一个BGP Speaker需要与其它所有的BGP Speaker建立bgp连接(形成一个bgp mesh)。

网络中bgp总连接数是按照O(n^2)增长的，有太多的BGP Speaker时，会消耗大量的连接。 calico默认使用全互联的方式，扩展性比较差，只能支持小规模集群

# 名词
* endpoint:  接入到calico网络中的网卡称为endpoint
* AS:        网络自治系统，通过BGP协议与其它AS网络交换路由信息
* ibgp:      AS内部的BGP Speaker，与同一个AS内部的ibgp、ebgp交换路由信息。
* ebgp:      AS边界的BGP Speaker，与同一个AS内部的ibgp、其它AS的ebgp交换路由信息。
 
* workloadEndpoint:  虚拟机、容器使用的endpoint
* hostEndpoints:     物理机(node)的地址

* ip fabric: IP Fabric指的是在IP网络基础上建立起来的Overlay隧道技术。
    * 基于胖树的Spine+Leaf拓扑结构的IP Fabric组网，任何两台服务器间的通信不超过3台设备，每个Spine和Leaf节点全互连，
    可以方便地通过扩展Spine节点来实现网络规模的弹性扩展。只要遍历一定数量的交换机，可以在几乎所有数据中心结构体系中
    的服务器节点之间传输流量，该架构由多条高带宽的直接路径组成，消除了网络瓶颈带来的潜在传输速度下降，从而实现极高
    的转发效率和低延迟。 根据不同的业务需要，Spine和Leaf之间可以使用IP路由、VXLAN或TRILL等技术。

# calico原理

每个node上运行一个软路由软件bird，并且被设置成BGP Speaker，与其它node通过BGP协议交换路由信息，知晓了每个workload-endpoint的下一跳地址。。

```
我是X.X.X.X，某个IP或者网段在我这里，它们的下一跳地址是我。
```

calico网络对底层的网络的要求很少，只要求node之间能够通过IP联通。
当要部署calico网络的时候，第一步就是要确认，网络中处理能力最强的设备最多能设置多少条路由。

> 在calico中，全网路由的数目和endpoints的数目一致，通过为node分配网段，可以减少路由数目，但不会改变数量级。 如果有1万个endpoints，那么就至少要有一台能够处理1万条路由的设备。
>
> 无论用哪种方式部署始终会有一台设备上存放着calico全网的路由。

calico系统组成:

1. Felix负责管理设置node
2. etcd, the data store.
3. bird是一个开源的软路由，支持多种路由协议。
4. BGP Route Reflector (BIRD), an optional BGP route reflector for higher scale.
5. The Orchestrator plugin, orchestrator-specific code that tightly integrates calico into that orchestrator.

# 部署非full mesh模式

如果底层的网络是ip fabric的方式，三层网络是可靠的，只需要部署一套calico。

### 一 禁用full mesh

1. 确认是否default
    ```bash
    calicoctl get bgpconfig default
    ```
2. 如果资源确实存在，请跳至步骤3.否则，请使用以下命令创建资源。
    根据需要调整 nodeToNodeMeshEnabled 和 asNumber。
   
   ```bash
    cat << EOF | calicoctl create -f -
    apiVersion: projectcalico.org/v3
    kind: BGPConfiguration
    metadata:
      name: default
    spec:
      logSeverityScreen: Info
      nodeToNodeMeshEnabled: false
      asNumber: 63400
    ```
   
3. 如果资源确实存在。
   
    ```bash
    calicoctl get bgpconfig default --export -o yaml > bgp.yaml
    ```
    根据需要调整 nodeToNodeMeshEnabled 和 asNumber。
    ```bash
    calicoctl replace -f bgp.yaml
    ```

### 二  配置 global BGP peer

1. bgp-global-peer.yaml
    假设我当前虚机的ip是 10.18.1.11

    ```bash
    $ cat << EOF | calicoctl create -f -
      apiVersion: projectcalico.org/v3
      kind: BGPPeer
      metadata:
        name: bgppeer-global-10180111
      spec:
        peerIP: 10.18.1.11
        asNumber: 64567
    ```

2. 查看bgppeer

    ```bash
    $ calicoctl get bgpPeer 
    ```


# 参考资料

* [华为数据中心网络设计指南](https://support.huawei.com/enterprise/zh/doc/EDOC1100023543?section=j00y)
* [Calico网络的原理、组网方式与使用](https://www.lijiaocn.com/%E9%A1%B9%E7%9B%AE/2017/04/11/calico-usage.html)
* [使用calico的ipip模式解决k8s的跨网段通信](https://www.lijiaocn.com/%E9%A1%B9%E7%9B%AE/2017/09/25/calico-ipip.html)
* [数据中心网络架构浅谈（二）](https://zhuanlan.zhihu.com/p/29975418)
* [calico网络原理及与flannel对比](https://blog.csdn.net/hxpjava1/article/details/79566192)
* [一次IPVS模式下的Kubernetes容器网络排障](https://www.kubernetes.org.cn/5010.html)
