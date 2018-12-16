---
layout: post
title: docker run 时覆盖 entrypoint 和 command
category: tech
tags: docker
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

# 背景

容器测试的时候常需要将默认的运行命令修改为 /bin/bash 等自定义的命令。



# 命令行

```
docker run -d -t --entrypoint "/bin/bash" debian ls -alh
docker exec -it xxx /bin/bash
```

* 主要参数为 --entrypoint "/bin/bash"，覆盖默认 entrypoint
* 但除此之外，我们还要注意使用 -t 的参数，并且不能使用 -it。使用 -it 的话，退出时会导致容器也挂了。
* -d 意思是运行在后台
* ls -alh 是覆盖默认 command

