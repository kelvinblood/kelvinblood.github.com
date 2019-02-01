---
layout: post
title: php 调用 docker 服务
category: tech
tags: php docker
---
![](https://cdn.kelu.org/blog/tags/php.jpg)

# 背景

最近在使用一个云产品，网上看到了相关的api镜像，直接运行容器即可简单操作。如何使用 php 操作呢？于是查了相关的东西，最后完成到自己的项目中。这篇文章记录一下使用过程。官方提供了 golang、python和http的 API调用，社区也做好了各种语言的SDK，有需要的都可以用起来。

| Language              | Library                                                      |
| --------------------- | ------------------------------------------------------------ |
| C                     | [libdocker](https://github.com/danielsuo/libdocker)          |
| C#                    | [Docker.DotNet](https://github.com/ahmetalpbalkan/Docker.DotNet) |
| C++                   | [lasote/docker_client](https://github.com/lasote/docker_client) |
| Dart                  | [bwu_docker](https://github.com/bwu-dart/bwu_docker)         |
| Erlang                | [erldocker](https://github.com/proger/erldocker)             |
| Gradle                | [gradle-docker-plugin](https://github.com/gesellix/gradle-docker-plugin) |
| Groovy                | [docker-client](https://github.com/gesellix/docker-client)   |
| Haskell               | [docker-hs](https://github.com/denibertovic/docker-hs)       |
| HTML (Web Components) | [docker-elements](https://github.com/kapalhq/docker-elements) |
| Java                  | [docker-client](https://github.com/spotify/docker-client)    |
| Java                  | [docker-java](https://github.com/docker-java/docker-java)    |
| Java                  | [docker-java-api](https://github.com/amihaiemil/docker-java-api) |
| NodeJS                | [dockerode](https://github.com/apocas/dockerode)             |
| NodeJS                | [harbor-master](https://github.com/arhea/harbor-master)      |
| Perl                  | [Eixo::Docker](https://github.com/alambike/eixo-docker)      |
| PHP                   | [Docker-PHP](https://github.com/docker-php/docker-php)       |
| Ruby                  | [docker-api](https://github.com/swipely/docker-api)          |
| Rust                  | [docker-rust](https://github.com/abh1nav/docker-rust)        |
| Rust                  | [shiplift](https://github.com/softprops/shiplift)            |
| Scala                 | [tugboat](https://github.com/softprops/tugboat)              |
| Scala                 | [reactive-docker](https://github.com/almoehi/reactive-docker) |
| Swift                 | [docker-client-swift](https://github.com/valeriomazzeo/docker-client-swift) |

# 用法

通过composer添加依赖：

```
composer require docker-php/docker-php
```

可以查看社区文档获得更详细的使用方法：<https://docker-php.readthedocs.io/en/latest/>

### 连接docker

按常规的方式，如果不做docker配置，则会将其`unix:///var/run/docker.sock`用作默认配置连接docker。

由于本地的程序是运行在容器里的，所以当然没有这个文件，只能通过tcp方式连接，在服务器上可以通过把宿主机的docker.sock文件映射到容器里进行读取.

值得注意的是，代码中我使用了`10.0.75.1:2376`这样的地址。IP地址是Windows中源主机的ip，Windows中记得打开docker的访问地址：

![54495809413](https://cdn.kelu.org/blog/2018/12/1544958094135.jpg)

你应该也注意到了我使用的不是2375端口，因为这个端口只能是127.0.0.1地址才能访问，所以我做了一个转发，你在Windows下开发的时候也要这么做：

```
netsh interface portproxy add v4tov4 listenport=2376 connectaddress=127.0.0.1 connectport=2375
```

实现代码如下：

```

    public static function getClient(){
        if (app()->environment('local')) {
            $client = DockerClientFactory::create([
                'remote_socket' => 'tcp://10.0.75.1:2376',
                'ssl' => false,
            ]);
        } else {
            $client = null;
        }

        return $client;
    }
    
    public static function dockerTest(){
        $cfg = self::getClient();
        if($cfg){
            $docker = Docker::create($cfg);
        }else{
            $docker = Docker::create();
        }

        $containers = $docker->containerList(["all"=>true]);
        foreach ($containers as $container) {
            echo $container->getNames()[0]. "\n";
            if ($container->getState() == 'exited') {
                $docker->containerDelete($container->getId());
            }
        }
    }    
```

### 创建容器

设置好所需的镜像和环境变量，再运行即可。敏感的变量我使用了xxx进行替代。

```

    public static function setConfig($endPoint, $apiKey, $secretKey, $type)
    {
        $containerConfig = new ContainersCreatePostBody();
        $containerConfig->setImage('xxxx');
        $containerConfig->setEnv([
            "END_POINT=" . $endPoint,
            "API_KEY=" . $apiKey,
            "SECRET_KEY=" . $secretKey
        ]);

        $containerConfig->setAttachStdin(true);
        $containerConfig->setAttachStdout(true);
        $containerConfig->setAttachStderr(true);
        switch ($type) {
            case "xxxx":
                break;
            default:
        }

        return $containerConfig;
    }


    public static function basic($func,$cmd = "xxx"){
        $cfg = self::getClient();
        $docker = $cfg ? Docker::create($cfg) : Docker::create();

        foreach (Account::$configs as $key => $config) {
            foreach (Account::$apis as $api) {
                $containerCreateResult = $docker->containerCreate(self::setConfig($api, $config[0], $config[1], $cmd));
                echo $containerCreateResult->getId()."\n";
                $id = $containerCreateResult->getId();
                $attachStream = $docker->containerAttach($id, [
                    'stream' => true,
                    'stdin' => true,
                    'stdout' => true,
                    'stderr' => true
                ]);
                $docker->containerStart($id);

                $output = '';
                $attachStream->onStdout(function ($stdout) use (&$output) {
                    $output .= $stdout;
                });

                $attachStream->wait();

                $result = json_decode($output);

                if (!$result) dd("idcf no return value");

                self::$func($result);
                $docker->containerDelete($id);
            }
        }
    }
```

# 参考资料

* [Develop with Docker Engine SDKs and API](https://docs.docker.com/develop/sdk/)
* [docker-php - github](https://github.com/docker-php/docker-php)

