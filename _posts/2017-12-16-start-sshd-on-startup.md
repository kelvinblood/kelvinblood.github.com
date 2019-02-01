---
layout: post
title: CentOS 7 开机自启动ssh服务
category: tech
tags: tech
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

	systemctl enable sshd

另外我在某台机器上遇到了一个错误，始终无法启动 ssh，使用 systemctl status sshd.service，内容如下：

	sshd.service - OpenSSH server daemon
	  Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
	  Active: activating (auto-restart) (Result: exit-code) since Wed 2017-12-27 17:38:43 CST; 9s ago
	    Docs: man:sshd(8)
	          man:sshd_config(5)
	 Process: 6860 ExecStart=/usr/sbin/sshd -D $OPTIONS (code=exited, status=255)
	Main PID: 6860 (code=exited, status=255)
	
	Dec 27 17:38:43 adsl-172-10-1-100.dsl.sndg02.sbcglobal.net systemd[1]: Failed to start OpenSSH server daemon.
	Dec 27 17:38:43 adsl-172-10-1-100.dsl.sndg02.sbcglobal.net systemd[1]: Unit sshd.service entered failed state.
	Dec 27 17:38:43 adsl-172-10-1-100.dsl.sndg02.sbcglobal.net systemd[1]: sshd.service failed.

	
使用 journalctl -xe 得到了有用的信息：

	/var/empty/sshd must be owned by root and not group or world-writable.


发现 /var/empty/sshd 文件的属性为777.改为755即可：

	chmod 755 /var/empty/sshd
