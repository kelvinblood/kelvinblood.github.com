---
layout: post
title: VPS主机测试脚本
category: tech
tags:  linux vps
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

持续更新。

目前参考自[使用脚本测试VPS](https://www.zhujiboke.com/2017/01/30.html)：

# 硬盘IO及全球下载速度测试

使用秋水逸冰的一键Bench脚本

	wget -qO- bench.sh | bash

或者下载到本地运行:

	wget https://cdn.kelu.org/blog/2017/09/bench.sh
	chmod +x bench.sh
	./bench.sh

我经常运行到一半就卡了，不知道为什么，一般就看个I/O速度。

# 全国网络测试

来自于91yun，包括了全国PING值的测试和各地路由的走法，偏向于网络测试。

	wget -N --no-check-certificate https://raw.githubusercontent.com/91yun/91yuntest/master/test_91yun.sh && bash test_91yun.sh s

# 服务器性能测试

简单的对CPU进行运算测试，需要跑的时间很长，请耐心等好最后测试出来的跑分。如下：

	wget --no-check-certificate https://github.com/teddysun/across/raw/master/unixbench.sh
	chmod +x unixbench.sh
	./unixbench.sh

# 线路测试

```
wget —no-check-certificate https://raw.githubusercontent.com/wn789/Superspeed/master/superspeed.sh
chmod +x superspeed.sh
./superspeed.sh
```

![](https://cdn.kelu.org/blog/2017/09/2018-06-05_19-38-17.jpg)

![](https://cdn.kelu.org/blog/2017/09/0603141338.jpg)

# 参考资料

* [单使用脚本测试VPS](https://www.zhujiboke.com/2017/01/30.html)
* [VPS云主机测试脚本](https://birdteam.net/2017/08/vps-cloud-host-test-scripts.html)
* [91yun - github](https://github.com/91yun)
* [teddysun](https://github.com/teddysun)/**[across](https://github.com/teddysun/across)**
* [Linux性能测试UnixBench一键脚本](https://teddysun.com/245.html)
* [一键测试脚本bench.sh](https://teddysun.com/444.html)
* [如何安装和配置simple-obfs服务端](https://teddysun.com/511.html)