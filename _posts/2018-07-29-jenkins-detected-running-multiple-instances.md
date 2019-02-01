---
layout: post
title: Error - Jenkins detected running multiple instances
category: tech
tags: jenkins linux
---
![](https://cdn.kelu.org/blog/tags/jenkins.jpg)

我使用的 Jenkins 放在 kubernetes 中运行。今天出现了漂移的现象，因为没有做共享存储，运行时数据全都没有了。二话不说把数据迁移了过来，没想到运行时在web界面上显示了以下错误：

```
Jenkins detected that you appear to be running more than one instance of Jenkins that share the same home directory '’. This greatly confuses Jenkins and you will likely experience strange behaviors, so please correct the situation.

This Jenkins: 17485453 contextPath="" at 1264@< MachineName >
Other Jenkins: 15621395 contextPath="" at 13424@< MachineName >
```

原因是我在转移数据的时候没有重启服务，导致系统运行前后数据不一致，重启容器即可解决 。

# 参考资料

* [Error - Jenkins detected running multiple instances](https://stackoverflow.com/questions/21480876/error-jenkins-detected-running-multiple-instances)