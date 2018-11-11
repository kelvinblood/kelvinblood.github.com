---
layout: post
title: 使用 Proxifier 解决系统级的代理问题
category: tech
tags: proxy linux mac windows
---
![](https://cdn.kelu.org/blog/tags/proxy.jpg)

先前有写过这样一篇文章[《Fiddler 让 Win10 自带日历客户端连接谷歌账户》](/tech/2017/03/01/a-userful-tool-help-your-win10-calendar-connect-to-google-account.html)

然而 Fiddler 毕竟是跟踪流量用的，本业并不是代理，所以在代理设置上还是捉襟见肘的。 今天找到了 Proxifier 这个软件，就是为了代理而生的，非常好用。

先说一下使用场景，我目前的需求是在 Mac 下同步 Google Drive，虽然登录是没问题，然而连接就是失败，官方客户端也没有提供 http/socks 代理设置之类的，也是无语。于是就找到了这个东西。

# 介绍

>
Proxifier allows network applications that do not support working through proxy servers to operate through a SOCKS or HTTPS proxy and chains.
The most advanced proxy client 。https://www.proxifier.com/index.htm

>
Proxifier是一款功能非常强大的socks5客户端，可以让不支持通过代理服务器工作的网络程序能通过HTTPS或SOCKS代理或代理链。支持 64位系统，支持Xp，Vista，Win7，MAC OS ,支持socks4，socks5，http代理协议，支持TCP，UDP协议，可以指定端口，指定IP，指定域名,指定程序等运行模式，兼容性非常好，和SOCKSCAP属于同类软件，不过SOCKSCAP已经很久没更新了，不支持64位系统。 有许多网络应用程序不支持通过代理服务器工作，Proxifier 解决了这些问题和所有限制，让您有机会不受任何限制使用你喜爱的软件。此外，它让你获得了额外的网络安全控制，创建代理隧道，并添加使用更多网络功能的权力。 

特性如下:

* 通过代理服务器运行任何网络应用程序。对于软件不需要有什么特殊配置；整个过程是完全透明的。
* 通过代理服务器网关访问受限制的网络。
* 绕过防火墙的限制。
* ”隧道”整个系统 （强制所有网络连接，包括系统工作都通过代理服务器连接）。
* 通过代理服务器解析 DNS 名称。
* 灵活的代理规则，对于主机名和应用程序名称可使用通配符。
* 通过隐藏您的 IP 地址的获得安全隐私。
* 通过代理服务器链来工作，可使用不同的协议。
* 查看当前网络活动的实时信息（连接，主机，时间，带宽使用等）。
* 维护日志文件和流量转储。
* 获得详细的网络错误报告。

官网地址：<http://www.proxifier.com/>
下载地址：<http://www.proxifier.com/download.htm>     

然而，价格也是非常昂贵的。在这里我就不给出注册码了，需要的朋友请私下联系我。

<span style="display:none">
L6Z8A-XY2J4-BTZ3P-ZZ7DF-A2Q9C（Portable Edition）
5EZ8G-C3WL5-B56YG-SCXM9-6QZAP（Standard Edition）
P427L-9Y552-5433E-8DSR3-58Z68（MAC）
</span>

# 使用

我是 Mac 下的环境。Windows 下界面大同小异。
        
* 添加代理信息

    打开软件，点击图中按钮，添加代理信息

    ![](https://cdn.kelu.org/blog/2017/07/2017-07-04-8.25.24.jpg)

    还可以在代理添加界面点击”Proxy Chains”按钮添加多条代理线路，以实现均衡负载。
    
* 添加代理规则

    ![](https://cdn.kelu.org/blog/2017/07/2017-07-04-10.41.37.jpg)

    这里可以设置某一款程序需要通过代理访问。

*  其它注意事项

    为了防止DNS污染，一般使用代理的时候都会使用远程服务器的DNS设置，在第一次启动软件时会有提示，我们也可以在这里设置。

    ![](https://cdn.kelu.org/blog/2017/07/2017-07-04-8-25-59.jpg)

做完了上面的步骤，就可以看主界面啦。 

![](https://cdn.kelu.org/blog/2017/07/2017-07-04-10.40.16.jpg)

主界面还可以看实时流量图和统计信息。

![](https://cdn.kelu.org/blog/2017/07/2017-07-04-10.40.37.jpg)
        
​        
# 开源软件参考

朋友介绍了一个类似的开源软件，有余力的朋友可以参考一下，朋友说非常好用：

[csujedihy/proximac - An open-source alternative to proxifier](https://github.com/csujedihy/proximac)
