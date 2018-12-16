---
layout: post
title: yum 查询包版本与rpm包下载
category: tech
tags: centos linux kubernetes
---
![](https://cdn.kelu.org/blog/tags/centos.jpg)

# 查询版本号

某些场景下我们需要安装某些软件的特定版本，这个时候就需要在yum仓库中查询包版本号。例如查询 cri-tools 这个软件的版本如下：

```
yum -v list cri-tools --show-duplicates
yum --showduplicates list cri-tools
```

![](https://cdn.kelu.org/blog/2018/07/20180717092634.jpg)

列出的版本信息具体内容是：

```
package_name.architecture  version_number–build_number  repository
```

# 下载rpm

在知道rpm包版本好后，我们希望将其下载下来，以供内网环境安装。用如下方法下载:

```
yum install --downloadonly --downloaddir=/tmp/ [package-name]-[version].[architecture]

# 例如：
yum install --downloadonly --downloaddir=/tmp/ cri-tools-1.0.0_beta.1-0
```

# 对于kubernetes的rpm

说来也是气人，kubernetes的repo文件比较奇葩：<https://kubernetes.io/docs/setup/independent/install-kubeadm/#k8s-install-1>

对于上边的命令行，都要附上这样一个特殊的命令：

```
--disableexcludes=kubernetes
```

例如：

```
yum install --downloadonly --downloaddir=/tmp/ xxx --disableexcludes=kubernetes
```

# 参考资料

* [yum search - package version](https://serverfault.com/questions/385226/yum-search-package-version)
* [如何使用yum来下载RPM包而不进行安装](https://linux.cn/article-5100-1.html)
* [How can I instruct yum to install a specific version of package X?](https://unix.stackexchange.com/questions/151689/how-can-i-instruct-yum-to-install-a-specific-version-of-package-x)
* <https://kubernetes.io/docs/setup/independent/install-kubeadm/#k8s-install-1>