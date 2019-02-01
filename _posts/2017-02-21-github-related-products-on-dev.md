---
layout: post
title: github的辅助项目们
category: tech
tags: github git opensource
---
![](https://cdn.kelu.org/blog/tags/github.jpg)

时常在github项目上看到类似下面这样的小标签,用于展示项目的一些信息。

![](https://cdn.kelu.org/blog/2017/02/20170221202753.jpg)

今天稍微接触了一下这些(小)项目。目前还没有在blog上使用，过段时间会尝试一下。

# Shields.io

提供高质量Github项目进度角标图片的API.[shields.io][shields.io] 。引用起来也非常简单

    <div id="container">
        <img src="http://progressed.io/bar/28?title=progress" alt="">
        <img src="http://progressed.io/bar/30?title=nice" alt="">
        <img src="http://progressed.io/bar/60?title=极客标签" alt="">
        <img src="https://img.shields.io/teamcity/http/teamcity.jetbrains.com/s/bt345.svg" alt="">
        <img src="https://img.shields.io/pypi/dw/Django.svg" alt="">
        <img src="https://img.shields.io/badge/soul-GBTAG-red.svg" alt="">
    </div>
    <script type="text/javascript" src="http://cdn.gbtags.com/jquery/1.11.1/jquery.min.js"></script>



显示出来就是这个样子：

<div id="container">
    <img src="http://progressed.io/bar/28?title=progress" alt="">
    <img src="http://progressed.io/bar/30?title=nice" alt="">
    <img src="http://progressed.io/bar/60?title=极客标签" alt="">
    <img src="https://img.shields.io/teamcity/http/teamcity.jetbrains.com/s/bt345.svg" alt="">
    <img src="https://img.shields.io/pypi/dw/Django.svg" alt="">
    <img src="https://img.shields.io/badge/soul-GBTAG-red.svg" alt="">
</div>
<script type="text/javascript" src="http://cdn.gbtags.com/jquery/1.11.1/jquery.min.js"></script>

总的说来就是显示项目构建、下载、版本号、sns情况和其他五花八门的信息显示图标。

# gitter.im

[Gitter.im][gitter.im]是一款支持Markdown的针对开发者的即时通讯软件。

* Gitter.im 基于 Github 进行构建，紧密地集成到您的 organisations, repositories, issues 和 activity。
* Gitter.im还提供与 Trello, Jenkins, Travis CI, Heroku, Sentry, BitBucket, HuBoard, Logentries, Pagerduty 以及 Sprintly 的集成。同样支持自定义的 webhook ，为集成提供了开源库以及灵活的API。
* 支持MarkDown语法
* 免费用户就可拥有 无限制的公开及私密聊天室数量
* 免费用户就可拥有 无限制的历史聊天记录
* 拥有Macos，Linux，Windows，苹果IOS，安卓Andriod APP客户端，还有几十个第三方APP。

# Go Report Card

[Go_Report_Card][Go_Report_Card],一个可以为你的开源 Go 代码生成质量报告的网站，挺不错的，利用的常见的几个工具，golint, go vet等。

# microbadger

[microbadger][microbadger]是一个管理你的Docker镜像的工具。

# Coveralls

使用[coveralls][coveralls]在代码自动化测试时统计测试覆盖率

# CI持续集成平台

## appveyor

随着SaaS的兴起，[appveyor][appveyor]把持续集成搬到了云端，我们无需架设自己的CI服务器，只需注册一个账号，然后把GitHub, BitBucket或者TFS 连上AppVeyor就可以了

## travis-ci.org

[Travis CI][travis-ci] 是目前新兴的开源持续集成构建项目，它与jenkins，GO的很明显的特别在于采用yaml格式，简洁清新独树一帜。目前大多数的github项目都已经移入到Travis CI的构建队列中。Travis-CI 使用 PostgreSQL 数据库。

## circleci

[CircleCI][circleci] 是又一个持续集成平台。

# 参考资料

* [kcptun][kcptun]
* [thefuck][thefuck]
* [shields.io][shields.io]
* [gitter.im][gitter.im]
* [Go_Report_Card][Go_Report_Card]
* [microbadger][microbadger]
* [travis-ci][travis-ci]
* [circleci][circleci]
* [appveyor][appveyor]
* [coveralls][coveralls]
* [利用 AppVeyor 实现 GitHub 托管项目的自动化集成](http://www.gulu-dev.com/post/2015-05-01-appveyor-ci)
* [云端持续集成——AppVeyor拥抱GitHub](http://www.cnblogs.com/henryzhu/p/contentious-integration-with-appveyor.html)
* [使用AppVeyor CI 和PowerShell部署应用](http://www.infoq.com/cn/articles/AppVeyor-CI?utm_campaign=infoq_content&utm_source=infoq&utm_medium=feed&utm_term=global)
* [使用Travis-CI+Coveralls让你的Github开源项目持续集成](http://www.tuicool.com/articles/VR3a2ar)
* [从自动化测试到持续部署，你需要了解这些](https://www.diycode.cc/topics/128)
* [使用Travis-CI+Coveralls让你的Github开源项目持续集成](http://div.io/topic/1674)

[shields.io]: http://shields.io
[kcptun]: https://github.com/xtaci/kcptun/blob/master/README-CN.md
[thefuck]: https://github.com/nvbn/thefuck
[gitter.im]: https://gitter.im
[Go_Report_Card]: https://goreportcard.com
[microbadger]: https://microbadger.com
[travis-ci]: https://travis-ci.org/getting_started
[appveyor]: https://www.appveyor.com
[circleci]: https://circleci.com
[coveralls]: https://coveralls.io
