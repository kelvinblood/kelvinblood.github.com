---
layout: post
title: 波兰 nazwa 家的 vps 重装系统的密码问题
category: tech
tags: linux vps
---
![](https://cdn.kelu.org/blog/tags/vps.jpg)

有在用波兰 nazwa 家的服务器的同学们要注意一下，他们的 vps 重装系统后没有密码的，要跑进控制台自行设置。这篇文章说明一下 CentOS/Debian 的设置过程，其他系统大同小异。

首先登录到[VPS服务器管理面板](https://vps.nazwa.pl/)，转到实例列表并单击Console下拉列表。然后点击蓝色的QEMU行和**SendCtrlAltDel**重置按钮。

# CentOS

将光标设置为**CentOS Linux**，然后按*e*并转到编辑。

![img](https://cdn.kelu.org/blog/2018/06/csm_centos_root_1_4b3302ecd0.jpg)

在编辑窗口中，转到以**linux**条目开头的行。删除参数**root = UUID = e35103f0-80 ...**之后的信息并将其替换为以下条目：

```
rw init = /bin/bash
```

![img](https://cdn.kelu.org/blog/2018/06/csm_centos_root_2_58a1038c0d.jpg)

更改参数后，按*CTRL + x*或*F10*启动系统。

1. 检查文件系统是否以读/写（rw）模式安装。

   ```
   root @（none）：/＃mount | grep -w /
   ```

2. 输入**passwd**命令并输入**root**帐户的新密码。

   ```
   root @（none）：/＃passwd
   ```

3. 创建*autorelabel*文件。

   ```
   root @（none）：/＃touch /.autorelabel
   ```

   ![img](https://cdn.kelu.org/blog/2018/06/csm_centos_root_3_bbe57b82ce.jpg)

4. 重新启动系统。

   ```
   root @（none）：/＃exec /sbin/reboot -f
   ```

   

# Debian

在GRUB菜单中，将光标设置为**Debian GNU / Linux**条目，然后按*e*键并转到编辑。

![img](https://cdn.kelu.org/blog/2018/06/csm_debian_root_1_62e840c68b.jpg)

在编辑窗口中，转到以**linux**条目开头的行。删除参数**root = UUID = 8c132507-315c ...**之后的信息并将其替换为以下条目：

```
rw init = /bin/bash
```

![img](https://cdn.kelu.org/blog/2018/06/csm_debian_root_2_045fb2e406.jpg)

更改参数后，选择*CTRL + x*或*F10*以启动系统。

1. 检查文件系统是否以读/写（rw）模式安装。

   ```
   root @（none）：/＃mount | grep -w /
   ```

2. 输入**passwd**命令并输入**root**帐户的新密码。

   ```
   root @（none）：/＃passwd
   ```

3. 创建*autorelabel*文件。

   ```
   root @（none）：/＃touch /.autorelabel
   ```

4. 重新启动系统。

   ```
   root @（none）：/＃exec /sbin/reboot -f
   ```

   ![img](https://cdn.kelu.org/blog/2018/06/csm_debian_root_3_b9ccc6d193.jpg)



# 参考资料

* <https://pomoc.nazwa.pl/baza-wiedzy/produkty-i-uslugi/serwery-vps/informacje-ogolne-o-serwerach-vps/jak-przez-ssh-zmienic-haslo-do-konta-root/>