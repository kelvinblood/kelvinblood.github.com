---
layout: post
title: Rancher 上线应用商店的基本流程
category: tech
tags: rancher
---
![](https://cdn.kelu.org/blog/tags/rancher.jpg)

在 Rancher 中，编写好 docker-commpose.yaml 和 rancher-compose.yaml 后，我们就可以部署应用了。
然而当我们给客户提供容器模板时候，更简单的方式还是走应用商店。

Rancher提供了一个应用商店，通过商店中的应用程序模版的可以简化部署复杂应用的过程。这篇文章简单记录一下创建私有应用商店的步骤。

可以查看 github 上的社区商店帮助理解：<https://github.com/rancher/community-catalog> 

*   _Cattle_ 调度引擎:`templates`文件夹
*   _[Swarm](http://rancher.com/docs/rancher/v1.6/zh/swarm/)_ 调度引擎: `swarm-templates`文件夹
*   _[Mesos](http://rancher.com/docs/rancher/v1.6/zh/mesos/)_ 调度引擎: `mesos-templates`文件夹


# 私有商店项目

```
-- templates (Or any of templates folder)
  |-- cloudflare
  |   |-- 0
  |   |   |-- docker-compose.yml
  |   |   |-- rancher-compose.yml
  |   |-- 1
  |   |   |-- docker-compose.yml
  |   |   |-- rancher-compose.yml
  |   |-- catalogIcon-cloudflare.svg
  |   |-- config.yml
...
```
* 私有仓库至少要包含一个模板目录，明明为前文描述的那几个`templates`。这个目录确定 Rancher 的调用引擎。
* 在这个`templates`目录下就放置我们的应用模板了。假设是 `cloudflare`。
* 在 `cloudflare`文件夹中包含0、1、2等文件夹。第一个版本为`0`，后续每个版本加1。每增加一个新版本的文件夹，你就可以使用这个新版本的应用模版来升级应用了。另外，你也可直接更新`0`文件夹中的内容并重新部署应用。
* 在`cloudflare`文件夹中还包含两个文件，一个是 config.yml，包含了应用模板的详细信息。另一个是模板的logo，以 `catalogIcon-` 开头。

以我的 hello world 为例，config.yml 的内容如下，单词的解释也蛮清楚得了：

	name: Pingpong
	description: kelu's ping pong hello world
	version: v0.01
	category: Entertainment
	maintainer: kelvin blood <xxx@xxx.org>

将这个项目部署到 Rancher 可以访问的 git 服务器上，在 Rancher 设置中添加好就可以使用了。可以查看我的：
<https://github.com/kelvinblood/community-catalog/tree/init>

# Rancher 添加

在 Rancher 中一共有四种应用商店：

* 个人应用商店
* 共享应用商店
* 社区应用商店
* 官方应用商店

作为管理员可以将社区和官方应用商店关闭掉。如果以管理员身份添加的的应用商店，即为共享应用商店：

![](https://cdn.kelu.org/blog/2017/11/rancher41.jpg)

个人用户添加的应用商店入口在这：

![](https://cdn.kelu.org/blog/2017/11/rancher42.jpg)

![](https://cdn.kelu.org/blog/2017/11/rancher43.jpg)

# 参考资料

* [创建私有应用商店](http://rancher.com/docs/rancher/v1.6/zh/catalog/private-catalog/)