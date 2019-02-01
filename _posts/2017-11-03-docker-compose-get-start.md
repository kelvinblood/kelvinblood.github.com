---
layout: post
title: docker compose 起步
category: tech
tags: docker
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

昨天写完了 Dockerfile，使用 Docker run 将容器启动起来了。今天使用 docker compose 的方式将它启动起来。先前转载过一篇教程，也可以看一看：《[Docker Compose工具快速入门](/tech/2017/10/21/docker-compose.html)》

# 安装

Compose 目前支持 Linux、macOS、Windows 10 三大平台。
Compose 可以通过 Python 的包管理工具 pip 进行安装，也可以直接下载编译好的二进制文件使用，或在 Docker 容器中运行。

用 pip 安装比较简单：

```
 pip install -U docker-compose
```
即可开始使用。

卸载的话使用如下命令：

```
pip uninstall docker-compose
```

# 编写yaml模板文件

接上一篇的[dockerfile](/tech/2017/11/02/dockerfile-practice-1.html)

模板文件涉及的命令还蛮多的，不过大部分指令跟 `docker run` 相关参数的含义都是类似的。

来看我编写的 docker-compose.yml。

	version: '3'    
	services:
	  nginx:	  # 镜像名称
	    build: .  # 指定 `Dockerfile` 所在文件夹的路径，进行镜像编译。
	    ports:    # 暴露端口信息。
	     - "18080:80"
	    volumes:  # 数据卷所挂载路径设置。
	     - /var/local/nginx:/var/local/nginx/conf/vhost
	     - /var/local/log/nginx:/var/local/log/nginx
	  redis:      # 做个样子顺便写的
	    image: "redis:alpine"   # 镜像

这里解释一下常用的这些命令：

* build

	自动构建这个镜像，然后使用这个镜像

* ports

	暴露端口信息。
	
	使用 `（HOST:CONTAINER）`格式，或者仅仅指定容器的端口（宿主将机端口）都可以。
	
	```
	ports:
	 - "3000"
	 - "8000:8000"
	 - "49100:22"
	 - "127.0.0.1:8001:8001"
	```

* volumes

	数据卷所挂载路径设置。可以设置宿主机路径 （`HOST:CONTAINER`） 或加上访问模式 （`HOST:CONTAINER:ro`）。

	该指令中路径支持相对路径。例如
	
	```
	volumes:
	 - /var/lib/mysql
	 - cache/:/tmp/cache
	 - ~/configs:/etc/configs/:ro
	```

* image

	指定为镜像名称或镜像 ID。如果镜像在本地不存在，`Compose` 将会尝试拉去这个镜像。
	
	例如：
	
	```
	image: ubuntu
	image: orchardup/postgresql
	image: a4bc65fd
	```

* `command`

	覆盖容器启动后默认执行的命令。
	
	```
	command: echo "hello world"
	```

指令列表如下：

