---
layout: post
title: Mac 中 Zsh 下 PATH 环境变量的设置
category: tech
tags: mac zsh
---

前段时间切换到zsh，今天试着在本地运行jekyll时竟然显示

	zsh: command not found: jeykll
	
感觉是环境变量出了问题。查了一下果然是这方面的原因。总结了一些容易遇到的问题：

* 自己添加的路径总是被放到系统路径之后
* 环境变量中的部分路径重复了两遍

先说我的解决办法：
在`~/.zshrc`的末尾添加

	export PATH=$PATH:/Library/Ruby/Gems/2.0.0/gems/jekyll-2.5.3/bin
	
下面转载一些资料，探讨一下这个问题。

## zsh启动顺序
zsh 启动过程中会依次读取以下文件：

* /etc/zshenv
* $ZDOTDIR/.zshenv（$ZDOTDIR 未设置时默认为 $HOME）
* 如果是 non-login shell，读取 /etc/zprofile, $ZDOTDIR/.zprofile
* 如果是 interactive shell，读取 /etc/zshrc, $ZDOTDIR/.zshrc
* 如果是 login shell，读取 /etc/zlogin, $ZDOTDIR/.zlogin

login shell 是用户登陆时，输入用户名和密码后启动的 shell  
non-login shell 是登录以后所打开的 shell  
interactive shell 在终端上执行，shell 等待你的输入，并且立即执行你提交的命令，跟用户存在交互  
non-interactive shell 以 shell script（非交互）方式执行。



## Mac下zsh问题探讨

>
纯转载

那么问题来了，在 Mac OS X 中打开 iTerm.app 或者 Terminal.app 启动的 shell 是什么类型呢？通常来说，应该是 interactive, non-login shell，但实际上却是 interactive, login shell，至于为什么这样就不深究了。下面的测试代码可以证明：

	[[ -o login ]] && echo 'yes' || echo 'no'
	[[ -o interactive ]] && echo 'yes' || echo 'no'
	
所以，打开 iTerm.app 或者 Terminal.app 启动的 shell 会读取上述1-5中存在的所有文件，如果其中多个文件均对 PATH 环境变量作过设置，那么最终呈现的 PATH 环境变量就会比较复杂，部分路径重复也就不足为奇了。

查看 `/etc/zshenv`，会发现调用的是`/usr/libexec/path_helper`，而它加载的正是系统路径，并且将系统路径放在最前。  
如果接下来用户在 $ZDOTDIR 中的文件中加载了自己设置的路径并置于最前，再接下来再加载的 /etc/zprofile、/etc/zshrc 可能还会调用/usr/libexec/path_helper，又造成了系统路径重新被放到最前面，形成了奇葩的 PATH 环境变量系统路径、自设路径、系统路径交错的现象。

了解了这么多，解决方法也很简单，那就是上述1-5中仅让必要的文件涉及 PATH 环境变量。比如在 /etc/zshenv 中通过调用/usr/libexec/path_helper设置系统路径，$ZDOTDIR/.zshenv 中将自设路径放在最前，其余文件均不涉及 PATH 环境变量设置。

### 参考资料

* [zsh+tmux+OS X: 正确地设置 PATH](http://chenyufei.info/blog/2014-03-04/zsh-tmux-osx-set-correct-path/)
* [Mac OS X 中 Zsh 下 PATH 环境变量的正确设置](http://www.jmlog.com/set-path-in-zsh-on-mac-os-x/)