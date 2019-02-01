---
layout: post
title: PHP 的字符串和数组的转换函数 explode() 和 implode()
category: tech
tags: php string function wechat
---

一年一度的春节终于过去啦๑乛◡乛๑ 。今年春节一直比较闲，终于有闲心下来看一些架构方面的书了。最近已经习惯于用微信读书了，感觉不愧是腾讯做的东西。读书应用里我用过的很多，包括京东，豆瓣，Amazon，多看阅读，百度阅读，都有用过，而且为之付费不菲，断断续续看了几本书，没办法养成习惯。一部分原因可以归咎于自己确实没有毅力，另一部分感觉还是 app 做的有欠缺。

微信读书在这方面做的感觉很到位，背靠腾讯大靠山，首先流量不缺，通过首批核心用户在朋友圈网络进行宣传推广，在此之上的推广还能得到5个书币，获得的书币可以拿来买书；除了推广获得书币外，还可以通过阅读时间来兑换，不得不说这个方式太赞了，反过来又促进了爱书用户更多地看书。除了看书的核心功能，腾讯理所当然还加入了社交功能社交功能（爱恨交加的社交，说好的用完即走呢，傲娇的张小龙，╮(╯3╰)╭），相比于其它几种阅读app，微信做的实在是太赞了。看好微信读书的未来。

另外今天发现了一个有趣的网站<http://hepwori.github.io/execorder/>，哈哈哈，反正效果是这样的：

![](https://cdn.kelu.org/blog/2017/02/20170203224858.jpg)

好了，下面是正文。

# explode() 

把字符串打散为数组。

语法

    explode(separator,string,limit)
    
    * separator	必需。规定在哪里分割字符串。
    * string	必需。要分割的字符串。
    * limit	    可选。规定所返回的数组元素的数目。
                大于 0 - 返回包含最多 limit 个元素的数组
                小于 0 - 返回包含除了最后的 -limit 个元素以外的所有元素的数组
                0 - 返回包含一个元素的数组




例子：

    $str = "Hello world. I love Shanghai!";
    var_dump(explode(" ",$str));
    
真实例子:

    public function setExpectedIndustryTagAttribute($value)
    {
        if (is_string($value)) {
            $array = explode(' ', $value);
            $array = array_filter($array);
            $this->attributes['tag'] = json_encode($array);
        }

        if (is_array($value)) {
            $this->attributes['tag'] = $value;
        }
    }
    
    
# implode() 

把数组元素组合为字符串。

语法

    implode(separator,array)
    
    * separator	可选。规定数组元素之间放置的内容。默认是 ""（空字符串）。
    * array	必需。要组合为字符串的数组。

例子：

    $arr = array('Hello','World!','I','love','Shanghai!');
    echo implode(" ",$arr)."<br>";
    echo implode("+",$arr)."<br>";
    echo implode("-",$arr)."<br>";
    echo implode("X",$arr);
