---
layout: post
title: windows 命令行下用 netsh 实现端口转发(端口映射)
category: tech
tags: windows
---
![](https://cdn.kelu.org/blog/tags/windows.jpg)

# 命令

```
netsh interface portproxy add/set/show/delete v4tov4/v4tov6/v6tov6/v6tov4
```

# 例子

### 增加

```
netsh interface portproxy add v4tov4 listenport=8080 connectaddress=192.168.56.101 connectport=8080
```

将本地的8080端口的数据转发至192.168.56.101上的8080端口。

```
netsh interface portproxy add v4tov4 listenport=9090 connectaddress=192.168.56.101 connectport=9090
```

将本地的9090端口的数据转发至192.168.56.101上的9090端口。

### 显示

```
netsh interface portproxy show all
```

### 修改

```
netsh interface portproxy set v4tov4 listenport=9090 connectaddress=192.168.56.101 connectport=9080
```

将本地9090端口改成转发至192.168.56.101的9080端口中。

### 删除

```
netsh interface portproxy delete v4tov4 listenport=9090
```

删除本地端口9090的端口转发配置。

![](https://cdn.kelu.org/blog/2018/08/31120102.jpg)

# 参考资料

* [在windows上用netsh动态配置端口转发](http://aofengblog.blog.163.com/blog/static/631702120148573851740/)
* [使用Windows命令来实现端口转发](http://foreversong.cn/archives/1117)

