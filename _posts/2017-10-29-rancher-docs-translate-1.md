---
layout: post
title: Rancher 中文文档 —— Rancher 概述
category: tech
tags: rancher docker
---
![](https://cdn.kelu.org/blog/tags/rancher.jpg)

原文：<http://rancher.com/docs/rancher/v1.6/en/>

[查看本系列翻译的目录](/tech/2017/10/27/rancher-docs-translate.html)

# 概述

* * *

Rancher 是一个开源软件平台，用于运行和管理 Docker 与 Kubernetes。在 Rancher 中，我们不再需要从头开始整合不同的开源技术搭建容器平台。Rancher 整合提供了容器生产环境中所需要的软件技术栈。


# 基础架构

Rancher 可以在任何公有云或私有云的 Linux 主机上使用底层的计算资源。 Linux 主机可以是虚拟机，也可以是物理机。Rancher 对主机资源的消耗也很小。从 Rancher 的角度看，Rancher 无法区分当前管理的机器是物理机还是虚拟机。

Rancher 实现了便携的专为 Dcoker 设计的基础架构，包括 网络、存储、负载均衡、DNS 和安全性。 Rancher 可以在任何Linux主机任何云上进行部署，因为 Rancher 的基础设施服务也是由 Docker 进行部署。

# 容器的编排和调度

许多用户使用容器编排和调度框架来管理容器化的应用。 Rancher 包含了当下所有流行的容器编排和调度框架，包括 Docker Swarm, Kubernetes 和 Mesos. 同一个用户可以创建多个 Swarm 或 Kubernetes 集群，然后再用 Swarm 或 Kubernetes 的原生工具管理他们的应用。

除了支持这些流行的框架 Swarm, Kubernetes 和 Mesos， Rancher 也支持了一套自家公司开发的编排和调度工具 —— Cattle。

# 应用商店

在 Rancher 中可以很方便地在应用商店中部署多个容器集群的应用。 如果应用有版本升级，应用升级的过程都是自动化的，简单无痛。

Rancher 用户除了可以使用公有的应用商店，也可以创建自己的私有应用商店。

![](https://cdn.kelu.org/blog/2017/10/rancher31.jpg)

# 企业级控制

Rancher 对用户身份验证的支持非常灵活，可以自由设置登陆用户的访问权限。除此之外，Rancher 还内置了Active Directory, LDAP, 和 GitHub 认证插件。 Rancher 基于角色的访问控制权限可以同时在开发环境和生产环境中使用。

下图是 Rancher 的主要组件和功能特性。

![](https://cdn.kelu.org/blog/2017/10/rancher33.jpg)







