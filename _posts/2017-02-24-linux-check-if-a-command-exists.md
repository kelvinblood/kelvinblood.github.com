---
layout: post
title: Linux 判断一个命令是否存在
category: tech
tags: linux linux-command
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

在命令行时，我们常使用 which xxx 或者 whereis xxx 来判断某个命令是否存在。然而在编写 bash 时，应该避免使用 which 命令。

原因是 which 做为一个外部的工具，并不一定存在，在发行版之间也会有区别，有的系统的 which 命令不会设置有效的 exit status，存在一定的不确定性。

Bash 提供的内建命令如 hash、type、command 可以达到要求。例如：

    $ command -v foo >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
    $ type foo >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
    $ hash foo 2>/dev/null || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }

编写方法时，可以这么编写：

    gnudate() {
        if hash gdate 2>/dev/null; then
            gdate "$@"
        else
            date "$@"
        fi
    }


# 参考资料

* [Shell(Bash)中如何判断是否存在某个命令 - segmentfault][segmentfault]
* [Check if a program exists from a Bash script - stackoverflow][stackoverflow]

[segmentfault]: https://segmentfault.com/q/1010000000156870 
[stackoverflow]: http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
