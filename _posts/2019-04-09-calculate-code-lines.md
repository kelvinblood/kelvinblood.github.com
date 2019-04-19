---
layout: post
title: 代码量统计 cloc
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

# 什么是Cloc

Cloc是一款使用Perl语言开发的开源代码统计工具，支持多平台使用、多语言识别，能够计算指定目标文件或文件夹中的文件数（files）、空白行数（blank）、注释行数（comment）和代码行数（code）。

# 安装

使用 cloc 命令行可以快速统计代码数量。Github仓库: <https://github.com/AlDanial/cloc>

可以根据操作系统的不同进行安装：

```bash
npm install -g cloc                    # https://www.npmjs.com/package/cloc
sudo apt install cloc                  # Debian, Ubuntu
sudo yum install cloc                  # Red Hat, Fedora
sudo dnf install cloc                  # Fedora 22 or later
sudo pacman -S cloc                    # Arch
sudo emerge -av dev-util/cloc          # Gentoo https://packages.gentoo.org/packages/dev-util/cloc
sudo apk add cloc                      # Alpine Linux
sudo pkg install cloc                  # FreeBSD
sudo port install cloc                 # Mac OS X with MacPorts
brew install cloc                      # Mac OS X with Homebrew
choco install cloc                     # Windows with Chocolatey
scoop install cloc                     # Windows with Scoop
```

# 使用

我以 GitHub 上 kubernetes 的代码仓库为例：

```bash
$ git clone --depth=1 https://github.com/kubernetes/kubernetes.git
$ cloc kubernetes
```

显示如下：

![1555569428654](https://cdn.kelu.org/blog/2019/04/1555569428654.jpg)

它也可以统计压缩包的代码行数：

![1555657515793](https://cdn.kelu.org/blog/2019/04/1555657515793.jpg)

统计某类型的文件：

![1555657583059](https://cdn.kelu.org/blog/2019/04/1555657583059.jpg)



# 参考资料

* [你能从Github库中获取代码行数吗？](https://codeday.me/bug/20170526/18452.html)