---
layout: post
title: cannot create socket Permission denied
category: tech
tags: tmux linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

今天在使用 tmux 时突然显示无法创建 socket 的错误：

```
[root@repo env (master ✗)]$ tmux new -s kelu
can't create socket: Permission denied
```

查到了 GitHub 上的 issue，解决办法是：

```
rm -r /tmp/tmux-*
```

然后就可以正常运行了。

当然以前创建的信息就全部不存在了。

# 参考资料

* [can't create socket: Permission denied #1215](https://github.com/tmux/tmux/issues/1215)
