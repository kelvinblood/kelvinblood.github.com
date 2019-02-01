---
layout: post
title: 访问容器的方式 —— docker attach/exec
category: tech
tags: docker
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

1. 进入容器默认运行的session：

	docker attach $pid

		Usage:  docker attach [OPTIONS] CONTAINER
		
		Attach to a running container
		
		Options:
		 --detach-keys string   Override the key sequence for detaching a container
		 --help                 Print usage
		 --no-stdin             Do not attach STDIN
		 --sig-proxy            Proxy all received signals to the process (default true)

1. 进入容器环境并运行新的命令：

	docker exec -it $pid /bin/bash // 对指定的容器执行bash

		docker exec --help
		
		Usage:  docker exec [OPTIONS] CONTAINER COMMAND [ARG...]
		
		Run a command in a running container
		
		 -d, --detach         Detached mode: run command in the background
		  --detach-keys        Override the key sequence for detaching a container
		  --help               Print usage
		  -i, --interactive    Keep STDIN open even if not attached
		  --privileged         Give extended privileges to the command
		  -t, --tty            Allocate a pseudo-TTY
		  -u, --user           Username or UID (format: <name|uid>[:<group|gid>])

