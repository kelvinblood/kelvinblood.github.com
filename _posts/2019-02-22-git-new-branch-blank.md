---
layout: post
title: git创建新的空白分支 - 孤儿分支
category: tech
tags: git
---
![](https://cdn.kelu.org/blog/tags/git.jpg)

创建为孤儿分支：

```
git checkout --orphan <branchname>
```

然后清除仓库中的缓存：

```
git rm --cached -r .
```

删除所有文件：

```
rm -rf *
echo '' > .gitignore
```

初始化提交

```
touch readme
git add .
git commit -m "init"
```

push

```
git push --set-upstream origin <branchname>
```

# 参考资料

* [How to create a new empty branch for a new project](https://stackoverflow.com/questions/13969050/how-to-create-a-new-empty-branch-for-a-new-project)