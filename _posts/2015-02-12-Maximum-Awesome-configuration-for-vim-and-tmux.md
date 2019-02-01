---
layout: post
title: 使用Maximum Awesome
category: tech
tags: linux maximum vim tmux
---

[Maximum Awesome](https://github.com/square/maximum-awesome) 是美国移动支付领域Square团队的开源产品，包含了vim和Tmux的配置文件。我也刚刚才接触两个星期，总算把Tmux给弄得手熟，真的超级强悍。vim的配置文件现在还用的不多，光是Tmux的配置，已经能让人爽到不行了。

Maximum Awesome 是专为Mac使用的vim和tmux的配置。下文几乎翻译自Maximum Awesome的[Github](https://github.com/square/maximum-awesome)地址。

安装的内容包括

* [MacVim](https://code.google.com/p/macvim/) 一个vim的UI客户端。
* [iTerm 2](http://www.iterm2.com/)一个绝佳的终端的替代品。
* [tmux](http://tmux.sourceforge.net/)一个终端里的命令。
* [Solarized color scheme](http://ethanschoonover.com/solarized) 一个非常流行的配色方案。


## vim的快捷键

几乎每一个插件都可以用一篇文章来介绍一下。都是杀手级插件。以后慢慢写。

* `,d` [NERDTree](https://github.com/scrooloose/nerdtree), 树形目录插件。光标focus左侧树形窗口，? 弹出NERDTree的帮助，再次？关闭帮助显示。
* `,t` [ctrlp.vim](https://github.com/kien/ctrlp.vim)，重新定义了编辑器打开文件的方式，极大了方便了大规模工程代码的浏览。仿照sublime的CtrlP，完全实现了sublime的功能，可以模糊查询定位：工程下的所有文件，打开的buffer，buffer内的tag，最近访问的文件。通过externsion，甚至可以定位mark，register，cmdline history，yankring。虽然在操作体验上还不如sublime，但是功能上已经超越了师傅，更是拉下fuzzyfinder，lookupfiles这些老一辈Vim插件好几条街。
* `,b` ctrlp.vim插件中的打开buffer的快捷键
* `,a` 使用[ag.vim](https://github.com/rking/ag.vim) 和 [the silver searcher](https://github.com/ggreer/the_silver_searcher) 进行项目快速搜索(比 ack 插件更快)
* `ds`/`cs` 删除/修改配对符号 [vim-surround](https://github.com/tpope/vim-surround)
* `gcc` commentary，快速注释一行
* `gc` 快速注释多行
* `vii`/`vai` indentobject，快速选择当前缩进/上一级缩进的全部内容
* `Vp`/`vp` 快速置换一对tag之间的内容
* `,[space]` 删除全文多余的空格
* `<C-]>` ctags，快速跳到定义。
* `,l` align，按照特定的符号对齐，一般我们按照等号对齐`,l=`
* `<C-hjkl>` 快速移动到窗口，替代`<C-w> hjkl`的快捷键。

## tmux的快捷键

* `<C-a>` 重新绑定快捷键（对HHKB尤其友好）
* 默认鼠标滚动Tmux屏幕。
* `prefix v` 纵向切割屏幕
* `prefix s` 横向切割屏幕

有三个以上panes:
* `prefix +` 改为横向布局
* `prefix =` 改为纵向布局

你可以在`.tmux.conf`里修改横向纵向布局时小panes的高度和宽度。更多的快捷键可以直接看配置文件，非常简单直观。

## 关于安装

  git clone https://github.com/square/maximum-awesome.git && cd maximum-awesome && rake

## 安装的vim插件列表

* ack		快速搜索
* align	对齐插件
* [bundle](http://blog.log4d.com/2012/04/vundle/) 插件管理
* [commentary](https://github.com/tpope/vim-commentary) 批量注释工具
* [ctrlp.vim](https://github.com/kien/ctrlp.vim) 快速打开文件
* [cucumber](https://github.com/tpope/vim-cucumber) Ruby acceptance testing framework
* [endwise](https://github.com/tpope/vim-endwise) ruby自动补全
* [fugitive](https://github.com/tpope/vim-fugitive) he best Git wrapper
* [gitgutter](https://github.com/jisaacks/GitGutter) 显示git diff状态的插件
* [greplace](https://github.com/skwp/greplace.vim) 跨文件搜索和替换
* [handlebars](https://github.com/nono/vim-handlebars) 一个框架handlebars的vim插件
* [indentobject](https://github.com/michaeljsmith/vim-indent-object) 快速选择同级缩进文本
* [javascript](https://github.com/pangloss/vim-javascript)
* [jshint](http://jshint.com) 都是Javascript代码验证工具，检查你的代码并提供相关的代码改进意见。
* [kwbd](https://github.com/rgarver/Kwbd.vim) Add a buffer close to vim that doesn't close the window
* [matchit](https://github.com/vimcn/matchit.vim.cnx) 扩展了%匹配字符的范围，甚至是html
* [mustache](https://github.com/mustache/vim-mustache-handlebars) 模板插件 working with mustache and handlebars templates
* nerdtree
* [pastie](https://github.com/tpope/vim-pastie) create pastes at http://pastie.org/
* [protobuf](https://github.com/uarun/vim-protobuf) 针对Google's Protocol Buffers的高亮插件
* [ragtag](https://github.com/tpope/vim-ragtag) 快速生成tag
* rails
* [repeat](https://github.com/tpope/vim-repeat) 重复命令.的插件
* ruby
* [snipmate](https://github.com/garbas/vim-snipmate) 自动补全，[可定制](http://www.ccvita.com/481.html)。
* solarized 配色方案
* [vim-surround](https://github.com/tpope/vim-surround) 删除/修改配对符号
* [syntastic](https://github.com/scrooloose/syntastic) 一个代码检查的插件
* [tagbar](https://github.com/majutsushi/tagbar) 函数列表显示taglist强化版
* [typescript-vim](https://github.com/leafgarland/typescript-vim) typescript的插件
* [unimpaired](https://github.com/tpope/vim-unimpaired) pairs of handy bracket mappings
* vim-coffee-script
* vim-indent-guides
* [vim-slim](https://github.com/slim-template/vim-slim) 高亮slim
* [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)
* [vividchalk](https://github.com/tpope/vim-vividchalk) 配色方案
* [whitespace](https://github.com/bronson/vim-trailing-whitespace) whitespace高亮插件

我自己添加了两个插件，supertab和neocomplcache，看[这里](http://blog.kelu.org/linux/2015/01/12/vim-simple-config.html)，但是和默认的自动补全的插件应该会有冲突，暂时没有解决。

## 参考资料

* [vim中的杀手级插件：CtrlP](http://zuyunfei.com/2013/08/26/vim-plugin-ctrlp/)
* RubyChina - [比 ack 更快更好用的东东：the silver searcher](https://ruby-china.org/topics/8728)
* [vim中的杀手级插件: surround](http://zuyunfei.com/2013/04/17/killer-plugin-of-vim-surround/)
