---
layout: post
title: 使用容器编译 golang 项目
category: tech
tags: go
---
![](https://cdn.kelu.org/blog/tags/go.jpg)

一直推崇开发环境容器化，对于我这种多台电脑同时办公的开发者是十分必要的。最近换了一台工作机器，想起按照原来的方式再走一遍环境配置，不禁恼火。于是还是搞起了容器化编译。下面记录一下过程。

# 启动环境

编辑 `boot.sh` 脚本，运行 golang 容器。

```
#!/usr/bin/env bash

docker run -d -t --name=go --net=host -v /root/golang/go:/go -v /root/golang/code:/code --privileged docker.io/golang bash
```

其中我把go的依赖文件映射到本地 `/root/golang/go`，代码仓库映射到 `/root/golang/code`。至于为什么直接使用host的网络，还是为了编译测试的方便。

# 进入容器

编辑 `exec.sh` 脚本，方便进入容器里

```
docker exec -it go /bin/bash
```

# 拉取依赖

这里以gin为例：

```
go get -u github.com/gin-gonic/gin
```

# 编译

以下面这个helloworld为例：

```
# gohello.go

package main

import (
"github.com/gin-gonic/gin"
"net/http"
)

func main(){
   router := gin.Default()
   router.GET("/", func(c *gin.Context) {
      c.String(http.StatusOK, "Hello World")
   })
   router.Run(":8000")
}
```

运行命令：

```
go build gohello.go
```

生成 `gohello` 文件。

运行这个文件，在浏览器中访问：

```
http://{ip}:8000/
```

可以看到浏览器中显示 `hello world` 字样。

另外，很多go项目对go的版本是有要求的，所以需要注意下运行的golang的版本号。