---
layout: post
title: Rancher 中文文档 —— Rancher 安装
category: tech
tags: rancher docker
---
![](https://cdn.kelu.org/blog/tags/rancher.jpg)

原文：<http://rancher.com/docs/rancher/v1.6/en/installing-rancher/installing-server/>

[查看本系列翻译的目录](/tech/2017/10/27/rancher-docs-translate.html)

# 安装 Rancher 服务器

* * *

Rancher 由一系列的 Dcoekr 容器组成。 运行 Rancher 就像添加两个容器一样简单： 一个服务管理容器和一个作为客户端的节点容器。

*   [Rancher Server -单容器（非HA）](http://rancher.com/docs/rancher/v1.6/en/installing-rancher/installing-server/#single-container)
*   [Rancher Server - 单容器（非HA） - 外部数据库](http://rancher.com/docs/rancher/v1.6/en/installing-rancher/installing-server/#single-container-external-database)
*   [Rancher Server - 单容器（非HA）- 绑定 Mysql 数据卷](http://rancher.com/docs/rancher/v1.6/en/installing-rancher/installing-server/#single-container-bind-mount)
*   [Rancher Server -全主动/主动HA](http://rancher.com/docs/rancher/v1.6/en/installing-rancher/installing-server/#multi-nodes)
*   [Rancher Server - 在 AWS 上使用 ELB](http://rancher.com/docs/rancher/v1.6/en/installing-rancher/installing-server/#elb)
*   [Rancher Server - 启用 ACTIVE DIRECTORY 或 OPENLDAP FOR TLS](http://rancher.com/docs/rancher/v1.6/en/installing-rancher/installing-server/#ldap)
*   [Rancher Server -启用 http 代理](http://rancher.com/docs/rancher/v1.6/en/installing-rancher/installing-server/#http-proxy)
*   [Rancher Server - 与 MySQL 通过 SSL 通信](http://rancher.com/docs/rancher/v1.6/en/installing-rancher/installing-server/#mysql-ssl)

> 注意：Rancher 服务器容器帮助选项`docker run rancher/server --help`


# 要求

* 支持 Dcoekr 的 Linux 发行版。我们在 RancherOS Ubuntu 和 RHEL/CentOS 7 行会进行更多的测试(画外音：所以会更稳定一些)。。
	* 在 RHEL/CentOS 里，Docker 不支持默认的存储驱动器，比如devicemapper 使用的 loopback。所以请参考 Dcoker 的相关文档如何进行修改。
	* 对于RHEL / CentOS的，如果要启用SELinux的，需要[安装附加的SELinux模块](http://rancher.com/docs/rancher/v1.6/en/installing-rancher/selinux/)
*   1GB RAM
*   MySQL服务器应该设置 MAX_CONNECTIONS > 150
	* 配置要求：
		*   Option 1: Run with Antelope with default of `COMPACT`			  						
		*   Option 2: Run MySQL 5.7 with Barracuda where the default `ROW_FORMAT` is `Dynamic`

	*   推荐设置：
        *   `max_packet_size` > = 32M
        *   `innodb_log_file_size` > = 256M（如果你有一个现有的数据库，请确保适当的计划如何更改此设置。）
        *   `innodb_file_per_table=1`
        *   `innodb_buffer_pool_size` > = 1GB（对于内存较大的主机，建议4-8G池）

> 注：目前，Docker Mac 暂不支持 Rancher。

# Rancher server 标签

Rancher server 有两个不同的标签。对于每一个主要版本的标签，我们将提供特定版本的文档。

*   `rancher/server:latest`标签将是我们最新开发版本。这些版本会已经通过我们的CI自动化框架验证。这些版本不意味着在它们可以在生产环境中部署。
*   `rancher/server:stable`标签将是我们最新的稳定版本。这个标签是我们推荐用于生产的版本。

请不要使用有任何带有`rc{n}`后缀的版本。这些`rc`是 Rancher 的测试版本

# 启动 Rancher 服务器 - 单容器（非HA）

在已安装了 docker 的 Linux 机器上，启动 Rancher 的单个实例很简单。

```
$ sudo docker run -d --restart=unless-stopped -p 8080:8080 rancher/server
```
## Rancher 界面

Rancher 的界面和 API 可以通过 8080 端口访问。docker 镜像下载完成后，需要1到两分钟时间才可以使用。

进入网站: `http://<SERVER_IP>:8080`.  `<SERVER_IP>`是 Rancher server 的公网地址.

当 Rancher 界面启动后， 我们可以添加主机或者从应用仓库里添加容器。 默认情况下 Rancher 使用 cattle 作为容器编排的环境。在主机添加吼，我们就可以开始添加服务或者在应用商店中通过模板添加服务了。

# 启动 Rancher 服务器 - 单容器 - 外部数据库

我们可以指定使用外部数据库来启动 Rancher。 命令行还是相同的，不过我们会添加额外的参数来设定如何使用外部数据库。

> 注意：数据库，名称和数据库的用户需要事先创建好，模式Schema不需要创建。Rancher 将自动创建所有与 Rancher 的模式Schema。

下面是创建一个数据库和用户的SQL命令的例子。

```
> CREATE DATABASE IF NOT EXISTS cattle COLLATE = 'utf8_general_ci' CHARACTER SET = 'utf8';
> GRANT ALL ON cattle.* TO 'cattle'@'%' IDENTIFIED BY 'cattle';
> GRANT ALL ON cattle.* TO 'cattle'@'localhost' IDENTIFIED BY 'cattle';

```
要启动 Rancher 连接到外部数据库，我们要将额外的信息作为命令的一部分传给容器：

```
$ sudo docker run -d --restart=unless-stopped -p 8080:8080 rancher/server \
    --db-host myhost.example.com --db-port 3306 --db-user username --db-pass password --db-name cattle

```
大多数的选项有默认值，不是必需的。只有 MySQL 服务器的位置是必需的。

```
--db-host               IP or hostname of MySQL server
--db-port               port of MySQL server (default: 3306)
--db-user               username for MySQL login (default: cattle)
--db-pass               password for MySQL login (default: cattle)
--db-name               MySQL database name to use (default: cattle)

```

> 注： Rancher server 的早期版本中，我们使用环境变量连接到外部数据库，这些环境变量也会继续生效，不过我们建议使用参数来运行 Rancher

# 启动 Rancher 服务器 - 单容器 - 绑定 Mysql 数据卷

如果你想将容器的数据库与主机商的存储设备绑定起来，那么应当这么启动 Rancher server：
```
$ sudo docker run -d -v <host_vol>:/var/lib/mysql --restart=unless-stopped -p 8080:8080 rancher/server

```
使用此命令，数据库将会把数据卷绑定到主机上。如果你已经有了 Rancher 数据库，也想绑定 MySQL 数据卷，参考我们的[升级文件](http://rancher.com/docs/rancher/v1.6/en/upgrading/#single-container-bind-mount)。


# 启动 Rancher 服务器 - 全主动/主动HA

Rancher server 上跑 HA 和上文的跑外部数据库一样简单。通过一个额外的端口和参数，与外部的负载均衡器进行通信。

要求：

* HA节点:
	* 支持 Dcoekr 的 Linux 发行版。我们在 RancherOS Ubuntu 和 RHEL/CentOS 7 行会进行更多的测试(画外音：所以会更稳定一些)。
		* 在 RHEL/CentOS 里，Docker 不支持默认的存储驱动器，比如devicemapper 使用的 loopback。所以请参考 Dcoker 的相关文档如何进行修改。
		* 对于RHEL / CentOS的，如果要启用SELinux的，需要[安装附加的SELinux模块](http://rancher.com/docs/rancher/v1.6/en/installing-rancher/selinux/)
	*   1GB RAM
	*   节点之间开通需要的端口：`9345`，`8080`
*   MySQL服务器应该设置 MAX_CONNECTIONS > 150
	* 配置要求：
		*   Option 1: Run with Antelope with default of `COMPACT`			  						
		*   Option 2: Run MySQL 5.7 with Barracuda where the default `ROW_FORMAT` is `Dynamic`

* 外部负载均衡器
	*   `8080`

> 注：目前，Docker Mac 暂不支持 Rancher。

## 对大规模部署的建议


*   每个 Rancher server 节点应该有一个4 GB或8 GB 堆的大小，这需要具有至少8 GB或16 GB的RAM
*   MySQL数据库应该有快速磁盘
*   对于真正的HA，建议MySQL数据库进行适当策略的备份。例如构建一个 Galera Cluster，提高MySQL服务的可用性和性能。

1.  在每个要加入HA的节点，运行以下命令：

    ```
    # Launch on each node in your HA cluster
    $ docker run -d --restart=unless-stopped -p 8080:8080 -p 9345:9345 rancher/server \
         --db-host myhost.example.com --db-port 3306 --db-user username --db-pass password --db-name cattle \
         --advertise-address <IP_of_the_Node>
    ```
    对于每个节点，`<IP_of_the_Node>`都是唯一的，因为这将是正被加入到HA设置的每个特定节点的IP。
    如果你需要更改`-p 8080:8080`，使HTTP端口暴露在主机上的不同端口上，将需要添加`--advertise-http-port <host_port>`的命令。

    > 注意：您可以通过运行得到帮助的命令`docker run rancher/server --help`

2.  配置外部负载均衡器，平衡端口`80`和`443`之间的流量，将流量指向运行 Rancher Server 的节点池。负载平衡器必须支持的WebSockets和headers转发。请参阅[SSL设置页](http://rancher.com/docs/rancher/v1.6/en//installing-rancher/installing-server/basic-ssl-config/)查看配置示例。

## ADVERTISE-ADDRESS 配置

| Option | Example | Description |
| --- | --- | --- |
| IP address | `--advertise-address 192.168.100.100` | Uses the give IP address |
| Interface | `--advertise-address eth0` | Retrieves the IP of the given interface |
| awslocal | `--advertise-address awslocal` | Retrieves the IP from `http://169.254.169.254/latest/meta-data/local-ipv4` |
| ipify | `--advertise-address ipify` | Retrieves the IP from `https://api.ipify.org` |


## Rancher HA注意事项

如果你的 Rancher 主服务器节点更改IP，你的节点将不再是 Rancher HA 群集的一部分。您必须使用`--advertise-address` + 不正确的IP停止老的 Rancher server 容器 ，并使用 `--advertise-address` + 正确的IP 开始一个新的Rancher server 容器。

# 在 AWS 上运行 Rancher server 的 ELB

因为译者不用这一块，所以现在先不翻译了 2333333333333

## 在 AWS 的应用负载平衡器（ALB）

我们不再建议在AWS应用负载平衡器（ALB）在使用弹性/经典负载均衡器（ELB）。如果您仍然选择使用ALB，您需要将流量引导到节点上的HTTP端口，默认是`8080`端口。


# 启用ACTIVE DIRECTORY 或 OPENLDAP FOR TLS

要启用 Active Directory 或 OpenLDAP P for TLS， Rancher server 容器需要在启动时候加载由 LDAP 提供的证书。

我们需要通过绑定拥有证书的数据卷来启动 Rancher 容器。证书必须命名为`ca.crt`:

```
$ sudo docker run -d --restart=unless-stopped -p 8080:8080 \
  -v /some/dir/cert.crt:/var/lib/rancher/etc/ssl/ca.crt rancher/server

```
我们可以通过跟踪 Rancher server 地日志来检查 `ca.crt`是不是正确地传递给了 Rancher server：

```
$ docker logs <SERVER_CONTAINER_ID>
```
日志的开头，就会出现正确添加证书的信息。

```
Adding ca.crt to Certs.
Updating certificates in /etc/ssl/certs... 1 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d....done.
Certificate was added to keystore
```
# 启用 Rancher http 代理

为了启用 http 代理， docker daemon 需要修改代理的配置。在启动 Rancher server 之前进行配置:

	sudo vi /etc/default/docker

在文件中，编辑`#export http_proxy="http://127.0.0.1:3128"` 指向您的代理。保存更改，然后重新启动 Docker。

重启 Docker 的方式在不同操作系统之间会有所差别。

> 注： 如果您使用 systemd 运行 Docker，请根据 Docker 的[说明](https://docs.docker.com/articles/systemd/#http-proxy) 配置HTTP代理。

配置好了 Docker，为了在[Rancher 应用](http://rancher.com/docs/rancher/v1.6/en/catalog/)里也能加载，需要进行一些配置，并把代理的配置参数添加到 Rancher 的环境变量。

```
$ sudo docker run -d \
    -e http_proxy=<proxyURL> \
    -e https_proxy=<proxyURL> \
    -e no_proxy="localhost,127.0.0.1" \
    -e NO_PROXY="localhost,127.0.0.1" \
    --restart=unless-stopped -p 8080:8080 rancher/server

```

如果不使用 [Rancher 应用](http://rancher.com/docs/rancher/v1.6/en/catalog/)，按照正常情况启动 Rancher server 即可。

当 [主机添加](http://rancher.com/docs/rancher/v1.6/en/hosts/)到 Rancher 之后，后续就不需要再添加其他配置了。

# 与 MySQL 通过 SSL 通信

> 注：目前，Rancher 1.6.3+ 以上支持这个特性

## 重要提示

如果你使用了 LDAP/AD authentication 作为认证后端，由其它客户端生成CA证书(而不是MySQL生成的)，那么接下里的操作不适合你，不会达到预期效果。

## 要求

* 认证文件 或 MySQL 服务器的 CA 证书(PEM编码)

## 说明

1.  将服务器的证书或CA证书复制到 Rancher server 的主机。当启动`rancher/server`容器时需要挂载认证文件到`/lib/rancher/etc/ssl/ca.crt`。
2.  替换服务器变量中的默认值，构建一个自定义的JDBC URL：
    `jdbc:mysql://<DB_HOST>:<DB_PORT>/<DB_NAME>?useUnicode=true&characterEncoding=UTF-8&characterSetResults=UTF-8&prepStmtCacheSize=517&cachePrepStmts=true&prepStmtCacheSqlLimit=4096&socketTimeout=60000&connectTimeout=60000&sslServerCert=/var/lib/rancher/etc/ssl/ca.crt&useSSL=true`
3.  根据这个 JDBC URL 设置容器中的环境变量，包括 `CATTLE_DB_CATTLE_MYSQL_URL`和`CATTLE_DB_LIQUIBASE_MYSQL_URL`。

4.  在容器中设置 export `CATTLE_DB_CATTLE_GO_PARAMS="tls=true"`。如果服务器的证书的主题字段不匹配服务器的主机名，需要使用`CATTLE_DB_CATTLE_GO_PARAMS="tls=skip-verify"`代替。


#### 例子

```

$ export JDBC_URL="jdbc:mysql://<DB_HOST>:<DB_PORT>/<DB_NAME>?useUnicode=true&characterEncoding=UTF-8&characterSetResults=UTF-8&prepStmtCacheSize=517&cachePrepStmts=true&prepStmtCacheSqlLimit=4096&socketTimeout=60000&connectTimeout=60000&sslServerCert=/var/lib/rancher/etc/ssl/ca.crt&useSSL=true"

$ cat <<EOF > docker-compose.yml
version: '2'
  services:
    rancher-server:
      image: rancher/server:stable
      restart: unless-stopped
      command: --db-host <DB_HOST> --db-port <DB_PORT> --db-name <DB_NAME> --db-user <DB_USER> --db-pass <DB_PASS>
      environment:
        CATTLE_DB_LIQUIBASE_MYSQL_URL: $JDBC_URL
        CATTLE_DB_CATTLE_MYSQL_URL: $JDBC_URL
        CATTLE_DB_CATTLE_GO_PARAMS: "tls=true"
      volumes:
        - /path/to/mysql/ca.crt:/var/lib/rancher/etc/ssl/ca.crt
      ports:
        - "8080:8080"
EOF

$ docker-compose up -d

```

重要提示： 需要同时修改 JDBC URL 和 命令行中 `--db-xxx` 的变量！
