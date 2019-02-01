---
layout: post
title: dockerfile 实践
category: tech
tags: docker
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

看过了这么多的教程，我仍然写不好一个 Dockerfile 文件233333333。主要原因还是没有自己动手实践，把自己的项目一行一行敲出来做成一个镜像。

在这篇文档中，我将在我 GitHub 上的项目 —— [KeluLinuxKit](https://github.com/kelvinblood/KeluLinuxKit) 作为基础，对照其中的命令移植到 Dockerfile 里来。

# 准备

***

先看一下我原生的脚本：
	
	install_openresty(){
	    cd $DOWNLOAD
	    aptitude -y install libreadline-dev libpcre3-dev libssl-dev libpq-dev
	    wget https://openresty.org/download/ngx_openresty-1.9.7.1.tar.gz
	    tar -xzvf ngx_openresty-1.9.7.1.tar.gz
	    cd ngx_openresty-1.9.7.1/
	    ./configure --prefix=/usr/share/openresty --with-pcre-jit --with-http_postgres_module --with-http_iconv_module --with-http_stub_status_module
	    make && make install
	
	    mkdir /var/local/nginx
	    mkdir /var/local/log/nginx
	    cp -R $NGINX_HOME /var/local
	    cd /var/local/nginx
	    mkdir conf/vhost
	
	    cp $RESOURCE/nginx/* /var/local/nginx/
	}

这部分命令行主要做的是 openresty 的下载、编译然后拷贝现有的配置，其中涉及的命令行的知识就不做解读了。

以下这个部分会非常长，嫌麻烦的可以直接跳到最后看结果。

# dockerfile 介绍

***

接触过容器的朋友应该都知道，`Dockerfile`是由一系列命令和参数构成的脚本，使用 Dockerfile 可以创建容器的镜像。

一个`Dockerfile`里面包含了构建一个容器镜像的完整命令。Docker通过`docker build`执行`Dockerfile`中的一系列命令自动构建`image`。

首先，我使用一个简单的例子介绍一下 dockerfile。 一个标准最小化的 dockerfile 格式应该是这样子的：

```
FROM nginx
MAINTAINER kelvinblood <xxx@xxx.org>
RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
ENTRYPOINT ["nginx", "-g", "daemon off;"]
```
它包含四个部分：

*   基础镜像（父镜像）信息
*   维护者信息
*   镜像操作命令
*   容器启动命令

完成之后，我们只需要简单的的使用 `docker build .` 命令，就可以将它制作出来了。

以下介绍 Dockerfile 的常用命令：

* build
* FROM
* MAINTAINER
* USER
* ENV
* ARG
* RUN
* ADD
* COPY
* LABLE
* ONBUILD
* STOPSIGNAL
* HEALTHCHECK
* SHELL
* CMD
* EXPOSE
* ENTRYPOINT
* VOLUME
* WORKDIR


# build

***

通过上面的介绍，我们对 dockerfile 已经有了一个大概的认识，现在先来看如何制作镜像。

	docker build CONTENT

`docker build`命令从`Dockerfile`和`context`中构建image。`context`可以使是`PATH`或`URL`。`PATH`是本地文件目录。 `URL`则是 Git 仓库的位置。

`context`以递归方式处理。所以`PATH`会包括目录下的所有子目录，`URL`会包括仓库和仓库的子模块。下面是一个使用当前目录作为`context`的构建镜像的命令：

```
$ docker build .
Sending build context to Docker daemon  6.51 MB
...

```
构建由Docker 守护程序运行，而不是由 Docker 命令行运行。在这里放上一个 Docker 的架构图帮助理解。关于Docker守护进程和命令行的内容在本文就不展开了。

![](https://cdn.kelu.org/blog/2017/11/docker-architecture.jpg)

![](https://cdn.kelu.org/blog/2017/11/docker-interaction.jpg)

构建过程所做的第一件事是将整个context递归地发送给守护进程。一个比较好的做法是将`Dockerfile`和所需文件复制到一个空的目录，再到这个目录进行构建。(尤其注意不要把根目录这种传过去）

以下是一些与 build 相关的小知识点：

* 可以通过`.dockerignore` 来排除 content 中的文件和目录。这样能提高构建的性能。
* 一般默认`Dockerfile`位于`context`的根目录下。也可以使用`-f`标志可指定Dockerfile的位置。

	```
	$ docker build -f /path/to/a/Dockerfile .
	
	```
* 用 -t 保存为新的镜像，也可以保存成多个镜像：

	```
	$ docker build -t shykes/myapp .
	$ docker build -t shykes/myapp:1.0.2 -t shykes/myapp:latest .
	```

* Docker守护程序会按顺序运行`Dockerfile`中的指令。
* Docker 是根据 dockerfile 中的每一个指令进行镜像构建。在 dockerfile 中运行`RUN cd /tmp`对下一个指令不会有任何影响。Docker 每个指令都会产生中间镜像，以此来加速`docker build`的过程。

# Dockerfile 格式

***

以下四个部分的命令分类，是我按照平时各个命令常见的位置来划分的，并没有实际意义。


## 第一部分 基础镜像（父镜像）信息

***

### 解析器指令

用来做一些解析的设置，目前只支持 escape。

有一些注意事项，例如必须置于 `From` 之前，不能重复，不能换行，未知指令视为注释。

* escape

	用于在`Dockerfile`中转义字符的字符。如果未指定，则缺省转义字符为`\`。 
		
		# escape=\ (backslash)
	
	或
		
		# escape=` (backtick)
	
### FROM

	FROM <image> 
	FROM <image>:<tag>
	FROM <image>@<digest>

* 除了注释，from 必须作为第一个命令。
* 可以出现多次。
* `tag`或`digest`可以不填。如果省略其中任何一个，构建器将默认使用`latest`。

### .dockerignore

docker CLI 将 content 发送到 docker 守护程序之前，它会项目根目录中查找名为`.dockerignore`的文件。如果文件存在，CLI 将排除匹配的文件和目录后再将 content 发送给守护程序。

使用方法与 .gitignore 类似，这里就不展开说明了。

## 第二部分 维护者信息

***

### MAINTAINER

```
MAINTAINER <name>
```
指镜像维护的作者信息。

### USER

```
USER <user>[:<group>] 
USER <UID>[:<GID>]
```
`USER`指令设置运行image时使用的用户名或UID，用于运行 `RUN`，`CMD`和`ENTRYPOINT`指令。

注意，如果所在的用户组没有 root 权限，那么镜像将会以 `root` 用户组运行。

## 第三部分 镜像操作命令

***

### ENV

```
ENV <key> <value>
ENV <key>=<value> ...

```

ENV 主要用于设置变量，使用 `$variable_name`或 `${variable_name}` 进行访问。一般用后者，可以进行下面这种神奇的操作：

	${foo}_bar

同时还支持几个bash修饰符

*   `${variable:-word}`表示默认值是`word`，没有值则为空字符串。
*   `${variable:+word}`表示默认值是空字符串，否则是`word`。

除此之外 ENV 还可以用来处理转义。

注意：设置全局生效的 ENV 变量可能会导致意想不到的结果，比如设置 `ENV DEBIAN_FRONTEND noninteractive` 会导致其他用户在 apt-get 的时候因为跳过提示而不明所以。 只在一个命令中生效可以这么设置：`RUN <key>=<value> <command>`.

### ARG

```
ARG <name>[=<default value>]
```

`ARG`中定义的变量，可以通过`docker build --build-arg <varname> = <value>`，在构建时将其传递给构建器。如果指定了一个未在`Dockerfile`中定义的，则会报错。

```
One or more build-args were not consumed, failing build.
```
`ARG`可以设置默认值。

> `警告`：不建议使用 ARG 来传递诸如github密钥，用户凭证等密码。这样使用`docker history`命令对Docker的所有用户都可见。

`ARG`和`ENV`很像，都可以给变量赋值，不同的是 `ENV`可以将它们持久保存在最终image中。

Docker有一组预定义的`ARG`变量，您可以在Dockerfile中使用相应的ARG指令。

*   HTTP_PROXY
*   http_proxy
*   HTTPS_PROXY
*   https_proxy
*   FTP_PROXY
*   ftp_proxy
*   NO_PROXY
*   no_proxy

使用 ARG 变量会导致一些缓存未命中的问题，会降低编译的速度。详细内容可以参考官方文档<https://docs.docker.com/engine/reference/builder/#impact-on-build-caching>

### RUN

RUN有2种形式：

*   `RUN <command>`（*shell*形式）
*   `RUN ["executable"，"param1"，"param2"]`（_exec_ 形式）

`RUN`指令将在当前 image 之上的新层中执行命令，生成新的一层。这样可以从 image 历史中的任何点创建容器，就像代码控制一样简单。

* shell

	`shell`形式在 Linux上为`/bin/sh -c`，Windows上为`cmd /S/C`。
	常见的方式是在末尾添加反斜杠来换行处理：
	
	```
	RUN /bin/bash -c 'source $HOME/.bashrc; \
	echo $HOME'
	```

* exec
	
	`exec`形式可以避免 shell 的字符串变化，并且可以指定特定的 shell 来运行`RUN`命令。例如：
	
		RUN ["/bin/bash", "-c", "echo $HOME"]

	当然使用 `exec`形式 也有弊端，执行命令的时候必须指定 shell，不能像平时使用 shell 一样使用`exec`形式。比如这个形式是错的： `RUN [ "echo", "$HOME" ]`。正确的写法应该是上面的形式。

	`exec`形式中使用json进行参数传递，所以不能使用单引号包裹字符串，必须使用双引号。

	所以这也涉及到了字符转义的问题，尤其是Windows下的字符转义问题，比如这个写法是错的： `RUN ["c:\windows\system32\tasklist.exe"]` 。正确的写法是: `RUN ["c:\\windows\\system32\\tasklist.exe"]`

为了加快编译速度， Docker 会对`RUN apt-get dist-upgrade -y` 这样的命令做缓存，加快下一次的镜像构建。如果我们希望不对它进行缓存，应该使用`--no-cache` 标志, 例如 `docker build --no-cache`. 

### ADD

*   `ADD <src>... <dest>`
*   `ADD ["<src>",... "<dest>"]` (对于包含空格的路径，此形式是必需的)

`ADD`指令从`<src>`复制新文件、目录或远程文件`URL`，并将它们添加到容器的文件系统，路径`<dest>`。

`<src>`可以包含通配符，`<dest>`是绝对路径或相对于`WORKDIR`的路径。

如果 src 是文件或者目录那么：

* 所有新文件和目录的UID和GID都是0
* 如果文件名中包含有特殊字符，那么需要根据 Go 的转义规则转义这些字符串。例如我们添加这个文件 `arr[0].txt`： 

	```
	ADD arr[[]0].txt /mydir/    # copy a file named "arr[0].txt" to /mydir/
	```
* 如果`<src>`是可以识别的压缩格式（identity，gzip，bzip2或xz），则 Docker 会将其解包为目录。Url 的资源不会解被压缩。如解压后有冲突，那么会将冲突的文件名改为"2."并继续解压。`注意`：文件是否被识别为识别的压缩格式，基于文件的内容，而不是文件的名称。

如果 src 是 url 地址：

* dsct 的文件权限将设置为 600.
* 如果 HTTP 头部带有`Last-Modified`的时间戳，则 dest 的 mtime 就使用这个时间戳。Dockerfile 的其他的操作，比如ADD，则不会修改这个值。
* 如果`<src>`是URL并且`<dest>`以尾部斜杠结尾，则 Docker 会从URL中推断文件名，并将文件下载到`<dest>/<filename>`。例如，`ADD http://example.com/foobar /`会创建文件`/ foobar`。网址必须有一个路径，以便在这种情况下可以发现一个适当的文件名（`http://example.com` 除外）。

关于 dest：
* `<src>` 路径必须在构建的上下文中; 不能 `ADD ../something /something`，因为docker构建的第一步是发送上下文目录（和子目录）到docker守护进程。
* 如果`<dest>`以尾部斜杠`/`结尾，它会被认为是一个目录，`<src>`的内容将被写在`<dest>/base(<src>)`。
* 如果使用通配符指定了多个`<src>`资源，则`<dest>`必须是目录，并且必须以斜杠`/`结尾。
* 如果`<dest>`不以尾部斜杠结尾，它将被视为常规文件，`<src>`的内容将写在`<dest>`。
* 如果`<dest>`不存在，则会与其路径中的所有缺少的目录一起创建。

使用 ADD 还需要注意下面这些情况：

* 如果 dockerfile 使用管道传输过来进行构建镜像，因为不存在构建的其它文件，那么 dockerfile 里就只能使用 ADD url 的操作了。
* ADD 不提供权限操作，无法解决访问权限的问题。如果 Docker 没有读取 src 的权限，那么需要使用 wget curl 或者其他工具解决。


### COPY

两种形式：

*   `COPY <src>... <dest>`
*   `COPY ["<src>",... "<dest>"]` (src有空格时使用)

基本和ADD类似，除了`COPY`的`<src>`不能为URL。


### LABLE

`LABEL` 指令向image添加元数据。`LABEL`是键值对。有空格的话要使用引号或者反斜杠。下面是一些例子：

```
LABEL "com.example.vendor"="ACME Incorporated"
LABEL com.example.label-with-value="foo"
LABEL version="1.0"
LABEL description="This text illustrates \
that label-values can span multiple lines."
```
image可以有多个label。因为每个`LABEL`都会产生一个新层，会导致镜像效率低下，所以建议一行将所有 Lable 都添加完全。

```
LABEL multi.label1="value1" \
      multi.label2="value2" \
      other="value3"

```
使用`docker inspect` 查看image的labels：

```
"Labels": {
    "com.example.vendor": "ACME Incorporated"
    "com.example.label-with-value": "foo",
    "version": "1.0",
    "description": "This text illustrates that label-values can span multiple lines.",
    "multi.label1": "value1",
    "multi.label2": "value2",
    "other": "value3"
},
```

### ONBUILD

```
ONBUILD [INSTRUCTION]
```
`ONBUILD`指令在当前镜像被用作其它镜像构建的基础时，添加要在以后执行的*trigger*指令，当前镜像内不执行。

这一块目前很少见到有使用，等以后需要了再学习。<https://docs.docker.com/engine/reference/builder/#onbuild>

### STOPSIGNAL

```
STOPSIGNAL signal
```
`STOPSIGNAL` 接收系统的退出指令并退出容器。

### HEALTHCHECK

两种形式：

*   HEALTHCHECK [OPTIONS] CMD command (通过在容器中运行命令来检查容器运行状况)
*   HEALTHCHECK NONE (禁用检查)

`HEALTHCHECK`指令告诉Docker如何测试容器以检查它是否仍在工作。

### SHELL

```
SHELL ["executable", "parameters"]
```
`SHELL` 指令用于覆盖默认的shell。

Linux上的默认shell是`["/bin/sh","-c"]`，在Windows上是`["cmd","/S","/C"]`。

`SHELL`指令在Windows上特别有用，其中有两个常用的和完全不同的本机shell：`cmd`和`powershell`，以及`sh`的备用Shell。

`SHELL`指令可以多次出现。每个`SHELL`指令覆盖所有先前的`SHELL`指令，并影响所有后续指令。 例如：

以下示例是Windows上的常见模式，可以使用SHELL指令进行简化。也可以在Linux上使用，如`zsh`，`csh`，`tcsh`等等。

`SHELL`功能是在Docker 1.12中添加的。

## 第四部分 容器启动命令

***

### CMD

CMD指令有三种形式：

*   `CMD ["executable","param1","param2"]` (_exec_ form, 首选形式)
*   `CMD ["param1","param2"]` (为 _ENTRYPOINT_ 提供参数)
*   `CMD command param1 param2` (_shell_ form)

在`Dockerfile`中只能有一个`CMD`指令。如果有多个则只有最后一个生效。

`CMD`的主要目的是为运行容器时的默认启动命令。

* `注意`：如果使用`CMD`为`ENTRYPOINT`指令提供默认参数，`CMD`和`ENTRYPOINT`指令都应该以 JSON 数组格式指定。
* `注意`：exec 形式作为JSON数组解析，使用双引号（”）而不是单引号（’）。
* 如果用户指定`docker run`参数，那么它们将覆盖`CMD`中指定的默认值。

> `注意`：不要将`RUN`和`CMD`混淆。`RUN`实际上运行一个命令并提交结果;`CMD`在构建时不执行任何操作，目的是指定镜像运行时的默认命令。

### EXPOSE

```
EXPOSE <port> [<port>...]

```
`EXPOSE` 主要用来标记 Docker 运行时侦听的网络端口。默认监听TCP，也可以设置为UDP。

`EXPOSE`并不是真正的启动一个对外的端口，它的作用主要是在镜像创建者和运行者之间类似开发文档一样的东西。要真正开启这个端口，需要在 Docker run 的时候使用 -p 命令开启特定端口或者 -P 命令监听所有端口。

### ENTRYPOINT

两种形式：

*   ENTRYPOINT [“executable”, “param1”, “param2”] （_exec_ 形式, 首选）
*   ENTRYPOINT command param1 param2 (_shell_ 形式)

`ENTRYPOINT`时容器启动时运行的一个脚本，只有最后一个`ENTRYPOINT`指令会有效果。

如果我们为 entrypoint 写一个可执行脚本 entrypoint.sh，可以使用`exec`和`gosu`命令确保最终可执行文件接收到Unix信号：

```
#!/bin/bash
set -e

if [ "$1" = 'postgres' ]; then
    chown -R postgres "$PGDATA"

    if [ -z "$(ls -A "$PGDATA")" ]; then
        gosu postgres initdb
    fi

    exec gosu postgres "$@"
fi

exec "$@"

```
理解 entrypoint 与 cmd 的关系：

*   `Dockerfile`应该至少指定一个`CMD`或`ENTRYPOINT`命令。
*   当使用容器作为可执行文件时，应该定义`ENTRYPOINT`。
*   `CMD`应该用作定义`ENTRYPOINT`命令的默认参数。
*   当容器运行命令带有替代参数时，`CMD`会将被覆盖。

下面这个表格可以辅助我们理解 entrypoint 与 cmd 的协作：

| --- | 无 ENTRYPOINT | ENTRYPOINT exec_entry p1_entry | ENTRYPOINT [“exec_entry”, “p1_entry”] |
| --- | --- | --- | --- |
| **无 CMD** | --- | /bin/sh -c exec_entry p1_entry | exec_entry p1_entry |
| **CMD [“exec_cmd”, “p1_cmd”]** | exec_cmd p1_cmd | /bin/sh -c exec_entry p1_entry | exec_entry p1_entry exec_cmd p1_cmd |
| **CMD [“p1_cmd”, “p2_cmd”]** | p1_cmd p2_cmd | /bin/sh -c exec_entry p1_entry | exec_entry p1_entry p1_cmd p2_cmd |
| **CMD exec_cmd p1_cmd** | /bin/sh -c exec_cmd p1_cmd | /bin/sh -c exec_entry p1_entry | exec_entry p1_entry /bin/sh -c exec_cmd p1_cmd |

### VOLUME

```
VOLUME ["/data"]
```
`VOLUME` 标记为从本机主机或其他容器保留外部挂载的卷。

VOLUME 可以是JSON数组，或具有多个参数的纯字符串：

* `VOLUME ["/var/log/"]`
* `VOLUME /var/log`
* `VOLUME /var/log /var/db`

一些注意事项：

* 如果使用JSON数组，注意要使用双引号（”）而不是单引号（’）
* Windows下的挂载点，必须符合两个条件之一:
	* 一个不存在的或者空的文件夹
	* 一个C盘之外的硬盘
* 如果在声明后更改了卷中的数据，那么这些更改将无效。所以我们一般把 VOLUME 放到比较靠后的位置。

### WORKDIR

```
WORKDIR /path/to/workdir
```

`WORKDIR`指令为`Dockerfile`中的`RUN`，`CMD`，`ENTRYPOINT`，`COPY`和`ADD`等指令设置工作目录。如果`WORKDIR`不存在会则自动被创建。

它可以在一个`Dockerfile`中多次使用。如果提供的是相对路径，它将相对于先前WORKDIR指令的路径。 例如：

```
WORKDIR /a
WORKDIR b
WORKDIR c
RUN pwd
```
在这个`Dockerfile`中的最终`pwd`命令的输出是`/a/b/c`。

`WORKDIR`指令可以解析先前使用`ENV`显式设置设置的环境变量，例如：

```
ENV DIRPATH /path
WORKDIR $DIRPATH/$DIRNAME
RUN pwd
```
`pwd`命令在该`Dockerfile`中输出的最后结果是`/path/$DIRNAME`。

# 结果

根据 Dockerfile 的文档，将之前主机上运行的脚本改写为 Dockerfile 的结果如下：

	FROM debian:jessie
	MAINTAINER kelvinblood <admin@kelu.org>
	
	# Docker Build Arguments
	ENV RESTY_VERSION="1.9.7.1" \
	    RESTY_CONFIG_OPTIONS=" \
	        --prefix=/usr/share/openresty \
	        --with-pcre-jit \
	        --with-http_postgres_module  \
	        --with-http_iconv_module  \
	        --with-http_stub_status_module" \
	    RESTY_DATA_DIR="/var/local/nginx/conf/vhost/" \
	    RESTY_LOG_DIR="/var/local/log/nginx/"
	
	COPY assets/sources.list /etc/apt/sources.list
	
	RUN apt-get update \
	 && DEBIAN_FRONTEND=noninteractive apt-get install -y zip vim locales curl wget net-tools\
	        libperl4-corelibs-perl libreadline-dev libpcre3-dev libssl-dev libpq-dev gcc libc6-dev make\
	 && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX \
	 && locale-gen en_US.UTF-8 \
	 && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales \
	 && cd /tmp \
	    && wget https://openresty.org/download/ngx_openresty-${RESTY_VERSION}.tar.gz \
	    && tar -xzvf ngx_openresty-${RESTY_VERSION}.tar.gz \
	    && cd ngx_openresty-${RESTY_VERSION}/ \
	    && ./configure ${RESTY_CONFIG_OPTIONS} \
	    && make \
	    && make install \
	    && mkdir -p /var/local/log/nginx \
	    && mkdir -p /var/local/nginx/fastcgi_cache/one_hour \
	    && cp -R /usr/share/openresty/nginx /var/local \
	    && mkdir -p /var/local/nginx/conf/vhost \
	    && apt-get clean\
	    && rm -rf /var/lib/apt/lists/* \
	    && rm -rf /tmp/ngx_openresty-${RESTY_VERSION} \
	    && rm /tmp/ngx_openresty-${RESTY_VERSION}.tar.gz
	
	COPY assets/nginx/conf/nginx.conf /var/local/nginx/conf/nginx.conf
	COPY assets/nginx/conf/vhost/www.conf /var/local/nginx/conf/vhost/www.conf
	
	EXPOSE 80/tcp
	
	VOLUME ["${RESTY_DATA_DIR}", "${RESTY_LOG_DIR}"]
	# ENTRYPOINT /usr/share/openresty/nginx/sbin/nginx -c /var/local/nginx/conf/nginx.conf -g 'daemon off;'
	CMD ["/usr/share/openresty/nginx/sbin/nginx","-c","/var/local/nginx/conf/nginx.conf","-g","daemon off;"]

将正常的脚本转换成 Dockerfile 基本的思路就是

* 设定好这个 Dockerfile 和相关依赖包的版本号
* 安装系统依赖
* 清除多余软件包和文件
* 拷贝必要的脚本或配置
* 做好端口和挂载点声明
* 写好并添加启动命令或脚本entrypoint.sh 

这个脚本中我做了几个方便验证的东西：

* 挂载 volume 的验证：

	在不挂载 RESTY_DATA_DIR 的情况下，，启用后我改成了另外一个配置，显示其他页面。

	运行命令： `docker run --name 'daemon4' -d -p 18080:80 test` 时，会显示默认的 nginx 页面。

	挂载 RESTY_DATA_DIR 文件夹后，就换成其它界面： 

		docker run --name 'daemon' -d -p 18080:80 \
			--volume /var/local/nginx/:/var/local/nginx/conf/vhost \
			--volume /var/local/log/nginx/:/var/local/log/nginx/ test4

	挂载的nginx.conf的文件如下:

		server {
		        listen 80;
		        access_log /var/local/log/nginx/nginx.www.access.log;
		        error_log /var/local/log/nginx/nginx.www.error.log;
		
		        location / {
		            default_type text/html;
		            content_by_lua '
		                ngx.say("<p>hello, kelu volume</p>")
		            ';
		        }
		    }
	
*  最后两行 ENTRYPOINT 和 CMD 的作用是一样的。我多写了一个看看效果。

# 参考资料

* [Docker命令行与守护进程如何交互？](https://blog.fundebug.com/2017/05/22/docker-cli-daemon/)
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
* [Best practices for writing Dockerfiles](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/)