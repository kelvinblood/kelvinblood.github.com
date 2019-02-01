---
layout: post
title: 初始化 Git 环境的一些操作
category: tech
tags: git
---
![](https://cdn.kelu.org/blog/tags/git.jpg)

在一台新的服务器上写代码，刚初始化了 git 环境。冒出了一些初始化设置的提示，这一篇记录一下我所做的操作。

* 配置与 github 的连接

		ssh-agent bash
		ssh-ageng -s
		ssh-add ~/.ssh/xxx@xxx.com
		ssh -T git@github.com

* git 默认环境配置

		git config --global user.name "kelvinblood"
		git config --global user.email "xxx@xxx.com"
		git config --global merge.tool vimdiff

* 本地仓库与远端仓库的关联

		git remote add origin git@github.com:kelvinblood/ping-pong-go.git

* git pull 设置默认使用 rebase 而不用 merge

		git config --global pull.rebase true

* git pull 设置默认分支：

		git branch --set-upstream master origin/master

* git push 设置默认分支

	初次提交本地分支，例如`git push origin develop`操作，并不会定义当前本地分支的upstream分支，我们可以通过`git push --set-upstream origin develop`，关联本地develop分支的upstream分支。

		git push --set-upstream origin develop

* push.default

	有可选值：**nothing, current, upstream, simple, matching**，用途分别为：

	*   **nothing** - push操作无效，除非显式指定远程分支，例如`git push origin develop`（我觉得。。。可以给那些不愿学git的同事配上此项）。
	
	*   **current** - push当前分支到远程同名分支，如果远程同名分支不存在则自动创建同名分支。
	
	*   **upstream** - push当前分支到它的upstream分支上（这一项其实用于经常从本地分支push/pull到同一远程仓库的情景，这种模式叫做central workflow）。
	
	*   **simple** - simple和upstream是相似的，只有一点不同，simple必须保证本地分支和它的远程
	    upstream分支同名，否则会拒绝push操作。
	
	*   **matching** - push所有本地和远程两端都存在的同名分支。
	
	因此如果我们使用了git2.0之前的版本，push.default = matching，git push后则会推送当前分支代码到远程分支，而2.0之后，push.default = simple，如果没有指定当前分支的upstream分支，就会收到上文的fatal提示。

更多关于git pull 和 push 默认行为的分析，可以参考这篇文章： [Git push与pull的默认行为](https://segmentfault.com/a/1190000002783245)


# 参考资料

* [Git push与pull的默认行为](https://segmentfault.com/a/1190000002783245)
