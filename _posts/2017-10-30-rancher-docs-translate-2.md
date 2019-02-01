---
layout: post
title: Rancher 中文文档 —— 快速入门指南
category: tech
tags: rancher docker
---
![](https://cdn.kelu.org/blog/tags/rancher.jpg)

原文：<http://rancher.com/docs/rancher/v1.6/en/quick-start-guide/>

[查看本系列翻译的目录](/tech/2017/10/27/rancher-docs-translate.html)



# 快速入门指南

* * *

在本指南中，我们将在一台 Linux 主机上安装 Rancher。

# 准备一台 Linux 主机

准备一台Linux主机：

* 使用64位的Ubuntu 16.04，必须有3.10+的内核
* 至少1G内存
* 安装了 Docker。

你可以使用笔记本、虚拟机或者物理服务器。

如何安装Docker可以参考[官方文档](https://docs.docker.com/engine/installation/linux/ubuntulinux/)。

> 注意: 目前 Rancher 不支持 Mac和 Windows 下的 Docker

> 译者注： 目前 Rancher v1.6 最好安装 Rancher 官方推荐的 Docker 17.06.0-ce.

# Rancher server 标签

Rancher server 有两个不同的标签。对于每一个主要版本的标签，我们将提供特定版本的文档。

*   `rancher/server:latest`标签将是我们最新开发版本。这些版本会已经通过我们的CI自动化框架验证。这些版本不意味着在它们可以在生产环境中部署。
*   `rancher/server:stable`标签将是我们最新的稳定版本。这个标签是我们推荐用于生产的版本。

请不要使用有任何带有`rc{n}`后缀的版本。这些`rc`是 Rancher 的测试版本。


# 启动 Rancher server

你需要一行命令来启动 Rancher server。启动后，我们将跟踪查看容器的日志。
	
	$ sudo docker run -d --restart=unless-stopped -p 8080:8080 rancher/server:stable 

	# 跟踪日志  
	$ sudo docker logs -f <CONTAINER_ID>

需要几分钟的时间等待 Rancher serer 启动。当日志显示`.... Startup Succeeded, Listening on port...`后，Rancher的 UI 就会启动并运行。

日志显示基本上是实时的。请不要以为这是在初始化时的日志的最后一行，后边可能还会有更多的日志。

> 注： 任何有 Rancher 所在主机IP的人员都可以访问 Rancher 的主界面和API。我们建议你进行 访问控制 的配置

### 添加主机

为简单起见，我们将 Rancher Server 所在的机器添加为主机。在实际环境中，我们推荐使用独立的（一个或多个）主机来运行 Rancher server。

要添加主机，访问的用户界面，然后单击**Infrastructure**，它会立即跳到**Hosts**页面。点击 **Add Host**。

![非原文图片](https://cdn.kelu.org/blog/2017/10/rancher3.jpg)

Rancher 会提示你选择一个主机注册 URL。这个网址是 Rancher server 运行的地址，必须要保证其它被添加的主机都能访问到。把 Rancher 服务器的端口通过防火墙的 NAT 或者负载均衡器暴露出来，或者暴露到 Internet上在有些情况下是很有用的。如果你的主机有一个私有或者本地 IP 地址，例如： `192.168.*.*`；Rancher 将打印一个提示信息，告诉您是否确认这个 IP 地址可以被正常访问到。

现在我们添加 Rancher 服务器主机自身，因此我们可以忽略这个提示信息。点击**保存**。之后的页面中，默认情况下选中的是**custom**选项。在这可以得到运行 rancher/agent 容器的命令。这里还有其它的公有云的选项。

网页列出了需要服务器预先打开的端口和说明。由于我们正在添加 Rancher 服务器的主机，我们需要添加这个主机所使用的共有 IP。Rancher agent 命令中如果没有这个参数，这个主机的 IP 很可能会是个错误的配置。

在需要添加的主机上运行界面提示的命令。

当您单击**关闭**之后就会到达**Stacks** - > **Infrastructure**页面。等待一两分钟后，主机就自动出现了。

# 基础架构服务

第一次登录 Rancher， 你会自动处于 **默认** 环境中。在默认环境中我们使用了  cattle 的环境模板来添加一些基础架构服务。 这些基础架构服务需要预先被添加进来，才能获得 Rancher 框架的支持。这些基础架构服务可以在 ` Stacks -> Infrastructure` 里找到。 

这些应用在添加主机之前都会会保持 `unhealthy` 的状态。在增加主机后，我们需要等待一点时间，直到这些应用变为 `active` 的状态。

在主机页面中，默认情况下，作为基础设施服务的容器不会显示出来。你也可以勾选`显示系统容器`，将系统容器显示出来。

![](https://cdn.kelu.org/blog/2017/10/rancher35.jpg)

# 通过界面创建容器

> 编者注：你可能会混淆一些概念，下文翻译的“应用”英文原文都是stack，而不是application。这个翻译是按照 Rancher 里的中文翻译对应的，并非编者所创。

点击 `stacks` 进入 stack 页面。如果您看到欢迎屏幕，您可以点击定义一个应用。如果已经存在了一些应用，您可以点击添加服务于任何现有的应用，或创建一个新应用中添加服务。

应用/statck 仅仅是一个方便的方式来组服务结合在一起。如果你需要创建一个新的应用，点击添加应用，填好名称和描述，单击创建，然后点击添加服务。

假设我们定义了一个服务叫`first-service`。你可以使用默认设置单机创建。 Rancher 就会将容器添加到主机中。无论你的主机IP地址是多少，这个`first-service`容器的IP都会在 `10.42.*.*` 的范围内，因为在前文中 Rancher 使用了 `ipsec` 的基础设施服务，这个服务采用了 overlay 的网络架构解决容器间的跨主机通信问题。

在容器界面中，点击 `first-container` 的下拉菜单，你就可以进行一些容器的管理操作，例如停止容器、擦好看日志，或者进入命令行等。


# 通过 Docker 原生命令创建容器


Rancher也会显示那些通过 Docker 原生命令行创建的容器。

通过主机的终端，我们运行以下命令创建容器：

	$ docker run -d -it --name=second-container ubuntu:14.04.2

在 Rancher 的主机页面上，你会看到一个名叫 `second-container` 的容器冒出来了。

Rancher 感知到 Docker daemon 发生的事件，并用恰当的方式将他们显示出来， 可以查看 [native docker CLI](http://rancher.com/docs/rancher/v1.6/en/native-docker/). 获得更多的信息。

如果你查看 `second-container` 的 IP，你会发现它并不是`10.42.*.*` 范围里的，而是与 Docker deamon 类似的 IP。这是使用原生命令行创建容器的结果。

如果我们希望使用原生命令行创建容器，又将它纳入 Rancher 的 Overlay 网络，使得管理更为便利，应该怎么办呢？ 很简单，我们为它在命令行中添加一个标签，例如`io.rancher.container.network=true`，使得 Rancher 将这个容器识别为可以管理的。

	$ docker run -d -it --label io.rancher.container.network=true ubuntu:14.04.2

# 创建一个多容器应用

我们已经展示了如何创建单独的容器，并解释它们如何将我们的跨主机网络的连接。然而，大多数现实中的应用，是创建多种服务，每个服务由多个容器组成。例如一个[LetsChat](https://sdelements.github.io/lets-chat/)应用，可以包括以下服务：

1.  负载均衡器LB。负载均衡网络流量重定向到“LetsChat”应用程序。
2.  一个_网络_服务 web service 由两个“LetsChat”容器组成。
3.  一个 db service 由一个“Mongo的”容器组成。

lb 与 web service 相连，web service 与 db service 相连(例如Mongo)。

在本节中，我们将详细介绍如何创建和部署[LetsChat](https://sdelements.github.io/lets-chat/)在牧场主的应用。

导航到**stacks**页面，如果您看到欢迎屏幕，您可以点击 **Define a Service**。如果已经有相关的应用存在了，您可以点击** Add Stack**来创建一个新的应用。填好名称和描述，单击**创建**。然后在新的应用中点击 **Add Service**。

首先，我们使用`mongo`镜像，创建一个名为`database`的数据库服务。点击**创建**。你会立即回到应用页面(Stacks)，其中将包含新创建的db service。

接下来，点击**Add Service**再添加另外的服务。我们将添加一个LetsChat服务，并链接到db service——创建一个名为`web`的服务的并使用`sdelements/lets-chat`镜像。
在页面中，我们将将滑块移动到——有服务的规模为2个容器。
在 **Service Links**，添加db service，并提供名称`mongo`。

类似于Docker，Rancher 将从`mongo`中链接所需的环境变量到`letschat`镜像。点击**创建**。

最后，我们创建一个负载平衡器。点击旁边的下拉菜单图标**Add Service**按钮。选择 **Add Load Balancer**。我们明明为`letschatapplb`。输入的源端口（即`80`），选择目标服务（即web），并选择一个目标端口（即`8080`, 假定 web service 监听 8080 端口）, 点击**创建**。

我们LetsChat应用程序现在完成了！在**Stacks**页面，你就可以找到负载平衡器为网络上暴露的端口。点击这个链接，你就到了 LetsChat 的应用上了。


### 使用 Rancher CLI 创建多容器应用程序

在本节中，我们将向您展示如何使用 [Rancher CLI](http://rancher.com/docs/rancher/v1.6/en/cli/) 创建和部署相同的[LetsChat](https://sdelements.github.io/lets-chat/)

在 Rancher 中，使用 Rancher CLI 把应用拉起来，就像 Docker Compose 工具那么简单。你同样需要`docker-compose.yml`文件来部署在 Rancher 上的应用。此外您可以指定一个额外的`rancher-compose.yml`扩展和覆盖`docker-compose.yml`的文件。

在上一节中，我们创建了一个带有负载均衡器的 `LetsChat` 应用。如果你已经在 Rancher 创建了它，你可以直接从应用中的下拉菜单**导出配置**。在`docker-compose.yml`和`rancher-compose.yml`文件是这样的：


#### DOCKER-COMPOSE.YML 示例

```
version: '2'
services:
  letschatapplb:
    #If you only have 1 host and also created the host in the UI,
    # you may have to change the port exposed on the host.
    ports:
    - 80:80/tcp
    labels:
      io.rancher.container.create_agent: 'true'
      io.rancher.container.agent.role: environmentAdmin
    image: rancher/lb-service-haproxy:v0.4.2
  web:
    labels:
      io.rancher.container.pull_image: always
    tty: true
    image: sdelements/lets-chat
    links:
    - database:mongo
    stdin_open: true
  database:
    labels:
      io.rancher.container.pull_image: always
    tty: true
    image: mongo
    stdin_open: true

```

#### RANCHER-COMPOSE.YML 示例

```
version: '2'
services:
  letschatapplb:
    scale: 1
    lb_config:
      certs: []
      port_rules:
      - hostname: ''
        path: ''
        priority: 1
        protocol: http
        service: web
        source_port: 80
        target_port: 8080
    health_check:
      port: 42
      interval: 2000
      unhealthy_threshold: 3
      healthy_threshold: 2
      response_timeout: 2000
  web:
    scale: 2
  database:
    scale: 1

```

Rancher CLI 的二进制包可以在 Rancher 主页面的右下角找到。适用于 Windows Mac 和 Linux.

为了在Rancher CLI 中使用 Rancher 的一系列服务，我们还需要设置一些环境变量。我们需要在 Rancher 页面中创建一个帐户[API密钥](http://rancher.com/docs/rancher/v1.6/en/api/api-keys/)。点击**API** - > **Key**。点击**添加帐户API密钥**。填写名称，然后点击**创建**。保存**Access Key**和**Secret Key**。 之后就可以通过 Rancher URL，Access Key和Secret Key，使用 `rancher config` 来配置 Rancher CLI了。

```
# Configure Rancher CLI
$ rancher config
# Set the Rancher URL
URL []: http://<SERVER_IP>:8080/
# Set the access key, i.e. username
Access Key []: <accessKey_of_account_api_key>
# Set the secret key, i.e. password
Secret Key []:  <secretKey_of_account_api_key>

```

现在，将 `docker-compose.yml` 和 `rancher-compose.yml` 保存后运行如下命令：

```
$ rancher up -d -s NewLetsChatApp

```
你就可以看到一个名为**NewLetsChatApp**的应用就启动起来了。
