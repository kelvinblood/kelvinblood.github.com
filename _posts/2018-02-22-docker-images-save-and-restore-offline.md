---
layout: post
title: 离线获取 Docker 镜像
category: tech
tags: docker
---
![](https://cdn.kelu.org/blog/tags/docker.jpg)

在内网中使用 docker 源，标准的方式是使用 harbor。如果是小量的只需要几个镜像，我们可以使用 docker save 和 docker load 的命令，将外部的容器镜像导入内部。下面介绍一下用法，最后还附带一个一键保存、还原所有镜像的脚本。

# 保存单个镜像

1.  环境准备

	*   服务器node01、node02
	*   node01可以访问外网，node02不能访问外网，但node01与node02之间是互通的
	*   node01和node02均已成功安装并启动Docker

2.  在node01上，从远程仓库获取镜像

		docker pull nginx
	
		Using default tag: latest
		latest: Pulling from library/nginx
		8176e34d5d92: Pull complete
		5b19c1bdd74b: Pull complete
		4e9f6296fa34: Pull complete
		Digest: sha256:4771d09578c7c6a65299e110b3ee1c0a2592f5ea2618d23e4ffe7a4cab1ce5de
		Status: Downloaded newer image for nginx:latest

3.  归档

    ```
    docker save -o nginx.tar library/nginx
    ```
    docker save : 将指定镜像保存成 tar 归档文件。 -o :输出到的文件。
4.  将保存好的nginx.tar上传至服务器node02上

    ```
    scp nginx.tar root@node02:/tmp
    ```
5.  登录node02，加载nginx.tar

		docker load -i /tmp/nginx.tar

		014cf8bfcb2d: Loading layer [==================================================>]  58.46MB/58.46MB
		832a3ae4ac84: Loading layer [==================================================>]  53.91MB/53.91MB
		e89b70d28795: Loading layer [==================================================>]  3.584kB/3.584kB
		Loaded image: nginx:latest

	docker load : 加载指定的tar归档文件格式的镜像。-i :指定要读取的tar归档文件格式的镜像。

# 批量保存镜像

如果需要保存比较多的镜像，这种笨重的方式显然不合适，我找到了这个脚本，一键打包/加载所有镜像，非常好用。

下载链接：[hydra1983](https://gist.github.com/hydra1983)/**[docker_images.sh](https://gist.github.com/hydra1983/22b2bed38b4f5f56caa87c830c96378d)**

![](https://cdn.kelu.org/blog/2018/02/20180224132216.jpg)

# 参考资料

* [离线环境获取Docker镜像](https://my.oschina.net/u/3446722/blog/988807)
* [Save and load docker images in batch](https://gist.github.com/hydra1983/22b2bed38b4f5f56caa87c830c96378d)