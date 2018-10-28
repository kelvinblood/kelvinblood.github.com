---
layout: post
title: 写出健壮的 Bash 脚本
category: tech
tags: bash linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

原文来自 [开源中国社区](http://www.oschina.net/news/26744/build-robust-bash-script)。

许多人用shell脚本完成一些简单任务，而且变成了他们生命的一部分。不幸的是，shell脚本在运行异常时会受到非常大的影响。在写脚本时将这类问题最小化是十分必要的。本文中我将介绍一些让bash脚本变得健壮的技术。

##使用set -u

你因为没有对变量初始化而使脚本崩溃过多少次？对于我来说，很多次。



    chroot=$1
    ...
    rm -rf $chroot/usr/share/doc

如果上面的代码你没有给参数就运行，你不会仅仅删除掉chroot中的文档，而是将系统的所有文档都删除。那你应该做些什么呢？好在bash提供了set -u，当你使用未初始化的变量时，让bash自动退出。你也可以使用可读性更强一点的set -o nounset。

    david% bash /tmp/shrink-chroot.sh
    $chroot=
    david% bash -u /tmp/shrink-chroot.sh
    /tmp/shrink-chroot.sh: line 3: $1: unbound variable
    david%

##使用set -e

你写的每一个脚本的开始都应该包含set -e。这告诉bash一但有任何一个语句返回非真的值，则退出bash。使用-e的好处是避免错误滚雪球般的变成严重错误，能尽早的捕获错误。更加可读的版本：set -o errexit
使用-e把你从检查错误中解放出来。如果你忘记了检查，bash会替你做这件事。不过你也没有办法使用$?来获取命令执行状态了，因为bash无法获得任何非0的返回值。你可以使用另一种结构：

    command
    if [ "$?"-ne 0]; then echo "command failed"; exit 1; fi
可以替换成：

    command || { echo "command failed"; exit 1; }

或者使用：

    if ! command; then echo "command failed"; exit 1; fi

如果你必须使用返回非0值的命令，或者你对返回值并不感兴趣呢？你可以使用 command || true ，或者你有一段很长的代码，你可以暂时关闭错误检查功能，不过我建议你谨慎使用。

    set +e
    command1
    command2
    set -e

相关文档指出，bash默认返回管道中最后一个命令的值，也许是你不想要的那个。比如执行 false | true 将会被认为命令成功执行。如果你想让这样的命令被认为是执行失败，可以使用 set -o pipefail

##程序防御 - 考虑意料之外的事

你的脚本也许会被放到“意外”的账户下运行，像缺少文件或者目录没有被创建等情况。你可以做一些预防这些错误事情。比如，当你创建一个目录后，如果父目录不存在，mkdir 命令会返回一个错误。如果你创建目录时给mkdir命令加上-p选项，它会在创建需要的目录前，把需要的父目录创建出来。另一个例子是 rm 命令。如果你要删除一个不存在的文件，它会“吐槽”并且你的脚本会停止工作。（因为你使用了-e选项，对吧？）你可以使用-f选项来解决这个问题，在文件不存在的时候让脚本继续工作。
准备好处理文件名中的空格
有些人从在文件名或者命令行参数中使用空格，你需要在编写脚本时时刻记得这件事。你需要时刻记得用引号包围变量。

    if [ $filename = "foo" ];

当$filename变量包含空格时就会挂掉。可以这样解决：

    if [ "$filename" = "foo" ];

使用$@变量时，你也需要使用引号，因为空格隔开的两个参数会被解释成两个独立的部分。

    david% foo() { for i in $@; do echo $i; done }; foo bar "baz quux"
    bar
    baz
    quux
    david% foo() { for i in "$@"; do echo $i; done }; foo bar "baz quux"
    bar
    baz quux

我没有想到任何不能使用"$@"的时候，所以当你有疑问的时候，使用引号就没有错误。
如果你同时使用find和xargs，你应该使用 -print0 来让字符分割文件名，而不是换行符分割。

    david% touch "foo bar"
    david% find | xargs ls
    ls: ./foo: No such file or directory
    ls: bar: No such file or directory
    david% find -print0 | xargs -0 ls
    ./foo bar

##设置的陷阱

当你编写的脚本挂掉后，文件系统处于未知状态。比如锁文件状态、临时文件状态或者更新了一个文件后在更新下一个文件前挂掉。如果你能解决这些问题，无论是 删除锁文件，又或者在脚本遇到问题时回滚到已知状态，你都是非常棒的。幸运的是，bash提供了一种方法，当bash接收到一个UNIX信号时，运行一个 命令或者一个函数。可以使用trap命令。

    trap command signal [signal ...]

你可以链接多个信号（列表可以使用kill -l获得），但是为了清理残局，我们只使用其中的三个：INT，TERM和EXIT。你可以使用-as来让traps恢复到初始状态。
信号描述

INT
Interrupt - 当有人使用Ctrl-C终止脚本时被触发
TERM
Terminate - 当有人使用kill杀死脚本进程时被触发
EXIT
Exit - 这是一个伪信号，当脚本正常退出或者set -e后因为出错而退出时被触发


当你使用锁文件时，可以这样写：

    if [ ! -e $lockfile ]; then
    touch $lockfile
    critical-section
    rm $lockfile
    else
    echo "critical-section is already running"
    
    fi
当最重要的部分(critical-section)正在运行时，如果杀死了脚本进程，会发生什么呢？锁文件会被扔在那，而且你的脚本在它被删除以前再也不会运行了。解决方法：

    if [ ! -e $lockfile ]; then
    trap " rm -f $lockfile; exit" INT TERM EXIT
    touch $lockfile
    critical-section
    rm $lockfile
    trap - INT TERM EXIT
    else
    echo "critical-section is already running"
    fi

现在当你杀死进程时，锁文件一同被删除。注意在trap命令中明确地退出了脚本，否则脚本会继续执行trap后面的命令。
竟态条件 (wikipedia)
在上面锁文件的例子中，有一个竟态条件是不得不指出的，它存在于判断锁文件和创建锁文件之间。一个可行的解决方法是使用IO重定向和bash的noclobber(wikipedia)模式，重定向到不存在的文件。我们可以这么做：

    if ( set -o noclobber; echo "$$" > "$lockfile") 2> /dev/null;
    then
    trap 'rm -f "$lockfile"; exit $?' INT TERM EXIT
    critical-section
    rm -f "$lockfile"
    trap - INT TERM EXIT
    else
    echo "Failed to acquire lockfile: $lockfile"
    echo "held by $(cat $lockfile)"
    fi

更复杂一点儿的问题是你要更新一大堆文件，当它们更新过程中出现问题时，你是否能让脚本挂得更加优雅一些。你想确认那些正确更新了，哪些根本没有变化。比如你需要一个添加用户的脚本。

    add_to_passwd $user
    cp -a /etc/skel /home/$user
    chown $user /home/$user -R

当磁盘空间不足或者进程中途被杀死，这个脚本就会出现问题。在这种情况下，你也许希望用户账户不存在，而且他的文件也应该被删除。

    rollback() {
        del_from_passwd $user
            if [ -e /home/$user ]; then
                rm -rf /home/$user
            fi
            exit
    }
    trap rollback INT TERM EXIT
    add_to_passwd $user
    cp -a /etc/skel /home/$user
    chown $user /home/$user -R
    trap - INT TERM EXIT

在脚本最后需要使用trap关闭rollback调用，否则当脚本正常退出的时候rollback将会被调用，那么脚本等于什么都没做。

##保持原子化

又是你需要一次更新目录中的一大堆文件，比如你需要将URL重写到另一个网站的域名。你也许会写：

    for file in $(find /var/www -type f -name "*.html"); do
    perl -pi -e 's/www.example.net/www.example.com/' $file
    done

如果修改到一半是脚本出现问题，一部分使用www.example.com，而另一部分使用www.example.net。你可以使用备份和trap解决，但在升级过程中你的网站URL是不一致的。
解决方法是将这个改变做成一个原子操作。先对数据做一个副本，在副本中更新URL，再用副本替换掉现在工作的版本。你需要确认副本和工作版本目录在同一个磁盘分区上，这样你就可以利用Linux系统的优势，它移动目录仅仅是更新目录指向的inode节点。

    cp -a /var/www /var/www-tmp
    for file in $(find /var/www-tmp -type -f -name "*.html"); do
    perl -pi -e 's/www.example.net/www.example.com/' $file
    done
    mv /var/www /var/www-old
    mv /var/www-tmp /var/www

这意味着如果更新过程出问题，线上系统不会受影响。线上系统受影响的时间降低为两次mv操作的时间，这个时间非常短，因为文件系统仅更新inode而不用真正的复制所有的数据。

这种技术的缺点是你需要两倍的磁盘空间，而且那些长时间打开文件的进程需要比较长的时间才能升级到新文件版本，建议更新完成后重新启动这些进程。对于 apache服务器来说这不是问题，因为它每次都重新打开文件。你可以使用lsof命令查看当前正打开的文件。优势是你有了一个先前的备份，当你需要还原 时，它就派上用场了。
