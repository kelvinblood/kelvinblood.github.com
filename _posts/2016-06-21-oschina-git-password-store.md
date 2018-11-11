---
layout: post
title: 使用git@oschina时存储密码
category: tech
tags: git oschina
---

最近使用了oschina的git服务，虽然不那么稳定（一星期抽风一到两次），应该已经是国内最好的git服务了吧。小团队不需要部署自己的git服务器，减少了不少维护成本。

然而，在服务器上每一次拉取代码都要输入密码，比较烦人。

![](https://cdn.kelu.org/blog/2016/06/QQ截图20160621231034.jpg)

不过为了方便部署，我还是把记住密码的功能打开了。下面是解决办法。

* 设置基本的git信息：

        $ git config --global user.name "John Doe"
        $ git config --global user.email johndoe@example.com

* 进行一次git操作，pull或者fetch都ok
* 储存密码

        git config --global credential.helper store # 长期存储密码
        git config --global credential.helper cache # 设置记住密码（默认15分钟）
        git config credential.helper 'cache --timeout=3600' # 自己设置时间


---

参考资料：

* [https方式使用git@osc设置密码的方式](http://zqscm.qiniucdn.com/data/20141215095738/index.html)