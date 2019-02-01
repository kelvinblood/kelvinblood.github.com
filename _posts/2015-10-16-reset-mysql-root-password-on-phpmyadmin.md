---
layout: post
title: 通过PhpMyAdmin修改MySQL的root密码
category: tech
tags: linux mysql phpmyadmin database
---

今天在本地装了xampp，发现默认root的密码竟然为空。进入PhpMyAdmin时也提示了尽快修改。

![image](https://cdn.kelu.org/blog/2015/10/blog_2015-10-16-5.34.31.jpg)

以前也遇到了好几次这样的问题，都是测试环境其实没什么要紧的。不过上了生产环境之后迟早要修改的，于是现在就来尝试一下了。


### 修改MySQL root密码
首先用root账号登陆phpmyadmin，然后点击左侧进入mysql数据库，在顶部点击“mysql”进入sql输入界面。输入以下命令：

	update user set password=password('123456') where User='root'

其中123456为你希望修改的密码，切记不要在数据库中直接手工修改密码。

![image](https://cdn.kelu.org/blog/2015/10/blog_2015-10-16-5.43.13.jpg)

然后点击右下角的“执行”，看到“影响了x行”，就表示修改成功。

### 修改配置文件

接着修改`config.default.php`和`config.inc.php`文件。通过如下命令寻找到这两个文件：

	sudo find / -name 'config.default.php'
	sudo find / -name 'config.inc.php'

Mac下的安装路径为`/Applications/XAMPP/xamppfiles/phpmyadmin/libraries/config.default.php`  
`/Applications/XAMPP/xamppfiles/phpmyadmin/config.inc.php`
	
找到$cfg['Servers'][$i]['password']  = ' '，
修改为
	
	$cfg['Servers'][$i]['password'] = '123456'; 

重启mysql后新密码生效。


同时还要修改www目录下你的工程的配置文件config.php，修改以下两项

	'DB_USER'=>'root', 
	'DB_PWD'=>'123456', 

至此，修改完成。