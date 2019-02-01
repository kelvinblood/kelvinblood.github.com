---
layout: post
title: 在Linux上使用dropbox
category: tech
tags: linux dropbox
---

需要在Linux服务器和本地下载东西时，ftp什么的也可行，但我常常在服务器上下载pt资源，每次都下载到本地也是麻烦。索性直接扔到网盘让本地自动同步还更方便。

说到网盘，脑子里闪现出来的只有谷歌、微软和dropbox了。不过能同时支持Linux和Mac的，就只剩下dropbox了。虽然dropbox空间比较小，不过以前有做过活动，我的dropbox有8G的空间，所以还是蛮足够了的。

安装的方法只看dropbox的官网上就有说明了。

![image](https://cdn.kelu.org/blog/2015/10/blog_2015-10-11-1.26.40.jpg)

你可以以命令行安装无外设模式的dropbox，对于服务器来说维护起来更加方便。也可以以桌面安装的方式安装，符合习惯，并且可以选择同步位置。当然两者混合着来也ok。下面把两种方式都写下来。

## 命令行安装
Dropbox 守护程序可在所有 32 位与 64 位 Linux 服务器上正常运行。若要安装，请在 Linux 终端运行下列命令。

	32-bit:
	
	cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -
	64-bit:
	
	cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
接着，从新建的 .dropbox-dist 文件夹运行 Dropbox 守护程序。

	~/.dropbox-dist/dropboxd

如果是首次在服务器上运行 Dropbox，系统会要求您将类似于下面的链接复制并粘贴到运行的浏览器中，以便创建一个新的帐户或将服务器附加到现有帐户上。

	https://www.dropbox.com/cli_link?host_id=XXXXXXXXXXXXXXXXXXX

操作完成后，系统会在您的主目录中创建 Dropbox 文件夹。下载这个 [dropbox.py](https://gist.github.com/kelvinblood/febea84bc8a504926aba92d823a67807) 脚本，通过命令行控制 Dropbox。
操作完成后，系统会在您的主目录中创建 Dropbox 文件夹。下载这个 [dropbox.py](https://gist.github.com/kelvinblood/febea84bc8a504926aba92d823a67807) 脚本，通过命令行控制 Dropbox。

为了方便访问，我把这个脚本放入Dropbox目录下，使用下面的命令将快捷方式添加到系统中：

	echo "alias dr='python ~/Dropbox/dropbox.py'" >> ~/.bashrc

之后就可以很方便的使用`dr`这个命令对dropbox进行操作了，直接输入`dr`就可以看到相关的命令了。

![image](https://cdn.kelu.org/blog/2015/10/blog_WeChat_1444541977.jpeg)

## 普通安装Dropbox
使用上面的方法已经可以安装使用dropbox了。然而无界面的dropbox的不便就是，设置dropbox目录地址不方便。所以可以直接下载deb文件进行安装。当然，服务器上必须要有桌面环境才可。

服务器管理员们常常懒得安装桌面环境，毕竟性能损耗大，也显得没必要。如果环境里没有的话，参考我这一篇[《使用vnc/xrdp连接你的Debian》][blog_link]，安装轻量级的桌面环境jwm即可。

如果你使用的桌面环境是GNOME这类的高级桌面环境的话，就可以略过下面这个步骤，直接双击安装就OK了。是jwm的话，还得用命令行安装：

	dpkg -i xxx.deb

按照提示安装完成是在应用程序栏里会显示的。jwm并不显示。没关系，直接找到application menu文件夹查看启动命令即可。

	vi /usr/share/applications/dropbox.desktop
	
	[Desktop Entry]
	Name=Dropbox
	GenericName=File Synchronizer
	Comment=Sync your files across computers and to the web
	Exec=dropbox start -i
	Terminal=false
	Type=Application
	Icon=dropbox
	Categories=Network;FileTransfer;
	StartupNotify=false

于是使用`dropbox start -i`启动ui界面，点击下一步安装即可。安装过程中也会提醒你安装的位置。

![image](https://cdn.kelu.org/blog/2015/10/blog_2015-10-13-6.17.03.jpg)

启动完成之后，dropbox就会显示在桌面上啦。

![image](https://cdn.kelu.org/blog/2015/10/blog_2015-10-13-6.43.46.jpg)

- - - -
参考链接

* [Dropbox 官网说明](https://www.dropbox.com/zh_CN/install?os=lnx)



[blog_link]: http://blog.kelu.org/linux/2015/01/31/connect-your-debian-via-vnc-and-xrdp.html
