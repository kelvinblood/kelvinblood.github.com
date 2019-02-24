---
layout: post
title: 在 Debian 中安装 node.js
category: tech
tags: nodejs
---
![](https://cdn.kelu.org/blog/tags/nodejs.jpg)

# 背景

以前博客有两篇涉及到nodejs，当时只是轻度使用，不甚熟悉。估计今后使 nodejs 的地方会越来越多，本文整理了node 的一些笔记。

# 介绍

简单来说，nodejs 就是运行在服务端的JavaScript。

为什么要使用 nodejs ？它跟 java PHP 有什么区别呢？

node.js 有非阻塞，事件驱动I/O等特性，非常适合高并发的应用。

以上说明对于一些人来说可能显得晦涩不少，又要去查什么叫非阻塞、事件驱动等。下面是更简单的解释。

> 在 Java™ 和 PHP 这类语言中，每个连接都会生成一个新线程，每个新线程可能需要 2 MB 的配套内存。在一个拥有 8 GB RAM 的系统上，理论上最大的并发连接数量是 4,000 个用户。随着您的客户群的增长，如果希望您的 Web 应用程序支持更多用户，那么，您必须添加更多服务器。当然，这会增加服务器成本、流量成本和人工成本等成本。
>
> 除这些成本上升外，还有一个潜在技术问题，即用户可能针对每个请求使用不同的服务器，因此，任何共享资源都必须在所有服务器之间共享。
>
> 鉴于上述所有原因，整个 Web 应用程序架构（包括流量、处理器速度和内存速度）中的瓶颈是：服务器能够处理的并发连接的最大数量。
>
> 
>
> Node 解决这个问题的方法是：更改连接的方式。每个连接发生一个在 Node 引擎进程中的事件，而不是为每个连接生成一个新的线程（并为其分配一些配套内存）。Node 不会死锁，因为它根本不允许使用锁，它不会直接阻塞 I/O 调用。
>
> 转自：<https://www.ibm.com/developerworks/cn/opensource/os-nodejs/index.html>

# 安装

我是用的系统为 Debian 8.8，root用户。

安装可用三种方式：

1. 源安装
2. PPA安装
3. mvm安装

## 1. 源安装

```
apt-get update
apt-get install nodejs npm
```

查看版本：

```
nodejs -v
npm -v
```

如果你是用普通用户安装，要确保该用户拥有 sudo 权限。

如果使用root用户安装，另外增加如下命令：

```
npm config set user 0
npm config set unsafe-perm true
```



## 2. PPA安装

```
curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
bash nodesource_setup.sh

apt-get install nodejs npm
```

查看版本：

```
nodejs -v
npm -v
```

如果你是用普通用户安装，要确保该用户拥有 sudo 权限。

如果使用root用户安装，另外增加如下命令：

```
npm config set user 0
npm config set unsafe-perm true
```

为了使某些`npm`包能够工作（例如，需要从源代码编译代码），需要安装`build-essential`包：

```
apt-get install build-essential
```



## 3. NVM安装

```
curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh -o install_nvm.sh
```

运行脚本`bash`：

```
bash install_nvm.sh
```

软件会安装到`~/.nvm`。它还在`~/.profile`文件添加三行以使用nvm，你可以参考。如果使用zsh的话依样画葫芦把它拷贝到 `~/.zshrc`中。

查看可用的Node.js版本的信息：

```
nvm ls-remote
```

我选择了最新的长期支持版本：

```
nvm install 8.11.1
nvm use 8.11.1
```

查看版本：

```
node -v
npm -v
```

安装模块时需要注意如下事项，以`express`模块为例:

```
npm install express
```

如果您想要全局安装模块，使用相同版本的Node.js将其提供给其他项目，您可以添加`-g`标志：

```
npm install -g express
```

这将安装包：

```
~/.nvm/versions/node/node_version/lib/node_modules/express
```

全局安装模块将允许您从命令行运行命令，但是您必须将程序包链接到本地范围以从程序中请求它：

```
npm link express
```

## 卸载

以前两种方式安装的，运行如下命令卸载：

```
sudo apt remove nodejs
```

使用nvm方式的，运行如下命令卸载：

1. 确定要删除的版本是否为当前活动版本：

  ```
  nvm current
  ```

1. 如果您要定位的版本**不是**当前的活动版本，则可以运行：

  ```
  nvm uninstall node_version
  ```
  
  此命令将卸载所选的Node.js版本。

1. 如果要删除的版本**是**当前活动版本，则必须先停用`nvm`以启用更改：

  ```
  nvm deactivate
  ```

# 参考资料

* [Node.js 究竟是什么？ - IBM](https://www.ibm.com/developerworks/cn/opensource/os-nodejs/index.html)

* [如何在Debian 9上安装Node.js](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-debian-9)

* [sh: 1: node: Permission denied](https://www.jianshu.com/p/0128c90d6746)

  ​
