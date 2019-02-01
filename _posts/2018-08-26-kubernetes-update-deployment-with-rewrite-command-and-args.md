---
layout: post
title: 在 kubernetes-dashboard 中覆盖容器默认 args
category: tech
tags: kubernetes docker
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

```
            "command": [
              "cicd"
            ],
            "args": [
              "-mock"
            ],
```

command 会覆盖容器的 entrypoint，args 覆盖容器的 command。

![83109440](https://cdn.kelu.org/blog/2018/08/0831094407.jpg)