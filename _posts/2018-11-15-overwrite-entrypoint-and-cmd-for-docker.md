---
layout: post
title: 覆盖镜像中默认的entrypoint
category: tech
tags: docker
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

# 背景

做容器化镜像调试时，我们经常需要覆盖原始镜像中的entrypoint 为 /bin/bash，好让我们进去调试，查看错误。最常用的做法就是在docker run 的时候将其覆盖。当然也可以编译为自己的镜像，但这样做相对还是麻烦点。



# 命令行

覆盖entrypoint的时候需要注意，容器中的命令必须前台运行，而且要保持运行状态，否则运行结束时容器就退出了。所以我们要加上 `tty=true` 类似的这种参数，让 bash 保持前台运行。

我以 debian 镜像为例：

```
docker run -d -t --name kelu --entrypoint "/bin/bash" debian
docker exec -it kelu /bin/bash
```

* 主要参数为 --entrypoint "/bin/bash"，覆盖默认 entrypoint
* 不能使用 -it。使用 -it 的话，退出时会导致容器也挂了。
* -d 意思是运行在后台

