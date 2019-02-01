---
layout: post
title: 谷歌人机验证 reCAPTCHA 的解决办法
category: software
tags: google
---

![](https://cdn.kelu.org/blog/tags/google.jpg)

首先声明这个不是破解谷歌 reCAPTCHA 的意思Orz

当前世界范围的IPv4地址紧张，运营商给自家用户常常分配同一个IP上网(这句可以无视666)。在这种情况下访问谷歌搜索，容易被谷歌 reCaptcha 误伤识别成疑似机器人。这篇文章讨论如何避免这种情况。

>
接下来是正文

以前进行谷歌搜索的时候，都是很正常的。最近服务器发生了一些变动，在地址栏直接输入关键字搜索，就跳出了人机验证的界面，如下图

![](https://cdn.kelu.org/blog/2017/04//547fbadc3fff5.gif)

第一次遇到只要点击窗口就没有问题了，心里还感叹了下谷歌能把人机验证这事做的这么好，不错。然而这个窗口还是会不断调出来扰人= =

次数多了之后 Google 还会弹出一个窗口，要求输入传统的验证码或者跳出阿猫阿狗汽车的图片让你选择。

![](https://cdn.kelu.org/blog/2017/04//547fc0c191bbd.jpg)

关于谷歌人机验证的详细新闻，可以看雷锋网的这篇文章——[《与恼人的验证码说拜拜，Google用一次点击区分人与机器》][1]。我猜测这是多人公用同一个谷歌搜索的站点引起的问题。Google reCaptcha 功能会在收集大量信息，包括IP地址和cookies，然后通过收集这些数据对比用户是否和过去在互联网上的行为一致，来判定这个用户究竟是不是机器人。

在好基友的帮助下我找到了一个折中解决的办法。简单说来就是新建一个搜索引擎，指定想要的搜索地址就好(最好避开与你共用一条线路的用户访问的谷歌搜索的站点——主站.com，香港.hk和日本.co.jp这一类)。下面是具体的步骤：

1 访问 <google.com/ncr>，随便搜索一个关键字。（ncr=no country redirect不做国家跳转） 
2 修改浏览器默认搜索引擎。下面以 Chrome 为例：

打开设置
    
![](https://cdn.kelu.org/blog/2017/04/20170406192140.jpg)

管理搜索引擎
    
![](https://cdn.kelu.org/blog/2017/04/20170406192152.jpg)
    
自定义搜索引擎，并且设为默认搜索引擎

![](https://cdn.kelu.org/blog/2017/04/20170406192158.jpg)

将自定义搜索的地址改成各种天花乱坠的谷歌 + /search?q=%s ，比如

亚洲：

    蒙古 google.mn蒙古语
    韩国 google.co.kr 韩语
    日本 google.co.jp 日语
    越南 google.com.vn 越南语
    老挝 google.la 老挝语
    柬埔寨 google.com.kh 高棉语
    泰国 google.co.th 泰语
    马来西亚 google.com.my 马来语
    新加坡 google.com.sg 马来语
    文莱达鲁萨兰国 google.com.bn 马来语
    菲律宾 google.com.ph 菲律宾语
    印度尼西亚 google.co.id 印尼语
    东帝汶 google.tp 葡萄牙语
    哈萨克斯坦 google.kz 哈萨克语
    吉尔吉斯斯坦 google.kg 吉尔吉斯语
    塔吉克斯坦 google.com.tj 塔吉克语
    乌兹别克斯坦 google.co.uz 乌兹别克语
    土库曼斯坦 google.tm 土库曼语
    阿富汗 google.com.af 波斯语
    巴基斯坦 google.com.pk 乌尔都语
    尼泊尔 google.com.np 尼泊尔语
    印度 google.co.in 英语
    孟加拉国 google.com.bd 英语
    斯里兰卡 google.lk 僧伽罗语
    马尔代夫 google.mv 马尔代夫语
    科威特 google.com.kw 阿拉伯语
    沙特阿拉伯 google.com.sa 阿拉伯语
    巴林 google.com.bh 阿拉伯语
    阿联酋 google.ae 阿拉伯语
    阿曼 google.com.om 阿拉伯语
    约旦 google.jo 阿拉伯语
    以色列 google.co.il 阿拉伯语
    黎巴嫩 google.com.lb 阿拉伯语
    土耳其 google.com.tr 土耳其语
    阿塞拜疆 google.az 阿塞拜疆语
    亚美尼亚 google.am 亚美尼亚语英语
    莱索托 google.co.ls 莱索托语
    
    

欧洲：
欧洲：

    冰岛 google.is英语
    丹麦 google.dk 丹麦语
    挪威 google.no 挪威语
    瑞典 google.se 瑞典语
    芬兰 google.fi 芬兰语
    爱沙尼亚 google.ee 爱沙尼亚语
    拉脱维亚 google.lv 拉脱维亚语
    立陶宛 google.lt 立陶宛语
    爱尔兰 google.ie 爱尔兰语
    英国 google.co.uk 英语
    根西 google.gg
    泽西 google.je
    马恩 google.im
    法国 google.fr 法语
    荷兰 google.nl 荷兰语
    比利时 google.be 荷兰语
    卢森堡 google.lu 德语
    德国 google.de 德语
    奥地利 google.at 德语
    瑞士 google.ch 德语
    列支敦士登 google.li 德语
    葡萄牙 google.pt 葡萄牙语
    西班牙 google.es 西班牙语
    直布罗陀 google.com.gi 西班牙语
    安道尔 google.ad 法语
    意大利 google.it 意大利语
    马耳他 google.com.mt 马耳他语
    圣马力诺 google.sm 意大利语
    希腊 google.gr 希腊语
    俄罗斯 google.ru 俄语
    白俄罗斯 google.com.by 白俄罗斯语
    乌克兰 google.com.ua 乌克兰语
    波兰 google.pl 波兰语
    捷克 google.cz 捷克语
    斯洛伐克 google.sk 斯洛伐克语
    匈牙利 google.hu 匈牙利语
    斯洛文尼亚 google.si 斯洛文尼亚语
    克罗地亚 google.hr 克罗地亚语
    波黑 google.ba 塞尔维亚语
    黑山 google.me 黑山语
    塞尔维亚 google.rs 塞尔维亚语
    马其顿 google.mk 马其顿语
    保加利亚 google.bg 保加利亚语
    罗马尼亚 google.ro 罗马尼亚语
    摩尔多瓦 google.md 摩尔多瓦语

非洲：
非洲：

    埃及 google.com.eg 阿拉伯语
    利比亚 google.com.ly 阿拉伯语
    阿尔及利亚 google.dz 阿拉伯语
    摩洛哥 google.co.ma 阿拉伯语
    塞内加尔 google.sn 法语
    冈比亚 google.gm 英语
    马里 google.ml 法语
    布基纳法索 google.bf 法语
    塞拉利昂 google.com.sl 英语
    科特迪瓦 google.ci 法语
    加纳 google.com.gh 英语
    多哥 google.tg 法语
    贝宁 google.bj 法语
    尼日尔 google.ne 法语
    尼日利亚 google.com.ng 英语
    圣赫勒拿 google.sh 英语
    喀麦隆 google.cm 法语
    乍得 google.td 阿拉伯语
    中非 google.cf 法语
    加蓬 google.ga 法语
    刚果（布） google.cg 法语
    刚果（金） google.cd 法语
    安哥拉 google.it.ao 葡萄牙语
    埃塞俄比亚 google.com.et 安哈拉语
    吉布提 google.dj 阿拉伯语
    肯尼亚 google.co.ke 英语
    乌干达 google.co.ug 英语
    坦桑尼亚 google.co.tz 英语
    卢旺达 google.rw 卢旺达语
    布隆迪 google.bi 布隆迪语
    马拉维 google.mw 契瓦语
    莫桑比克 google.co.mz 葡萄牙语
    马达加斯加 google.mg 马尔加什语
    塞舌尔 google.sc 英语
    毛里求斯 google.mu 英语
    赞比亚 google.co.zm 英语
    津巴布韦 google.co.zw 英语
    博茨瓦纳 google.co.bw 茨瓦纳语
    纳米比亚 google.com.na 南非荷兰语
    南非 google.co.za

大洋洲：

    澳大利亚 google.com.au 英语
    诺福克岛 google.com.nf 英语
    新西兰 google.co.nz 英语
    所罗门群岛 google.com.sb Pidgin
    斐济 google.com.fj 印地语
    密克罗尼西亚 google.fm 英语
    基里巴斯 google.ki 吉尔伯特语
    瑙鲁 google.nr 瑙鲁语
    托克劳 google.tk 英语
    萨摩亚 google.ws 英语
    东萨摩亚 google.as 萨摩亚语
    汤加 google.to 英语
    纽埃 google.nu 纽埃语
    库克群岛 google.co.ck 毛利语 法语
    多米尼加 google.com.do 西班牙语
    特立尼达和多巴哥google.tt
    哥伦比亚 google.com.co 西班牙语
    厄瓜多尔 google.com.ec 西班牙语
    委内瑞拉 google.co.ve 西班牙语
    圭亚那 google.gy 英语
    秘鲁 google.com.pe 西班牙语
    玻利维亚 google.com.bo 西班牙语
    巴拉圭 google.com.py 西班牙语
    巴西 google.com.br 葡萄牙语
    乌拉圭 google.com.uy 西班牙语
    阿根廷 google.com.ar 西班牙语
    智利 google.cl 西班牙语

美洲：

    格陵兰 google.gl 格陵兰语
    美国 google.com 英语
    墨西哥 google.com.mx 西班牙语
    危地马拉 google.com.gt 西班牙语
    伯利兹 google.com.bz 英语
    萨尔瓦多 google.com.sv 西班牙语
    洪都拉斯 google.hn 西班牙语
    尼加拉瓜 google.com.ni 西班牙语
    哥斯达黎加 google.co.cr 西班牙语
    巴拿马 google.com.pa 西班牙语
    巴哈马 google.bs 英语
    古巴 google.com.cu 西班牙语
    牙买加 google.com.jm 英语
    海地 google.ht

### Safari

特别的，针对于 Mac 用户以及 Safari 蛋疼的尿性——没办法自定义搜索引擎，可以通过插件[『Clean Links for Google』][2]达到不再重定向、直达.com的作用。

当然，要使得这个插件生效，你同样需要先访问 <google.com/ncr> 。再接下来地址栏搜索，就会直达 .com 网站啦。

# 参考资料

* [谷歌（google)世界各国网址大全](https://www.douban.com/note/202069625/)

[1]: http://www.leiphone.com/news/201412/Hnux7n19OcNWwUFt.html
[2]: https://safari-extensions.apple.com/details/?id=com.umetzu.disablegoogleredirect-NP536EQGR6