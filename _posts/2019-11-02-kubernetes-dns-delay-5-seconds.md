---
layout: post
title: kubernetes 集群中的5秒 DNS 延迟
category: tech
tags: kubernetes
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

这是个讨论了很久的问题，网上也有很多文章讨论出了结果。因为近期也遇上了这样的问题，将问题解决过程记录下来。

# 一、问题

一个新搭建的环境，在进行系统各项指标测试时，发现dns解析有延迟：

<<https://k8smeetup.github.io/docs/tasks/administer-cluster/dns-debugging-resolution/>>

运行命令：

```
kubectl exec -it busybox-check-dns-bjp -n monitor -- nslookup kubernetes.default 10.190.0.10
```

可以明显看到解析延迟。

添加 time 命令，可以看到dns解析延迟为5s,10s,15s等规律的延迟。

![1572926381234](https://cdn.kelu.org/blog/2019/11/1572926381234.jpg)

运行的busybox为 `busybox:1.28.4`.

# 二、原因分析

这一块已经有太多雷同的文章，源头应该都是一样的，下面贴几个分析比较好的原因：

<https://tencentcloudcontainerteam.github.io/2018/10/26/DNS-5-seconds-delay/>

### DNS 5秒延时

在pod中(通过nsenter -n tcpdump)抓包，发现是有的DNS请求没有收到响应，超时5秒后，再次发送DNS请求才成功收到响应。

在kube-dns pod抓包，发现是有DNS请求没有到达kube-dns pod， 在中途被丢弃了。

为什么是5秒？ `man resolv.conf`可以看到glibc的resolver的缺省超时时间是5s。

### 丢包原因

经过搜索发现这是一个普遍问题。
根本原因是内核conntrack模块的bug。

Weave works的工程师[Martynas Pumputis](https://tencentcloudcontainerteam.github.io/2018/10/26/DNS-5-seconds-delay/martynas@weave.works)对这个问题做了很详细的分析：
<https://www.weave.works/blog/racy-conntrack-and-dns-lookup-timeouts>

相关结论：

- 只有多个线程或进程，并发从同一个socket发送相同五元组的UDP报文时，才有一定概率会发生
- glibc, musl(alpine linux的libc库)都使用”parallel query”, 就是并发发出多个查询请求，因此很容易碰到这样的冲突，造成查询请求被丢弃
- 由于ipvs也使用了conntrack, 使用kube-proxy的ipvs模式，并不能避免这个问题

# 三、相关解决办法

因为这个涉及系统bug，根本的解决办法是修改内核，然而对大部分人来说不现实。于是产生了以下几种规避方式：

### 使用TCP发送DNS请求

在容器的resolv.conf中增加`options use-vc`, 强制glibc使用TCP协议发送DNS query。下面是这个man resolv.conf中关于这个选项的说明：

```
use-vc (since glibc 2.14)
                     Sets RES_USEVC in _res.options.  This option forces the
                     use of TCP for DNS resolutions.
```

### 避免相同五元组DNS请求的并发

resolv.conf：

- single-request-reopen
  发送A类型请求和AAAA类型请求使用不同的源端口。这样两个请求在conntrack表中不占用同一个表项，从而避免冲突。
- single-request
  避免并发，改为串行发送A类型和AAAA类型请求。没有了并发，从而也避免了冲突。

具体容器中的办法参考腾讯云的文章链接。

关于五元组是什么，看到这里的朋友大概率是不知道这个概念的：

![1572931550902](https://cdn.kelu.org/blog/2019/11/1572931550902.jpg)

# 四、复盘解决过程

看完相关的文章（一篇文章到处转载内容一毛一样）后，虽然原理和解决办法讲清楚了，实际上还是没有告诉看客们应该如何操作。

半天研究下来，我感觉实际上该问题包含三个方面：

1. 观察到dns延迟的现象
2. 系统层面解决dns延迟问题
3. 再观察是否存在dns延迟现象

这三个方面都很重要，例如第三步，如果观察和再观察选择的工具有问题，你仍会蒙在鼓里。

### 1、观察到问题

针对第一步，观察到现象，一家成熟的公司，还是尽量不要让客户帮我们发现问题，应当有自己的一套工具，用来验证整个系统处于正常状态。

我们使用 `busybox:1.28.4` 进行测试，发现了这个问题：

```
time nslookup kubernetes.default 10.190.0.10
```

### 2、尝试解决

修改容器中 resolv.conf 的当然简单，使用 busybox:1.28.4 修改即可：

![1572931831600](https://cdn.kelu.org/blog/2019/11/1572931831600.jpg)

经过测试发现，虽然解析延迟的概率降低了，但仍然是有问题的。

![1572931940527](https://cdn.kelu.org/blog/2019/11/1572931940527.jpg)

同理，我们修改了所有主机的resolv.conf，以期解决问题。

```
cat /etc/resolv.conf

nameserver 10.10.30.10
nameserver 10.10.10.10
options timeout:1 attempts:2 single-request-reopen
```

与单独修改 busybox 的结果是一样的，解析延迟的问题大大缓解，但仍然没有达到100%解决。

### 3、改用 glibc 1.28.4 版本的busybox

经过群友的提醒，改用了该版本 busybox 后，结果达到了 100% 无延迟。

![1572932362328](https://cdn.kelu.org/blog/2019/11/1572932362328.jpg)

至此，问题得到解决。

# 参考资料

* [kubernetes集群中夺命的5秒DNS延迟 - 腾讯云容器团队](<https://tencentcloudcontainerteam.github.io/2018/10/26/DNS-5-seconds-delay/>)
* [DNS解析超时排查/etc/resolv.conf single-request-reopen参数说明](https://www.cnblogs.com/zhangmingda/p/9725746.html)
* <https://k8smeetup.github.io/docs/tasks/administer-cluster/dns-debugging-resolution/>
* [在 Kubernetes 中配置私有 DNS 和上游域名服务器](<https://kubernetes.io/zh/docs/tasks/administer-cluster/dns-custom-nameservers/>)
* [DNS intermittent delays of 5s #56903 - github issue](<https://github.com/kubernetes/kubernetes/issues/56903>)
* [搭建Kubernetes集群时DNS无法解析问题的处理过程](https://segmentfault.com/a/1190000015639327)
* [CoreDNS系列1：Kubernetes内部域名解析原理、弊端及优化方式](<https://hansedong.github.io/2018/11/20/9/>)