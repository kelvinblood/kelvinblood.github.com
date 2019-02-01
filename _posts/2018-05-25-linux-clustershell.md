---
layout: post
title: Linux：集群工具ClusterShell
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

ClusterShell 是一个轻量级的运维工具，可以在一台机器上向多台机器发送指令，轻松实现类似《黑客帝国》中批量关闭电厂的效果：

![](https://cdn.kelu.org/blog/2018/05/matrix1.gif)

ClusterShell每天在Linux超级计算机（拥有超过5000个计算节点）上使用。使用很简单，只要在主控机上配置好子节点的ssh密钥登陆，同时做好节点配置即可，非常便捷。这篇文章介绍它的安装和简单使用。

# 安装

```
yum install -y clustershell
// or
apt-get install clustershell
```



# 配置

在/etc/clustershell目录下，手动创建groups文件

```
$ vim /etc/clustershell/groups

all: a1 host1 host2
name:host3 host4
adm: example0
oss: example4 example5
mds: example6
io: example[4-6]
compute: example[32-159]
gpu: example[156-159]
hadoop: z[1-4]


# 需要注意的是all 是必须配置的。
```

`hadoop: z[1-4]`，是指定hadoop组中有四个节点，分别是z1，z2，z3，z4。

其它的配置也类似，可以加入多个组，使用的时候通过`-g hadoop`来选择。

# 命令

```
clush -a 全部 等于 clush -g all
clush -g 指定组
clush -w 操作主机名字，多个主机之间用逗号隔开
clush -g 组名 -c  --dest 文件群发     （-c等于--copy）

注意：clush 是不支持环境变量的 $PATH
```

# 实例

#### 输出所有节点的信息

```
$ clush -a "uptime"
$ clush -b -a "uptime"
```

#### 删除指定节点的文件

```
$ clush -w z2,z3,z4 rm -rf /mnt/zhao/soft/jdk
```

#### 集群分发文件

```
$ clush -b -g hadoop --copy /mnt/zhao/package/jdk-7u79-linux-x64.tar.gz --dest /mnt/zhao/package/
```

#### 集群查看文件

查看所有hadoop组中/mnt/zhao/package/目录下的文件，输出结果合并。

```
$ clush -b -g hadoop ls /mnt/zhao/package/
```

#### 交互模式

启动clush，后面不带命令，就进入交互模式： 

```
$ clush -w hadoop
```

# 参考资料

* [Ubuntu安装使用clustershell](https://blog.csdn.net/logsharp/article/details/50612767)
* [Linux：集群工具ClusterShell](http://zhaodedong.leanote.com/post/Linux%EF%BC%9A%E9%9B%86%E7%BE%A4%E5%B7%A5%E5%85%B7ClusterShell)