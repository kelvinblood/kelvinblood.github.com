---
layout: post
title: git pull 时报错 The remote end hung up unexpectedly
category: tech
tags: linux git
---
![](https://cdn.kelu.org/blog/tags/git.jpg)

在进行git clone 下载项目是，出现了这样的错误：

```
error: RPC failed; curl 56 Recv failure: Connection was reset fatal: The remote end hung up unexpectedly
```

### 快速方案:

```
git config --global http.postBuffer 524288000
```

或者将http.postBuffer调整的更大：

```
git config --global http.postBuffer 1048576000
```

![](https://cdn.kelu.org/blog/2018/03/20180404151222.jpg)



### 更多信息:

从  [`git config手册`](https://git-scm.com/docs/git-config), 可以了解到`http.postBuffer` :

> Maximum size in bytes of the buffer used by smart HTTP transports when POSTing data to the remote system.
> For requests larger than this buffer size, HTTP/1.1 and `Transfer-Encoding: chunked` is used to avoid creating a massive pack file locally. Default is 1 MiB, which is sufficient for most requests.

翻译过来就是HTTP传输的缓冲区大小，避免在本地创建大量的包文件。

`Error code 56` 表示curl接收错误。



# 参考资料

* [The remote end hung up unexpectedly while git cloning](https://stackoverflow.com/questions/6842687/the-remote-end-hung-up-unexpectedly-while-git-cloning)