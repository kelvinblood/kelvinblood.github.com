---
layout: post
title: zsh进阶配置 - 显示 hostname
category: tech
tags: linux
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

你可以查看我在github上的开源项目 [KeluLinuxKit][KeluLinuxKit] 获得完整源码。

手上有好几台服务器，配置都是相似的，也使用zsh。每次窗口稍微一多，就不知道是在哪个服务器上了，每次`hostname`也是麻烦。寻思着还是想办法在zsh上显示`hostname`吧。然后找到了一个超强的 .zshrc 配置。原文在这：[My Extravagant Zsh Prompt][Zsh-Prompt]

我稍微做了一点点调整，将它加到 .zshrc 里去，最后是这样子的。

效果图如下：

![](https://cdn.kelu.org/blog/2017/03/filehelper_1489153072468_70.jpg)

源码如下：

    function collapse_pwd {
        echo $(pwd | sed -e "s,^$HOME,~,")
    }
    
    function prompt_char {
        git branch >/dev/null 2>/dev/null && echo '±' && return
        hg root >/dev/null 2>/dev/null && echo '☿' && return
        echo 'YUKI.N > '
    }
    
    function battery_charge {
        echo `$BAT_CHARGE` 2>/dev/null
    }
    
    function virtualenv_info {
        [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
    }
    
    function hg_prompt_info {
        hg prompt --angle-brackets "\
    < on %{$fg[magenta]%}<branch>%{$reset_color%}>\
    < at %{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[yellow]%}>%{$reset_color%}>\
    %{$fg[green]%}<status|modified|unknown><update>%{$reset_color%}<
    patches: <patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied(%{$reset_color%})>>" 2>/dev/null
    }
    
    PROMPT='
    %{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg_bold[green]%}$(collapse_pwd)%{$reset_color%}$(hg_prompt_info)$(git_prompt_info)
    $(virtualenv_info)$(prompt_char) '
    
    RPROMPT='$(battery_charge)'
    
    ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
    ZSH_THEME_GIT_PROMPT_CLEAN=""

# 参考资料

* [My Extravagant Zsh Prompt][Zsh-Prompt]

[Zsh-Prompt]: http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/
[KeluLinuxKit]: https://github.com/kelvinblood/KeluLinuxKit
