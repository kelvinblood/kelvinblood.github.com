---
layout: post
title: harbor 测试连接成功但同步失败
category: tech
tags: harbor
---
![](https://cdn.kelu.org/blog/tags/harbor.jpg)

在进行 harbor 同步时候遇到了这个问题，记录下来。

# harbor是什么

Harbor 是 VMware 公司开源的企业级 Registry 项目，可以帮助用户迅速搭建一个企业级的 Docker registry 服务。它以 Docker 公司开源的 registry 为基础，提供了管理UI, 基于角色的访问控制(Role Based Access Control)，AD/LDAP 集成、以及审计日志(Audit logging) 等企业用户需求的功能，同时还原生支持中文。

# 问题背景

背景很简单，就是在新的机器上运行了一个新的 Harbor:

```
wget https://storage.googleapis.com/harbor-releases/harbor-offline-installer-v1.3.0.tgz
tar xzvf harbor-offline-installer-v1.3.0.tgz
cd harbor
./install.sh
```

在进行 replication 同步时，测试可以连通，log显示无法同步，与github上的这个issue描述基本一致：

<https://github.com/vmware/harbor/issues/3856>

```
2017-12-22T14:37:07Z [INFO] initializing: repository: crm/mysql, tags: [], source URL: http://registry:5000, destination URL: http://reg1.rainbow.com, insecure: true, destination user: admin
2017-12-22T14:37:07Z [INFO] initialization completed: project: crm, repository: crm/mysql, tags: [latest v1.0.0], source URL: http://registry:5000, destination URL: http://reg1.rainbow.com, insecure: true, destination user: admin
2017-12-22T14:37:07Z [ERROR] [transfer.go:204]: an error occurred while creating project crm on http://reg1.rainbow.com with user admin : failed to create project crm on http://reg1.rainbow.com with user admin: 301
```

从下文贡献者 @[**reasonerjt**](https://github.com/reasonerjt) 回复的答案

```
This is because you are running a 1.3.0 build on your remote target, and the request failed due to API security enforcement. This should be fixed if you upgrade your source env to 1.3.0 also.
```

可以知道，这是两个harbor版本不一致造成的：我的源 Harbor 版本为 1.2.2 版本，新环境中的 Harbor 为 1.3.0。

# 其他问题

在运行过程中，也出现了下面这个现象:

​	harbor-adminserver 容器始终无法启动。

查看日志可以了解到，secretkey_path 是个文件夹，通过删除data文件夹后重新install解决。




# 参考资料

* [replication error，Test connection success，V1.2.2](https://github.com/vmware/harbor/issues/3856)
* [Gitlab迁移（Docker版）](https://segmentfault.com/a/1190000011147277)
* [install harbor 1.1.1-rc4 harbor-adminserver Error #2294](https://github.com/vmware/harbor/issues/2294)

