---
layout: post
title: kubernetes 创建 charts 的示例
category: tech
tags: docker kubernetes
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

本文记录将 eclipse 的物联网开源应用 kapua 容器化为 kubernetes charts 的要点。 项目demo也在我的github上面：[kelvinblood/kapua-kubernetes](https://github.com/kelvinblood/kapua-kubernetes)

# 一 docker-compose

首先我们在官网上 <https://www.eclipse.org/kapua/getting-started.php> 看到 kapua 的启动命令：

```
$ docker run -td --name kapua-sql -p 8181:8181 -p 3306:3306 kapua/kapua-sql:0.3.2

$ docker run -td --name kapua-elasticsearch -p 9200:9200 -p 9300:9300 elasticsearch:5.4.0 -Ecluster.name=kapua-datastore -Ediscovery.type=single-node -Etransport.host=_site_ -Etransport.ping_schedule=-1 -Etransport.tcp.connect_timeout=30s

$ docker run -td --name kapua-broker --link kapua-sql:db --link kapua-elasticsearch:es --env commons.db.schema.update=true -p 1883:1883 -p 61614:61614 kapua/kapua-broker:0.3.2

$ docker run -td --name kapua-console --link kapua-sql:db --link kapua-broker:broker --link kapua-elasticsearch:es --env commons.db.schema.update=true -p 8080:8080 kapua/kapua-console:0.3.2

$ docker run -td --name kapua-api --link kapua-sql:db --link kapua-broker:broker --link kapua-elasticsearch:es --env commons.db.schema.update=true -p 8081:8080 kapua/kapua-api:0.3.2
```

在这里可以看到 kapua 一共分成五个组件：

* sql
* es
* broker
* console
* api

我们先将这几个命令行组合起了成为一个 docker-compose 文件，便于管理：

```
version: '2'
services:
  kapua-sql:
    image: iot/kapua-sql:0.3.2
    restart: always

  kapua-elasticsearch:
    image: elasticsearch:5.4.0
    restart: always
    command:
    - -Ecluster.name=kapua-datastore
    - -Ediscovery.type=single-node
    - -Etransport.host=_site_
    - -Etransport.ping_schedule=-1
    - -Etransport.tcp.connect_timeout=30s

  kapua-broker:
    image: iot/kapua-broker:0.3.2
    restart: always
    links:
      - kapua-sql:db
      - kapua-elasticsearch:es
    environment:
      - commons.db.schema.update=true
      - DB_PORT_3306_TCP_PORT=3306
    ports:
      - "1883:1883"
      - "61614:61614"

  kapua-console:
    image: iot/kapua-console:0.3.2
    restart: always
    links:
      - kapua-sql:db
      - kapua-elasticsearch:es
      - kapua-broker:broker
    environment:
      - commons.db.schema.update=true
    ports:
      - "8080:8080"

  kapua-api:
    image: iot/kapua-api:0.3.2
    restart: always
    links:
      - kapua-sql:db
      - kapua-elasticsearch:es
      - kapua-broker:broker
    environment:
      - commons.db.schema.update=true
    ports:
      - "8080:8080"
```

有了这个文件，在单机上我们可以直接使用 `docker-compose up -d` 部署应用。

# 二 转换为chart

### 入门

对于新手来说，有一个很好的应用，可以快速辅助你将 docker-compose 文件转换成 kubernetes 的应用—— [kompose](https://github.com/kubernetes/kompose) 。使用方法也很简单

```
# Linux
curl -L https://github.com/kubernetes/kompose/releases/download/v1.14.0/kompose-linux-amd64 -o kompose

# macOS
curl -L https://github.com/kubernetes/kompose/releases/download/v1.14.0/kompose-darwin-amd64 -o kompose

chmod +x kompose
sudo mv ./kompose /usr/local/bin/kompose
```

以上安装完成后使用以下命令转换

```
kompose convert -f docker-compose.yaml 
```

即可将文件转换成 kubernetes chart 文件。下图就是使用命令转换后的文件列表(templates目录)。

![](https://cdn.kelu.org/blog/2018/06/20180620141933.jpg)

之后，我们使用 helm 创建 charts 的命令行创建chart，清空 templates 目录后将刚才的文件挪进去。

### 修改

不过使用 kompose 转换的文件还是有一些问题的，直接放到文件夹中并不好用。比如它没有使用values.yaml，没有生成namespace，没有资源限制等等，我们需要用以下的方式将其改造的更符合我们的要求。

注意事项:

1. name: 字段不允许使用骆驼峰模式，可使用分隔符 -，英文需要全部小写。
2. value.yaml中的变量，不要使用分隔符 - ，会与变量解释器产生冲突，编译的时候报错。可以使用骆驼峰。
3. 注意缩进问题，缩进不对或者带tab也会报错。

接下来做一些改造：

1. 在 template 文件夹中使用_helpers.tpl文件，以便在 yaml 文件中使用重复的字段。

   我做了一个简单的小改造：

   ![](https://cdn.kelu.org/blog/2018/06/20180620161144.jpg)

   这里面定义了两个变量，name和fullname，可以在yaml文件中直接使用：

   ![](https://cdn.kelu.org/blog/2018/06/20180620161200.jpg)

2. 使用 ingress：

   我这里使用的是traefik作为ingress的实现方式，需要事先安装好traefik。ingress.yaml 配置如下：

   ![](https://cdn.kelu.org/blog/2018/06/20180620162000.jpg)

   ​

3. 创建 namespace

   ![](https://cdn.kelu.org/blog/2018/06/20180620162031.jpg)

4. 配置灵活的 values.yaml，将镜像前缀设置成可配的(方便内网应用部署)

   ![](https://cdn.kelu.org/blog/2018/06/20180620162102.jpg)

5. 为Java虚拟机 jvm 做资源限制，以console作为例子

   ![](https://cdn.kelu.org/blog/2018/06/20180620162537.jpg)

   在values.yaml中配置如下：

   ```
   kapuaConsole:
     containerPort: 8080
     javaOpts: -Xms80m -Xmx80m -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -Xmn10m -XX:PermSize=16M -XX:MaxPermSize=64M
     service:
       type: NodePort
   ```

6. 使用service的name为服务创建别名，以broker作为例子：

   ![](https://cdn.kelu.org/blog/2018/06/20180620162638.jpg)

   ​

7. 限制pod和container的资源

   ![](https://cdn.kelu.org/blog/2018/06/20180620162732.jpg)

   ​

# 参考资料

* [The Chart Template Developer’s Guide](https://docs.helm.sh/chart_template_guide/)
* [Kubernetes Namespaces - k8s中文社区](http://docs.kubernetes.org.cn/242.html#i) 
* [kompose - github](https://github.com/kubernetes/kompose) 
* [Kubernetes 给容器和Pod分配内存资源](http://docs.kubernetes.org.cn/729.html)
* [设置 Pod CPU 和内存限制](https://kubernetes.io/cn/docs/tasks/administer-cluster/cpu-memory-limit/)
* [Assign Memory Resources to Containers and Pods](https://kubernetes.io/docs/tasks/configure-pod-container/)
* [kubernetes限制pod的cpu和内存](https://www.jianshu.com/p/e8a77682eb48)