---
layout: post
title: Git入门
category: tech
tags: linux git tutorial
---

今天在 [Digital Ocean][DO] 入了一个新服务器。意外地不知道什么时候里面已经有了10美元了。选了最便宜的5美元一个月的服务器，顺便把多年未更新的 [KeluLinuxKit][KeluLinuxKit] 给更新了。算是第一次在生产系统上使用，没想到问题那么多。已经修改好啦。

如果你也打算使用[Digital Ocean][DO]，不妨使用我的链接，这样子你将得到10美元。噢，大概我的10美元也是这么来的。

在正式入门之前，先记录个小故事。每每看到Git的诞生，还是忍俊不禁。O(∩_∩)O！



## 诞生

很多人都知道，Linus在1991年创建了开源的Linux，从此，Linux系统不断发展，已经成为最大的服务器系统软件了。

Linus虽然创建了Linux，但Linux的壮大是靠全世界热心的志愿者参与的，这么多人在世界各地为Linux编写代码，那Linux的代码是如何管理的呢？

事实是，在2002年以前，世界各地的志愿者把源代码文件通过diff的方式发给Linus，然后由Linus本人通过手工方式合并代码！

你也许会想，为什么Linus不把Linux代码放到版本控制系统里呢？不是有CVS、SVN这些免费的版本控制系统吗？因为Linus坚定地反对CVS和SVN，这些集中式的版本控制系统不但速度慢，而且必须联网才能使用。有一些商用的版本控制系统，虽然比CVS、SVN好用，但那是付费的，和Linux的开源精神不符。

不过，到了2002年，Linux系统已经发展了十年了，代码库之大让Linus很难继续通过手工方式管理了，社区的弟兄们也对这种方式表达了强烈不满，于是Linus选择了一个商业的版本控制系统BitKeeper，BitKeeper的东家BitMover公司出于人道主义精神，授权Linux社区免费使用这个版本控制系统。

安定团结的大好局面在2005年就被打破了，原因是Linux社区牛人聚集，不免沾染了一些梁山好汉的江湖习气。开发Samba的Andrew试图破解BitKeeper的协议（这么干的其实也不只他一个），被BitMover公司发现了（监控工作做得不错！），于是BitMover公司怒了，要收回Linux社区的免费使用权。

Linus可以向BitMover公司道个歉，保证以后严格管教弟兄们，嗯，这是不可能的。实际情况是这样的：

Linus花了两周时间自己用C写了一个分布式版本控制系统，这就是Git！一个月之内，Linux系统的源码已经由Git管理了！牛是怎么定义的呢？大家可以体会一下。

Git迅速成为最流行的分布式版本控制系统，尤其是2008年，GitHub网站上线了，它为开源项目免费提供Git存储，无数开源项目开始迁移至GitHub，包括jQuery，PHP，Ruby等等。

## 安装

请参考 [Github][Github] 上的教程。

## 配置

Git 提供了 git config 工具，专门用来配置或读取相应的工作环境变量。这些变量可以存放在以下三个不同的地方：

* /etc/gitconfig 文件：系统中对所有用户都普遍适用的配置。若使用 git config 时用 --system 选项，读写的就是这个文件。
* ~/.gitconfig 文件：用户目录下的配置文件只适用于该用户。若使用 git config 时用 --global 选项，读写的就是这个文件。
* 工作目录中的 .git/config 文件：这里的配置仅仅针对当前项目有效。每一个级别的配置都会覆盖上层的相同配置，所以 .git/config 里的配置会覆盖 /etc/gitconfig 中的同名变量。

### 配置用户信息

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com
	$ git config --global core.editor emacs
	$ git config --global merge.tool vimdiff

### 查看配置信息

要检查已有的配置信息，可以使用 git config --list 命令：

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

有时候会看到重复的变量名，那就说明它们来自不同的配置文件（比如 /etc/gitconfig 和 ~/.gitconfig），不过最终 Git 实际采用的是最后一个。

也可以直接查阅某个环境变量的设定。

	$ git config user.name
	Scott Chacon

### 设置快捷键

	$ git config --global alias.co checkout
	$ git config --global alias.br branch
	$ git config --global alias.ci commit
	$ git config --global alias.st status
	$ git config --global alias.unstage 'reset HEAD --'
	$ git config --global alias.last 'log -1 HEAD'

### 自动补全

	wget https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
	mv git-completion.bash /etc/bash_completion.d/

## 使用

以下内容过多，详细内容请查看这本教程：[《Pro Git 2nd Edition》][git-scm]



### 下载提交

	$ git clone git://github.com/schacon/ticgit.git
	$ git remote -v
	$ git remote add pb git://github.com/paulboone/ticgit.git
	$ git fetch pb			# 抓取所有
	$ git add .
	$ git commit -m 'xxx'
	$ git push origin master

### 撤销提交

最后一次提交添加文件

	$ git commit -m 'initial commit'
	$ git add forgotten_file
	$ git commit --amend

