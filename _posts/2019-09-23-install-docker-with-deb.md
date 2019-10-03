---
layout: post
title: 使用 deb 包安装 docker
category: tech
tags: linux debian docker
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

手头有一个某云平台的虚拟机，很不幸无法使用docker官方的脚本安装docker：

```
curl -sSL https://get.docker.com/ | sh
usermod -aG docker $USER
systemctl enable docker
systemctl start docker
```

报错则是xxx链接超时。我使用的是debian系统，所以这一篇记录如何使用deb包安装docker。

# 查看系统版本

```
YUKI.N > lsb_release -a
No LSB modules are available.
Distributor ID: Debian
Description:    Debian GNU/Linux 9.11 (stretch)
Release:        9.11
Codename:       stretch
```

# 进入下载页

进入到下载包页面 <https://download.docker.com/linux/>

点击进入 `debian>dists>stretch`  进入了这个连接地址 https://download.docker.com/linux/debian/dists/

# 选择一个比较新的版本

我选择的是 19.03

```
wget https://download.docker.com/linux/debian/dists/stretch/pool/stable/amd64/docker-ce_19.03.0~3-0~debian-stretch_amd64.deb
```

# 安装命令

```
sudo dpkg -i docker-ce*.deb
sudo apt-get -f install
```

安装完成后查看版本信息：

```
YUKI.N > docker version
Client: Docker Engine - Community
 Version:           19.03.2
 API version:       1.40
 Go version:        go1.12.8
 Git commit:        6a30dfca03
 Built:             Thu Aug 29 05:29:49 2019
 OS/Arch:           linux/amd64
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          19.03.0
  API version:      1.40 (minimum version 1.12)
  Go version:       go1.12.5
  Git commit:       aeac9490dc
  Built:            Wed Jul 17 18:12:33 2019
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.2.6
  GitCommit:        894b81a4b802e4eb2a91d1ce216b8817763c29fb
 runc:
  Version:          1.0.0-rc8
  GitCommit:        425e105d5a03fabd737a126ad93d62a9eeede87f
 docker-init:
  Version:          0.18.0
  GitCommit:        fec3683
```

至此安装完成。