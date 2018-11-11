---
layout: post
title: 中国电信 cn2 是什么
category: tech
tags:  vps
---
![](https://cdn.kelu.org/blog/tags/network.jpg)

# 中国电信

中国电信是世界上最大的固网运营商和宽带服务提供商，为一亿宽带用户和超过230万中国网站提供了中国互联网信息的接入服务。在中国拥有超过300骨干网节点和4000Gbps的网络带宽，70%的中文资源和和超过90万宽带用户。

中国电信在全球部署超过40个POP节点(关键的交换中心)，节点如图：

![](https://cdn.kelu.org/blog/2017/08/1400483105827.jpg)

> 资料来源：[中国电信集团公司](http://www.chinatelecomglobal.com/product/detail.html?cate_id=900003&lang=zh)

# CN2

CN2全称为中国电信下一代承载网，英文Chinatelecom Next Carrier Network，缩写为CNCN，进一步缩写为CN2。

CN2采用全网MPLS、保证8个等级的QoS以及支持全网组播和IPv6硬件转发等代表当今IP尖端技术的网络。由600多台T级交换容量的高端路由器、194个节点组成，耗资13亿. 中国电信对它“职业生涯”的规划是“承载3G的话音和数据传输、NGN业务承载、VIP集团用户的联网以及流媒体业务”，老的ChinaNet———即163、169网络将主要被用作ADSL、拨号等INTERNET接入和浏览业务。

CN2网络特征——骨干网简洁化

	1) 减少了协议层次，降低了设备的复杂性，提供了链路利用率。
	
	2) CN2网络基于IP/MPLS协议，VPN业务MPLS转发，互联网业务Native IP转发
	
	3) CN2网络特征——业务和控制边缘化

根据业务流量预测、传输资源状况和地理位置，选择北京、上海、广州、南京、武汉、成都和西安7个节点为核心节点。7个核心节点在网络结构上地位相同，只是业务容量不同。

考虑QOS质量对网络结构的要求、采用全网状结构，保证正常情况下核心节点间的延时小于15ms（3000KM传输距离），单局向链路故障情况下延时小于20ms（4000公里传输距离）。

CN2在香港、东京、新加坡、伦敦、法兰克福、纽约、华盛顿、圣何塞、洛杉矶设置了9个POP节点，提供国际VPN、Internet接入和网间互连业务

就我个人理解，总的来说，cn2指的是中国的新一代互联网承载的网络，优质快速，在出海线路上更是完爆其他网络线路。

> 插入一个BGP小知识

> BGP是自治系统间的路由协议，它的主要功能是和其他BGP说话者之间交换网络可达性信息。一个BGP说话者是任何为BGP配置的设备。BGP使用TCP作为它的传输协议(端口179)，这提供了可靠的数据传输。BGP线路 解决了国内不同运营商互联互通问题。

# CN2线路判断

普通家庭宽带用户用不上CN2线路，哪怕加几倍的钱也不一定能用上，而接入CN2线路机房的VPS，价格卖得比其他线路的高很多。用户少，服务器少，分配的独享资源多，这样就能保证绝大多数情况下CN2线路的流畅性。

判断目标服务器是否在 cn2 线路上，

1. 可以上 <http://www.ipip.net/traceroute.php> 进行查询，例如：

	![](https://cdn.kelu.org/blog/2017/08/QQ20170805-024741.jpg)

	注意起始节点不要选 BGP 的节点。要不然可能会跑其他运营商那而不是电信的节点，测不出来就没意义了。

1. 也可以使用 mtr 命令进行查询，从本地测试服务器ip是去程，在服务器上测试本地 ip是回程，可以都测一下。不知道为什么我的本地测试显示的不对，可能是本地用的代理的原因？（摊手

	![](https://cdn.kelu.org/blog/2017/08/2017-08-05-3.02.33.jpg)

结论：

59.43.xxx.xxx ：这样以59.42开头（C段不详）一般为中国电信CN2骨干网IP地址，具体的可以到[ipip.net](https://www.ipip.net/)查验。

# 出口节点

CN2北京出口到伦敦，上海出口到圣何塞、洛杉矶、法兰克福、东京、香港，广州出口到圣何塞、洛杉矶、新加坡、香港，国内具体走哪个出口到海外估计要看城域网。

# 理论知识

![](https://cdn.kelu.org/blog/2017/08/1.jpg)

![](https://cdn.kelu.org/blog/2017/08/2.jpg)

![](https://cdn.kelu.org/blog/2017/08/3.jpg)

![](https://cdn.kelu.org/blog/2017/08/4.jpg)

![](https://cdn.kelu.org/blog/2017/08/5.jpg)

![](https://cdn.kelu.org/blog/2017/08/6.jpg)

# 参考资料

* [中国电信下一代承载网络：CN2介绍](http://blog.sina.com.cn/s/blog_591f0e6e0100aoqy.html)
* [核心网和骨干网的区别和联系](http://www.txrjy.com/asktech/question.php?qid=15819)
* [电信骨干路由器有多强？](https://www.zhihu.com/question/48105938/answer/142393813)
* [CN2 线路介绍及 CN2 VPS服务商](https://www.gubo.org/instroduction-to-cn2-and-cn2-vps-providers/)
* [CN2网络概况及MPLS VPN简介_图文_百度文库](https://wenku.baidu.com/view/f5cab81a3968011ca2009121.html)
