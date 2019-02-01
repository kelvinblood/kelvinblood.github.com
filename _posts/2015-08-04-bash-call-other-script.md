---
layout: post
title: 在bash脚本中引用其他脚本
category: tech
tags: linux bash linux-command
---

## fork

这是最常用的调用方式，直接指定要调用的脚本的名字，也可以指定要使用的shell,比如

      sh ${scriptname}
      bash ${scriptname}

如果不指定使用的shell名称，则根据脚本的shebang来确定使用的脚本解释器。

这种方式，shell会为调用脚本fork一个子进程来执行被调用的脚本。子进程继承父进程的环境变量，子进程结束时会有退出状态给父进程。

## source(.)

source或. 是bash的内建命令，在命令行上执行的时候,将会直接执行被调用脚本。在脚本内source另一个脚本时，会将被调用脚本插入到调用脚本，并执行这些脚本。因此调用脚本和被调用脚本可以相互访问彼此的变量。类似C/C++语言的include语句。

## exec

这是 shell 的内建命令，将使用被调用脚本来取代当前进程，当被调用脚本执行完毕后,调用脚本也随之结束。
