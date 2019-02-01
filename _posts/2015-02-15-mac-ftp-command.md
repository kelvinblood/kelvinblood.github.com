---
layout: post
title: Mac下使用命令行登陆ftp
category: tech
tags: mac ftp
---

最近使用forklift下载服务器pureftp上的东西，总是断断续续的，经常下载到99%然后显示下载失败，非常不舒服！原以为是forklift的问题，换了transmit发现同样有这样的现象。看来是ftp服务器搭的有问题~~不过因为用的不多，目前懒的解决了，暂时用Mac的终端命令来用着。其实效率也是蛮高的哦=。=



默认的本地目录是home。 输入help即可获得所有命令的帮助。

1. 连接ftp服务器

  man ftp 可以看到有这些信息。

  	NAME
  	     ftp -- Internet file transfer program
  	
  	SYNOPSIS
  	     ftp [-46AadefginpRtvV] [-N netrc] [-o output] [-P port] [-q quittime]
  	         [-s srcaddr] [-r retry] [-T dir,max[,inc]] [[user@]host [port]]
  	         [[user@]host:[path][/]] [file:///path]
  	         [ftp://[user[:password]@]host[:port]/path[/][;type=X]]
  	         [http://[user[:password]@]host[:port]/path] [...]
  	     ftp -u URL file [...]

  连接服务器的话基本上就用到上面的讯息了。原本没有看man手册，一直使用

  	ftp user@xxx.com port

  每次都要输入密码。后来还是用了下面这个更加简单的

  	ftp ftp://user:passwd@xxx.com:port

2. 浏览文件
	
	命令和Windows、Linux的命令基本相同
	
		ftp> cd Documents
		ftp> ls		
		ftp> dir
	
3. 下载上传文件

		put filename - Upload a file to the server
		
		get filename - Download a file from the server
		
		mput filename - Put multiple files on the server
		
		mget filename - Get multiple files on the server

4. 断开连接

	bye：中断与服务器的连接。
	
		ftp> bye


5. 大部分的命令如下，可敲入`man ftp`获得
	
		ls – list the contents of a directory on the FTP server
		cd – change the working directory on the FTP server
		pwd – show the current directory on the FTP server
		get – download files from the FTP server
		put – upload files to the FTP server
		account – include a password with your login information
		bye – terminate an ftp session and close ftp (or use disconnect to simply terminate a session)
		bell – make a cute sound after each file transfer is done
		chmod – change permissions
		delete – your guess is as good as mine (OK, you got me, it’s to delete a file off the server)
		glob – enable globbing
		hash – only functional in Amsterdam
		help – get help
		lpwd – print the local working directory for transfers
		mkdir – create folders on the FTP server
		rmdir – delete folders from the FTP server
		newer – only get a file if it’s newer (great for scripting synchronizations)
		nmap – use positional parameters to set filenames
		passive – use FTP passive mode
		prompt – allows the use of letters to automate answers to prompts
		rate – limit the speed of an upload or download

关于ftp，你甚至还可以写脚本进行文件操作，比如

		#!/bin/bash
		ftp -d krypted.com << ftpEnd
		prompt
		cd /Library/WebServer/Documents
		put “*.html”
		put “*.php”
		cd /Library/WebServer/Documents
		put “*.png”
		quit
		ftpEnd
	
		#!/bin/bash
		ftp -d krypted.com << ftpEnd
		prompt
		cd /My/Documents
		get “*.doc”
		quit
		ftpEnd

在你的脚本中，可以使用以下几个字符获取一些特定的变量：

	%/ – the current working directory of the FTP server
	%M – the hostname of the FTP server
	%m – the hostname only up to the .
	%n – the username used for the FTP server

最后有一个问题，为什么老是有不明的人/机器想登陆我的FTP？= =不过自己也是只有使用的时候才会开。

![ftp-log](https://cdn.kelu.org/blog/2015/02/FTP-Log.jpg)