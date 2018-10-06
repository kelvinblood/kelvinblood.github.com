---
layout: post
title: Linux 使用 ssh-keygen 生成 RSA 密钥对
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)



# 什么是 SSH 和 RSA密钥

RSA 是一种公钥加密算法，在 1977 年由麻省理工学院的 Ron Rivest, Adi Shamir, Leonard Adleman 三人一起提出，因此该算法命名以三人姓氏首字母组合而成。

SSH 是 Secure Shell 缩写，是建立在应用层和传输层基础上的安全协议，为计算机上运行的 Shell 提供安全的传输和使用环境。

传统的 rsh, FTP, POP 和 Telnet 网络协议因为传输时采用明文，很容易受到中间人方式攻击。为了防止远程传输信息出现泄露，SSH 协议支持对传输的数据进行加密，因此它还能防止 DNS 和 IP 欺骗。另外采取 SSH 协议传输的数据可以进行压缩，所以可以加快数据传输速度。最初 SSH 协议由芬兰的 [Tatu Ylönen](http://zh.wikipedia.org/wiki/Tatu_Yl%C3%B6nen) 在 1995 年设计开发，目前属于 SSH Communications Security 拥有，由于版权原因，1999 年 10 月开源软件 **OpenSSH** 被开发出来，它已成为事实上的 SSH 协议标准实现（SSH Communications Security 提供的 SSH 软件使用不同于 OpenSSH 的私钥格式），也是目前 Linux 标准配置。

# 工具

OpenSSH 提供了以下几个工具：

1. ssh：实现 SSH 协议，用以建立安全连接，它替代了较早的 rlogin 和 Telnet。
2. scp, sftp：利用 SSH 协议远程传输文件，它替代了较早的 rcp。
3. sshd：SSH 服务器守护进程，运行在服务器端。
4. ssh-keygen：用以生成 RSA 或 DSA 密钥对。
5. ssh-agent, ssh-add：管理密钥的工具。
6. ssh-keyscan：扫描网络中的主机，记录找到的公钥。

# 方案

### 交互界面生成命令

```
$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/xavier/.ssh/id_rsa): id_rsa
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in id_rsa.
Your public key has been saved in id_rsa.pub.
The key fingerprint is:
ce:89:59:3d:a1:3a:99:b3:01:46:78:0f:d1:cc:d4:fa xavier@Qbee-X
The key's randomart image is:
+--[ RSA 2048]----+
|    .=..         |
|   . .+ .        |
|  . +  .  .      |
|   o o.  o .     |
|    o ..S o      |
|   . . XE. .     |
|      X +        |
|       =         |
|      .          |
+-----------------+
```

ssh-keygen 默认使用 RSA 算法，长度为 2048 位，生成一个私钥文件 id_rsa 和一个公钥文件 id_rsa.pub，两个文件默认保存在用户的 ~/.ssh 目录下。你可以在命令行交互过程指定密钥文件路径，也可以设置密钥口令，如果设置了密钥口令，在使用密钥进行登录时，需要输入口令。

### 快速生成命令

```
ssh-keygen -t rsa -P '' -f '/root/.ssh/id_rsa'
```

执行后将会生成 id_rsa 的密钥和 id_rsa.pub 的公钥。



# 参考资料

* [在 Linux CLI 使用 ssh-keygen 生成 RSA 密钥](https://www.cnblogs.com/ifantastic/p/3984150.html)