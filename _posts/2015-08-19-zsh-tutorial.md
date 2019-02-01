---
layout: post
title: zsh介绍
category: tech
tags: linux zsh tutorial
---

先前用的shell是bash(一般程序员都这样吧= =)，接触了一段时间zsh，非常好用的shell，最方便的地方，应该就是命令行补全和命令历史记录共享。下面来记录一下。

## zsh简介

Shell是Linux/Unix的一个外壳，负责外界与Linux内核的交互，接收用户或其他应用程序的命令，然后把这些命令转化成内核能理解的语言，传给内核，之后再把结果返回用户或应用程序。

Linux/Unix提供了很多种Shell，可以通过以下命令查看系统中自带的shell：`cat /etc/shells`

初期zsh并不是那么好用，因为配置复杂。直到有一天国外有个程序员开发出了一个快速上手的zsh项目「[oh my zsh](https://github.com/robbyrussell/oh-my-zsh)」，人气开始聚集起来。

好，下面我们看看如何安装、配置和使用 zsh。


## zsh安装

如果你使用的是Mac，那么可以跳过安装这一节，Mac自带了zsh。
### 安装zsh
	apt-get install zsh
### 安装oh my zsh
自动安装：

	wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
手动安装：
	
	git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
	cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

## zsh配置

与bash类似的配置文件.bashrc，zsh的配置主要集中在用户当前目录的.zshrc里，打开.zshrc，在最下面会发现这么一行字：

	# Customize to your needs…

可以在此处定义自己的环境变量和别名，当然，oh my zsh 在安装时已经自动读取当前的环境变量并进行了设置，你可以继续追加其他环境变量。

我自己的部分配置如下：

	alias vi='vim'
	alias dd='df -h'
	alias p='netstat -antp'
	alias pp='pstree -a'
	alias ta='tail -f /var/log/syslog'
	alias dudir='du --max-depth=1 -ah 2> /dev/null | sort -hr | head '
	alias rm0='find / -type f -name "0" | xargs -i  rm -fr "{}"'
	alias grepall='grep -D skip -nRe'
	
	ip() {
	  iptables -F;
	  iptables-restore < /etc/iptables.test.rules;
	  iptables-save > /etc/iptables.up.rules;
	  iptables -L;
	}
	
	alias tn='tmux new -s'
	alias tll='tmux ls'
	alias tt='tmux attach -t'
	alias tk='tmux kill-session -t'

zsh可以针对文件类型设置对应的打开程序，比如：

alias -s html=mate，意思就是你在命令行输入 hello.html，zsh会为你自动打开 TextMat 并读取 hello.html； 
alias -s gz='tar -xzvf'，表示自动解压后缀为 gz 的压缩包

## zsh使用

* 强大的历史纪录功能，输入 grep 然后用上下箭头可以翻阅你执行的所有 grep 命令。

* 智能拼写纠正.

* 各种补全：路径补全、命令补全，命令参数补全，插件内容补全等等。触发补全只需要按一下或两下 tab 键，补全项可以使用 ctrl+n/p/f/b上下左右切换。

* 目录浏览和跳转：输入 d，即可列出你在这个会话里访问的目录列表，输入列表前的序号，即可直接跳转。

* 在当前目录下输入 .. 或 … ，或直接输入当前目录名都可以跳转。

## zsh其它

通过以上步骤，zsh已经可以很好地使用了。如果你还想更加rock一些，zsh也可以满足你的要求。

### 主题
如果你是个主题控，还可以玩玩 zsh 的主题。在 .zshrc 里找到ZSH_THEME，就可以设置主题了，默认主题是：

	ZSH_THEME=”robbyrussell”

oh my zsh 提供了数十种主题，相关文件在~/.oh-my-zsh/themes目录下，你可以随意选择。

### 插件

oh my zsh 项目提供了完善的插件体系，相关的文件在~/.oh-my-zsh/plugins目录下，默认提供了100多种，大家可以根据自己的实际学习和工作环境采用。

想了解每个插件的功能，只要打开相关目录下的 zsh 文件看一下。插件也是在.zshrc里配置，找到plugins关键字，你就可以加载自己的插件了，系统默认加载 git ，你可以在后面追加内容，如下：

	plugins=(git textmate ruby autojump)
	
	
参考资料:

* <http://zhuanlan.zhihu.com/mactalk/19556676>
* <http://blog.163.com/qy_gong/blog/static/1718738792013102992830558/>
* <http://www.zhihu.com/question/25910725/answer/31951050>

* <https://www.v2ex.com/t/215033#reply6>
* <http://blog.jobbole.com/89609/>
* [Mac命令行工具强化及使用简单记录](http://uecss.com/zsh-brew-autojump-plugins-shell-for-mac.html)
