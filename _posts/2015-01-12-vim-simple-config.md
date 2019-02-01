---
layout: post
title: vim的简略配置
category: tech
tags: linux vim
---
![](https://cdn.kelu.org/blog/tags/vim.jpg)

曾经用过比较长一段时间的vim，因为后来一直在windows下开发，也就没怎么用过了。现在平台移到了Linux和Mac，Mac还好各种工具，前段时间试用了Coda，觉得真的挺好用的。虽然如此，在Linux下开发就显得很捉急了，因为都是终端进去敲的。虽然也可以在本地写好了再上传，终究麻烦。而且更重要的一点是——Coda太贵，用不起Orz。

![vim](https://cdn.kelu.org/blog/2015/01/vimScreenShot.jpg)

于是，重操旧业，今晚把vim好好整理了一下，把以前最基本的配置拿了回来。装上了几个简单的插件，就这么先用着了。

备注都给的很详细了，就不说了。就装了两个插件 supertab和neocomplcache（我真的对自动补全怨念很深啊233333333）其实只要最基本的补全搞定了，其他的不爽也少了很多。

插件的使用方法就是把 [vim_config.tgz](http://blog.kelu.org/attachment/2015/01/vim_config.tgz) 在本地用户目录解压就好了。这个配置文件存在用户目录下命名为 `.vimrc`



	" ==========通用设置start================
	set encoding=utf-8
	set fileencodings=utf-8,shift-jis,cp936,latin1
	colo django " 主题配色
	set nocompatible " 关闭VI兼容模式
	set expandtab " 将tab扩展为空
	set mouse=a  " 开启鼠标模式
	set guifont=Monaco:h18 "字体
	set shiftwidth=4			" 设定 << 和 >> 命令移动时的宽度为 4
	set softtabstop=4		   " 使得按退格键时可以一次删掉 4 个空格
	set tabstop=4			   " 设定 tab 长度为 4
	set nobackup				" 覆盖文件时不备份
	set autochdir			   " 自动切换当前目录为当前文件所在的目录
	set backupcopy=yes		  " 设置备份时的行为为覆盖
	set ignorecase smartcase	" 搜索时忽略大小写，但在有一个或以上大写字母时仍大小写敏感
	set nowrapscan			  " 禁止在搜索到文件两端时重新搜索
	set incsearch			   " 输入搜索内容时就显示搜索结果
	set showmatch			   " 插入括号时，短暂地跳转到匹配的对应括号
	set matchtime=2			 " 短暂跳转到匹配括号的时间
	set magic				   " 显示括号配对情况
	set hidden				  " 允许在有未保存的修改时切换缓冲区，此时的修改由 vim 负责保存
	set nu " 显示行号
	set autochdir "自动切换工作目录
	syntax on " 语法高亮
	set so=4 " 设置光标距离上下边界的距离
	set ruler " 开启右下角光标位置显示
	set showcmd " 在窗口右下角显示完整命令已输入部分
	set cursorline " 高亮光标所在行
	set hlsearch " 搜索关键词高亮
	set cmdheight=2 " 设置命令行高度
	set foldenable			  " 开始折叠
	set foldmethod=syntax	   " 设置语法折叠
	set foldcolumn=0			" 设置折叠区域的宽度
	setlocal foldlevel=1		" 设置折叠层数为
	setlocal noswapfile " 关闭临时文件
	set wildmenu " 启用文本模式的菜单
	set guioptions-=m " 关闭菜单栏
	set guioptions-=T " 关闭工具栏
	set laststatus=2
	set statusline=YUKI.N>\ こんにちは\ %m%r\ %=
	set statusline+=\ %{&ff}\ %Y\ 0x%02.2B
	set statusline+=\ %-21(%11(%l/%L%),%-3v\ %P%)
	"set smartindent			 " 开启新行时使用智能自动缩进
	"set cindent
	" set nowrap				  " 不自动换行
	"set autoindent
	" set textwidth=76		  " 自动换行
	" ==========通用设置end================
	
	
	
	" ==========Plugin start================
	filetype plugin indent on   " 开启插件
	" filetype on 命令打开文件类型检测功能
	" filetype plugin on 允许vim加载文件类型插件。
	" filetype indent on 允许vim为不同类型的文件定义不同的缩进格式。可继续设置
	"
	set completeopt=longest,menu " 补全
	
	" 加速补全
	" supertab
	" 在输入变量名或路径名等符号中途按Tab键，得到以前输入过的符号列表，并通过Tab键循环选择。
	"0 - 不记录上次的补全方式
	"1 - 记住上次的补全方式,直到用其他的补全命令改变它
	"2 - 记住上次的补全方式,直到按ESC退出插入模式为止
	let g:SuperTabRetainCompletionType=2
	let g:SuperTabDefaultCompletionType=""
	"
	" vim配置及自动补全插件neocomplcache
	" 使用缓存，自动补全时效率高、生成的关键词列表准确等优点。
	let g:neocomplcache_enable_at_startup=1
	
	" Remove trailing whitespace when writing a buffer, but not for diff files.
	" 自动去除无效空白，包括行尾和文件尾
	" @see http://blog.bs2.to/post/EdwardLee/17961
	function RemoveTrailingWhitespace()
	 if &ft != "diff"
	  let b:curcol = col(".")
	  let b:curline = line(".")
	  silent! %s/\s\+$//
	  silent! %s/\(\s*\n\)\+\%$//
	  call cursor(b:curline, b:curcol)
	 endif
	endfunction
	autocmd BufWritePre * call RemoveTrailingWhitespace()
	

有时你需要复制粘贴，不需要自动缩进，可以使用这个命令进行临时取消自动缩进：`:set noai`
有时你需要复制粘贴，不需要自动缩进，可以使用这个命令进行临时取消自动缩进：`:set noai`