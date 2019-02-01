---
layout: post
title: Rancher安装手册
category: tech
tags: docker rancher
---
![](https://cdn.kelu.org/blog/tags/rancher.jpg)

这几天在搭建 Rancher 环境。

Rancher 是以在生产环境中运行容器为目标而构建的开源软件平台。随着 [**Docker**](http://www.dockerinfo.net/) 容器这种类型的应用工作负载的逐渐流行，它催生了很多与之相应的基础架构服务，如网络服务、存储服务、负载均衡，安全，服务发现和资源管理。

官方网站: <https://rancher.com/>

官方文档在此： <http://rancher.com/docs/rancher/latest/en/>

dockerinfo对其中的部分章节做了翻译<http://www.dockerinfo.net/rancher/page/5>

今天这篇就是dockerinfo其中的一篇翻译，我做了点无关痛痒的增删。需要学习的朋友可以两边都对照着看，又达到比较快的速度，也可以达到深入理解的层次。


### 准备 Linux 主机

先安装一个64位的 Ubuntu 14.04 Linux 主机，其内核必须高于 3.10 。或者其它同等的 Linux 发行版。你可以使用一台笔记本、一个虚拟机或者一台物理的服务器。请确保目标安装 Linux 主机的内存至少1GB。

然后安装 Docker 在这个 Linux 主机上， 可以参考 [**Docker安装**](http://www.dockerinfo.net/dockerinstall)说明。

### 启动 Rancher 服务器

启动 Rancher 服务器所需要做的动作就只有一条命令。在启动了这个容器之后，我们将能查看到这个运行中的服务器的日志。

```
$ sudo docker run -d --restart=always -p 8080:8080 rancher/server
# 显示 Rancher 服务器的容器 ID，替换containerid
$ sudo docker ps
# 显示并查看 Rancher 服务器的日志
$ sudo docker logs -f containerid
```
![修改语言](https://cdn.kelu.org/blog/2017/10/rancher1.jpg)

启动 Rancher 服务器可能需要花几分钟时间。这取决于您下载 Rancher Server镜像的速度。当日志中显示 “…. Startup Succeeded, Listening on port…” 以后，Rancher UI 图形界面现在就能正常访问了。

Rancher 服务器的图形界面访问端口是 8080 ，通过在浏览器中访问这个网址 http://linux_host_ip:8080 , 您就可以打开 Rancher 服务器的图形界面。如果您的浏览器和 Rancher 服务器都运行在同一台服务器上，你需要使用主机的真实 Ip 地址，如： http://192.168.1.100:8080 ， 而不是 http://localhost:8080

> **注意:** Rancher 的访问控制在初始安装时并没有配置，你的 Rancher 服务器图形界面和 API 能在任何能访问到您的 IP 地址的地方被访问到。我们建议配置访问控制参考 访问控制.

### 添加主机

![添加主机](https://cdn.kelu.org/blog/2017/10/rancher2.jpg)

为简化操作，我们将添加运行 Rancher 服务器容器的主机。而在实际的生产环境中，我们建议使用专用的主机来运行 Rancher 服务器。

通过点击图形界面的 **Infrastructure** 标签来添加主机，然后您将会看到 **Hosts** 页面。Rancher 会提示您选择一个 IP 地址。这个 IP 地址必须可以被所有即将添加的主机访问到。把 Rancher 服务器的端口通过防火墙的 NAT 或者负载均衡器暴露出来，或者暴露到 Internet上在有些情况下是很有用的。如果你的主机有一个私有或者本地 IP 地址，例如： `192.168.*.*`；Rancher 将打印一个提示信息，告诉您是否确认这个 IP 地址可以被正常访问到。

![添加主机](https://cdn.kelu.org/blog/2017/10/rancher3.jpg)

现在我们添加 Rancher 服务器主机自身，因此我们可以忽略这个提示信息。点击 **Save** ；您将进入默认的**Custom** 选项页面，您在这可以得到运行 rancher/agent 容器的命令。这里还有其它的公有云的选项，使用这个选项可以实现通过 `docker-machine` 去启动主机节点。在 Web 界面上，Rancher 提供的用于添加主机的命令如下：

> $ sudo docker run -d –privileged -v /var/run/docker.sock:/var/run/docker.sock rancher/agent:v0.7.9 http://172.17.0.3:8080/v1/scripts/DB121CFBA836F9493653:1434085200000:2ZOwUMd6fIzz44efikGhBP1veo

![添加主机](https://cdn.kelu.org/blog/2017/10/rancher4.jpg)

由于我们正在添加 Rancher 服务器的主机，我们需要添加这个主机所使用的共有 IP。Rancher agent 命令中如果没有这个参数，这个主机的 IP 很可能会是个错误的配置。您可以添加这个 IP 地址在**Step 4**，这将会修改命令，并加入一个环境变量。

> $ sudo docker run -e CATTLE_AGENT_IP=172.17.0.3 -d –privileged -v /var/run/docker.sock:/var/run/docker.sock rancher/agent:v0.7.9 http://172.17.0.3:8080/v1/scripts/DB121CFBA836F9493653:1434085200000:2ZOwUMd6fIzz44efikGhBP1veo

在运行 Rancher 服务器的主机上运行这个命令。

当您在 Rancher 的页面中点击 **Close** 按钮后，您会被返回到 **Infrastructure** -> **Hosts** 页面。在一两分钟后，这个主机将自动出现在这里。

![添加主机](https://cdn.kelu.org/blog/2017/10/rancher5.jpg)

![添加主机](https://cdn.kelu.org/blog/2017/10/rancher6.jpg)


### 使用图形界面创建一个容器

进入 **Applications** -> **Stacks** 页面，如果这里还没有服务，你可以点击 “Add Service” 按钮。你可以输入一个类似 “first_container” 的名字。您现在使用默认配置并点击 **Create** 。Rancher 将开始在这个主机上启动两个容器。一个容器是您所创建的名为**_first_container_** ；另外一个容器是**_Network Agent_**，这是个由 Rancher 创建的系统容器，它用来处理扩主机联网和健康检查等任务。

不管你的主机是什么 IP 地址，**_first_container_** 和 **_Network Agent_** 将会的到 `10.42.*.*` 网段的 IP 地址。Rancher 已经创建了能在不同主机之上的让所有容器可以相互通信的覆盖网络。

如果你点击 **_first_container_**的下拉菜单，你可以执行各种动作，例如：停止容器，查看日志，或者进入容器的 控制台。

### 使用 Docker 原生命令创建一个容器

Rancher 会显示所有在主机上的容器，即使有些容器是在图形界面之外创建的。在主机的 shell 命令行里创建一个容器。

```
$ docker run -it --name=second_container ubuntu:14.04.2
```

在图形界面中，你将看到 **_second_container_** 在你的主机上出现！如果你通过退出命令行来退出用命令方式创建的容器，在 Rancher 图形界面中将立刻显示这个容器的状态为停止。

Rancher 可以对带外发生的事件作出反应，并把当前的显示状况如实地整合在它的视图中。

如果你查看容器 **_second_container_** 的 IP 地址，你会注意到他不在 `10.42.*.*` 网段中。它的 IP 地址是通过 Docker 后台服务获得的。这是通过命令行方式创建容器的正常的结果。

如果我希望通过命令行创建的容器依然具有 Ranger 覆盖网络的网络地址呢？我们所需要做的就仅仅是在命令中加一个标签。

```
$ docker run -it --label io.rancher.container.network=true ubuntu:14.04.2
```

标签 `io.rancher.container.network` 让我们通过命令行传递了一个通知，这样 Rancher 会为把容器配置为连接到覆盖网络。