撤销提交

	$ git checkout -- benchmarks.rb
	$ git reset HEAD benchmarks.rb
	$ git reset --soft xxx
	$ git reset --hard xxx

### 提交前后其他操作

	$ git diff		# 看暂存前后的变化
	$ git diff --cached # 查看已经暂存起来的变化：
	$ git rm 记录此次移除文件
	$ git mv file_from file_to

### .gitignore

	# 此为注释 – 将被 Git 忽略
	# 忽略所有 .a 结尾的文件
	*.a
	# 但 lib.a 除外
	!lib.a
	# 仅仅忽略项目根目录下的 TODO 文件，不包括 subdir/TODO
	/TODO
	# 忽略 build/ 目录下的所有文件
	build/
	# 会忽略 doc/notes.txt 但不包括 doc/server/arch.txt
	doc/*.txt
	# ignore all .txt files in the doc/ directory
	doc/**/*.txt

### 标签

	$ git tag v1.4-lw
	$ git show

### 冲突

如果合并出现冲突，则修改冲突文件，并删除 <<<<<<<，======= 和 >>>>>>> 这些行。在解决了所有文件里的所有冲突后，运行 `git add` 将把它们标记为已解决状态，再运行一次 `git status` 来确认所有冲突都已解决.

### 提交历史

	$ git log -p -2			# 最近的两次更新
	$ git log --pretty=format:"%h %cr %s" --graph
		--oneline- 压缩模式，以一行显示
		--graph- 图形模式
		--all- 显示所有
	$ git log -n 1 --stat 	# 查看上次提交影响的文件
	$ git reflog 			# 本地的历史节点

`git reflog`列出了head曾经指向过的一系列commit。要明白它们只存在于你本机中；而不是你的版本仓库的一部分，也不包含在push和merge操作中。
	
	log的一些选项以及释义
	
	选项	说明
	-p	按补丁格式显示每个更新之间的差异。
	--word-diff	按 word diff 格式显示差异。
	--stat	显示每次更新的文件修改统计信息。
	--shortstat	只显示 --stat 中最后的行数修改添加移除统计。
	--name-only	仅在提交信息后显示已修改的文件清单。
	--name-status	显示新增、修改、删除的文件清单。
	--abbrev-commit	仅显示 SHA-1 的前几个字符，而非所有的 40 个字符。
	--relative-date	使用较短的相对时间显示（比如，“2 weeks ago”）。
	--graph	显示 ASCII 图形表示的分支合并历史。
	--pretty	使用其他格式显示历史提交信息。可用的选项包括 oneline，short，full，fuller 和 format（后跟指定格式）。
	--oneline	--pretty=oneline --abbrev-commit 的简化用法。

### 查看修改历史

当事情出错时，先去指责别人是人类的天性之一。如果你的产品服务器挂了，使用git blame命令可以很容易找出罪魁祸首。这个命令可以将文件中的每一行的作者、最新的变更提交和提交时间展示出来。
	
	$ git blame [file_name]

## 分支

### 本地分支

	$ git branch testing 	# 新建分支	
	$ git checkout testing 	# 切换分支
	$ git checkout -b iss53 # 新建并切换到分支
	$ git branch -d hotfix  # 删除分支
	$ git merge iss53		# 合并分支到当前分支

### 远程分支

	$ git push origin dev  # 生成远程dev分支
	$ git push origin feature
	$ git branch -r 		# 查看远程分支
	$ git checkout --track origin/dev		# 从远程拉取并切换到dev分支
	$ git checkout -b develop origin/dev	# 从远程拉取dev命名为develop，并切换
	$ git push origin dev:dev				# 提交本地分支，如果在dev分支下工作，可直接git push
	$ git push origin :dev				# 删除远程分支
	$ git fetch origin					# 同步本地远程分

### 现场存储

当你正在开发一个功能时，突然boss让你尽快修改一个bug，此时最紧急的是fix bug. 而正开发的功能尚未完善还不能提交，这个时候就会想到能不能将手头的工作隔离开，去单单解决bug，然后提交bug，然后在进行手头工作。

	$ git stash  #把当前工作现场“储藏”起来	
	$ git stash pop # 还原成最新的现场，并删除stash列表里的这个存储
	$ git stash apply #重新回来原来的工作时，只需把Stash区域的内容取出来应用到当前工作目录就行
	$ git stash apply stash@{1} #应用某一个队列
	$ git stash list #查看所有stash列表
	$ git stash show #显示stash的内容具体是什么，同git stash apply一样，可以选择指定stash的名字。

git stash apply之后再git stash list会发现，apply后的stash还在stash列表中，如果要将其从stash列表中删除可以用：

	$ git stash drop	#丢弃这个stash，stash的命令参数都可选择指定stash名字，否则就是最新的stash。
	$ git stash pop #是应用与删除的快捷，一个命令即可
	$ git stash apply --index #维持原来的样子,原来暂存的文件仍然是暂存状态，可以加上--index参数,否则都将变成未暂存状态

