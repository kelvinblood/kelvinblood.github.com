---
layout: post
title: harbor源码解读 - jeremy的技术点滴
category: tech
tags: kubernetes harbor
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

# 背景

偶然看到这篇文章，讲解的比较详细，转载过来做个备忘。原文：<https://jeremy-xu.oschina.io/2018/09/harbor源码解读/>，以下是原文：



[harbor](https://goharbor.io/)基本上是目前企业级docker registry唯一的开源方案了，之前就有接触，不过一直是当成一个功能丰富的镜像registry来用，并没有深入了解其实现原理。最近认领了一个任务，会涉及harbor代码级开发，这里提前阅读一下其源代码，提前了解其实现原理及细节。

## harbor的架构

官方有一个[框架图](https://github.com/goharbor/harbor/wiki/Architecture-Overview-of-Harbor)，如下：

![image-20180910192701065](https://cdn.kelu.org/blog/2018/11/image-20180910192701065.jpg)

也简单说了下各组件完成的功能，如下：

> As depicted in the above diagram, Harbor comprises 6 components:
>
> **Proxy:** Components of Harbor, such as registry, UI and token services, are all behind a reversed proxy. The proxy forwards requests from browsers and Docker clients to various backend services.
>
> **Registry:** Responsible for storing Docker images and processing Docker push/pull commands. As Harbor needs to enforce access control to images, the Registry will direct clients to a token service to obtain a valid token for each pull or push request.
>
> **Core services:** Harbor’s core functions, which mainly provides the following services:
>
> **UI:** a graphical user interface to help users manage images on the Registry Webhook: Webhook is a mechanism configured in the Registry so that image status changes in the Registry can be populated to the Webhook endpoint of Harbor. Harbor uses webhook to update logs, initiate replications, and some other functions. Token service: Responsible for issuing a token for every docker push/pull command according to a user’s role of a project. If there is no token in a request sent from a Docker client, the Registry will redirect the request to the token service. Database: Database stores the meta data of projects, users, roles, replication policies and images.
>
> **Job services:** used for image replication, local images can be replicated(synchronized) to other Harbor instances.
>
> **Log collector:** Responsible for collecting logs of other modules in a single place.

大致浏览了下代码，上述说明基本也是对的，不过为了方便开发人员理解，下面我用更直接的说法描述一下：

`Proxy`：底层实际上就是跑了一个nginx的容器，向docker client及浏览器暴露端口，将这些客户端发来的请求反向代理到后端`Core Services`、`Registry`。

`Registry`：这个其实是就是官方的docker registry，其配置了webhook到`Core Services`，这样当镜像的状态发生变化时，可通知到`Core Services`了。

`Core Services`：这个里面内容就比较多了，主要由多个http服务组成，完成的功能主要有以下几点：

1. 监听`Registry`上镜像的变化，做相应处理，比如记录日志、发起复制等
2. 充当[Docker Authorization Service](https://docs.docker.com/registry/spec/auth/token/)的角色，对镜像资源进行基于角色的鉴权
3. 连接`Database`，提供存取projects、users、roles、replication policies和images元数据的API接口
4. 提供UI界面

从目前的代码来看主要有这4个部分`ui`（这个感觉改名为controller好一点）、`adminserver`、`registryctl`、`portal`。

`Job Service`：定时执行一些任务，提供API供外部提交任务及查询执行结果。

`Log collector`：说白了就是一个`rsyslog`日志服务，其它组件可以将日志发送到这里，它负责集中存储。

`Database`：就是`mysql`数据库服务，用于存储projects、users、roles、replication policies和images的元数据。

## 编译harbor

直接参照官方给出的编译指南即可编译harbor。

### 准备环境

由于我使用的是macOS系统，比较简单，就是安装`docker`、 `docker-compose`、 `git`、 `golang`。

```
brew install docker docker-compose git golang
```

### 编译代码

首先克隆代码：

```
mkdir $GOPATH/src/github.com/goharbor/
git clone https://github.com/goharbor/harbor $GOPATH/src/github.com/goharbor/harbor
```

根据实际情况修改配置文件：

```
cd $GOPATH/src/github.com/goharbor/harbor
vi make/harbor.cfg
```

编译代码：

```
make install -e NOTARYFLAG=true CLAIRFLAG=true
```

因为我用的是macOS系统，官方的脚本在macOS系统执行会报一些，幸好找到有人给出了[补丁](https://github.com/cd1989/harbor/commit/02a50b5735306aad0b5419869531c42d219b176c)，不过该补丁还没合到主干上，需要手工合并自己的工作区。

第一次成功编译后，后面给`make`命令传入不同的环境变量及预定义target名称，即可完成各种CI任务了。**为啥不接入标准的CI系统？** Makefile的使用说明参见[这里](https://github.com/goharbor/harbor/blob/master/docs/compile_guide.md#appendix)。

## 快速部署

这里使用官方提供的helm chart快速在k8s里进行部署。

下载helm chart源代码：

```
git clone https://github.com/goharbor/harbor-helm
cd harbor-helm
```

编辑values.yaml文件：

```
cp values.yaml values_local.yaml
vi values_local.yaml
...
externalURL: https://harbor.k8s.local
...
ingress:
  enabled: true
  hosts:
    core: harbor.k8s.local
    notary: notary.k8s.local
  ...
  tls:
    enabled: true
    # Fill the secretName if you want to use the certificate of 
    # yourself when Harbor serves with HTTPS. A certificate will 
    # be generated automatically by the chart if leave it empty
    secretName: "default-tls-secret"
```

仅修改了几处域名相关的配置项，同时HTTPS证书使用已经创建好了的`default-tls-secret`，创建`default-tls-secret`的办法可参考之前的[文章](https://jeremy-xu.oschina.io/2018/08/k8s%E4%B8%AD%E4%BD%BF%E7%94%A8cert-manager%E7%8E%A9%E8%BD%AC%E8%AF%81%E4%B9%A6/)。

使用helm命令安装：

```
helm install . --namespace kube-system --name local-harbor -f values_local.yaml
```

然后就可以用浏览器访问`https://harbor.k8s.local`了。

## 分析部署结构

看一下部署的结构：

```
$ kubectl -n kube-system get deployment|grep local-harbor
local-harbor-harbor-adminserver            1         1         1            1           9h
local-harbor-harbor-chartmuseum            1         1         1            1           9h
local-harbor-harbor-clair                  1         1         1            1           9h
local-harbor-harbor-jobservice             1         1         1            1           9h
local-harbor-harbor-notary-server          1         1         1            1           9h
local-harbor-harbor-notary-signer          1         1         1            1           9h
local-harbor-harbor-portal                 1         1         1            1           9h
local-harbor-harbor-registry               1         1         1            1           9h
local-harbor-harbor-ui                     1         1         1            1           9h
$ kubectl -n kube-system get statefulset|grep local-harbor
local-harbor-harbor-database   1         1         9h
local-harbor-redis-master      1         1         9h
```

可以看到总共有9个deployments和2个statefulsets，结构架构图及官方文档，总结这11个组件的作用如下：

1. `local-harbor-harbor-notary-server`、`local-harbor-harbor-notary-signer`这两个deployments主要用于实现`Docker Content Trust`，界面上显示为给镜像签名。
2. `local-harbor-harbor-database`、`local-harbor-redis-master`这两个是存储组件，是数据库及redis缓存，helm chart也提供方案使用外部数据库及redis缓存，在`values.yaml`里简单配置一下就好。
3. `local-harbor-harbor-jobservice`就是架构图里的`Job services`了。
4. `local-harbor-harbor-clair`主要用于对镜像进行安全扫描。
5. `local-harbor-harbor-registry`就是架构图里的`Registry`了。
6. `local-harbor-harbor-adminserver`、`local-harbor-harbor-chartmuseum`、`local-harbor-harbor-ui`、`local-harbor-harbor-portal`在架构图里都属于`Core Services`，分别是用于系统配置管理、chart存储抽象层、harbor核心逻辑控制层、harbor web界面前端。

这11个组件的镜像封装脚本在`$GOPATH/src/github.com/goharbor/harbor/make/photon`目录里，以后要将业务应用封装成docker镜像，可以参考这些`Dockerfile`文件。

这11个组件的k8s部署描述文件在`$GOPATH/src/github.com/goharbor/harbor/make/kubernetes`目录里，同样以后如果要将业务应用部署在k8s里，可以参考这里的描述文件。

## 解读源码

主要代码位于`$GOPATH/src/github.com/goharbor/harbor/src`这个目录，这里将这几个目录逐个分析一下。

### ui

这是个API聚合层，个人感觉改名为controller好一点。它是一个标准的API服务，主要完成以下功能：

1. 监听`Registry`上镜像的变化，做相应处理，比如记录日志、发起复制等
2. 充当[Docker Authorization Service](https://docs.docker.com/registry/spec/auth/token/)的角色，对镜像资源进行基于角色的鉴权
3. 连接`Database`，提供存取projects、users、roles、replication policies和images元数据的API接口
4. 提供UI界面、

首先从其入口方法`$GOPATH/src/github.com/goharbor/harbor/src/ui/main.go`看起，主要完成以下几步：

1. 初始化beego框架的session、模板。

   ```
     beego.BConfig.WebConfig.Session.SessionOn = true
     // TODO
     redisURL := os.Getenv("_REDIS_URL")
     if len(redisURL) > 0 {
     gob.Register(models.User{})
     beego.BConfig.WebConfig.Session.SessionProvider = "redis"
     beego.BConfig.WebConfig.Session.SessionProviderConfig = redisURL
     }
     beego.AddTemplateExt("htm")
   ```

2. 初始化配置，注意配置是从adminserver得来，配置的管理由adminserver负责。

   ```
     log.Info("initializing configurations...")
     if err := config.Init(); err != nil {
      log.Fatalf("failed to initialize configurations: %v", err)
     }
     log.Info("configurations initialization completed")
   ```

3. 为多个服务初始化accessFilter，主要就是`Notary`和`Registry`。`accessFilter`就是对`Registry`和`Notary`的一些操作进行过滤处理，主要是根据角色进行一些权限约束，架构上参考[Docker Authorization Service](https://docs.docker.com/registry/spec/auth/token/)。详见这个`$GOPATH/src/github.com/goharbor/harbor/src/ui/service/token/creator.go`文件。

   ```
     token.InitCreators()
   ```

4. 初始化数据库连接。

   ```
     database, err := config.Database()
     if err != nil {
      log.Fatalf("failed to get database configuration: %v", err)
     }
     if err := dao.InitDatabase(database); err != nil {
      log.Fatalf("failed to initialize database: %v", err)
     }
   ```

5. 从adminserver得到配置的管理员密码，更新到数据库。

   ```
     password, err := config.InitialAdminPassword()
     if err != nil {
      log.Fatalf("failed to get admin's initia password: %v", err)
     }
     if err := updateInitPassword(adminUserID, password); err != nil {
      log.Error(err)
     }
   ```

6. 初始化一些controller对象，这里主要是`chartcontroller`。

   ```
     // Init API handler
     if err := api.Init(); err != nil {
      log.Fatalf("Failed to initialize API handlers with error: %s", err.Error())
     }
   ```

7. 启动定时任务队列处理器。

   ```
     // Enable the policy scheduler here.
     scheduler.DefaultScheduler.Start()
   ```

8. 订阅一些Policy通知的topic，当决策发生变化时，作出相应处理。

   ```
     // Subscribe the policy change topic.
     if err = notifier.Subscribe(notifier.ScanAllPolicyTopic, &notifier.ScanPolicyNotificationHandler{}); err != nil {
      log.Errorf("failed to subscribe scan all policy change topic: %v", err)
     }
   ```

9. 如果启用了`Clair`，则初始化相关的数据库及触发定时扫描所有镜像的事件。`Clair`是用于扫描镜像风险扫描的解决方案，见[这里](https://github.com/coreos/clair)。

   ```
     if config.WithClair() {
      clairDB, err := config.ClairDB()
      if err != nil {
          log.Fatalf("failed to load clair database information: %v", err)
      }
      if err := dao.InitClairDB(clairDB); err != nil {
          log.Fatalf("failed to initialize clair database: %v", err)
      }
      // Get policy configuration.
      scanAllPolicy := config.ScanAllPolicy()
      if scanAllPolicy.Type == notifier.PolicyTypeDaily {
          dailyTime := 0
          if t, ok := scanAllPolicy.Parm["daily_time"]; ok {
              if reflect.TypeOf(t).Kind() == reflect.Int {
                  dailyTime = t.(int)
              }
          }
         
          // Send notification to handle first policy change.
          if err = notifier.Publish(notifier.ScanAllPolicyTopic,
                                    notifier.ScanPolicyNotification{Type: scanAllPolicy.Type, DailyTime: (int64)(dailyTime)}); err != nil {
              log.Errorf("failed to publish scan all policy topic: %v", err)
          }
      }
     }
   ```

10. 初始化`replication controller`，通过`replication controller`可以操控`Job Service`完成镜像复制的功能。

    ```
    if err := core.Init(); err != nil {
        log.Errorf("failed to initialize the replication controller: %v", err)
    }
    ```

11. 初始化一些过滤器，主要是一些安全相关的Filter。

    ```
    filter.Init()
    beego.InsertFilter("/*", beego.BeforeRouter, filter.SecurityFilter)
    beego.InsertFilter("/*", beego.BeforeRouter, filter.ReadonlyFilter)
    beego.InsertFilter("/api/*", beego.BeforeRouter, filter.MediaTypeFilter("application/json", "multipart/form-data", "application/octet-stream"))
    ```

12. 初始化请求路由，请求路由见`$GOPATH/src/github.com/goharbor/harbor/src/ui/router.go`这个文件，其实大概扫一眼每个接口的名字，就知道其主要完成的功能。

    ```
    initRouters()
    ```

13. 将当前`Registry`里的镜像相关信息同步至数据库。

    ```
    syncRegistry := os.Getenv("SYNC_REGISTRY")
    sync, err := strconv.ParseBool(syncRegistry)
    if err != nil {
        log.Errorf("Failed to parse SYNC_REGISTRY: %v", err)
        // if err set it default to false
        sync = false
    }
    if sync {
        if err := api.SyncRegistry(config.GlobalProjectMgr); err != nil {
            log.Error(err)
        }
    } else {
        log.Infof("Because SYNC_REGISTRY set false , no need to sync registry \n")
    }
    ```

14. 初始化到`Registry`的反向代理，有官方`Registry`的基础上主要添加了安装相关的Handler，见`$GOPATH/src/github.com/goharbor/harbor/src/ui/proxy/interceptors.go`这个文件。

    ```
    log.Info("Init proxy")
    proxy.Init()
    ```

15. 启动beego http服务。

    ```
    beego.Run()
    ```

这么一分析`ui`的逻辑还是比较清晰的，想了解哪一方面的功能，直接相关入口方法跟进去就可以了，大部分模块的代码就在2-3个go文件里实现了。

### adminserver

adminserver模块比较简单，主要实现一些配置管理的API接口，从`$GOPATH/src/github.com/goharbor/harbor/src/adminserver/handlers/router.go`这个文件为入口跟踪一下代码就很清楚了。

### chartserver

chartserver模块主要实现一些操作chart资源相关的API接口，由`ui`模块里的`$GOPATH/src/github.com/goharbor/harbor/src/ui/api/base.go#Init`调过来。

### common

common模块里放了一些其它模块共用的代码，比如一些工具函数、一些通用的base结构体、一些DTO对象等。

### jobservice

jobservice主要提供一些执行任务的API接口，其它模块会调用它的接口调度定时任务。核心的入口代码里这里`$GOPATH/src/github.com/goharbor/harbor/src/jobservice/runtime/bootstrap.go#LoadAndRun`，这里大致解读一下这个方法的代码。

1. 初始化job执行上下文。

   ```
      // Create the root context
      ctx, cancel := context.WithCancel(context.Background())
      defer cancel()

      rootContext := &env.Context{
          SystemContext: ctx,
          WG:            &sync.WaitGroup{},
          ErrorChan:     make(chan error, 1), // with 1 buffer
      }

      // Build specified job context
      if bs.jobConextInitializer != nil {
          if jobCtx, err := bs.jobConextInitializer(rootContext); err == nil {
              rootContext.JobContext = jobCtx
          } else {
              logger.Fatalf("Failed to initialize job context: %s\n", err)
          }
      }
   ```

2. 加载并运行任务工作池。

   ```
     // Start the pool
     var (
      backendPool pool.Interface
      wpErr       error
     )
     if config.DefaultConfig.PoolConfig.Backend == config.JobServicePoolBackendRedis {
      backendPool, wpErr = bs.loadAndRunRedisWorkerPool(rootContext, config.DefaultConfig)
      if wpErr != nil {
          logger.Fatalf("Failed to load and run worker pool: %s\n", wpErr.Error())
      }
     } else {
      logger.Fatalf("Worker pool backend '%s' is not supported", config.DefaultConfig.PoolConfig.Backend)
     }
   ```

   可以看到其是将任务工作池的信息保存在redis里。

3. 启动API接口HTTP服务。

   ```
      // Initialize controller
      ctl := core.NewController(backendPool)
      // Start the API server
      apiServer := bs.loadAndRunAPIServer(rootContext, config.DefaultConfig, ctl)
      logger.Infof("Server is started at %s:%d with %s", "", config.DefaultConfig.Port, config.DefaultConfig.Protocol)
   ```

   处理的API接口见`$GOPATH/src/github.com/goharbor/harbor/src/jobservice/api/router.go#registerRoutes`

   ```
      // registerRoutes adds routes to the server mux.
      func (br *BaseRouter) registerRoutes() {
       subRouter := br.router.PathPrefix(fmt.Sprintf("%s/%s", baseRoute, apiVersion)).Subrouter()
       
       subRouter.HandleFunc("/jobs", br.handler.HandleLaunchJobReq).Methods(http.MethodPost)
       subRouter.HandleFunc("/jobs/{job_id}", br.handler.HandleGetJobReq).Methods(http.MethodGet)
       subRouter.HandleFunc("/jobs/{job_id}", br.handler.HandleJobActionReq).Methods(http.MethodPost)
       subRouter.HandleFunc("/jobs/{job_id}/log", br.handler.HandleJobLogReq).Methods(http.MethodGet)
       subRouter.HandleFunc("/stats", br.handler.HandleCheckStatusReq).Methods(http.MethodGet)
      }
       
   ```

   可以看到，就是一些操纵job任务的API接口。

4. 将一些老旧的日志文件删除。

   ```
     // Start outdated log files sweeper
     logSweeper := logger.NewSweeper(ctx, config.GetLogBasePath(), config.GetLogArchivePeriod())
     logSweeper.Start()
   ```

5. 进程优雅退出处理。

   ```
      // To indicate if any errors occurred
      var err error
      // Block here
      sig := make(chan os.Signal, 1)
      signal.Notify(sig, os.Interrupt, syscall.SIGTERM, os.Kill)
      select {
      case <-sig:
      case err = <-rootContext.ErrorChan:
      }
       
      // Call cancel to send termination signal to other interested parts.
      cancel()
       
      // Gracefully shutdown
      apiServer.Stop()
       
      // In case stop is called before the server is ready
      close := make(chan bool, 1)
      go func() {
          timer := time.NewTimer(10 * time.Second)
          defer timer.Stop()
       
          select {
              case <-timer.C:
              // Try again
              apiServer.Stop()
              case <-close:
              return
          }
       
      }()
       
      rootContext.WG.Wait()
      close <- true
       
      if err != nil {
          logger.Fatalf("Server exit with error: %s\n", err)
      }
       
      logger.Infof("Server gracefully exit")
   ```

### registryctl

registryctl主要提供一些操纵`Registry`的API接口，比较简单，从`$GOPATH/src/github.com/goharbor/harbor/src/registryctl/handlers/router.go`看起就可以了。

```
func newRouter() http.Handler {
    r := mux.NewRouter()
    r.HandleFunc("/api/registry/gc", api.StartGC).Methods("POST")
    r.HandleFunc("/api/health", api.Health).Methods("GET")
    return r
}
```

可以看到现在就实现了两个接口。

### replication

replication实现镜像复制的业务逻辑。从`$GOPATH/src/github.com/goharbor/harbor/src/replication/core/controller.go`这个文件查看代码，注意`DefaultController`这个结构体的方法，每个方法完成一个具体的任务，比如`CreatePolicy`方法会根据`ReplicationPolicy`决策，根据要进行的`ReplicationTask`写入数据库，并调用`jobservice`创建一个job任务。

### portal

portal是用AngularJS写的前端界面，我这里比较关注后端，前端代码就不具体分析了。

源码目录大概就这些内容了，还是比较清晰的。

## 总结

整体来看harbor的代码还是比较清晰的，并没有像k8s一样采用各种设计模式封装代码，这个项目的代码涵盖了go语言Web应用开发、docker镜像制作、k8s部署、封装helm chart、Makefile编译脚本等一系列内容，作为一个开源项目，还是可以从中学到不少好东西的。

## 参考

1. <https://github.com/vmware/harbor/wiki/Architecture-Overview-of-Harbor>
2. <https://github.com/goharbor/harbor/blob/master/docs/compile_guide.md>
3. <https://github.com/goharbor/harbor>

