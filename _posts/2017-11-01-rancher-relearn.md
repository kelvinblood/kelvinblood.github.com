---
layout: post
title: Rancher 再学习(一)
category: tech
tags: docker rancher
---
![](https://cdn.kelu.org/blog/tags/rancher.jpg)

前段时间转载了这篇[《Rancher安装手册》](/tech/2017/10/14/rancher-tutorial.html)文章， 也尝试着安装了一下，有了一些浅显的认识。今天从0开始又一次部署，算是对 Rancher 的再学习。 这一篇主要是将各种事先需要准备的一些东西。

使用的环境为 CentOS 7.4 （` cat /etc/redhat-release`

事先准备几个命令，后边你可能会经常用到(但愿不需要用到)

	docker kill $(docker ps -a -q) # 杀死所有正在运行的容器
	docker rm $(docker ps -a -q)	# 删除所有已经停止的容器
	docker rmi $(docker images -q)	# 删除所有镜像

重置 docker/rancher：

	rm -rf /var/lib/docker
	rm -rf /var/lib/rancher

# Docker再安装

[按照 Rancher 的官方推荐，使用 17.06 版本的 Docker](http://rancher.com/docs/rancher/v1.6/en/hosts/#supported-docker-versions)。所以要先把本机的docker 卸载，再重新安装。

![](https://cdn.kelu.org/blog/2017/10/rancher11.jpg)

	# 查看安装版本号、卸载
	yum list installed | grep docker
	yum -y remove docker-ce.x86_64

	# 查看可用的版本
	yum makecache fast
	yum list docker-ce.x86_64 --showduplicates | sort -r

![](https://cdn.kelu.org/blog/2017/10/rancher12.jpg)

	yum -y install docker-ce-17.06.0.ce

### 加速

安装成功后需要对 Docker 源进行加速。我试用 Docker 官方的加速办法：在 /etc/docker/daemon.json 文件并添加上 registry-mirrors 键值。

	touch /etc/docker/daemon.json
	vi /etc/docker/daemon.json

```
{  
	"registry-mirrors": ["https://registry.docker-cn.com"]
}
```
重启 Docker 后生效。

### 开机自启动

	systemctl enable docker
	# Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.

# Rancher 安装

参照我先前的文章[《Rancher安装手册》](/tech/2017/10/14/rancher-tutorial.html)进行安装。

注意要使用 Chrome 访问 Rancher。在 IE 下会出现无法添加主机的情况（嗯，我踩过的坑。）

# 防火墙firewall

容器之间通信需要借助防火墙。使用 Rancher 添加不同主机的时候，就需要打通各个主机的通信，主要是 Rancher 服务器的默认 8080 端口和 IPsec 的 500、4500端口(UDP协议)。这里列几个，其他的我会再开一篇文章记录一下。

关于 firewall，只要记住服务和端口两个概念即可。
	
	iptables -F; # 清除 iptables，防止两个防火墙冲突。
	iptables -L;
	firewall-cmd --zone=public --list-ports  # 查看所有打开的端口
	firewall-cmd --list-services			# 查看开启的服务。
	firewall-cmd --zone=public --add-port=80/tcp --permanent    （--permanent永久生效，没有此参数重启后失效）							#  添加端口
	firewall-cmd --permanent --add-service="ipsec"  # 添加服务
	firewall-cmd --reload
	systemctl start firewalld.server		# 重启 firewall

打了这么些命令，可以参考一下

![](https://cdn.kelu.org/blog/2017/10/rancher13.jpg)

# 检查远端端口是否可用

使用 `nc` 命令进行检测：

	nc -v host port

出现  `Connection refused` 或者 `Connected ` 都说明端口可用。如果出现 `No route to host.` 则说明端口未开放。例如：

![](https://cdn.kelu.org/blog/2017/10/rancher14.jpg)

# 参考资料

* [CentOS 7 为firewalld添加开放端口及相关资料](http://www.cnblogs.com/hubing/p/6058932.html)
* [使用 nc 命令检查远程端口是否打开](https://linux.cn/article-8186-1.html)



