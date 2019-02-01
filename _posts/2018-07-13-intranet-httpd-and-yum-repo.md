---
layout: post
title: 配置局域网 yum 源(http模式)
category: tech
tags: linux centos
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

搭建 yum 有两种协议——http和ftp。比较常用的是http，这篇文章介绍 http 的方式。

# 环境准备

* rpm包——httpd和createrepo
* centos 光盘镜像

# 安装

在准备搭建yum源的服务器上安装 httpd 和 createrepo

```
rpm -ivh 包名
```

# 源配置

拷贝 centos 的两块系统光盘到 yum 源机器上。
把iso文件挂载到/mnt

```
mount -o loop -t iso9660 /isoname.iso /mnt
```

建立yum源的rpm包存放路径

```
mkdir -p/var/www/html/yum/CentOS6.3
```

拷贝rpm包到yum源目录，不同系统光盘rmp包存放的目录可能不同，占空间最大的就是。

```
cp /mnt/Packages/* /var/www/html/yum/CentOS6.3
```

卸载挂载的第一块光盘

```
umount /mnt
```

再重复上面的挂载和拷贝第二块光盘的rpm包，在最后有一个文件冲突的提示，两个都直接删除就好了。

# 生成创建仓库

```
createrepo /var/www/html/yum/CentOS6.3
```

需要等待比较长时间。

# 启动 httpd 服务器

```
systemctl restart httpd
```

到此 yum 源的服务端就已经完成。

# 修改客户端的 yum 源

备份默认配置

```
cp/etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bk
vi /etc/yum.repos.d/CentOS-Base.repo
```

把里面的mirrorlist加上注释，baseurl注释删掉后面的链接改成

```
http://ip/yum/CentOS6.3/
```

# 测试

```
yum clean all
yum -y install vim
```