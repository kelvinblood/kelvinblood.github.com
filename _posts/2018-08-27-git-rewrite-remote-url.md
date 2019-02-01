---
layout: post
title: git 重新设置远程仓库并关联新分支
category: tech
tags: git
---
![](https://cdn.kelu.org/blog/tags/git.jpg)

# 修改仓库地址

#### 方法一 直接修改

```
git remote xxx 查看指定远程仓库地址
git remote set-url origin git@github.com:kelvinblood/KeluLinuxKit.git
```

#### 方法二 先删除再添加

```
git remote rm origin
git remote add origin git@github.com:kelvinblood/KeluLinuxKit.git
```

#### 方法三 修改配置文件

进入git_test/.git 文件夹

```
[core] 
repositoryformatversion = 0 
filemode = true 
logallrefupdates = true 
precomposeunicode = true 
[remote "origin"] 
url = git@github.com:kelvinblood/KeluLinuxKit.git
fetch = +refs/heads/*:refs/remotes/origin/* 
[branch "master"] 
remote = origin 
merge = refs/heads/master
```



# 关联本地分支与远程分支

```
git branch --set-upstream-to=origin/remote_branch  your_branch
```

# 参考资料

* [Git远程仓库地址变更本地如何修改](https://blog.csdn.net/asdfsfsdgdfgh/article/details/54981823)
* [git branch --set-upstream 本地关联远程分支](https://blog.csdn.net/z1137730824/article/details/78254564)