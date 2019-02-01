---
layout: post
title: 数据可视化分类/表现形式 - YOYO做设计
category: design
---

> 转载自:<https://www.jianshu.com/p/f49ebcedc828>，做个记录备忘。

指标卡：直观展示具体数据和同环比情况；

![img](https://cdn.kelu.org/blog/2018/12/7044323-e1501edabcc671a5..jpg.jpg)

image

**计量图/仪表盘：直观显示数据完成的进度；**

![img](https://cdn.kelu.org/blog/2018/12/7044323-34190609b49590ac..jpg.jpg)

image

**折线图：看数据的变动走势；**

![img](https://cdn.kelu.org/blog/2018/12/7044323-f9c0328b7fbb8804..jpg.jpg)

image

**柱状图：直观展示对应的数据、可以对比多维度的数值；**

![img](https://cdn.kelu.org/blog/2018/12/7044323-94dd05b76d4ea37a..jpg.jpg)

image

![img](https://cdn.kelu.org/blog/2018/12/7044323-1aa4e2e33a2ec208..jpg.jpg)

image

**（堆积柱状图）**

**条形图：可以理解成横向的柱状图；**

![img](https://cdn.kelu.org/blog/2018/12/7044323-233639d0c4a638bf..jpg.jpg)

image

**双轴图：柱状图+折线图，这种图表大家都很经常用到；**

![img](https://cdn.kelu.org/blog/2018/12/7044323-1bb0145975866422..jpg.jpg)

image

![img](https://cdn.kelu.org/blog/2018/12/7044323-0af20f16322b4cc2..jpg.jpg)

image

**饼图/环图：分析数据所占比例；**

![img](https://cdn.kelu.org/blog/2018/12/7044323-9da1532fade113e7..jpg.jpg)

image

**行政地图：有省份或者城市数据即可；**

![img](https://cdn.kelu.org/blog/2018/12/7044323-c37134face789f7e..jpg.jpg)

image

**GIS地图：更精准的经纬度地图，需要有经纬度数据，可以精确到乡镇等小粒度的区域，参考链接：**[经纬度可视化地图](https://link.jianshu.com?t=https%3A%2F%2Flink.zhihu.com%2F%3Ftarget%3Dhttps%253A%2F%2Fme.bdp.cn%2Fshare%2Findex.html%253FshareId%253Dsdo_20d855c7156c15a1f32a3767f9c08e46.jpg)

![img](https://cdn.kelu.org/blog/2018/12/7044323-0c88fd1efa53783e..jpg.jpg)

image

![img](https://cdn.kelu.org/blog/2018/12/7044323-e5655075ca7cb5de..jpg.jpg)

image

**漏斗图：路径、数据转化情况；**

![img](https://cdn.kelu.org/blog/2018/12/7044323-25082f0b5953f73f..jpg.jpg)

image

**词云：即标签云，展示词频分布，率、；**

![img](https://cdn.kelu.org/blog/2018/12/7044323-886542e4393c0c20..jpg.jpg)

image

**矩形树图：分析不同维度数据的占比分布情**

![img](https://cdn.kelu.org/blog/2018/12/7044323-b21c46dcb3a0b583..jpg.jpg)

image

作者：小草莓
链接：[https://www.zhihu.com/question/26685414/answer/113122938](https://link.jianshu.com?t=https%3A%2F%2Fwww.zhihu.com%2Fquestion%2F26685414%2Fanswer%2F113122938.jpg)
来源：知乎著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

**旭日图：表达清晰的层级和归属关系**

旭日图（Sunburst Chart）是一种现代饼图，它超越传统的饼图和环图，能表达清晰的层级和归属关系，以父子层次结构来显示数据构成情况。旭日图中，离远点越近表示级别越高，相邻两层中，是内层包含外层的关系。

![img](https://cdn.kelu.org/blog/2018/12/7044323-a6a1454f12e1b1a1.jpg)

image.png

**平行坐标系**

在 ECharts 中平行坐标系（parallel）是一种常用的可视化高维数据的图表。平行坐标系的具有良好的数学基础， 其射影几何解释和对偶特性使它很适合用于可视化数据分析。

例如以下数据中，每一行是一个『数据项』，每一列属于一个『维度』。（例如上面数据每一列的含义分别是：『日期』,『AQI指数』, 『PM2.5』, 『PM10』, 『一氧化碳值』, 『二氧化氮值』, 『二氧化硫值』）。

平行坐标系适用于对这种多维数据进行可视化分析。每一个维度（每一列）对应一个坐标轴，每一个『数据项』是一条线，贯穿多个坐标轴。在坐标轴上，可以进行数据选取等操作。

![img](https://cdn.kelu.org/blog/2018/12/7044323-fbcbb7e4f53aa428.jpg)

image.png

**桑基图**
桑基图（series[i]-sankey），也称桑基能量平衡图，具有特殊类型的流程图，它主要用来表示原材料、能量等如何从初始形式经过中间过程的加工、转化到达最终形式。以下是使用桑基图的一个实例，您可以参考它。

![img](https://cdn.kelu.org/blog/2018/12/7044323-4f03b02328ab3dce.jpg)

ECharts桑基图

**漏斗图**
在 ECharts 系列中，漏斗图使用 series[i]-funnel 表示。漏斗图适用于业务流程比较规范、周期长、环节多的流程分析，通过漏斗各环节业务数据的比较，能够直观地发现和说明问题所在。

![img](https://cdn.kelu.org/blog/2018/12/7044323-e5c1f551bddeee11.jpg)

ECharts漏斗图

**象形柱图：PictorialBar**

![img](https://cdn.kelu.org/blog/2018/12/7044323-f19f7687f45de6b4.jpg)

image.png

B.技术的发展已导致数据的大爆炸。这反过来又促使数据展示方式的激增。一般来说，大多数据可视化分为2种不同的类型：探索型和解释型。勘探类型帮助人们发现数据背后的故事，而解析数据方便给人们看。

此外，有不同的方法可用于创建这2种类型。最常见的数据可视化方法包括：

- **2D区域**-此方法使用的地理空间数据可视化技术，往往涉及到事物特定表面上的位置。2D区域的数据可视化的例子包括点分布图，可以显示诸如在一定区域内犯罪情况。

![img](https://cdn.kelu.org/blog/2018/12/7044323-d00d3d475965730a.jpg)

image

- **时态**-时态可视化是数据以线性的方式展示。最为关键的是时态数据可视化有一个起点和一个终点。时态可视化的一个例子可以是连接的散点图，显示诸如某些区域的温度信息。

![img](https://cdn.kelu.org/blog/2018/12/7044323-003762c131f8c205.jpg)

image

- **多维**-可以通过使用常用的多维方法来展示目前2维或高维度的数据。多维可视化的一个例子可能是一个饼图，它可以显示诸如政府开支。

![img](https://cdn.kelu.org/blog/2018/12/7044323-936cc21c264e0086.jpg)

image

- **分层**-分层方法用于呈现多组数据。这些数据可视化通常展示的是大群体里面的小群体。分层数据可视化的例子包括一个树形图，可以显示语言组。

![img](https://cdn.kelu.org/blog/2018/12/7044323-5097f993a724651c.jpg)

image

- **网络**-在网络中展示数据间的关系,它是一种常见的展示大数据量的方法。

![img](https://cdn.kelu.org/blog/2018/12/7044323-ce58d9fe1f5e5239.jpg)