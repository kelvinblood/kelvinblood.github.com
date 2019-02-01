---
layout: post
title: api 使用 session 与 token 的利弊
category: tech
tags: api
---
![](https://cdn.kelu.org/blog/tags/api.jpg)

转自 [cipchk - segmentfault](https://segmentfault.com/u/cipchk)

在存储过等同的情况下，在只是**简单**运用上，我只能说**session与token没有本质的区别**，二者不都是一串被加密过的字符串，拿他来做校验都一样。

以上，是因为你把token拿来当作用户是不是当事人做这么一个简单的校验的情况下。

当然，如果我们抛开一些比较极端的操作，token比session也有很大的区别：

- token可以存在任何位置（cookie、local storage）
- token比session更容易跨域。
- CORS预检查时token比较更简单。
- token有更多的控制权，比如当token过期时，你可以拿通过刷新token，让用户一直保持有效登录。

等……其实如果你只是单纯拿着token做一下自己网站内用户登录检验的话是无太多区别的。

但假如token指的是OAuth Token提供认证和授权这类机制的话，那么就可以把session甩开N条街了，甚至是已经完全是两种不同的概念。

假设有这么一个场景，你们用户在你们网站产生的订单，而另一家公司是专业ERP公司；而你的用户希望他的订单同时授权给这家ERP公司使用的情况下，难道你希望用户拿在你家网站的用户名和密码给这家ERP公司吗？

这时候OAuth Token就有意义了，OAuth Token的授权大概是这样的：

- ERP需要调用我们提供的登录界面。
- 用户输入用户名和密码后，我们再向ERP发送一个TOKEN。
- ERP拿TOKEN换数据。

总之，如果你只是在自己网站内部上使用二者没有什么太多区别。而如果你的API是在不同终端上使用，token会更方便。

# 参考资料

* [api 使用session替代token 的利弊在哪？](https://segmentfault.com/q/1010000008903882)