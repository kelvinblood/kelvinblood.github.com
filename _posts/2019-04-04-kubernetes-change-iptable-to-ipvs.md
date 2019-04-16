---
layout: post
title: kubernetes 更改iptables模式为ipvs
category: tech
tags: kubernetes
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

Kubernetes 原生的 Service 负载均衡基于 Iptables 实现，其规则链会随 Service 的数量呈线性增长，在大规模场景下对 Service 性能会有严重的影响。具体测试可参考这篇文章：[《华为云在 K8S 大规模场景下的 Service 性能优化实践》](https://zhuanlan.zhihu.com/p/37230013)

本文主要记录操作层面的。

# 所有节点运行

在每个节点上安装ipvs，加载相关系统模块

```bash
#!/bin/bash

# 每台机器都要运行modprobe

cat > /etc/sysconfig/modules/ipvs.modules <<EOF
#!/bin/bash
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack_ipv4
EOF
chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4

yum install -y ipset ipvsadm

```

# k8s master运行

修改 kube-proxy 的配置，明确使用 ipvs 方式。

```bash
#!/bin/bash

rm *.yaml;
kubectl get configmap kube-proxy -n kube-system -oyaml >kube-proxy-configmap.yaml
sed -e '/mode:/s/""/"ipvs"/g' kube-proxy-configmap.yaml  >kube-proxy-configmap-ipvs.yaml
kubectl replace -f kube-proxy-configmap-ipvs.yaml
kubectl get pod  -n kube-system|grep kube-proxy|awk '{print "kubectl delete po "$1" -n kube-system"}'|sh

# https://segmentfault.com/a/1190000015104653
# https://blog.frognew.com/2018/10/kubernetes-kube-proxy-enable-ipvs.html

# kubectl logs kube-proxy -n kube-system
# ipvsadm -ln
```