---
layout: post
title: windows 挂载 Ubuntu 的 nfs 硬盘
category: tech
tags: windows linux storage nfs
---
![](https://cdn.kelu.org/blog/tags/windows.jpg)

这篇文章记录如何在win下挂载 Linux nfs 硬盘。

# linux下开启 NFS 服务

```
modprobe nfs
modprobe nfsd
apt-get -y install nfs-common

cat <<EOF > /etc/exports
/nfs *(rw,sync,no_subtree_check,no_root_squash)
EOF

exportfs  -av
```



# Win 下开启 NFS 功能

![img](https://cdn.kelu.org/blog/2018/08/22192719.jpg)

# 挂载

```
mount \\10.8.11.192\nfs x:\
```

![img](https://cdn.kelu.org/blog/2018/08/714585576.jpg)



![img](https://cdn.kelu.org/blog/2018/08/1783759218.jpg)



# 设置可写

使用 mount 命令，默认挂载的文件用户 uid=-2，gid=-2，将其修改为root用户0和用户组0：

![img](https://cdn.kelu.org/blog/2018/08/22193602.jpg)

打开注册表：

* Win + R，运行 regedit
* HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ClientForNFS\CurrentVersion\Default，增加两项：AnonymousUid，AnonymousGid 即可。

![img](https://cdn.kelu.org/blog/2018/08/22193709.jpg)

# 最后

重启操作系统，重新mount即可。