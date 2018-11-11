---
layout: post
title:  Linux 生成 source-list 源的快速方式
category: tech
tags: vps linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

今天在用阿里云的 Debian 8.6 的系统，一开始 apt-get 就提示源不存在，404了。 （摊手

然后发现了这个快速生成 source-list 的网站： <https://debgen.simplylinux.ch/>

感觉很像是以前的 jquery 简化版，通过选择一些 jquery 的组件，生成最小化的 jquery 文件。确实不错。

甚至还可以选择第三方组件。

![](https://cdn.kelu.org/blog/2017/06/9.40.39.jpg)

 我选择了最原始的选项，最后得出的代码如下：

    #------------------------------------------------------------------------------#
    #                   OFFICIAL DEBIAN REPOS                    
    #------------------------------------------------------------------------------#
    
    ###### Debian Main Repos
    deb http://deb.debian.org/debian/ oldstable main contrib non-free
    deb-src http://deb.debian.org/debian/ oldstable main contrib non-free
    
    deb http://deb.debian.org/debian/ oldstable-updates main contrib non-free
    deb-src http://deb.debian.org/debian/ oldstable-updates main contrib non-free
    
    deb http://deb.debian.org/debian-security oldstable/updates main
    deb-src http://deb.debian.org/debian-security oldstable/updates main
    
    deb http://ftp.debian.org/debian wheezy-backports main
    deb-src http://ftp.debian.org/debian wheezy-backports main

 ps：今天给博客侧边栏加了我的产品这个选项卡。原图在这里，^_^。   
 ps：今天给博客侧边栏加了我的产品这个选项卡。原图在这里，^_^。   
    
![](https://cdn.kelu.org/blog/2017/06/b4f963380cd79123802d6e23ac345982b3b78015.jpg)
