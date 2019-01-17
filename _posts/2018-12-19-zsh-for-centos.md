---
layout: post
title: zsh for centos
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

# 背景

个人很喜欢 zsh，社区也有人做了 maximum-awesome 这个专门针对 zsh 的一键安装项目。一开始是只有 Mac OS X 的，后来有人做成了 Debian 系的，无奈没有人做 CentOS 系的，大概是因为 CentOS 都是企业使用，而在企业环境里我们很少安装无用的软件吧。

其实制作起来相对简单的，社区安装使用的是ruby的rake安装，只需要把步骤中的 debian 的语法改成 CentOS 的语法即可。我也做好了发布到 github上： <https://github.com/kelvinblood/maximum-awesome-centos>

# 用法

用法也可以参考我另一个Linux安装脚本项目的引用：<https://github.com/kelvinblood/KeluLinuxKit>

下载后运行

```
./keluLinuxKit.sh install install_zsh_centos
```

即可。我在像目录不仅安装了 maximum-awesome，还安装了 tmux-powerline，而且自定义了显示栏内容。

安装的具体命令行脚本如下，想自定义的可以按需修改。

```
install_zsh_centos() {
    yum -y install zsh tmux git
    # zsh重启生效引入zsh增强插件,支持git,rails等补全，可选多种外观皮肤
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh

    echo ''
    echo ''
    echo ''
    echo "-- awesome-tmux -----------------------------------------------------"
    # pass the_silver_searcher install
    yum install -y install build-essential automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev rake
    # awesome-tmux
    cd $DOWNLOAD
    if [ ! -e maximum-awesome-centos ]; then
      git clone https://github.com/kelvinblood/maximum-awesome-centos.git
    fi
    cd maximum-awesome-centos
    rake

    # rake install:solarized['dark']

    cp $DOWNLOAD/maximum-awesome-centos/tmux.conf $DOWNLOAD/maximum-awesome-centos/tmux.conf_backup
    cp $RESOURCE/maximum-awesome-linux/tmux.conf $DOWNLOAD/maximum-awesome-centos/tmux.conf

    # cp $RESOURCE/maximum-awesome-centos/tmux.conf $DOWNLOAD/maximum-awesome
    # cp $RESOURCE/maximum-awesome-centos/.tmux* $HOME
    # cp $RESOURCE/maximum-awesome-centos/.vimrc* $HOME
    # cp $RESOURCE/maximum-awesome-centos/vimrc.bundles $DOWNLOAD/maximum-awesome-centos/vimrc.bundles

    # git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    # rm -r $HOME/.vim/bundle/vim-snipmate

    # tmux-powerline
    cd $HOME
    touch .tmux.conf.local

    cd $DOWNLOAD
    if [ ! -e tmux-powerline ]; then
      git clone https://github.com/erikw/tmux-powerline.git
    fi
    cp $DOWNLOAD/tmux-powerline/themes/default.sh $DOWNLOAD/tmux-powerline/themes/default.sh_backup
    cp $RESOURCE/tmux-powerline/default.sh $DOWNLOAD/tmux-powerline/themes/default.sh
cat >> $DOWNLOAD/maximum-awesome-linux/tmux.conf<< EOF
# add by Kelu
set-option -g status-left "#($DOWNLOAD/tmux-powerline/powerline.sh left)"
set-option -g status-right "#($DOWNLOAD/tmux-powerline/powerline.sh right)"
source-file ~/.tmux.conf.local
EOF

    cat $RESOURCE/Home/.zshrc >> $HOME/.zshrc
}
```