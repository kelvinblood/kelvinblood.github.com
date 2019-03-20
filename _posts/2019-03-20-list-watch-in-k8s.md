---
layout: post
title: 理解 K8S 的设计精髓之 list-watch - koala bear
category: tech
tags: kubernetes
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

> 博主是蘑菇街的员工，写了不少kubernetes的文章。这篇的原文链接：<http://wsfdl.com/kubernetes/2019/01/10/list_watch_in_k8s.html>

散，进而为 K8S 的设计理念所折服。List-watch 是 K8S 统一的异步消息处理机制，保证了消息的实时性，可靠性，顺序性，性能等等，为声明式风格的 API 奠定了良好的基础，它是优雅的通信方式，是 K8S 架构的精髓。

## List-Watch 是什么

Etcd 存储集群的数据信息，apiserver 作为统一入口，任何对数据的操作都必须经过 apiserver。客户端(kubelet/scheduler/ontroller-manager)通过 list-watch 监听 apiserver 中资源(pod/rs/rc 等等)的 create, update 和 delete 事件，并针对事件类型调用相应的事件处理函数。

那么 list-watch 具体是什么呢，顾名思义，list-watch 有两部分组成，分别是 list 和 watch。list 非常好理解，就是调用资源的 list API 罗列资源，基于 HTTP 短链接实现；watch 则是调用资源的 watch API 监听资源变更事件，基于 HTTP 长链接实现，也是本文重点分析的对象。以 pod 资源为例，它的 list 和 watch API 分别为：

[List API](https://v1-10.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#list-all-namespaces-63)，返回值为 [PodList](https://v1-10.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#podlist-v1-core)，即一组 pod。

```
GET /api/v1/pods
```

[Watch API](https://v1-10.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#watch-list-all-namespaces-66)，往往带上 watch=true，表示采用 HTTP 长连接持续监听 pod 相关事件，每当有事件来临，返回一个 [WatchEvent](https://v1-10.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#watchevent-v1-meta)。

```
GET /api/v1/watch/pods
```

K8S 的 informer 模块封装 list-watch API，用户只需要指定资源，编写事件处理函数，AddFunc, UpdateFunc 和 DeleteFunc 等。如下图所示，informer 首先通过 list API 罗列资源，然后调用 watch API 监听资源的变更事件，并将结果放入到一个 FIFO 队列，队列的另一头有协程从中取出事件，并调用对应的注册函数处理事件。Informer 还维护了一个只读的 Map Store 缓存，主要为了提升查询的效率，降低 apiserver 的负载。

![list watch](https://cdn.kelu.org/blog/2019/03/listwatch.jpg)

## Watch 是如何实现的

List 的实现容易理解，那么 Watch 是如何实现的呢？Watch 是如何通过 HTTP 长链接接收 apiserver 发来的资源变更事件呢？

秘诀就是 [Chunked transfer encoding(分块传输编码)](https://zh.wikipedia.org/zh-hans/%E5%88%86%E5%9D%97%E4%BC%A0%E8%BE%93%E7%BC%96%E7%A0%81)，它首次出现在 HTTP/1.1 。正如维基百科所说：

> HTTP 分块传输编码允许服务器为动态生成的内容维持 HTTP 持久链接。通常，持久链接需要服务器在开始发送消息体前发送Content-Length消息头字段，但是对于动态生成的内容来说，在内容创建完之前是不可知的。使用分块传输编码，数据分解成一系列数据块，并以一个或多个块发送，这样服务器可以发送数据而不需要预先知道发送内容的总大小。

当客户端调用 watch API 时，apiserver 在 response 的 HTTP Header 中设置 Transfer-Encoding 的值为 chunked，表示采用分块传输编码，客户端收到该信息后，便和服务端该链接，并等待下一个数据块，即资源的事件信息。例如：

```
$ curl -i http://{kube-api-server-ip}:8080/api/v1/watch/pods?watch=yes
HTTP/1.1 200 OK
Content-Type: application/json
Transfer-Encoding: chunked
Date: Thu, 02 Jan 2019 20:22:59 GMT
Transfer-Encoding: chunked

{"type":"ADDED", "object":{"kind":"Pod","apiVersion":"v1",...}}
{"type":"ADDED", "object":{"kind":"Pod","apiVersion":"v1",...}}
{"type":"MODIFIED", "object":{"kind":"Pod","apiVersion":"v1",...}}
...
```

## 谈谈 List-Watch 的设计理念

当设计优秀的一个异步消息的系统时，对消息机制有至少如下四点要求：

- 消息可靠性
- 消息实时性
- 消息顺序性
- 高性能

首先消息必须是可靠的，list 和 watch 一起保证了消息的可靠性，避免因消息丢失而造成状态不一致场景。具体而言，list API 可以查询当前的资源及其对应的状态(即期望的状态)，客户端通过拿期望的状态和实际的状态进行对比，纠正状态不一致的资源。Watch API 和 apiserver 保持一个长链接，接收资源的状态变更事件并做相应处理。如果仅调用 watch API，若某个时间点连接中断，就有可能导致消息丢失，所以需要通过 list API 解决消息丢失的问题。从另一个角度出发，我们可以认为 list API 获取全量数据，watch API 获取增量数据。虽然仅仅通过轮询 list API，也能达到同步资源状态的效果，但是存在开销大，实时性不足的问题。

消息必须是实时的，list-watch 机制下，每当 apiserver 的资源产生状态变更事件，都会将事件及时的推送给客户端，从而保证了消息的实时性。

消息的顺序性也是非常重要的，在并发的场景下，客户端在短时间内可能会收到同一个资源的多个事件，对于关注最终一致性的 K8S 来说，它需要知道哪个是最近发生的事件，并保证资源的最终状态如同最近事件所表述的状态一样。K8S 在每个资源的事件中都带一个 resourceVersion 的标签，这个标签是递增的数字，所以当客户端并发处理同一个资源的事件时，它就可以对比 resourceVersion 来保证最终的状态和最新的事件所期望的状态保持一致。

List-watch 还具有高性能的特点，虽然仅通过周期性调用 list API 也能达到资源最终一致性的效果，但是周期性频繁的轮询大大的增大了开销，增加 apiserver 的压力。而 watch 作为异步消息通知机制，复用一条长链接，保证实时性的同时也保证了性能。

## 最后

List-Watch 基于 HTTP 协议，是 K8S 重要的异步消息通知机制。它通过 list 获取全量数据，通过 watch API 监听增量数据，保证消息可靠性，实时性，性能和顺序性。而消息的实时性，可靠性和顺序性又是实现声明式设计的良好前提。它简洁优雅，功能强大，是 K8S 的精髓之一。本人读后，叹为观止。