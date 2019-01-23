各位走过路过不要错过，300块建立私有云了解一下，什么值得买生活家Flato和大家分享一下私有云的建立吧~

正文：

黑群晖已经组建一小段时间了，从有这个想法到落实一共用了几天的时间，没怎么看其他自建黑群晖的教程，恰好手头有不少冗余的硬件，东拼西凑就成了，除了买了个二手机箱以外一分钱没花。今天简单看了一下张大妈里自建私有云的文章，突然觉得我应该出来写这样一份报告，因为我用的硬件成本现在来看真的很低，当然不是教大家跟我一样不花钱，而是真正的花少钱办巧事。

## 前言

在正文开始之前，我想先磨叽两句，跟大家探讨两个哲学问题，第一个：**我们为什么要用私有云？**需要干货的老司机们可以直接跳过此段前言。

我觉得有意向自己组建黑群晖的朋友们各自都有不同的需求，但其中大多数人应该跟我一样，抛开价钱的问题，我需要一个设备，他能够具有什么功能呢，**1.私密且安全地存储我的个人文件**、照片、影像等，**2.脱机下载功能**（避免[游戏机](https://link.zhihu.com/?target=https%3A//www.smzdm.com/fenlei/youxiji/)耗电大户长时间开机下载），**3.本地播放功能**（透过DLNA连接家里的[智能设备](https://link.zhihu.com/?target=https%3A//www.smzdm.com/fenlei/chuandaishebei/)播放视频，并解决苹果设备观看下载视频时需要进行格式转换这种反人类要求），而这些个人基本需求，都是目前各类网盘无法解决的，因此，我想到了私有云。**P.S.群晖有很多更加强大的功能暂且不表，这里只谈到个人基本需求。**

有了这个想法之后，开始各种电商搜索私有云设备，不搜不知道，搜了之后内心真的是WTF？！

<img src="https://pic3.zhimg.com/v2-edf6242d2a11104f6c435ed0d19c0ac2_b.jpg" data-caption="" data-size="normal" data-rawwidth="600" data-rawheight="188" data-default-watermark-src="https://pic2.zhimg.com/v2-adefa9009d5d5541bc2992833a781659_b.jpg" class="origin_image zh-lightbox-thumb" width="600" data-original="https://pic3.zhimg.com/v2-edf6242d2a11104f6c435ed0d19c0ac2_r.jpg">![img](https://pic3.zhimg.com/80/v2-edf6242d2a11104f6c435ed0d19c0ac2_hd.jpg)

上几个卡片大家了解一下。 

<img src="https://pic4.zhimg.com/v2-9022de61a10382a35c6ccb6839670f67_b.jpg" data-caption="" data-size="normal" data-rawwidth="200" data-rawheight="200" data-default-watermark-src="https://pic1.zhimg.com/v2-d1867054a72d27ddf8520b54763f0db0_b.jpg" class="content_image" width="200">![img](https://pic4.zhimg.com/80/v2-9022de61a10382a35c6ccb6839670f67_hd.jpg)

**顺丰Synology/群晖 DS118 家用单盘位NAS 网络存储器 116升级**

<img src="https://pic4.zhimg.com/v2-e3201ea2f06ed69aaa82b1a37cec2aef_b.jpg" data-caption="" data-size="normal" data-rawwidth="200" data-rawheight="200" data-default-watermark-src="https://pic1.zhimg.com/v2-0c7430437b99e40e7080b9f9c2e1fc98_b.jpg" class="content_image" width="200">![img](https://pic4.zhimg.com/80/v2-e3201ea2f06ed69aaa82b1a37cec2aef_hd.jpg)

**群晖nas主机箱SynologyDS218J私人云家庭用网络存储器2盘位群辉**

<img src="https://pic3.zhimg.com/v2-e83510b0abd4d3204677a44afc2d780a_b.jpg" data-caption="" data-size="normal" data-rawwidth="200" data-rawheight="200" data-default-watermark-src="https://pic4.zhimg.com/v2-52c3703f51fe5aa4c75081ccec996297_b.jpg" class="content_image" width="200">![img](https://pic3.zhimg.com/80/v2-e83510b0abd4d3204677a44afc2d780a_hd.jpg)

**增票synology群晖DS918+网络存储器NAS服务器企业云四盘位**

单盘位尚且这个价格，这以后我的存储需求上升了换4盘位价格要上天？？？我只不过想要上面简简单单的三个功能要花这么多钱？？？而且这些货都仅仅只是一个NAS主机而已，不带硬盘啊！！

 由此引发了我的另一个哲学思考，我想能来到张大妈的同僚们都会跟我一样，那就是，**我要买的这个东西真的需要花这么多钱吗？**

当然不需要。

在我面对且接受了这个事实之后，冷静地了解了一下目前用户群体最大的群晖系统，然后，发现一个惊天的大秘密！群晖系统可以运行在X86平台上！这我岂不是上天了！

由此，诞生了这篇文章。**（本文不针对任何私有云硬件厂商，建议不差钱儿人士依旧支持专业的群晖平台等，毕竟他们为家用私有云行业做出了杰出的贡献，在技术研发层面的投入也值得消费者去消费，他们在提升我们百姓生活质量上面是功不可没的）**

## 正文

既然是X86架构，那么就说明我们现用的所有能运行瘟都死的电脑都可以安装黑群晖。能安装瘟都死的电脑的几个基本要素是什么呢？没错，**CPU,主板，内存，硬盘，机箱，电源**。咱们一个一个来买就可以了。在这里，买什么，怎么买，是要讲究方式方法的。容我娓娓道来。

## 1.CPU+主板

这里把CPU和主板放在一起，主要是因为这么干省钱，张大妈的贴子里我看到有人推荐J1900，这是一个4核CPU并集成[英特尔](https://link.zhihu.com/?target=http%3A//pinpai.smzdm.com/1699/)的显卡，马首富家最低有199元的。看到这里我笑了，因为我有一块闲置多年的农企产品E350啊！

简单介绍一下E350，AMD当年收购ATI后的APU产品，CPU与GPU二合一且集成在主板上，GPU是农企的HD6310支持硬件解码（为了方便理解暂表为GPU，其实是APU），CPU E-350双核1.6GHz，板载千兆网卡，2xDDR3内存插扣，2-6xSATA II接口（内网千兆[机械硬盘](https://link.zhihu.com/?target=https%3A//www.smzdm.com/fenlei/putongyingpan/)足够使用，根据不同品牌接口数目不同，我的是七彩虹6个接口），版型有ITX和MATX，整体功耗22W，比J1900多了仅仅7W，可以忽略了。

<img src="https://pic4.zhimg.com/v2-70e4b75c4e7e093cd99c02f4a017991b_b.jpg" data-caption="" data-size="normal" data-rawwidth="600" data-rawheight="959" data-default-watermark-src="https://pic2.zhimg.com/v2-923ba1cbdd4562fb4be58fd94d2608bd_b.jpg" class="origin_image zh-lightbox-thumb" width="600" data-original="https://pic4.zhimg.com/v2-70e4b75c4e7e093cd99c02f4a017991b_r.jpg">![img](https://pic4.zhimg.com/80/v2-70e4b75c4e7e093cd99c02f4a017991b_hd.jpg)

此处以铭瑄E350数据为例。

那么这块主板多少钱？悄悄地告诉你，咸鱼上面70包邮，而我，一分钱没有花。去吧！皮皮虾！

## 2.内存

E350主板拥有两个DDR3 1066/1333内存插槽，最开始我把游戏机上的4GB DDR3 1600给了它，但是使用一段时间之后我发现TMD内存占用量永远都是15%，不管我让它干什么都是15%，那我是不是给他1GB内存就够了！好吧，去亲戚家里拿了一条闲置的DDR3 1333 2G内存怼上了，而该条内存马首富家多少钱呢？55包邮！（已经够贵啦） 

**DDR3 1333 2G_**

## 3.机箱

关于机箱的选购，是我唯一花钱的地方，悄悄地告诉你，咸鱼60元买到的乔思伯C2，关于乔思伯这个牌子我要多说几句，有很多人叫它屌丝伯，不过无所谓，我们只考虑这一点，乔思伯的产品基本上可以说一分钱一分货，你买联立的产品，五分钱两分货（联立躺枪，举例子）。乔思伯马首富家里全新的价格是155包邮，155可以买到一个全铝的机箱实属不易，且做工又不差。如果你工作清闲，没事逛逛咸鱼，甚至可以几十块钱就拿下这个机箱，毕竟机箱是个壳子，一手二手都无所谓，不涉及到运行稳定性嘛。 

<img src="https://pic2.zhimg.com/v2-d0d680bf9a527a63036b3808ecb6128d_b.jpg" data-caption="" data-size="normal" data-rawwidth="200" data-rawheight="200" data-default-watermark-src="https://pic4.zhimg.com/v2-e4256dab55fd4450de5476404ea68df3_b.jpg" class="content_image" width="200">![img](https://pic2.zhimg.com/80/v2-d0d680bf9a527a63036b3808ecb6128d_hd.jpg)

**Jonsbo/乔思伯C2全铝电脑机箱 迷你mini MATX电脑机箱 台式小机**

乔思伯C2可以放下ITX版型的主板，我的七彩虹E350比较奇怪，不是ITX也不是MATX，吃错是17x20？厘米左右，简单来说就是比ITX长一点，宽度一样，跟这个机箱简直绝配，可丁可卯。除此之外有两大优点就是硬盘位在同类机箱里算多的，最多可以放4块硬盘（2x3.5,2x2.5），另外可以安装标准ATX电源，ATX电源便宜量又足啊！

<img src="https://pic1.zhimg.com/v2-97ebfcaee1190207ac254a70973f77ec_b.jpg" data-caption="" data-size="normal" data-rawwidth="600" data-rawheight="413" data-default-watermark-src="https://pic2.zhimg.com/v2-f95a16a28d409d276585a80e4e5091f5_b.jpg" class="origin_image zh-lightbox-thumb" width="600" data-original="https://pic1.zhimg.com/v2-97ebfcaee1190207ac254a70973f77ec_r.jpg">![img](https://pic1.zhimg.com/80/v2-97ebfcaee1190207ac254a70973f77ec_hd.jpg)

不喜欢看文字的可以看图片参数。（图片里也是字）

<img src="https://pic3.zhimg.com/v2-5321e66a517435817f330642285273fa_b.jpg" data-caption="" data-size="normal" data-rawwidth="600" data-rawheight="600" data-default-watermark-src="https://pic2.zhimg.com/v2-78b90d995b9f97d0587540bf175fa3ad_b.jpg" class="origin_image zh-lightbox-thumb" width="600" data-original="https://pic3.zhimg.com/v2-5321e66a517435817f330642285273fa_r.jpg">![img](https://pic3.zhimg.com/80/v2-5321e66a517435817f330642285273fa_hd.jpg)

<img src="https://pic1.zhimg.com/v2-e32cb72c5cfb68170e6cb918b6831230_b.jpg" data-caption="" data-size="normal" data-rawwidth="600" data-rawheight="800" data-default-watermark-src="https://pic4.zhimg.com/v2-9982cea6c7642ba44c845b92bf9229ab_b.jpg" class="origin_image zh-lightbox-thumb" width="600" data-original="https://pic1.zhimg.com/v2-e32cb72c5cfb68170e6cb918b6831230_r.jpg">![img](https://pic1.zhimg.com/80/v2-e32cb72c5cfb68170e6cb918b6831230_hd.jpg)

<img src="https://pic4.zhimg.com/v2-98ce8c0703631f2ab60d4bb5914c71df_b.jpg" data-caption="" data-size="normal" data-rawwidth="600" data-rawheight="450" data-default-watermark-src="https://pic4.zhimg.com/v2-92419e046691f7a5d36ffe76985c12cf_b.jpg" class="origin_image zh-lightbox-thumb" width="600" data-original="https://pic4.zhimg.com/v2-98ce8c0703631f2ab60d4bb5914c71df_r.jpg">![img](https://pic4.zhimg.com/80/v2-98ce8c0703631f2ab60d4bb5914c71df_hd.jpg)

上面是我的机箱布局，大家可以参考一下机箱的内部结构。

## 4.电源

电源还用废话吗？你我他他他他家里谁家没有旧电脑不要的？随便一个标准ATX电源就好了呀，你说没有，都扔了卖了送人了，那咋办，电脑城二手市场20块钱挑个干净板正的有的是啊，何必为了他买个80plus金牌电源呢？毕竟私有云它连点个亮儿都不需要啊 ，至于电源线……您家里有旧[电饭锅](https://link.zhihu.com/?target=https%3A//www.smzdm.com/fenlei/dianfan/)吗？通用……

## 5.价钱小结

是时候掏出我们祖传的计算器了，来跟我一起按，归、归归归零……

**CPU+主板（AMD E350 ITX小板）：70元**  加

**内存条（DDR3 1333 2GB）：55元**  加

**机箱（乔思伯 C2）：155元**  加

**电源（任意标准ATX电源）：20元**  等于

**300元**！！整

童叟无欺，300元内帮你打造保证性能又不失美观的NAS主机，看到价格我自己都害怕了 。至于硬盘，大家按照个人需求购买就好了，容量、品牌、型号就不推荐了，见仁见智嘛。

对于黑群晖的安装方法和教程大家上网随便一搜就有很多，不在这里赘述了，当然，还是建议大家尊重群晖的产权，群晖不制裁黑用户是对我们的尊重，而有能力的话去支持群晖是我们的本分，最后，感谢大家对本文的关注。

最后的最后，上面打了四个归之后，我已经不认识“归”这个字了。

BY：Flato

**本内容来源于@什么值得买http://SMZDM.COM**

**原文链接：**[最多300元，就能拥有一个美观高效的私有云！_生活记录_什么值得买](https://link.zhihu.com/?target=https%3A//post.smzdm.com/p/689648/)