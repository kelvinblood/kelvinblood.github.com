---
layout: post
title: 在线评测系统 Online Judge
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/acm.jpg)

**在线评测系统**（英语：**Online Judge**，缩写**OJ**）是一种在[编程](https://zh.wikipedia.org/wiki/%E7%BC%96%E7%A8%8B)竞赛中用来测试参赛程序的在线系统，也可以用于平时练习。近年来（2016年或更早）亦出现一些针对求职面试的在线评测系统。许多OJ网站会自发组织一些竞赛。此外，OJ网站通常会设立用户排名，以用户的提交答案通过数多少或某个题目执行时间快慢为排名依据。



## 原理[[编辑](https://zh.wikipedia.org/w/index.php?title=%E5%9C%A8%E7%BA%BF%E8%AF%84%E6%B5%8B%E7%B3%BB%E7%BB%9F&action=edit&section=1)]

算法竞赛通常采取[黑盒测试](https://zh.wikipedia.org/wiki/%E9%BB%91%E7%9B%92%E6%B5%8B%E8%AF%95)，事先准备好一些测试数据，然后用它们来测试选手的程序[[2\]](https://zh.wikipedia.org/zh-hans/%E5%9C%A8%E7%BA%BF%E8%AF%84%E6%B5%8B%E7%B3%BB%E7%BB%9F#cite_note-lrj-2)。

在在线评测系统中，用户需要提交源代码至服务器，服务器会编译用户的源代码，然后执行源代码生成的[可执行文件](https://zh.wikipedia.org/wiki/%E5%8F%AF%E6%89%A7%E8%A1%8C%E6%96%87%E4%BB%B6)（或用解释方式执行，或直接执行脚本文件），得到其输出的结果，并与正确结果比较。[[3\]](https://zh.wikipedia.org/zh-hans/%E5%9C%A8%E7%BA%BF%E8%AF%84%E6%B5%8B%E7%B3%BB%E7%BB%9F#cite_note-aq-3)

为防止攻击和恶意提交，服务器必须采取一定的安全措施，例如对用户提交的源代码实施过滤、将进程放入[沙盒](https://zh.wikipedia.org/wiki/%E6%B2%99%E7%9B%92_(%E8%A8%88%E7%AE%97%E6%A9%9F%E5%AE%89%E5%85%A8))以进行隔离、对代码进行[哈希](https://zh.wikipedia.org/wiki/%E5%93%88%E5%B8%8C)以防止抄袭和重复提交等。[[3\]](https://zh.wikipedia.org/zh-hans/%E5%9C%A8%E7%BA%BF%E8%AF%84%E6%B5%8B%E7%B3%BB%E7%BB%9F#cite_note-aq-3)

### Virtual Judge[[编辑](https://zh.wikipedia.org/w/index.php?title=%E5%9C%A8%E7%BA%BF%E8%AF%84%E6%B5%8B%E7%B3%BB%E7%BB%9F&action=edit&section=2)]

Virtual Judge是一种特殊的在线评测系统。与其他在线评测系统不同的是，Virtual Judge系统本身并没有任何测试数据，而是通过在其他在线评测系统中注册的机器人账号进行测试并抓取测试结果。因此可以在只有题目而没有测试数据的前提下建立竞赛。[[4\]](https://zh.wikipedia.org/zh-hans/%E5%9C%A8%E7%BA%BF%E8%AF%84%E6%B5%8B%E7%B3%BB%E7%BB%9F#cite_note-4)[[5\]](https://zh.wikipedia.org/zh-hans/%E5%9C%A8%E7%BA%BF%E8%AF%84%E6%B5%8B%E7%B3%BB%E7%BB%9F#cite_note-5)

## 题目状态[[编辑](https://zh.wikipedia.org/w/index.php?title=%E5%9C%A8%E7%BA%BF%E8%AF%84%E6%B5%8B%E7%B3%BB%E7%BB%9F&action=edit&section=3)]

在提交程序之后，在线评测系统会根据题目的测评情况，返回评测结果。只有返回“Accepted”状态，才表示题目通过，选手才会获得成绩。不同OJ评测结果略有出入，但常见的评测结果大致分为以下三类。

### 正在评测[[编辑](https://zh.wikipedia.org/w/index.php?title=%E5%9C%A8%E7%BA%BF%E8%AF%84%E6%B5%8B%E7%B3%BB%E7%BB%9F&action=edit&section=4)]

- Pending：系统繁忙，用户程序正在排队等待。
- Pending Rejudge：因为数据更新或其他原因，系统将重新判你的答案.
- Compiling：正在编译。
- Running & Judging：正在运行并与标准数据进行比较。

### 程序未通过[[编辑](https://zh.wikipedia.org/w/index.php?title=%E5%9C%A8%E7%BA%BF%E8%AF%84%E6%B5%8B%E7%B3%BB%E7%BB%9F&action=edit&section=5)]

- Wrong Answer（简称WA）：答案错误。
- Runtime Error（简称RE）：运行时错误，程序崩溃。
- Compile Error（简称CE）：编译错误。
- Time Limit Exceeded（简称TLE）：运行超出时间限制。
- Memory Limit Exceeded（简称MLE）：超出内存限制。
- Output Limit Exceeded（简称OLE）：输出的长度超过限制。
- Presentation Error（简称PE）：答案正确，但是输出格式不符合题目要求。在一些要求比较严格的比赛中，格式错也会被视为答案错误[[2\]](https://zh.wikipedia.org/zh-hans/%E5%9C%A8%E7%BA%BF%E8%AF%84%E6%B5%8B%E7%B3%BB%E7%BB%9F#cite_note-lrj-2)。

### 程序通过[[编辑](https://zh.wikipedia.org/w/index.php?title=%E5%9C%A8%E7%BA%BF%E8%AF%84%E6%B5%8B%E7%B3%BB%E7%BB%9F&action=edit&section=6)]

在测试过程中，只有未发生以上几种错误的情况下才算做通过。

- Accepted（简称AC）：程序通过。另外，在整场比赛中通过了所有题目又俗称“AK”或是“破台”。

一些比赛的测试点可以给出“部分分”，例如答案正确但不够优，或者选手没有完全完成题目所给的任务等。[[2\]](https://zh.wikipedia.org/zh-hans/%E5%9C%A8%E7%BA%BF%E8%AF%84%E6%B5%8B%E7%B3%BB%E7%BB%9F#cite_note-lrj-2)

## 实例[[编辑](https://zh.wikipedia.org/w/index.php?title=%E5%9C%A8%E7%BA%BF%E8%AF%84%E6%B5%8B%E7%B3%BB%E7%BB%9F&action=edit&section=7)]

最早的在线评测系统是由西班牙Valladolid大学的Ciriaco García de Celis于1995年开发的，当时用于该校参加[ACM/ICPC](https://zh.wikipedia.org/wiki/ACM/ICPC)西南欧区域赛选拔队员。[[6\]](https://zh.wikipedia.org/zh-hans/%E5%9C%A8%E7%BA%BF%E8%AF%84%E6%B5%8B%E7%B3%BB%E7%BB%9F#cite_note-6)

现在较为著名的在线评测系统有西班牙的[UVaOJ](https://zh.wikipedia.org/wiki/UVa%E7%B7%9A%E4%B8%8A%E8%A7%A3%E9%A1%8C%E7%B3%BB%E7%B5%B1)、俄罗斯的SGU、Timus、[Codeforces](https://zh.wikipedia.org/wiki/Codeforces)、波兰的SPOJ、美国的[TopCoder](https://zh.wikipedia.org/wiki/TopCoder)、中国的POJ（[北京大学](https://zh.wikipedia.org/wiki/%E5%8C%97%E4%BA%AC%E5%A4%A7%E5%AD%A6)）、ZOJ（[浙江大学](https://zh.wikipedia.org/wiki/%E6%B5%99%E6%B1%9F%E5%A4%A7%E5%AD%A6)）、[HDOJ](http://acm.hdu.edu.cn/)（[杭州电子科技大学](https://zh.wikipedia.org/wiki/%E6%9D%AD%E5%B7%9E%E7%94%B5%E5%AD%90%E7%A7%91%E6%8A%80%E5%A4%A7%E5%AD%A6)）等。[[2\]](https://zh.wikipedia.org/zh-hans/%E5%9C%A8%E7%BA%BF%E8%AF%84%E6%B5%8B%E7%B3%BB%E7%BB%9F#cite_note-lrj-2)

不同群体中不同OJ使用的频率也不同，学生中常会因为教师的要求使用公开/校内OJ，为此，许多公开OJ也提供了个性化服务，如[Vijos](https://vijos.org/)中的“域”服务[[7\]](https://zh.wikipedia.org/zh-hans/%E5%9C%A8%E7%BA%BF%E8%AF%84%E6%B5%8B%E7%B3%BB%E7%BB%9F#cite_note-7)，[OpenJudge](http://openjudge.cn/)、[洛谷](https://www.luogu.org/)、[Vjudge](https://vjudge.net/)中的团队服务。

在特定群体中亦有一些流行的在线评测系统，例如中国初中选手中流行的[Vijos](https://vijos.org/)、进阶选手使用的[BZOJ](http://www.lydsy.com/JudgeOnline)（现称“耒阳大视野”）、[hihocoder](https://hihocoder.com/)、美国求职者中流行的[LeetCode](https://leetcode.com/)等。

## 参见[[编辑](https://zh.wikipedia.org/w/index.php?title=%E5%9C%A8%E7%BA%BF%E8%AF%84%E6%B5%8B%E7%B3%BB%E7%BB%9F&action=edit&section=8)]

- [ACM国际大学生程序设计竞赛](https://zh.wikipedia.org/wiki/ACM%E5%9B%BD%E9%99%85%E5%A4%A7%E5%AD%A6%E7%94%9F%E7%A8%8B%E5%BA%8F%E8%AE%BE%E8%AE%A1%E7%AB%9E%E8%B5%9B)
- [国际信息学奥林匹克](https://zh.wikipedia.org/wiki/%E5%9B%BD%E9%99%85%E4%BF%A1%E6%81%AF%E5%AD%A6%E5%A5%A5%E6%9E%97%E5%8C%B9%E5%85%8B)
- [TopCoder](https://zh.wikipedia.org/wiki/TopCoder)
- [Codeforces](https://zh.wikipedia.org/wiki/Codeforces)
- [UVa线上解题系统](https://zh.wikipedia.org/wiki/UVa%E7%B7%9A%E4%B8%8A%E8%A7%A3%E9%A1%8C%E7%B3%BB%E7%B5%B1)

下面是几个比较大的在线提交系统（Online Judge）

浙江大学 Online Judge（ZOJ）
[http://acm.zju.edu.cn](http://acm.zju.edu.cn/)
国内最早也是最有名气的OJ，有很多高手在上面做题。特点是数据比较刁钻，经常会有你想不到的边界数据，很能考验思维的全面性。

北京大学 Online Judge（POJ）
<http://acm.pku.edu.cn/JudgeOnline/>
建立较晚，但题目加得很快，现在题数和ZOJ不相上下，特点是举行在线比赛比较多，数据比ZOJ上的要弱，有时候同样的题同样的程序，在ZOJ上WA，在POJ上就能AC。

同济大学 Online Judge (TOJ) 
<http://acm.tongji.edu.cn/index.php>
这个OJ题数上不能与上两个相比，推荐这个OJ的原因是它是中文的，这对很多对英文不太感冒的兄弟是个好消息吧。它也因此吸引了众多高中的OIer，毕竟他们的英文还差一些呵呵，上面的题目也更偏向高中的信息学竞赛一些。

西班牙Valladolid大学 Online Judge（UVA）
<http://acm.uva.es/>
世界上最大最有名的OJ，题目巨多而且巨杂，数据也很刁钻，全世界的顶尖高手都在上面。据说如果你能在UVA上AC一千道题以上，就尽管向IBM、微软什么的发简历吧，绝对不会让你失望的。

俄罗斯Ural立大学 Online Judge（URAL）
<http://acm.timus.ru/>
也是一个老牌的OJ，题目不多，但题题经典，我在高中的时候就在这上面做题的。
俄罗斯萨拉托夫国立大学(Saratov State University)(SGU) 
<http://acm.sgu.ru/>
SGU 是俄罗斯萨拉托夫国立大学(Saratov State University)用于培养ACM选手的训练网站。这个网站的建成时期较晚，但随着比赛的举行以及新题目的加入，这个题库的题目也日渐丰富。这个题库的一大特点就是Online Judge功能强大，它不仅使你避开了多数据处理的繁琐操作，还能告诉你程序错在了第几个数据。这一点虽然与ACM的Judge有些出入，但是却方便了调试程序。与UVA相比，这里的题目 在时间空间上要求都比较严格，而且更多的考察选手对算法的掌握情况，所以特别推荐冲击NOI的选手也来做一做。

UsacoGate Online Judge（USACO） 
<http://ace.delos.com/usacogate>
全美计算机奥林匹克竞赛（USACO）的训练网站，特点是做完一关才能继续往下做,与前面的OJ不同的是测试数据可以看到，并且做对后可以看标准解答，所以如果大家刚开始的时候在上面那些OJ上总WA却找不到原因的话，可以试着来这里做做，看看测试数据一般是从什么地方阴你的。

<https://www.kancloud.cn/digest/programingdesign/199000>



LeetCode找工作的时候刷了几遍，最近开始刷Euler。 
已经有很多年工作经验的前辈们会不会觉得这样只是入门级别的程序员才干的事情，但是真心觉得很有意思有木有。代码越来越优化，方法越来越多，数据结构用的越来越顺手。以下是目前接触到的非常的有用的网站： 

我和身边的朋友找工作必刷的LeetCode： 
<http://oj.leetcode.com/> 

复杂数据结构的讲解及实现GeeksForGeeks： 
<http://www.geeksforgeeks.org/> 

面试前了解公司的背景及面试题： 
<http://www.glassdoor.com/> 

一个比较牛逼的coding challenge网站： 
<https://www.hackerrank.com/> 

国内的面试题总结，我在csdn发现的July的博客： 
<http://blog.csdn.net/v_JULY_v> 
他总结出的《程序员编程艺术》： 
<https://github.com/julycoding/The-Art-Of-Programming-By-July/blob/master/ebook/zh/Readme.md>

国内比较有名的可能是北大的oj： 
<http://poj.org/> 
其他的国内国外的OJ请自行查询维基百科。 

最近发现的一个比较有意思的论坛Hacker News： 
[https://news.ycombinator.com](https://news.ycombinator.com/) 

----------------------------------------------------------------------------------------------------------------------------
突然想起来一本神书，这本书是大家在北美找工作必看的，叫做<Cracking the Coding Interview>，网上可以直接下载到电子版，我在amazon上面买了第五版的，二十多刀，是除了《Operation Systems In Depth》之外我目前在这边买的最贵的书（屌丝伤不起）。有人据说在找工作前刷了5遍然后面遍天下无敌手。个人认为这里的都是基础入门级算法题，不过每章有一两道稍难一些的（和LeetCode难度差不多的），对语言运用的比较熟的可以很快就刷完了。不过很有成就感有木有，这么厚的一本书，不过光答案就大半本，全是代码。我觉得这本书可以用来复习基础知识，查漏补缺，操作系统计算机网络数据库之类的，我一般用它来复习面向对象程序设计。 

By the way,大家有没有设计过电梯（OO Design）？ 好多公司在面试的时候都这个问到这个，google，box，貌似没有人能给出一个比较满意的答案，我琢磨着这个应该是上班之后项目做得多了容易有想法，有大神愿意赐教吗？ 

lz最近想换工作，开始正经的刷题，一年多没有做新题了，前两天刚刚把这一年出的新题中的easy和medium都搞定，hard一道都做不出来，动态规划是个坎儿，感觉看了答案就知道，不看答案自己知道这个是动态规划，也做不出来，唉，真捉急 
--------------------------------------------------------------------------------------------------------------------分隔线-------------------- 

lz在练习了一个多月的算法之后（下班之后抽空~~~~(>_<)~~~~），上个星期申请了一个组，然后聊了一下就预约了面试，今天下午连着面了四个小时，面死我了，以前找工作的时候哪里这样啊，每个人顶多问两道题，现在是连着面了四轮，每个人一个小时，每个人都至少一个小时，做完一道题还要问另外一道题，问完了算法问设计，尼玛，我才工作了一年，至于吗，明天给消息，希望不要悲剧，lz已经在这个组干不下去了，太没意思了 



<https://www.douban.com/group/topic/52118283/>



编程几乎已经成为了人类所知每个行业的必要组成部分，如今有越来越多的人开始了他们的编程之旅。

![img](http://upload-images.jianshu.io/upload_images/6837325-decbf46209ec7b8c?imageMogr2/auto-orient/strip%7CimageView2/2/w/640/format/webp)

如果你正在在学习编程，那么我可以告诉你一个提高技能的好方法，那就是敢于去解决编码过程中遇到的难题。解决不同类型的难题，可以帮助你成为一名优秀的问题解决者。

我**整理了一些非常受欢迎的编程难题网站列表，并且做了简单介绍**，希望它们可以在你的编程之旅中帮助到你：

**1、TopCoder**

![img](http://upload-images.jianshu.io/upload_images/6837325-82a15fa7f4a1c20b?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

这个网站可以说是一个程序设计比赛的网站，有近一百万程序员所支持，该网站每个星期都有两次网上在线比赛，根据比赛的结果对参赛者进行新的排名。参赛者可以使用他们的代码编辑器直接在线自行完成挑战。根据参赛者完成时间长短排名。

TopCoder上排名靠前的用户都是非常有潜力的程序员，他们会定期参加各种比赛。这些用户还可以通过名称为“ALGORITHMS WEEKLY BY PETR MITRICHEV”的博客平台去发表一些关于编程竞赛、算法、数学等方面的文章。

**2、Coderbyte**

![img](http://upload-images.jianshu.io/upload_images/6837325-67b8a908f411ad2c?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

Coderbyte 是 Kickstarter 资助的项目（在Kickstarter 支持之前这个网站就已经存在了），而且它针对完全的初学者和类似中级程序员。

Coderbyte 提供了 200 多种编码挑战，挑战者可以从 10 种编程语言任选一个，直接在线解决问题。挑战的范围从简单（查找字符串中的最大单词）到复杂。

他们还提供一系列算法教程，包括教程视频和面试准备课程。与HackerRank和其他类似网站不同的是，除了 Coderbyte 发布的官方解决方案外，用户还可以查看其他用户提供的解决方案。

**3、Project Euler**

![img](http://upload-images.jianshu.io/upload_images/6837325-81a10b63fad52645?imageMogr2/auto-orient/strip%7CimageView2/2/w/742/format/webp)

Project Euler 提供了很多关于计算机科学和数学领域的挑战。Project Euler 大概是世界上最受欢迎的编程挑战网站，它们设立得并不是很难，反而更加需要关键的思考和解决问题，以此来帮助你成长和学习你所使用的语言。这一切都是为了锻炼你进步，确保你充分理解自己在做什么。

你不能直接在网站上的编辑器编码，所以你需要在自己的电脑上编写一个解决方案，然后在他们的网站上提交解决方案。

**4、HackerRank**

![img](http://upload-images.jianshu.io/upload_images/6837325-859766c9c55a8960?imageMogr2/auto-orient/strip%7CimageView2/2/w/796/format/webp)

HackerRank提供了很多不同领域的挑战，比如算法、数学、SQL、函数式编程、人工智能等等。它关于人工智能的那部分挑战，它们非常酷，而且让高级程序员也有东西可以玩。它的背后是 Y Combinator、SVAngel 和许多其他公司。绝对有很多黑客在攻克这些。

HackerRank 还针对每一项挑战专门成立了讨论和领导委员会，而大多数挑战来自于一篇社论，它解释了更多的挑战，以及如何接近它提出解决方案。除了这篇社论，你目前还不能看到其他用户在 HackerRank 上的解决方案。

HackerRank 还支持用户提交应用程序，可以适用于工作、解决公司赞助编码的挑战。

**5、CodeChef**

![img](http://upload-images.jianshu.io/upload_images/6837325-eea943fd980196d4?imageMogr2/auto-orient/strip%7CimageView2/2/w/990/format/webp)

CodeChef 是一家位于印度的编程竞赛网站，由 Directi 创造的，该网站提供了数百种挑战。挑战者可以通过在线编辑器进行编程，而且还可以根据自身的编程能力去查看适合于自己水平的挑战题目，CodeChef 有一个大小合理的编程社区，用户可以参与论坛讨论，编写教程，而且还能参加 CodeChef 的编码竞赛。

**6、CodeEval**

![img](http://upload-images.jianshu.io/upload_images/6837325-d79ea41805ed7473?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

CodeEval 与 HackerRank 类似，它也提供了一系列公司赞助的编码挑战，如果能够很好的完成挑战，还可能帮助你找到工作或者是现金鼓励等。公司会举办竞争挑战赛，以此来招募新开发人员进行工作。参赛者在这里看到当前的挑战列表。

**7、Codewars**

![img](http://upload-images.jianshu.io/upload_images/6837325-1fd7eea1ae4db76e?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

Codewars 提供了很多由他们自己社区提交的编码挑战，挑战者可以选用多种语言在编辑器中直接在线完成挑战。用户还可以查看每个挑战的讨论以及其他用户的解决方案。很多人用过之后都表示很好用。

**8、LeetCode**

![img](http://upload-images.jianshu.io/upload_images/6837325-c342569db4d1d84d?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

LeetCode 是一个很受欢迎的在线判题系统，它提供了几百道挑战题目，这些题目可以帮助挑战者为面试做好技术准备。挑战者可以用 9 种编程语言直接在线完成挑战。虽然该网站不支持查看其他用户的解决方案，但用户可以为自己的解决方案提供统计数据，例如与其他用户相比，代码运行速度等等。

网站还设有一个专门为面试准备的 Mock Interview 部分，这是由他们自己创办的编码竞赛，网站上有一些文章可以帮助你提供更好的解题思路

**9、SPOJ**

![img](http://upload-images.jianshu.io/upload_images/6837325-1489aed9fde9f40b?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

Sphere Online Judge(SPOJ)是一个在线判题系统，提供 20000 多个编程挑战。它支持所有你能想到的编程语言，而且在它背后还有一个优秀活跃的社区论坛。用户可以直接通过在线编辑器提交代码。SPOJ 还举办了自己的竞赛，并用户可以自由讨论编程挑战题目。不过，他们目前没有像其他网站那样提供任何官方解决方案或社论。

**10、CodinGame**

![img](http://upload-images.jianshu.io/upload_images/6837325-e13ee8404d47f84b?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

CodinGame 与其他网站有点不同，因为它不是简单地在编辑器中去完成编码挑战，而是让挑战者真正参与在线游戏代码的编写。用户可以在这里看到当前提供的游戏列表和一个示例。这个游戏有一个问题描述，测试用例，和一个编辑器，你可以在 20 多个编程语言中任选一种编写你的代码。

**11、Codeforces**

![img](http://upload-images.jianshu.io/upload_images/6837325-35406bbd5bd6fcbd?imageMogr2/auto-orient/strip%7CimageView2/2/w/792/format/webp)

Codeforces 是一家为计算机编程爱好者提供的在线评测系统该网站由萨拉托夫国立大学的一个团体创立并负责运营。在编程挑战赛中，选手有 2 个小时的时间去解决 5 道题，通过得分排名，选手可以看到实时的排名(Standing)，也可以选择查看好友的排名，还可以看到某题有多少人通过等信息。

在 cf，所有的用户根据在以往比赛中的表现被赋予一个 Rating 并冠以不同的头衔，名字也会以不同的颜色显示,比如 Expert 是蓝色，Master 是黄色。

**12、hackerearth.com**

![img](http://upload-images.jianshu.io/upload_images/6837325-b999dcd7da41610e?imageMogr2/auto-orient/strip%7CimageView2/2/w/891/format/webp)

HackerEarth 成立于2013年，是一家来自印度的、面向程序员的挑战比赛、招聘服务网站，通过编程比赛，帮助企业挑选优秀的程序员。HackerEarth 根据记录每个人的编程过程，通过特殊的算法模型来为企业主推荐合适的开发者，并最终由雇主决定人选。

**13、atcoder.jp**

![img](http://upload-images.jianshu.io/upload_images/6837325-bc449e917f21c630?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

这个网站是 日本最大的算法竞赛网站，题风很棒。有英文和日文题解，很贴心，但是我们应该很少有人能够用日语看题看网站，不过，你可以将网站调成英文的。

**14、hihocoder.com**

![img](http://upload-images.jianshu.io/upload_images/6837325-70bf1a89833208f1?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

风格跟 ACM 很像，每周都会有一个竞赛题目，可以参与其中，每个月还会举办一般编程月赛，同其他参赛者们同台竞技，同时还有讨论社区可供用户讨论算法、分享经验等，而且也会像你推荐工作机会

**15、codefights.com**

![img](http://upload-images.jianshu.io/upload_images/6837325-be525d8dcee84679?imageMogr2/auto-orient/strip%7CimageView2/2/w/999/format/webp)

CodeFights 是一家将练习编程的过程变为游戏过程的初创公司。参赛者既可以选择人机对战模式，也可以选择挑战其它玩家。目前拥有 50 万活跃用户！可以让用户在对战之中不断提高自己的编程技巧。社交游戏与编程的结合是这个网站最大的特点

**16、Timus Online Judge URAL**

![img](http://upload-images.jianshu.io/upload_images/6837325-b031cc47b5c0f80a?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

Timus Online Judge 是一个俄罗斯最大的在线题库， 有很多自己独有的题目。由由乌拉尔联邦大学管理，该网站的比赛规则类似于ACM，比赛分为团队赛和个人挑战赛，比赛时间5个小时，通常有十几个问题，通过参赛者提交的解决方案计算得分。

**17、lintcode.com**

![img](http://upload-images.jianshu.io/upload_images/6837325-f16cfb05316242f9?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

在线刷题网站，汇集了各大公司的算法面试题。有阶梯式训练题库，帮你选好应该刷的题目，特别适合小白和懒人。评测数独很快，最大的中文在线题库。

**年度挑战赛类型：**

**18、Google Code Jam**

![img](http://upload-images.jianshu.io/upload_images/6837325-e0e2d0e78806f1d7?imageMogr2/auto-orient/strip%7CimageView2/2/w/400/format/webp)

Google Code Jam 是一项由 Google 主办的国际程序设计竞赛。该项赛事始于 2003 年，旨在帮助 Google 发掘潜在的工程领域顶级人才。比赛内容包括一系列的算法问题，参赛者必须在指定时间内解决。参赛者允许使用任意自选编程语言和开发环境来解答问题。

**19、Facebook Hacker Cup**

![img](http://upload-images.jianshu.io/upload_images/6837325-aa3b20088fb90b84?imageMogr2/auto-orient/strip%7CimageView2/2/w/380/format/webp)

Facebook Hacker Cup 是一个由 Facebook 脸谱主办的国际性的编程比赛 。竞赛始于 2011 年，是作为一种手段来招募工程技术人才。比赛由必须要在一个固定的时间内解决的一组算法问题组成，参赛者可以使用任何编程语言和发展环境去找他们的解决方案。

Facebook 将这次竞赛作为一个重要的人才招募平台，用以吸引优秀的程序设计人员加盟。预选赛的前 25 名将被邀请到Facebook总部进行决赛，决赛胜者将被授予全球"最佳黑客"称号，同时获得 5000 美元奖金。

**20、ACM 国际大学生程序设计竞赛**

![img](http://upload-images.jianshu.io/upload_images/6837325-3b8e3d512c8cc6d3?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

ACM 国际大学生程序设计竞赛(英文全称：ACM International Collegiate Programming Contest (简称 ACM-ICPC 或 ICPC))是由美国计算机协会(ACM)主办的，一项旨在展示大学生创新能力、团队精神和在压力下编写程序、分析和解决问题能力的年度竞赛。经过近 40 年的发展，ACM 国际大学生程序设计竞赛已经发展成为全球最具影响力的大学生程序设计竞赛。赛事目前由 IBM 公司赞助。

本文所提及的都是根据以下内容整理出来的：一些是我本人浏览网站时关注到的，一些是通过谷歌搜索和基于 Quora 上的文章，还有一些在一些文章中遇到过的。我还经常逛一些类似于 r/learnprogramming 这样的论坛，查看论坛用户通常推荐哪些网站。

[有哪些好的刷题网站？2017年最受欢迎的编程挑战网站](https://www.jianshu.com/p/a9683082b3cc)



# 各大刷题网站

### <http://oj.leetcode.com/>

Leetcode是一个主要面向面试者的OJ (LeetCode OJ is a platform for preparing technical coding interviews)。 题目类型偏基础，基本不会考察复杂的算法，很多都是对基础知识的应用，难度与topcoder div1 250或codeforces div1 A题难度相当。如果是希望练习编程基础或准备公司面试的话非常推荐此OJ

### <http://www.lintcode.com/>

LintCode也是类似Leetcode的面向找工作的刷题网站，网站可以选择中文，有独特的Ladder阶梯刷题模式，其test case相对LeetCode要少。

### <https://www.hackerrank.com/calendar>

以编码谜题和现实生活中遇到的编码难题为基础的新兴的社交平台

### Kattis - <https://open.kattis.com/>

Interesting, Fashionable, Challenging

### Leetcode题目难度列表－LeetCode Question Difficulty Distribution

<https://docs.google.com/spreadsheets/d/1lRvzw3bC7PAM130pKW3JDpU-p1CD5dChHbhubJGDKK4/pub?output=html>

### Leetcode/Lintcode题解

<https://drive.google.com/open?id=0B5v9H1j2igtVMGQxMHNXREtyeXc>

Full Stack Data Analytics TA

Office Hour/在线时间:
美西

－ 周三: 8-9pm
－ 周四: 8-9pm

欢迎大家一起来探讨问题 =)





Algorithms

------

- [https://www.hackerrank.com/domains ](https://www.evernote.com/OutboundRedirect.action?dest=https%3A%2F%2Fwww.hackerrank.com%2Fdomains)
- [https://oj.leetcode.com/problemset/algorithms/](https://www.evernote.com/OutboundRedirect.action?dest=https%3A%2F%2Foj.leetcode.com%2Fproblemset%2Falgorithms%2F) LeetCode至少要刷三遍，付费部分的题建议花点钱看一下，舍不得孩子套不着狼
- <http://lintcode.com/> 
- [http://www.ninechapter.com/solutions/ ](http://www.ninechapter.com/solutions/)
- <http://www.geeksforgeeks.org/about/interview-corner/>
- TopCoder Algorithm Tutorial: [http://help.topcoder.com/data-science/competing-in-algorithm-challenges/algorithm-tutorials/ ](http://help.topcoder.com/data-science/competing-in-algorithm-challenges/algorithm-tutorials/)其中几何算法的教程要仔细看，Google特爱出几何题
- CC150: Cracking the Code Interview: <http://www.valleytalk.org/wp-content/uploads/2012/10/CrackCode.pdf> 



如果你的主要目标不是去搞ACM/ICPC的，也不想去搞科研的，**适可而止**
所以这里迅速划掉：*CodeForces、BestCoder、SGU*
你以后真不见得会在工作中去用线段树与树状数组、树链剖分与动态树、树套树等等可以划到高级数据结构范畴的东西的，这些留给专业选手们、计算机科学家吧
上面这几个你倒是可以考虑一下做以下两方面的题目：
1、最水的题。这种题目做起来会莫名其妙卡壳的，多练练，练到有快速反应能力足以应付面试即可
2、动态规划类题目

HackerRank，看需要做需要的分类的题目，都搞透是没那么多精力的

还有一些说一下：

TopCoder：分Design、Develop、Algorithm的。Algorithm大约是黄名水平应该也就够了，毕竟div2的2个暴力+1个规划类，div1第一个一般也是dp这种

浙大 Programming Ability Test（PAT）练习题库：[题目集列表 | Programming Ability Test](https://link.zhihu.com/?target=http%3A//www.patest.cn/contests)
根据负责人陈越姥姥的说法，PAT现在3个等级的话，水平如下：（具体要求可参见 [查看新闻 | Programming Ability Test](https://link.zhihu.com/?target=http%3A//www.patest.cn/news/2)）
Basic（乙级）：熟悉C语言就能高分
Advanced（甲级）：大学的数据结构课程熟悉且有较好理解就能拿高分
Top（顶级）：ACM/ICPC银牌及以上实力水平
听说以后浙大计算机考研机试就PAT甲级了，题主看着办吧……

反正，为了找工作刷题说白了就是一种骗过面试的抱佛脚，然后后面开发的东西才是企业看中的实力，这个还是建议答主多积累一点大项目经验吧。



# 参考资料

* [在线评测系统 - 维基百科](https://zh.wikipedia.org/zh-hans/在线评测系统)