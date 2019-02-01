---
layout: post
title: Linux root不能 ssh 登陆的问题
category: tech
tags: linux 
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

有的发行版的 ssh 配置限制了，需要修改以下几个地方。

    vim /etc/ssh/sshd_config

        #PermitRootLogin without-password    #注释这句话
        PermitRootLogin yes                  #改为yes  然后重启ssh
        
    service ssh restart
        

