---
layout: post
title: git 国内加速代理
category: tech
tags: git
---
![](https://cdn.kelu.org/blog/tags/git.jpg)

长期以来都是用着大带宽的或者海外的服务器，最近阿里做了一个云服务器促销活动，只有1M的带宽，连接github下载工具包那是一个慢。这篇文章简单记录下如何使用代理服务器进行下载加速。

1. 设置本地代理

   http代理或socks代理均可，git目前都支持。

   ​

2. git 的 http 协议代理

   如果是http代理，假设端口为1080，按照如下设置：

   ```
   git config --global http.proxy 'http://127.0.0.1:1080' 
   git config --global https.proxy 'https://127.0.0.1:1080'
   ```

   如果是socks代理，则是如下设置：

   ```
   git config --global http.proxy 'socks5://127.0.0.1:1080' 
   git config --global https.proxy 'socks5://127.0.0.1:1080'

   # 只对github.com 代理
   git config --global http.https://github.com.proxy socks5://127.0.0.1:1080

   # 取消代理
   git config --global --unset http.https://github.com.proxy)
   ```
   ​

3. git 的 git 协议的代理

   ```
   git config --global core.gitproxy "git-proxy"
   git config --global socks.proxy "localhost:1080"

   git config --global --unset core.gitproxy
   ```



# 参考资料

* [git:// through proxy](https://stackoverflow.com/questions/5860888/git-through-proxy)