---
layout: post
title: 数据获取
category: software
tags: data
---
![](https://cdn.kelu.org/blog/tags/data.jpg)



转载自[有哪些「神奇」的数据获取方式？ - 知乎](https://www.zhihu.com/question/32164316)

大数据时代，用数据做出理性分析显然更为有力。做数据分析前，能够找到合适的的数据源是一件非常重要的事情，获取数据的方式有很多种，不必局限。下面将从公开的数据集、爬虫、数据采集工具、付费API等等介绍。给大家推荐一些能够用得上的数据获取方式，后续也会不断补充、更新。

## **一、公开数据库**

**1. 常用数据公开网站**

[UCI](https://link.zhihu.com/?target=http%3A//archive.ics.uci.edu/ml/datasets.html)：经典的机器学习、数据挖掘数据集，包含分类、聚类、回归等问题下的多个数据集。很经典也比较古老，但依然活跃在科研学者的视线中。

[国家数据](https://link.zhihu.com/?target=http%3A//data.stats.gov.cn/index.htm)：数据来源中华人民共和国国家统计局，包含了我国经济民生等多个方面的数据，并且在月度、季度、年度都有覆盖，全面又权威。

[CEIC](https://link.zhihu.com/?target=http%3A//www.ceicdata.com/zh-hans)：最完整的一套超过128个国家的经济数据，能够精确查找GDP、CPI、进口、出口、外资直接投资、零售、销售以及国际利率等深度数据。其中的“中国经济数据库”收编了300,000多条时间序列数据，数据内容涵盖宏观经济数据、行业经济数据和地区经济数据.

[万得](https://link.zhihu.com/?target=http%3A//www.wind.com.cn/)：简要介绍：被誉为中国的Bloomberg，在金融业有着全面的数据覆盖，金融数据的类目更新非常快，据说很受国内的商业分析者和投资人的亲睐。

[搜数网](https://link.zhihu.com/?target=http%3A//www.soshoo.com/index.do)：已加载到搜数网站的统计资料达到7,874本,涵盖1,761,009张统计表格和364,580,479个统计数据，汇集了中国资讯行自92年以来收集的所有统计和调查数据，并提供多样化的搜索功能。

[中国统计信息网](https://link.zhihu.com/?target=http%3A//www.tjcn.org/)：国家统计局的官方网站，汇集了海量的全国各级政府各年度的国民经济和社会发展统计信息，建立了以统计公报为主，统计年鉴、阶段发展数据、统计分析、经济新闻、主要统计指标排行等。

[亚马逊](https://link.zhihu.com/?target=http%3A//aws.amazon.com/cn/datasets/%3Fnc1%3Dh_ls)：来自亚马逊的跨科学云数据平台，包含化学、生物、经济等多个领域的数据集。

[figshare](https://link.zhihu.com/?target=https%3A//figshare.com/)：研究成果共享平台，在这里可以找到来自世界的大牛们的研究成果分享，获取其中的研究数据。

[github](https://link.zhihu.com/?target=https%3A//figshare.com/)：一个非常全面的数据获取渠道，包含各个细分领域的数据库资源，自然科学和社会科学的覆盖都很全面，适合做研究和数据分析的人员。



**2. 政府开放数据**

[北京市政务数据资源网](https://link.zhihu.com/?target=http%3A//www.bjdata.gov.cn/index.htm)：包含竞技、交通、医疗、天气等数据。

[深圳市政府数据开放平台](https://link.zhihu.com/?target=http%3A//opendata.sz.gov.cn/)：交通、文娱、就业、基础设施等数据。

[上海市政务数据服务网](https://link.zhihu.com/?target=http%3A//www.datashanghai.gov.cn/)：覆盖经济建设、文化科技、信用服务、交通出行等12个重点领域数据。

[贵州省政府数据开放平台](https://link.zhihu.com/?target=http%3A//www.gzdata.gov.cn/)：贵州省在政务数据开放方面做的确实不错。

[Data.gov](https://link.zhihu.com/?target=https%3A//www.data.gov/)：美国政府开放数据，包含气候、教育、能源金融等各领域数据。

**3. 数据竞赛网站**

竞赛的数据集通常干净且科研究性非常高。

[DataCastle](https://link.zhihu.com/?target=http%3A//www.pkbigdata.com/common/cmptIndex.html)：专业的数据科学竞赛平台。

[Kaggle](https://link.zhihu.com/?target=https%3A//www.kaggle.com/)：全球最大的数据竞赛平台。

[天池](https://link.zhihu.com/?target=https%3A//tianchi.aliyun.com/)：阿里旗下数据科学竞赛平台。

[Datafountain](https://link.zhihu.com/?target=http%3A//www.datafountain.cn/%23/)：CCF制定大数据竞赛平台。



## **二、利用爬虫可以获得有价值数据**

这里给出了一些网站平台，我们可以使用爬虫爬取网站上的数据，某些网站上也给出获取数据的API接口，但需要付费。



**1.财经数据**

（1）[新浪财经](https://link.zhihu.com/?target=http%3A//www.cnblogs.com/seacryfly/articles/stock.html)：免费提供接口，这篇博客教授了如何在新浪财经上获取获取历史和实时股票数据。

（2）[东方财富网](https://link.zhihu.com/?target=http%3A//data.eastmoney.com/xuangu/%23Yz1beWxubDAxKDF8MC4wNSld)：可以查看财务指标或者根据财务指标选股。

（3）[中财网](https://link.zhihu.com/?target=http%3A//data.cfi.cn/cfidata.aspx)：提供各类财经数据。

（4）[黄金头条](https://link.zhihu.com/?target=https%3A//goldtoutiao.com/)：各种财经资讯。

（5）[StockQ](https://link.zhihu.com/?target=http%3A//stockq.cn/)：国际股市指数行情。

（6）[Quandl](https://link.zhihu.com/?target=https%3A//www.quandl.com/)：金融数据界的维基百科。

（7）[Investing](https://link.zhihu.com/?target=https%3A//www.investing.com/)：投资数据。

（8）[整合的96个股票API合集](https://link.zhihu.com/?target=https%3A//www.programmableweb.com/news/96-stocks-apis-bloomberg-nasdaq-and-etrade/2013/05/22)。

（9）[Market Data Feed and API](https://link.zhihu.com/?target=http%3A//www.xignite.com/)：提供大量数据，付费，有试用期。



**2.网贷数据**

（1）[网贷之家](https://link.zhihu.com/?target=http%3A//shuju.wdzj.com/)：包含各大网贷平台不同时间段的放贷数据。

（2）[零壹数据](https://link.zhihu.com/?target=http%3A//data.01caijing.com/p2p/report/index.html)：各大平台的放贷数据。

（4）[网贷天眼](https://link.zhihu.com/?target=http%3A//www.p2peye.com/shuju/)：网贷平台、行业数据。

（5）[76676互联网金融门户](https://link.zhihu.com/?target=http%3A//www.76676.com/html/product/listhome/)：网贷、P2P、理财等互金数据。



**3.公司年报**

（1）[巨潮资讯](https://link.zhihu.com/?target=http%3A//www.cninfo.com.cn/cninfo-new/index)：各种股市咨询，公司股票、财务信息。

（2）[SEC.gov](https://link.zhihu.com/?target=https%3A//www.sec.gov/page/tmsectionlanding)：美国证券交易数据

（3）[HKEx news披露易](https://link.zhihu.com/?target=http%3A//www.hkexnews.hk/listedco/listconews/advancedsearch/search_active_main_c.aspx)：年度业绩报告和年报。



**4.创投数据**

（1）[36氪](https://link.zhihu.com/?target=http%3A//36kr.com/)：最新的投资资讯。

（2）[投资潮](https://link.zhihu.com/?target=http%3A//www.investide.cn/)：投资资讯、上市公司信息。

（3）[IT桔子](https://link.zhihu.com/?target=https%3A//www.itjuzi.com/investevents/)：各种创投数据。



**5.社交平台**

（1）[新浪微博](https://link.zhihu.com/?target=http%3A//weibo.com/)：评论、舆情数据，社交关系数据。

（2）[Twitter](https://link.zhihu.com/?target=http%3A//www.twitter.com/)：舆情数据，社交关系数据。

（3）[知乎](https://www.zhihu.com/)：优质问答、用户数据。

（4）[微信公众号](https://link.zhihu.com/?target=http%3A//weixin.qq.com/)：公众号运营数据。

（5）[百度贴吧](https://link.zhihu.com/?target=https%3A//tieba.baidu.com/index.html)：舆情数据

（6）[Tumblr](https://link.zhihu.com/?target=http%3A//mashable.com/category/tumblr/)：各种福利图片、视频。



**6.就业招聘**

（1）[拉勾](https://link.zhihu.com/?target=https%3A//www.lagou.com/)：互联网行业人才需求数据。

（2）[中华英才网](https://link.zhihu.com/?target=http%3A//campus.chinahr.com/)：招聘信息数据。

（3）[智联招聘](https://link.zhihu.com/?target=http%3A//ts.zhaopin.com/jump/index_new.html%3Fsid%3D121113803%26site%3Dpzzhubiaoti1)：招聘信息数据。

（4）[猎聘网](https://link.zhihu.com/?target=https%3A//www.liepin.com/%3Fmscid%3Ds_00_pz1)：高端职位招聘数据。



**7.餐饮食品**

（1）[美团外卖](https://link.zhihu.com/?target=http%3A//waimai.meituan.com/)：区域商家、销量、评论数据。

（2）[百度外卖](https://link.zhihu.com/?target=http%3A//waimai.baidu.com/waimai%3Fqt%3Dfind)：区域商家、销量、评论数据。

（3）[饿了么](https://link.zhihu.com/?target=https%3A//www.ele.me/home/)：区域商家、销量、评论数据。

（4）[大众点评](https://link.zhihu.com/?target=https%3A//www.dianping.com/)：点评、舆情数据。



**8.交通旅游**

（1）[12306](https://link.zhihu.com/?target=http%3A//www.12306.cn/mormhweb/)：铁路运行数据。

（2）[携程](https://link.zhihu.com/?target=http%3A//www.ctrip.com/)：景点、路线、机票、酒店等数据。

（3）[去哪儿](https://link.zhihu.com/?target=https%3A//www.qunar.com/)：景点、路线、机票、酒店等数据。

（4）[途牛](https://link.zhihu.com/?target=http%3A//www.tuniu.com/)：景点、路线、机票、酒店等数据。

（5）[猫途鹰](https://link.zhihu.com/?target=https%3A//www.tripadvisor.cn/)：世界各地旅游景点数据，来自全球旅行者的真实点评。

类似的还有同程、驴妈妈、途家等



**9.电商平台**

（1）[亚马逊](https://link.zhihu.com/?target=https%3A//www.amazon.cn/)：商品、销量、折扣、点评等数据

（2）[淘宝](https://link.zhihu.com/?target=https%3A//www.taobao.com/)：商品、销量、折扣、点评等数据

（3）[天猫](https://link.zhihu.com/?target=https%3A//www.tmall.com/)：商品、销量、折扣、点评等数据

（4）[京东](https://link.zhihu.com/?target=https%3A//www.jd.com/)：3C产品为主的商品信息、销量、折扣、点评等数据

（5）[当当](https://link.zhihu.com/?target=http%3A//www.dangdang.com/)：图书信息、销量、点评数据。

类似的唯品会、聚美优品、1号店等。



**10.影音数据**

（1）[豆瓣电影](https://link.zhihu.com/?target=https%3A//movie.douban.com/)：国内最受欢迎的电影信息、评分、评论数据。

（2）[时光网](https://link.zhihu.com/?target=http%3A//www.mtime.com/)：最全的影视资料库，评分、影评数据。

（3）[猫眼电影专业版](https://link.zhihu.com/?target=https%3A//piaofang.maoyan.com/dashboard)：实时票房数据，电影票房排行。

（4）[网易云音乐](https://link.zhihu.com/?target=http%3A//music.163.com/)：音乐歌单、歌手信息、音乐评论数据。



**11.房屋信息**

（1）[58同城房产](https://link.zhihu.com/?target=http%3A//cd.58.com/house.shtml%3Ffrom%3Dpc_topbar_link_house)：二手房数据。

（2）[安居客](https://link.zhihu.com/?target=https%3A//chengdu.anjuke.com/%3Fpi%3DPZ-baidu-pc-all-biaoti)：新房和二手房数据。

（3）[Q房网](https://link.zhihu.com/?target=http%3A//qfang.com/)：新房信息、销售数据。

（4）[房天下](https://link.zhihu.com/?target=http%3A//www1.fang.com/)：新房、二手房、租房数据。

（5）[小猪短租](https://link.zhihu.com/?target=http%3A//www.xiaozhu.com/)：短租房源数据。



**12.购车租车**

（1）[网易汽车](https://link.zhihu.com/?target=http%3A//auto.163.com/)：汽车资讯、汽车数据。

（2）[人人车](https://link.zhihu.com/?target=https%3A//www.renrenche.com/)：二手车信息、交易数据。

（3）[中国汽车工业协会](https://link.zhihu.com/?target=http%3A//www.caam.org.cn/data/)：汽车制造商产量、销量数据。



**13.新媒体数据**

[新榜](https://link.zhihu.com/?target=http%3A//www.newrank.cn/)：新媒体平台运营数据。

[清博大数据](https://link.zhihu.com/?target=http%3A//www.gsdata.cn/)：微信公众号运营榜单及舆情数据。

[微问数据](https://link.zhihu.com/?target=http%3A//wewen.io/)：一个针对微信的数据网站。

[知微传播分析](https://link.zhihu.com/?target=http%3A//www.weiboreach.com/)：微博传播数据。



**14.分类信息**

（1）[58同城](https://link.zhihu.com/?target=http%3A//cd.58.com/)：丰富的同城分类信息。

（2）[赶集网](https://link.zhihu.com/?target=http%3A//cd.ganji.com/)：丰富的同城分类信息。



## **三、数据交易平台**

由于现在数据的需求很大，也催生了很多做数据交易的平台，当然，出去付费购买的数据，在这些平台，也有很多免费的数据可以获取。

[优易数据](https://link.zhihu.com/?target=http%3A//www.youedata.com/)：由国家信息中心发起，拥有国家级信息资源的数据平台，国内领先的数据交易平台。平台有B2B、B2C两种交易模式，包含政务、社会、社交、教育、消费、交通、能源、金融、健康等多个领域的数据资源。![img](https://cdn.kelu.org/blog/2018/02/v2-a13995e80f6781a528df908cae5ebc91_hd.jpg)

[数据堂](https://link.zhihu.com/?target=http%3A//www.datatang.com/)：专注于互联网综合数据交易，提供数据交易、处理和数据API服务，包含语音识别、医疗健康、交通地理、电子商务、社交网络、图像识别等方面的数据。![img](https://cdn.kelu.org/blog/2018/02/v2-58e77fdfb728952372b9d03348812dd5_hd.jpg)

## **四、网络指数**

[百度指数](https://link.zhihu.com/?target=http%3A//index.baidu.com/)：指数查询平台，可以根据指数的变化查看某个主题在各个时间段受关注的情况，进行趋势分析、舆情预测有很好的指导作用。除了关注趋势之外，还有需求分析、人群画像等精准分析的工具，对于市场调研来说具有很好的参考意义。同样的另外两个搜索引擎搜狗、360也有类似的产品，都可以作为参考![img](https://cdn.kelu.org/blog/2018/02/v2-0881fb08a82b4ba8e69f422dd2f2548d_hd.jpg)

[阿里指数](https://link.zhihu.com/?target=https%3A//alizs.taobao.com/)：国内权威的商品交易分析工具，可以按地域、按行业查看商品搜索和交易数据，基于淘宝、天猫和1688平台的交易数据基本能够看出国内商品交易的概况，对于趋势分析、行业观察意义不小![img](https://cdn.kelu.org/blog/2018/02/v2-d86915bcb4eb3ed0e61f91a1d0db9548_hd.jpg)

[友盟指数](https://link.zhihu.com/?target=http%3A//www.umeng.com/)：友盟在移动互联网应用数据统计和分析具有较为全面的统计和分析，对于研究移动端产品、做市场调研、用户行为分析很有帮助。除了友盟指数，友盟的互联网报告同样是了解互联网趋势的优秀读物。![img](https://cdn.kelu.org/blog/2018/02/v2-3be656118816d546e60dc025450e994a_hd.jpg)

[爱奇艺指数](https://link.zhihu.com/?target=http%3A//index.iqiyi.com/)：爱奇艺指数是专门针对视频的播放行为、趋势的分析平台，对于互联网视频的播放有着全面的统计和分析，涉及到播放趋势、播放设备、用户画像、地域分布、等多个方面。由于爱奇艺庞大的用户基数，该指数基本可以说明实际情况。![img](https://cdn.kelu.org/blog/2018/02/v2-daad7b0de8e388666b3178ea5fdfadeb_hd.jpg)

[微指数](https://link.zhihu.com/?target=http%3A//data.weibo.com/index)：微指数是新浪微博的数据分析工具，微指数通过关键词的热议度，以及行业/类别的平均影响力，来反映微博舆情或账号的发展走势。分为热词指数和影响力指数两大模块，此外，还可以查看热议人群及各类账号的地域分布情况。![img](https://pic2.zhimg.com/80/v2-9c31099217326fe1d8a2e8d50cf242aa_hd.jpg)

除了以上指数外，还有[谷歌趋势](https://link.zhihu.com/?target=http%3A//www.google.com/trends/explore%23cmpt%3Dq%26tz%3DEtc%252FGMT-8)、[搜狗指数](https://link.zhihu.com/?target=http%3A//zhishu.sogou.com/)、[360趋势](https://link.zhihu.com/?target=https%3A//trends.so.com/%3Fsrc%3Dindex.haosou.com%23index)、[艾漫指数](https://link.zhihu.com/?target=http%3A//www.imzs.com/%23/home)等等。



## 五、网络采集器

网络采集器是通过软件的形式实现简单快捷地采集网络上分散的内容，具有很好的内容收集作用，而且不需要技术成本，被很多用户作为初级的采集工具。

[造数](https://link.zhihu.com/?target=http%3A//www.zaoshu.io/)：新一代智能云爬虫。爬虫工具中最快的，比其他同类产品快9倍。拥有千万IP，可以轻松发起无数请求，数据保存在云端，安全方便、简单快捷![img](https://cdn.kelu.org/blog/2018/02/v2-20aeb402d1356c57b2150658b8185bd4_hd.jpg)

[火车采集器](https://link.zhihu.com/?target=http%3A//www.locoy.com/)：一款专业的互联网数据抓取、处理、分析，挖掘软件，可以灵活迅速地抓取网页上散乱分布的数据信息。

[八爪鱼](https://link.zhihu.com/?target=http%3A//www.bazhuayu.com/)：简单实用的采集器，功能齐全，操作简单，不用写规则。特有的云采集，关机也可以在云服务器上运行采集任务。



# 答案二



<a class="UserLink-link" data-za-detail-view-element_name="User" target="_blank" href="//www.zhihu.com/people/Da-Hua-PPT">Robin王</a>

一、移动端数据

l 微信数据（营销老是要分析一些KOL和自媒体）

1.  [排名列表_日榜](https://link.zhihu.com/?target=http%3A//www.newrank.cn/public/info/list.html%3Fperiod%3Dday%26type%3Ddata%23%23%23)


2.  [新媒体指数](https://link.zhihu.com/?target=http%3A//www.gsdata.cn/index.php/rank/detail%3Fgid%3D0)


3.  [微问数据_微信公众号分析](https://link.zhihu.com/?target=http%3A//wewen.io/)


4. [ 微榜 爱微帮新媒体榜 Beta](https://link.zhihu.com/?target=http%3A//top.aiweibang.com/)
5.  [simplyKOL微信数据](https://link.zhihu.com/?target=http%3A//kol.simplybrand.com/KOLSec/Page/index.html)


6. [微指数_微信大数据领导者_微信文章_微信营销_微信公众账号大全_微信排行榜](https://link.zhihu.com/?target=http%3A//www.weizhishu.com/monitor/account)

7. [微信公众平台导航_微信公众账号大全](https://link.zhihu.com/?target=http%3A//wosao.cn/)

8. [可查90数据-易赞](https://link.zhihu.com/?target=http%3A//www.yeezan.com/web/public/search) （部分数据配合数据透视，有更多惊喜）

l 微博数据（宝强过后微博又开始红了一段时间）

1. [知微传播分析-WeiboReach](https://link.zhihu.com/?target=http%3A//www.weiboreach.com/)


2. [微博认证-名人堂](https://link.zhihu.com/?target=http%3A//verified.weibo.com/%3Fo%3D1)


3. [发现－热门微博](https://link.zhihu.com/?target=http%3A//d.weibo.com/%3Ffrom%3Dsignin)

4. [微风云_微博风云榜](https://link.zhihu.com/?target=http%3A//www.tfengyun.com/)

1. [数据首页-微博数据中心-新浪微博](https://link.zhihu.com/?target=http%3A//data.weibo.com/datacenter/recommendapp)

l APP数据（帮几家金融机构的APP，做过推广和优化，所以收藏了一些网站）

1. [热门苹果应用搜索](https://link.zhihu.com/?target=http%3A//www.asou.com/AsouHot/index) 只查IOS


2. [App Annie App Store Stats iOS热门 App 排行榜 中国 - 所有类别](https://link.zhihu.com/?target=https%3A//www.appannie.com/apps/ios/top/china/overall/%3Fdevice%3Diphone) 只查IOS


3. [应用雷达-iOS深度移动推广运营服务平台 苹果APP排名搜索优化统计分析](https://link.zhihu.com/?target=http%3A//www.ann9.com/) 只查IOS


4. [友盟指数 - 最专业的移动互联网行业发展趋势指数](https://link.zhihu.com/?target=http%3A//www.umindex.com/devices/ios_provinces)


1. [首页-应用排名分析平台-爱盈利](https://link.zhihu.com/?target=http%3A//rank.aiyingli.com/index.php/home/index/index.html)


6. [ASO100 - 中国最专业的 App Store 排名、ASO 数据平台](https://link.zhihu.com/?target=http%3A//aso100.com/index.php)


7. [App竞品大数据平台_App运营、ASO优化必上APPDUU](https://link.zhihu.com/?target=http%3A//www.appduu.com/)


8. [APP宏观数据—友盟指数 - 最专业的移动互联网行业发展趋势指数](https://link.zhihu.com/?target=http%3A//www.umindex.com/%3Fspm%3D0.0.0.0.RuO8Ft)


9. [应用排名分析平台-爱盈利](https://link.zhihu.com/?target=http%3A//rank.aiyingli.com/index.php/home/index/index.html)


10. [APP排名查询-易观千帆](https://link.zhihu.com/?target=http%3A//qianfan.analysys.cn/view/app/detail.html%3FappIds%3D2022613%26categoryIds%3D1191160)（数据比较详细，可惜只能免费查三天）


11. [安卓&IOS APP数据-酷传 - 添加应用](https://link.zhihu.com/?target=http%3A//jk.coolchuan.com/add%3Fsource%3Djk_index) 安卓和IOS都可以查

二、网站权重和数据（网站SEO和SEM不太懂，但是有一家很牛的供应商，主要做中间商，整理方案）营销的时候，SEO和舆情更配

1. [Alexa网站排名查询](https://link.zhihu.com/?target=http%3A//www.alexa.cn/)


2. [中国站长站](https://link.zhihu.com/?target=http%3A//www.chinaz.com/)


3. [站长工具-百度权重排名查询-站长seo查询 - 爱站网](https://link.zhihu.com/?target=http%3A//www.aizhan.com/)


4. [网站排名_网站数据流量查询_中国网站排名_网络媒体精品推荐](https://link.zhihu.com/?target=http%3A//www.iwebchoice.com/)
5. [友情链接—友情链接查询 友情链接检查工具-站长帮手网](https://link.zhihu.com/?target=http%3A//check.links.cn/)
6. [PR真假—PR查询 PR真假查询 PR劫持检测-站长帮手网](https://link.zhihu.com/?target=http%3A//pr.links.cn/)

7. [友情链接交换—go9go友情链接平台--想链就链go9go](https://link.zhihu.com/?target=http%3A//www.go9go.cn/)

8. [行业网站排名_行业网站排行榜_行业网站大全 - 网站排行榜](https://link.zhihu.com/?target=http%3A//top.chinaz.com/hangye/)

三、综合指数（写传播结案和分析客户传播节奏的时候用）

1. [百度指数](https://link.zhihu.com/?target=http%3A//index.baidu.com/)

2. [搜狗指数](https://link.zhihu.com/?target=http%3A//zhishu.sogou.com/)

3. [Google 趋势](https://link.zhihu.com/?target=http%3A//www.google.cn/trends/%3Fhl%3Dzh-CN)

4. [好搜指数-搜索大数据分享平台](https://link.zhihu.com/?target=http%3A//index.haosou.com/%23index)

1. [微指数首页](https://link.zhihu.com/?target=http%3A//data.weibo.com/index%3Fsudaref%3Dwww.digitaling.com)

6. [热搜榜单首页--百度搜索风云榜](https://link.zhihu.com/?target=http%3A//top.baidu.com/category%3Fc%3D12%26fr%3Dtopbuzz_b396_c12)

7. [艾曼指数首页](https://link.zhihu.com/?target=http%3A//www.imzs.com/)


8. [淘宝指数 - 淘宝消费者数据研究平台](https://link.zhihu.com/?target=http%3A//shu.taobao.com/)（已经没有了，以前很好用）


9. [阿里指数 - 社会化大数据分析平台](https://link.zhihu.com/?target=https%3A//alizs.taobao.com/%3Fspm%3D0.0.0.0.yhqwuK)（必须要开过淘宝店的账号，更可气的是只能查询单一行业）


10. [阿里指数_最权威专业的行业价格、供应、采购趋势分析](https://link.zhihu.com/?target=http%3A//index.1688.com/)（这个就能完美解决上面的问题）

四、票房和电视收视率（额……为什么有这些网站，才不会告诉别人，是因为我喜欢看电影）

1. [中国票房](https://link.zhihu.com/?target=http%3A//www.cbooo.cn/)

2. [电视收视率—CSM](https://link.zhihu.com/?target=http%3A//www.csm.com.cn/)

3. [猫眼票房分析](https://link.zhihu.com/?target=http%3A//piaofang.maoyan.com/)

4. [精选预告片 - 预告片世界](https://link.zhihu.com/?target=http%3A//www.yugaopian.com/highlight)

五、视频指数（近期想切入视频IP市场的推广，也就是想想）

1. [搜库-专找视频](https://link.zhihu.com/?target=http%3A//www.soku.com/newtop/all.html)

2. [腾讯视频指数](https://link.zhihu.com/?target=http%3A//v.qq.com/datacenter/index.html)

3. [中国网络视频指数 – 网络视频收视数据分析平台](https://link.zhihu.com/?target=http%3A//index.youku.com/)

4. [优酷指数 - 中国第一视频网,提供视频播放,视频发布,视频搜索](https://link.zhihu.com/?target=http%3A//index.youku.com/rank_top/)

1. [搜狐视频指数中心 - 搜狐视频](https://link.zhihu.com/?target=http%3A//index.tv.sohu.com/)

6. [爱奇艺指数](https://link.zhihu.com/?target=http%3A//index.iqiyi.com/)

六、内容排行（这个网站偶尔看一下热点吧，用的比较少）

1. [网评排行-搜狐](https://link.zhihu.com/?target=http%3A//comment.news.sohu.com/djpm/)

一、经济数据

1. [人民银行](https://link.zhihu.com/?target=http%3A//www.pbc.gov.cn/)

2. [国家数据](https://link.zhihu.com/?target=http%3A//data.stats.gov.cn/)

3. [中国银行业监督管理委员会](https://link.zhihu.com/?target=http%3A//www.cbrc.gov.cn/index.html)

4. [中国统计信息网](https://link.zhihu.com/?target=http%3A//www.tjcn.org/)

1. [统计数据](https://link.zhihu.com/?target=http%3A//www.stats.gov.cn/tjsj/)

6. [中华人民共和国国家统计局 统计数据](https://link.zhihu.com/?target=http%3A//www.stats.gov.cn/tjsj/)

7. [专项统计数据-中国证券业协会](https://link.zhihu.com/?target=http%3A//www.sac.net.cn/hysj/zxtjsj/)

8. [居民消费价格指数（CPI） _ 数据中心 _ 东方财富网](https://link.zhihu.com/?target=http%3A//data.eastmoney.com/cjsj/cpi.html)

二、企业数据（有时候接到一些Brief，大部分客户不靠谱，可能会问候一下他企业背景）

1. [全国企业信用信息公示系统](https://link.zhihu.com/?target=http%3A//gsxt.saic.gov.cn/) (官方出品)

2. [企业信息—天眼查-最专业的企业工商信息查询](https://link.zhihu.com/?target=http%3A//www.tianyancha.com/)（这个比官方的好用）

3. [企业名录-企业黄页_必途网企业黄页大全](https://link.zhihu.com/?target=http%3A//china.b2b.cn/)

4. [企业信用查询_企业信用报告查询系统_注册信息查询网-信用视界](https://link.zhihu.com/?target=http%3A//www.x315.com/)

三、金融数据

l 网贷数据（去年P2P，不，是互联网金融很火的）

1. [金汇金融__平台指数_P2P网贷平台评级_网贷315](https://link.zhihu.com/?target=http%3A//www.wd315.cn/p/list-0-0-%25E9%2587%2591%25E6%25B1%2587%25E9%2587%2591%25E8%259E%258D-0-1.html)

2. [【p2p网贷平台排名】最新网贷平台排名_网络借贷平台排名_网络贷款平台排名-网贷之家](https://link.zhihu.com/?target=http%3A//shuju.wangdaizhijia.com/)

3. [平台报告-零壹数据](https://link.zhihu.com/?target=http%3A//data.01caijing.com/p2p/report/index.html)

4. [上海贷款_小额贷款_贷款公司_银行贷款 - 融360](https://link.zhihu.com/?target=http%3A//shanghai.rong360.com/)

1. [平台指数_P2P网贷平台评级_网贷315](https://link.zhihu.com/?target=http%3A//www.wd315.cn/p/index.html)

6. [新金网 - 最专业的互联网金融导航网站](https://link.zhihu.com/?target=http%3A//hlwjr.n.puji114.com/)

7. [P2P网贷平台数据排行对比_网贷平台数据_网贷天眼](https://link.zhihu.com/?target=http%3A//www.p2peye.com/platdata.html)

8. [p2p排行榜,网络理财排行榜,第三方p2p平台排行榜 - 76676-最大的投资理财产品点评平台](https://link.zhihu.com/?target=http%3A//www.76676.com/html/product/listhome/)

l 上市公司年报（竟然为了分析社媒趋势去看BAT的年报，表示看不懂呀）

1. [中国—巨潮资讯网](https://link.zhihu.com/?target=http%3A//www.cninfo.com.cn/cninfo-new/index)


2. [美国—SEC.gov Company Search Page](https://link.zhihu.com/?target=http%3A//www.sec.gov/edgar/searchedgar/companysearch.html)

3. [香港—:: HKEx :: HKExnews ::](https://link.zhihu.com/?target=http%3A//www.hkexnews.hk/listedco/listconews/advancedsearch/search_active_main_c.aspx)

l 信托（信托切入互联网金融相对较慢，今年刚开始接触的几个客户）

1. [研究报告 - 中国信托业协会](https://link.zhihu.com/?target=http%3A//www.xtxh.net/xtxh/reports/index.htm)

2. [中国互联网金融研究中心 中国互联网金融网 中国互联网金融联盟 中国电子商务研究中心](https://link.zhihu.com/?target=http%3A//www.100ec.cn/zt/jr/)

l 其他

1. [案例报告列表_融资案例_并购案例_行业案例_企业案例_数据_分析—投资潮](https://link.zhihu.com/?target=http%3A//www.investide.cn/db/case/index.do)


2. [融资数据—融资事件列表页 IT桔子](https://link.zhihu.com/?target=https%3A//www.itjuzi.com/investevents)


3. [研究院_ChinaVenture投资中国网](https://link.zhihu.com/?target=http%3A//www.chinaventure.com.cn/cmsmodel/report/study/count/list.shtml)


4. [百度财富-专业金融服务平台](https://link.zhihu.com/?target=http%3A//caifu.baidu.com/)
5. [世界银行-Data The World Bank](https://link.zhihu.com/?target=http%3A//data.worldbank.org/)

6. [全球股市指数](https://link.zhihu.com/?target=http%3A//stockq.cn/)

7. [股指期货数据](https://link.zhihu.com/?target=http%3A//www.cffex.com.cn/)

四、汽车数据（有一个汽车配件的客户，讲真，汽车客户真的比金融客户前期好搞，不过后期服务就呵呵了）

1. [数据中心 世界汽车统计 中国汽车工业协会](https://link.zhihu.com/?target=http%3A//www.caam.org.cn/data/)

五、建筑数据（我也不知道为什么有这个网站）

[中华人民共和国住房和城乡建设部 - 单位资质查询](https://link.zhihu.com/?target=http%3A//mohurd.gov.cn/wbdt/dwzzcx/index.html)

六、医疗数据

1. [世界卫生组织 规划和项目](https://link.zhihu.com/?target=http%3A//www.who.int/entity/zh/)

七、服装数据（才不会告诉你，我是学国际经济与贸易出身的，后来才做了互联网营销策划，其中有一万只羊驼在奔跑）

1. [中国皮革原材料指数](https://link.zhihu.com/?target=http%3A//www.chinaleather.org/Channels/ZhiShuFaBu/1735/default.shtml)

2. [海宁周价格指数](https://link.zhihu.com/?target=http%3A//www.chinaleather.org/Expand/Share/Page/NSCMoreList.aspx%3FNSCID%3D3925)

3. [中国柯桥纺织指数](https://link.zhihu.com/?target=http%3A//www.kqindex.gov.cn/zsfx.asp)

4. [大朗毛织价格指数](https://link.zhihu.com/?target=http%3A//index.dalang.gov.cn/home/index/index.html)

八、工业指数

1. [今日国际原油价格,原油价格走势图,原油价格指数-油价网](https://link.zhihu.com/?target=http%3A//youjia.chemcp.com/YuanYouJiaGe.asp)

2. [上海有色金属价格指数](https://link.zhihu.com/?target=http%3A//www.ishupai.com/d/56)

3. [水泥指数](https://link.zhihu.com/?target=http%3A//index.ccement.com/)

其他数据

1. [中国统计信息服务中心 口碑查询](https://link.zhihu.com/?target=http%3A//www.researchina.cn/)

2. [最具公信力的名人影响力指标 - 必应 影响力](https://link.zhihu.com/?target=http%3A//cn.bing.com/yxl)

3. [全部榜单--百度搜索风云榜](https://link.zhihu.com/?target=http%3A//top.baidu.com/boards%3Ffr%3Dtopbuzz_b1192)

4. [百度预测-大数据 知天下](https://link.zhihu.com/?target=http%3A//trends.baidu.com/)

l [原始数据-数据淘](https://link.zhihu.com/?target=http%3A//www.datataotao.com/search/list%3FpriceType%3D1%26count%3D10%26page%3D1)（这个网站听说可以买到原始数据，不过没有试过）



# 答案三

（1）、[数据分析报告,数据报告,数据圈论坛 ](https://link.zhihu.com/?target=http%3A//www.shujuquan.com.cn/forum.php%3Fgid%3D230)

不得不说这真是一个获取数据的好地方，

主要包含：国内宏观、区域数据、世界经济、价格数据、工业行业、区域数据、国内宏观、区域数据、世界经济、价格数据、工业行业、区域数据。

是否免费：否（花费论坛金币） 

![img](https://cdn.kelu.org/blog/2018/02/4955ae460b16f37995e3aebfbb0e943e_hd.jpg)

（2）、

海量数据免费下载

此网站数据就比较多涉及的方面也比较多了，合适各种行业各种朋友。

主要包括数据：语音识别、医疗健康、交通地理、电子商务、社交网络、图像识别、统计年鉴、研发数据等领域。

是否免费：否（论坛金币，部分免费，部分花费少量金币） 

![img](https://pic1.zhimg.com/80/ed865c83c8e3c6955fde21d0e4e0c722_hd.jpg)

（3）、

国云数据市场

主要包含数据：生活服务、教育、能源、建筑、交通运输、政府、金融、农业、医疗、卫生

是否免费：否（大部分免费，根据自己选择） 

![img](https://cdn.kelu.org/blog/2018/02/b652d4df6d1df97065ed47085b5f5628_hd.jpg)

（4）、

数据包下载列表

主要数据包括：社交网络、电子商务、企业名录、 金融数据、生活服务、科研数据、知识库

是否免费：否（不全免费，部分需要rmb） 

![img](https://cdn.kelu.org/blog/2018/02/3cea25d3c18b3c76ac9c248d59a3a860_hd.jpg)

（5）、

微盛投资：沪深市场5分钟数据 wdz格式 转 txt、通达信，大智慧dad，飞狐dad，钱龙，同花顺等

（此网站界面有点low，不截图解释请自行访问查看）

（6）、[国家地球系统科学数据共享平台全球变化研究出版数据直接下载](https://link.zhihu.com/?target=http%3A//www.geodata.cn/thematicView/) （有部分数据）
（7）、[中华人民共和国国家统计局>>统计数据](https://link.zhihu.com/?target=http%3A//www.stats.gov.cn/tjsj/)

听名字就知道是什么数据了吧，而且所有数据都是免费，当然这个网站还有彩蛋。在文末的友情链接里面有很多地方的数据以及国外各国的数据。所以不要简单的认为只有本网站那么点数据喔。网站最后的友情链接请仔细查看，不要说我没告诉你。 

![img](https://cdn.kelu.org/blog/2018/02/ea49634b49bcc8f791ce8bb8fe856db0_hd.jpg)

（8）、

分类: 地球物理相关资源

这一位博主的博客，maybe出于研究目的，他整理了一些 地球物理相关的资，如果有人需要研究这方面的东西可以这里去下载你想要的资源，当然全部是免费的资源了。 

![img](https://pic4.zhimg.com/80/a0458fbd11e9283449c95c5b6bba882d_hd.jpg)

（9）、

国家数据

同样包含了国家的各种数据，点进去你可能会发现新世界的大门，而且所有数据均是免费！果然党是不会骗你钱的，好好跟党混没错。

![img](https://cdn.kelu.org/blog/2018/02/5f2e0d36a87f2cd7879d6cb8c600b0a9_hd.jpg)

（10）、[产业数据_统计数据](https://link.zhihu.com/?target=http%3A//www.chyxx.com/data/)

数据主要包括：能源、电力、冶金、化工、机电、电子、汽车、物流、房产、建材、农林、安防、包装、环保、食品、烟酒、医药、保健品、IT、通信、数码、家电、家居、家具、文化、传媒、办公、文教、服务、金融、培训、旅游、服装、玩具、礼品、工艺品

是否免费：全部免费 

![img](https://cdn.kelu.org/blog/2018/02/2b4a9072d9f53f75982b0213d8062750_hd.jpg)

（11）、

百度数据开放平台

不喷不喷不喷！重要的事情说三次。这点数据还是有用的！ 

![img](https://cdn.kelu.org/blog/2018/02/2118ec4a13cdafd746da678cde3362dc_hd.jpg)





# 答案四

我不是搞经济学的，但是最近做实习，要找N多千奇百怪的data，其中有些变态的数据，找来找去都找不到。

但是在某个一霎那，你会突然发现某个report/paper 里刚好有我们想要的数据。就像这样：

![img](https://cdn.kelu.org/blog/2018/02/326b18fbac7ea95441b6e1bbf1340089_hd.jpg)

来源：

http://www.colliers.com/-/media/files/marketresearch/apac/china/northchina-research/bj-residential-q1-2015.pdf

但是然并卵... 你去email colliers 要data 他并不会理你啊。

这时候就轮到神器登场了，[Ankit Rohatgi](https://link.zhihu.com/?target=http%3A//arohatgi.info/) 开发的 [WebPlotDigitizer](https://link.zhihu.com/?target=http%3A//arohatgi.info/WebPlotDigitizer/app/)。

![img](https://cdn.kelu.org/blog/2018/02/66808e81165424b503610e016afdef54_hd.jpg)

上传我们想要的图片：

![img](https://cdn.kelu.org/blog/2018/02/155a0b61f4a570dc5149fa4f623e929d_hd.jpg)

描好坐标轴和点：

![img](https://cdn.kelu.org/blog/2018/02/a58da35de421b5bc7ffdc2c2f87bc2eb_hd.jpg)

![img](https://cdn.kelu.org/blog/2018/02/112aa9928566ba682dcc590f576034f5_hd.jpg)

导出数据，大功告成！

![img](https://cdn.kelu.org/blog/2018/02/45840273d538a19078e4399dd43916f7_hd.jpg)

当然还有其他的，比如

Welcome to DataThief

http://digitizer.sourceforge.net/

Digitize graphs and plots

或者你也可以自己写matlab code啥的识别

反正我是懒得下载软件/自己写code。

－－－－－－－－－

其他可以解锁的技能：

* NO1.使用 [WebPlotDigitizer](https://link.zhihu.com/?target=http%3A//arohatgi.info/WebPlotDigitizer/app/) 自动识别曲线。
* NO2.使用 [WebPlotDigitizer](https://link.zhihu.com/?target=http%3A//arohatgi.info/WebPlotDigitizer/app/) 处理数据后使用[Plotly](https://link.zhihu.com/?target=https%3A//plot.ly/external)直接画出曲线。
* NO3.使用 [WebPlotDigitizer](https://link.zhihu.com/?target=http%3A//arohatgi.info/WebPlotDigitizer/app/) 识别对数坐标轴



