---
layout: post
title: 防止容器因 jvm 占用资源过多被杀死而频繁重启
category: tech
tags: docker java
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

本文记录 jvm 和 elasticsearch 在容器中的设置要点。

# JVM

不完全翻译自<https://blog.csanchez.org/2017/05/31/running-a-jvm-in-a-container-without-getting-killed/>。

JDK 8u131 在 JDK 9 中有一个特性，可以在 Docker 容器运行时能够检测到多少内存的能力，这个功能在我看来，颇为流氓。

在容器内部运行 JVM，它在大多数情况下将如何默认最大堆为主机内存的1/4，而非容器内存的1/4。如果对 Java 容器中的jvm虚拟机不做任何限制，当我们同时运行几个 java 容器时，很容易导致服务器的内存耗尽、负载飙升而宕机；而如果我们对容器直接进行限制，就会导致内核在某个时候杀死 jvm 容器而导致频繁重启。

例如：

```
$ docker run -m 100MB openjdk:8u121 java -XshowSettings:vm -version
VM settings:
    Max. Heap Size (Estimated): 444.50M
    Ergonomics Machine Class: server
    Using VM: OpenJDK 64-Bit Server VM
```

下面我们尝试 JDK 8u131 中的实验性参数 `-XX:+UseCGroupMemoryLimitForHeap`

```
$ docker run -m 100MB openjdk:8u131 java \
  -XX:+UnlockExperimentalVMOptions \
  -XX:+UseCGroupMemoryLimitForHeap \
  -XshowSettings:vm -version
VM settings:
    Max. Heap Size (Estimated): 44.50M
    Ergonomics Machine Class: server
    Using VM: OpenJDK 64-Bit Server VM
```

JVM能够检测容器只有100MB，并将最大堆设置为44M。

下面尝试一个更大的容器

```
$ docker run -m 1GB openjdk:8u131 java \
  -XX:+UnlockExperimentalVMOptions \
  -XX:+UseCGroupMemoryLimitForHeap \
  -XshowSettings:vm -version
VM settings:
    Max. Heap Size (Estimated): 228.00M
    Ergonomics Machine Class: server
    Using VM: OpenJDK 64-Bit Server VM
```

嗯，现在容器有1GB，但JVM仅使用228M作为最大堆。

除了JVM正在容器中运行以外，我们是否还可以优化它呢？

```
$ docker run -m 1GB openjdk:8u131 java \
  -XX:+UnlockExperimentalVMOptions \
  -XX:+UseCGroupMemoryLimitForHeap \
  -XX:MaxRAMFraction=1 -XshowSettings:vm -version
VM settings:
    Max. Heap Size (Estimated): 910.50M
    Ergonomics Machine Class: server
    Using VM: OpenJDK 64-Bit Server VM
```

使用`-XX:MaxRAMFraction` 我们告诉JVM使用可用内存/ MaxRAMFraction作为最大堆。使用`-XX:MaxRAMFraction=1`我们几乎所有可用的内存作为最大堆。

# elasticsearch

不完全翻译自<https://www.elastic.co/guide/en/elasticsearch/reference/5.4/heap-size.html>

Elasticsearch 将通过Xms（最小堆大小）和Xmx（最大堆大小）设置来分配 jvm.options 指定的整个堆，默认使用最小和最大大小为2 GB的堆。这些设置的值取决于服务器上可用的内存。在生产环境时，要确保 Elasticsearch 有足够的可用堆。

一些好的经验是：

- 将最小堆大小（Xms）和最大堆大小（Xmx）设置为彼此相等。

- Elasticsearch 可用的堆越多，可用于缓存的内存就越多。但太多的堆会导致一直进行垃圾回收。

- 将 Xmx 设置为不超过物理内存的50％，以确保有足够的物理内存留给内核文件系统缓存。

- 不要将 Xmx 设置为J VM 用于压缩对象指针（压缩oops）的临界值以上，接近32 GB。可以通过在日志中查找一行来验证您是否处于限制之下，如下所示：

  ```
  heap size [1.9gb], compressed ordinary object pointers [true]
  ```

- Even better, try to stay below the threshold for zero-based compressed oops; the exact cutoff varies but 26 GB is safe on most systems, but can be as large as 30 GB on some systems. You can verify that you are under the limit by starting Elasticsearch with the JVM options `-XX:+UnlockDiagnosticVMOptions -XX:+PrintCompressedOopsMode` and looking for a line like the following:

  ```
  heap address: 0x000000011be00000, size: 27648 MB, zero based Compressed Oops
  ```

  showing that zero-based compressed oops are enabled instead of

  ```
  heap address: 0x0000000118400000, size: 28672 MB, Compressed Oops with base: 0x00000001183ff000
  ```

以下是如何通过jvm.options文件设置堆大小的示例：

```
-Xms2g 
-Xmx2g 
```

也可以通过环境变量设置堆大小。

```
ES_JAVA_OPTS ="- Xms2g -Xmx2g"./bin/elasticsearch 
ES_JAVA_OPTS ="- Xms4000m -Xmx4000m"./bin/elasticsearch 
```

# 参考资料

* [Set JVM heap size via jvm.options](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/heap-size.html)
* [Install Elasticsearch with Docker](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docker.html)
* [Passing ES_JAVA_OPTS variable with spaces when using docker compose](https://stackoverflow.com/questions/44926335/passing-es-java-opts-variable-with-spaces-when-using-docker-compose)
* [Why my Java application is OOMKilled](https://banzaicloud.com/blog/java-resource-limits/)
* [Docker and Java: Why My App Is OOMKilled](https://dzone.com/articles/why-my-java-application-is-oomkilled)