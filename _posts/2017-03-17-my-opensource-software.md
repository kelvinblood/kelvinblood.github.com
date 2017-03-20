---
layout: post
title: 我的开源项目 - KeluLinuxKit
category: tech
tags: opensource shell
---

![](/assets/img/linux.jpg)

因为一个人管着好几台服务器，每一次部署相同的环境都很揪心。这个项目也断断续续搞了好久。终于在最近弄好了我的这个开源项目。以后部署新服务器再也不纠结了。

[KeluLinuxKit][kelulinuxkit] 主要是面向 Debian 系机器的。在 Linode 上使用没有问题。安装了以下软件：

* oh my zsh
* Maximum Awesome
* tmux-powerline
* iptables
* openresty
* php5.6
* postgresql9.4
* composer
* docker
* docker_pptp
* docker_shadowsocks
* l2tp
* server-client pptp & shadowsocks

pptp、l2tp和shadowsocks基于集群主从模式的。通过cron自动同步和下发用户数据。虽然这个模式需要和我的某个网站项目配套才能使用，但是机制已经搭建好了，如果你也有，只需要稍作修改便可。

当然这个项目我会持续更新下去，有新软件需要使用的话也会添加进去。

[kelulinuxkit]: https://github.com/kelvinblood/KeluLinuxKit