---
layout: post
title: CentOS 7 使用代理服务器
category: tech
tags: proxy
---
![](https://cdn.kelu.org/blog/tags/proxy.jpg)

这篇文章记录如何在 CentOS 7 下使用代理服务器，以此在国内服务器下载 k8s 的镜像，例如<k8s.gcr.io/defaultbackend:1.3>

# 代理客户端

代理客户端用来连接本地与服务器。

1. 安装

   ```
   sudo yum -y install epel-release
   sudo yum -y install python-pip
   sudo pip install shadowsocks
   ```

2. 配置

   ```
   sudo mkdir -p /etc/shadowsocks
   sudo vi /etc/shadowsocks/shadowsocks.json
   ```

   配置信息如下：

   ```
   {
       "server":"x.x.x.x",  # 服务器地址
       "server_port":1035,  # 服务器端口
       "local_address": "127.0.0.1", # 本地IP
       "local_port":1080,  # 本地端口
       "password":"password", # 连接密码
       "timeout":300,  # 等待超时时间
       "method":"aes-256-cfb",  # 加密方式
       "fast_open": false,  # true或false。开启fast_open以降低延迟，但要求Linux内核在3.7+
       "workers": 1  #工作线程数 
   }
   ```

3. 自启动

   新建脚本

   ```
   touch /etc/systemd/system/shadowsocks.service
   # vi /etc/systemd/system/shadowsocks.service

   [Unit]
   Description=Shadowsocks
   [Service]
   TimeoutStartSec=0
   ExecStart=/usr/bin/sslocal -c /etc/shadowsocks/shadowsocks.json
   [Install]
   WantedBy=multi-user.target
   ```

4. 启动Shadowsocks

   ```
   systemctl enable shadowsocks.service
   systemctl start shadowsocks.service
   systemctl status shadowsocks.service
   ```

5. 验证运行状况

   ```
   curl --socks5 127.0.0.1:1080 -i http://ip.cn
   ```

   将会显示ip的具体位置。



# privoxy

许多应用没有 socks 的能力。privoxy 用来将 socks5 代理转为 http 代理，就可以给大部分应用提供代理支持了。

1. 安装

   ```
   yum install privoxy -y
   systemctl enable privoxy
   systemctl start privoxy
   systemctl status privoxy
   ```

2. 配置

   ```
   cat >> /etc/privoxy/config << EOF
   forward-socks5t / 127.0.0.1:1080 .
   EOF
   ```

3. 设置http、https代理

   ```
   # vi ~/.bashrc 在最后添加如下信息
   PROXY_HOST=127.0.0.1
   export all_proxy=http://$PROXY_HOST:8118
   export ftp_proxy=http://$PROXY_HOST:8118
   export http_proxy=http://$PROXY_HOST:8118
   export https_proxy=http://$PROXY_HOST:8118
   export no_proxy=localhost,172.16.0.0/16,192.168.0.0/16.,127.0.0.1,10.10.0.0/16

   # 重载环境变量
   source ~/.bashrc
   ```

4. 验证运行状况

   ```
   curl -i http://ip.cn
   ```

   将会显示ip的具体位置。



取消代理，只要将 `~/.bashrc` 中的内容取消掉，再 source 加载就好了。



# 参考资料

* <https://www.zybuluo.com/ncepuwanghui/note/954160>