---
layout: post
title: smartgit “破解”
category: software
tags: git
---
![](https://cdn.kelu.org/blog/tags/git.jpg)

上个月开始，smartgit 就调整了它的免费版策略，每隔一段时间就出现无法跳过的30秒钟“非商业许可证”。这种情况不需要“破解”。

但如果你不小心按了商业版，实际上还是会给你弹出等待，超过时间还会强制购买，否则无法使用。
本文介绍在这种情况下，如何解决这个问题。

本文记录通过重置软件，继续试用的方式，跳过这个强制许可证，每隔1个月需要重新操作一次。略显麻烦，不过操作起来简单，值得一试。

1. Win+R

2. 输入以下命令

   ```
   %APPDATA%\syntevo\SmartGit\
   ```

   ![55040412404](https://cdn.kelu.org/blog/2019/02/1550404124047.jpg)

3. 删除 `settings.xml` 文件。

   ![55040420182](https://cdn.kelu.org/blog/2019/02/1550404201828.jpg)
   
最后注意不要主动升级版本。