*   [build](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#build)
*   [capadd, capdrop](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#capadd-capdrop)
*   [command](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#command)
*   [cgroup_parent](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#cgroupparent)
*   [container_name](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#containername)
*   [devices](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#devices)
*   [dns](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#dns)
*   [dns_search](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#dnssearch)
*   [dockerfile](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#dockerfile)
*   [env_file](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#envfile)
*   [environment](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#environment)
*   [expose](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#expose)
*   [extends](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#extends)
*   [external_links](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#externallinks)
*   [extra_hosts](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#extrahosts)
*   [image](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#image)
*   [labels](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#labels)
*   [links](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#links)
*   [log_driver](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#logdriver)
*   [log_opt](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#logopt)
*   [net](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#net)
*   [pid](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#pid)
*   [ports](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#ports)
*   [security_opt](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#securityopt)
*   [ulimits](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#ulimits)
*   [volumes](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#volumes)
*   [volumes_driver](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#volumesdriver)
*   [volumes_from](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#volumesfrom)
*   [其它指令](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#其它指令)
*   [读取环境变量](https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html#读取环境变量)


更详细的指令解说可以查看这个文档<https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html>


# 运行 docker compose


写好 docker-compose.yml 后就是运行了。Compose 命令的基本的使用格式是

```
docker-compose [-f=<arg>...] [options] [COMMAND] [ARGS...]

```

## 命令选项

*   `-f, --file FILE` 指定使用的 Compose 模板文件，默认为 `docker-compose.yml`，可以多次指定。
*   `-p, --project-name NAME` 指定项目名称，默认将使用所在目录名称作为项目名。
*   `--x-networking` 使用 Docker 的可拔插网络后端特性（需要 Docker 1.9 及以后版本）。
*   `--x-network-driver DRIVER` 指定网络后端的驱动，默认为 `bridge`（需要 Docker 1.9 及以后版本）。
*   `--verbose` 输出更多调试信息。
*   `-v, --version` 打印版本并退出。

也解释一下常用命令：

#### `up`

格式为 `docker-compose up [options] [SERVICE...]`。

该命令十分强大，它将尝试自动完成包括构建镜像，（重新）创建服务，启动服务，并关联服务相关容器的一系列操作。

链接的服务都将会被自动启动，除非已经处于运行状态。

可以说，大部分时候都可以直接通过该命令来启动一个项目。

默认情况，`docker-compose up` 启动的容器都在前台，控制台将会同时打印所有容器的输出信息，可以很方便进行调试。

当通过 `Ctrl-C` 停止命令时，所有容器将会停止。

如果使用 `docker-compose up -d`，将会在后台启动并运行所有的容器。一般推荐生产环境下使用该选项。

默认情况，如果服务容器已经存在，`docker-compose up` 将会尝试停止容器，然后重新创建（保持使用 `volumes-from` 挂载的卷），以保证新启动的服务匹配 `docker-compose.yml` 文件的最新内容。如果用户不希望容器被停止并重新创建，可以使用 `docker-compose up --no-recreate`。这样将只会启动处于停止状态的容器，而忽略已经运行的服务。如果用户只想重新部署某个服务，可以使用 `docker-compose up --no-deps -d <SERVICE_NAME>` 来重新创建服务并后台停止旧服务，启动新服务，并不会影响到其所依赖的服务。

选项：

*   `-d` 在后台运行服务容器。
*   `--no-color` 不使用颜色来区分不同的服务的控制台输出。
*   `--no-deps` 不启动服务所链接的容器。
*   `--force-recreate` 强制重新创建容器，不能与 `--no-recreate` 同时使用。
*   `--no-recreate` 如果容器已经存在了，则不重新创建，不能与 `--force-recreate` 同时使用。
*   `--no-build` 不自动构建缺失的服务镜像。
*   `-t, --timeout TIMEOUT` 停止容器时候的超时（默认为 10 秒）。

#### `build`

格式为 `docker-compose build [options] [SERVICE...]`。

构建（重新构建）项目中的服务容器。

服务容器一旦构建后，将会带上一个标记名，例如对于 web 项目中的一个 db 容器，可能是 web_db。

可以随时在项目目录下运行 `docker-compose build` 来重新构建服务。

选项包括：

*   `--force-rm` 删除构建过程中的临时容器。
*   `--no-cache` 构建镜像过程中不使用 cache（这将加长构建过程）。
*   `--pull` 始终尝试通过 pull 来获取更新版本的镜像。

#### `logs`

格式为 `docker-compose logs [options] [SERVICE...]`。

查看服务容器的输出。默认情况下，docker-compose 将对不同的服务输出使用不同的颜色来区分。可以通过 `--no-color` 来关闭颜色。

#### `ps`

格式为 `docker-compose ps [options] [SERVICE...]`。

列出项目中目前的所有容器。

选项：

*   `-q` 只打印容器的 ID 信息。


更详细的指令解说可以查看这个文档<https://yeasy.gitbooks.io/docker_practice/content/compose/commands.html>