### 分支衍合merge

把一个分支整合到另一个分支有两种方法：merge和rebase（衍合）
merge是把两个分支最新的快照和二者最新的共同祖先进行三方合并，产生一个新的提交对象。

	$ git merge issueFix

如果没有冲突的话，merge完成。有冲突的话，git会提示那个文件中有冲突，比如有如下冲突：
	
	<<<<<<< HEAD:test.c	
	printf (“test1″);
	=======
	printf (“test2″);
	>>>>>>> issueFix:test.c

merge有两个参数，

`git merge --no-ff`指的是强行关闭fast-forward方式。

fast-forward方式就是当条件允许的时候，git直接把HEAD指针指向合并分支的头，完成合并。属于“快进方式”，有个地方不好的就是不能显示历史信息，在以后开发中我不知道有哪些分支曾经合并过，所以最好使用 no-ff：no fast forward的合并方式，这种方式在合并的同时会生成一个新的commit，这样，从分支历史上就可以看出分支信息。

	$ git merge --no-ff -m "merge with no-ff" dev

`git merge --squash` 是用来把一些不必要commit进行压缩，比如说，你的feature在开发的时候写的commit很乱，那么我们合并的时候不希望把这些历史commit带过来，于是使用--squash进行合并，此时文件已经同合并后一样了，但不移动HEAD，不提交。需要进行一次额外的commit来“总结”一下，然后完成最终的合并。

总结：
--no-ff：不使用fast-forward方式合并，保留分支的commit历史
--squash：使用squash方式合并，把多次分支commit历史压缩为一次

![image](https://cdn.kelu.org/blog/2015/08/bVkJAj.jpg)

### 分支衍合cherry-pick

ps:Cherry-pick的内容转载自[Git笔记(三) - 进击的马斯特](http://pinkyjie.com/2014/08/10/git-notes-part-3/)

cherry-pick其实在工作中还挺常用的，一种常见的场景就是，比如我在A分支做了几次commit以后，发现其实我并不应该在A分支上工作，应该在B分支上工作，这时就需要将这些commit从A分支复制到B分支去了，这时候就需要cherry-pick命令了，B分支指着这些commit说：妈妈，我也要！

比如说，我们在master分支上继续做两次提交，第一次添加一行”test 10”，`git commit -am "commit 10"`，第二次添加“test 11”，到达如下图的状态：

![图25](https://cdn.kelu.org/blog/2015/08/git-notes-25.jpg)

这个时候我们发现，哦NO，我们不应该直接更改master分支，我们应该在自己的分支上做提交。这个时候先新建一个分支`git checkout -b branch3 1a222c3`，注意这里的最后一个参数是新分支的起点，也就是说，新的分支branch3是从“commit 8,9”开始的，现在我们需要把刚才的两次提交移动到新的分支上。运行`git cherry-pick 0bda20e 1a04d5f`，命令行会给出提示两个commit被复制到了当前分支上，此时SourceTree的状态如下图：

![图26](https://cdn.kelu.org/blog/2015/08/git-notes-26.jpg)
确定这两个commit被复制到指定分支以后，在master分支上将这两个commit删除。先切回master分支：`git checkout master`，运行`git reset --hard 1a222c3`，此时SourceTree的状态图为：

![图27](https://cdn.kelu.org/blog/2015/08/git-notes-27.jpg)
两个commit被成功的从master分支移动到了branch3分支。

### 分支衍合rebase

rebase是回到两个分支的共同祖先，根据要进行衍合的分支dev的历次提交对象，生成一系列文件补丁，然后以主干分支master的最后一个提交对象为新的出发点，逐个应用dev分支准备好的补丁文件，生成一个新的提交对象，改写dev的提交历史，使dev成为master的直接下游。然后回到master分支，进行一次快进合并。这样能够保持更加清晰的提交记录，就像没有使用过分支一样。

	$ git checkout dev
	$ git rebase master

### 分支策略
> 在实际开发中，我们应该按照几个基本原则进行分支管理：
> 
首先，master分支应该是非常稳定的，也就是仅用来发布新版本，平时不能在上面干活；
> 
那在哪干活呢？干活都在dev分支上，也就是说，dev分支是不稳定的，到某个时候，比如1.0版本发布时，再把dev分支合并到master上，在master分支发布1.0版本；
> 
你和你的小伙伴们每个人都在dev分支上干活，每个人都有自己的分支，时不时地往dev分支上合并就可以了。


## 导出

Git提供了archive命令，可以导出一个干净的项目文档，不包括版本控制文件。

	git archive --format zip -o kelu.zip HEAD
	git archive -–format zip -o site-$(git log –pretty=format:”%h” -1).zip HEAD

未完待续......
未完待续......

[DO]:https://www.digitalocean.com/?refcode=f595b7f62cc7
[KeluLinuxKit]:https://github.com/kelvinblood/KeluLinuxKit
[Github]:https://help.github.com/articles/set-up-git/
[git-scm]:http://git-scm.com/book/zh/
