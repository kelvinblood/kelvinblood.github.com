---
layout: post
title: Linux下同步onedrive
category: tech
tags: linux microsoft onedrive
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

最近入了台surface pro 3，微软附带送了1年的onedrive和skype的服务。skype倒还好可以无压力地用掉。onedrive就很头疼了，在本地上传传得地老天荒还没传完2%，百度云早就传完了。大概是onedrive对国内的用户还不够友好吧。

早上闲来无事，不知道怎么搞的便安装起了github上的一个项目[onedrive-d](https://github.com/xybu/onedrive-d "onedrive-d")，在linux下同步onedrive用的。折腾来折腾去总算是搞好了同步。

看到github上的一些issue，不少人使用onedrive-d仍然有一些问题，反应的，诸如每次开机会重新同步所有文件；并且有可能会将文件同步多次，形成多个同名文件。安装时候要做好一定的心理准备。

## pip ##

按照习惯先说卸载时遇到的问题Orz

pip是python的软件安装工具。今天在卸载onedrive-d的时候出现了这个提示符`pip:command not found`。上官网找了好几遍竟然没找到下载地址，也真是醉了，竟然在一个不起眼的地方。

下载之后运行`python get-pip.py`安装pip。安装完成后就开始卸载onedrive-d，但是其实卸载还是会报错。把`~/.onedrive`删除后就不用管它，已经是卸载了= =。

## 安装 ##

    $ git clone https://github.com/xybu92/onedrive-d.git
    $ cd onedrive-d
    $ ./setup.sh --help
    
    Usage ./setup.sh [inst|remove]
    inst: install onedrive-d
    remove: uninstall onedrive-d from the system
    
    # 安装
    ./setup.sh inst

## 配置 ##

按照上述步骤安装之后就算是安装成功了。

来看看代码的目录结构。

    default  LICENSE  LiveAPI.md  onedrive_d  README.md  setup.sh
    
    ./default:
    ignore_list.txt
    
    ./onedrive_d:
    config.py    live_api.py  observer_gtk.py  pref.py      setup.py
    daemon.py    logger.py    pref_cmd.py      __pycache__
    __init__.py  main.py      pref_gtk.py      res


程序中有两个重要的命令，一个是预配置`onedrive-pref`，用来设定账户，另一个是`onedrive-d`，用来设定哪个文件需要同步的。

接下来使用`onedrive-pref`预配置。

    $ onedrive-pref

不知道大家运行成功不，反正在Debian7.7下是没办法运行的

    onedrive-pref: command not found

作者也说，他非正式版本还没吧命令添加进系统里！1.0正式版本也还没发布的样子= =所以直接运行

    ./onedrive_d/pref.py --no-gui

会给出一个连接，将这个链接粘贴到浏览器登陆到hotmail邮箱之后，将地址栏的信息粘贴回终端里，就完成账号绑定啦。

要退出账号也很简单，用下面这个命令退出。

    ./onedrive_d/pref.py --log-out

> tips: 为了今后能够更快的运行命令，建议用`~/.bashrc`记录你的快捷命令。例如以下命令，设定之后记得`source ~/.bashrc`

    alias onedrive-d='/home/github/onedrive-d/onedrive_d/main.py'
    alias onedrive-prefs='/home/github/onedrive-d/onedrive_d/pref.py'

## 使用 ##

然后在默认目录~/OneDrive下运行`onedrive-d`进行完全同步.

## 总结

目前我是暂时不用了，一来服务器没有那么大的空间同步，二来一不小心搞得自己以前的文件乱七八糟的，收拾起来也麻烦。

