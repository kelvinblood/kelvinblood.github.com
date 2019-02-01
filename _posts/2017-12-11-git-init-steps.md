---
layout: post
title: git初始化/git关联已有项目
category: tech
tags: git
---
![](https://cdn.kelu.org/blog/tags/git.jpg)

##### 初始化设置

	git config --global user.name "xxx"
	git config --global user.email "xxx@xxx.com"

##### 拉取全新新项目

	git clone xxx.git
	cd test
	touch README.md
	git add README.md
	git commit -m "add README"
	git push -u origin master

##### 已有文件夹中创建项目

	cd existing_folder
	git init
	git remote add origin xxx.git
	git add .
	git commit -m "Initial commit"
	git push -u origin master

##### 关联已有项目

	cd existing_repo
	git remote add origin xxx.git
	git push -u origin --all
	git push -u origin --tags

##### 取消关联
	
	git remote remove origin

##### 打包

	git archive --format zip --output /path/to/file.zip master # 将 master 以zip格式打包到指定文件



