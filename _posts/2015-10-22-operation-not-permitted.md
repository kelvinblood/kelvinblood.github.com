---
layout: post
title: root用户删除文件提示：Operation not permitted
category: tech
tags: linux linux-command bash
---

一些文件看上去可能一切正常，但当您尝试删除的时候，居然也会报错，就象下边一样:

	rm: cannot unlink `.user.ini': Operation not permitted

身为root用户，我被吓了一大跳，这是被黑了么？各种查询资料，原因终于解开了——lsattr命令。
 
在lsattr命令下，这个`.user.ini`文件带有一个"i"的属性，所以才不可以删除。
 
这个属性专门用来保护重要的文件不被删除，通常的情况下，懂得用这几个命令的通常系统管理员有能力判断这个文件是否可以被删除。如果您想给一个文件多加点保护，可以使用下边的命令：
 
	chattr +i filename
 
命令，这样一来，想要删除这个文件就要多一个步骤。同时，这样的文件也是不可以编辑和修改的。只有root用户才能使用chattr命令。
 
类似于和Windows文件系统，不能随意删除的文件多半都有其道理，即使您知道如何删除，都应该三思而后行。

我们现在可以用下边的一系列命令将文件删除掉:

	lsattr .user.ini
	chattr -i .user.ini
	rm -rf .user.ini