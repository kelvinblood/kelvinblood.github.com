---
layout: post
title: 简单的 python http 服务器
category: tech
tags: python docker
---
![](https://cdn.kelu.org/blog/tags/python.jpg)

运维人员常需要在内网环境中传输文件，除了使用scp外，还有一个比较灵活的办法就是 http 服务。而如果你在容器中临时需要传输文件进行测试，这几乎是最好的方式了。

python 中临时启动一个 http 服务也特别简单，只需要1行命令：

	python -m SimpleHTTPServer

访问你服务器的 8000 端口即可。

如果需要自定义端口，则在后边添加端口参数即可,例如自定义为8080端口:

	python -m SimpleHTTPServer 8080

# 参考资料

* [非常简单的PYTHON HTTP服务 - 酷壳](https://coolshell.cn/articles/1480.html)