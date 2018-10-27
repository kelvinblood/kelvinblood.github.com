---
layout: post
title: 开源协议的比较——GPL BSD MIT Apache
category: tech
tags:
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

# GPL

GPL，全称 GNU General Public License。

常说的传染性：只要在一个软件中使用(“使用”指类库引用或者修改后的代码) GPL 协议的产品，则该软件产品必须也采用GPL协议，既必须也是开源和免费。

采用这个协议的开源软件有：Linux、 MySQL。

# BSD

全称 Berkeley Software Distribution。

这个协议允许使用者修改和重新发布代码，也允许使用或在BSD代码基础上开发商业软件发布和销售，因此是适用于商业软件的。

使用时需要满足三个条件： 

1. 如果再发布的产品中包含源代码，则在源代码中必须带有原来代码中的BSD协议。 
2. 如果再发布的只是二进制类库/软件，则需要在类库/软件的文档和版权声明中包含原来代码中的BSD协议。 
3. 不可以用开源代码的作者/机构名字和原来产品的名字做市场推广。

适用BSD协议的开源软件有： nginx、CruiseControl、Redis。

# MIT

MIT，源自麻省理工学院（Massachusetts Institute of Technology, MIT），又称X11协议。MIT与BSD类似，但是比BSD协议更加宽松，是目前最少限制的协议。 

这个协议唯一的条件就是在修改后的代码或者发行包包含原作者的许可信息。

使用MIT的软件项目有：Node.js, [jQuery](https://github.com/jquery/jquery/blob/master/LICENSE.txt), [.NET Core](https://github.com/dotnet/corefx/blob/master/LICENSE), 和 [Rails](https://github.com/rails/rails/blob/master/activerecord/MIT-LICENSE) .

# Apache License 2.0

比起 BSD，Apache License 2.0 除了为用户提供版权许可之外，还有专利许可，使用者可以获得永久授权，修改时需要放置版权说明。

1. 需要给代码的用户一份 Apache Licence。
2. 如果你修改了代码，需要再被修改的文件中说明。
3. 在延伸的代码中（修改和有源代码衍生的代码中）需要带有原来代码中的协议，商标，专利声明和其他原来作者规定需要包含的说明。
4. 如果再发布的产品中包含一个Notice文件，则在Notice文件中需要带有Apache Licence。你可以在Notice中增加自己的许可，但不可以表现为对Apache Licence构成更改。

它还有这些好处：

1. 永久权利 一旦被授权，永久拥有。
2. 全球范围的权利 在一个国家获得授权，适用于所有国家。假如你在美国，许可是从印度授权的，也没有问题。
3. 授权免费 无版税， 前期、后期均无任何费用。
4. 授权无排他性 任何人都可以获得授权
5. 授权不可撤消 一旦获得授权，没有任何人可以取消。比如，你基于该产品代码开发了衍生产品，你不用担心会在某一天被禁止使用该代码

使用apache Licence vesion 2.0协议的开源软件有：[Android](https://github.com/android/platform_system_core/blob/master/NOTICE)、 [Apache](https://svn.apache.org/viewvc/httpd/httpd/trunk/LICENSE?view=markup) 、[Swift](https://github.com/apple/swift/blob/master/LICENSE.txt) 、Hadoop 、Spring Framework、MongoDB 。

举一个例子：

GitHub 上开源项目 SeaweedFS 的作者 Chris Lu [控诉京东 TigLab 项目涉嫌抄袭代码](https://zhuanlan.zhihu.com/p/45668894)的事情在知乎上闹得沸沸扬扬。Chris Lu 发文表示京东的项目使用了他的源码，但是没有根据  Apache-2.0 协议的许可条款添加引用说明。

 ![jd](https://cdn.kelu.org/blog/2018/09/v2-9f8d4da222d422c4bd0b9b8d3cb50a73_hd.png)





 

最后给张图：

<http://choosealicense.online/>:

![http://choosealicense.online/](https://cdn.kelu.org/blog/2018/09/1ceaceb1b7e128b54f437a7540881e25_hd-20181027191829898.png)



# 参考资料

* [主流开源协议之间有何异同？-知乎](https://www.zhihu.com/question/19568896)
* <http://choosealicense.online/>

