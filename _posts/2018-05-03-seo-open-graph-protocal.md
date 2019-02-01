---
layout: post
title: seo优化之open-graph-protocal
category: product
tags: seo
---
![](https://cdn.kelu.org/blog/tags/seo.jpg)

# 什么是og

og是一种新的HTTP头部标记，由 Facebook在 2010年F8会议上公布的一套**开放内容协议(Open Graph Protocol)**，任何网页只要遵守该协议，SNS就能从页面上提取最有效的信息并呈现给用户。

可以查看官网进行更深入的了解——<http://ogp.me/

按照百度百科的信息:

> Open Graph通讯协定(Protocol)本身是一种制定一套Metatags的规格，用来标注你的页面，告诉我们你的网页代表哪一类型的现实世界物件。另一伙伴网站，即Amazon旗下的Internet Movie Database(IMDb)，将用这个Open Graph Protocol为每一部电影标注页面。按下IMDb上的“赞”按钮，就会自动把那部电影加入Facebook使用者profile中的“最爱的电影”。

> Facebook已和Yahoo、Twitter合作采用OAuth 2.0认证标准。Graph API翻新了Facebook的平台程序代码，让Facebook里的每个物件都拥有独特的ID。通过Open Graph把其他社交网站建构的网络给连接起来，将创造一个更聪明、更与社交连接、更个人化也更具语意意识的网络。



# OG 的意义

当用户将网页分享到facebook、twitter或者微博的时候，sns网站中的内容是按照我们og属性规定内容呈现的，以此保证信息分享更准确更符合作者所想。

搜索引擎机器人爬取的是我们的页面，即html代码，meta信息尤为关注，所以我们增加的og meta标签是可以别搜索引擎发现并评估权重的，将原有meta信息优化手段同时使用到og:title这种属性值当中，加强meta信息优化内容， 对于权重提升和排名还是很有利的。

# OG的应用

## 基本使用

要将网页转换为图形对象，您需要将基本元数据添加到页面中。每个页面的四个必需属性是：

- `og:title` - 对象标题，例如“The Rock”。
- `og:type`- 对象类型
- `og:image` - 图片网址。
- `og:url` - 网页的永久URL，例如“http://www.imdb.com/title/tt0117500/”。

以下是[IMDB上Rock](http://www.imdb.com/title/tt0117500/)的Open Graph协议标记：

```
<html prefix="og: http://ogp.me/ns#">
<head>
<title>The Rock (1996)</title>
<meta property="og:title" content="The Rock" />
<meta property="og:type" content="video.movie" />
<meta property="og:url" content="http://www.imdb.com/title/tt0117500/" />
<meta property="og:image" content="http://ia.media-imdb.com/images/rock.jpg" />
...
</head>
...
</html>
```

## 视频video 

og:videosrc 视频资源链接，例如可是播放视频的flash地址

og:width 视频的宽度 可为空 允许多个

og:height 视频的高度 可为空 允许多个

## 音频audio 

og:audiosrc  不可为空 允许多个 音乐资源链接，例如可是播放歌曲的flash地址

og:artist 音乐家 可为空 需唯一

### 普通网页link 

og:abstract 内容摘要 可为空 允许多个

og:contentid 可为空 唯一 内容主体的ID，用来标识当前页面主要内容所处的HTML标签的ID 

### 图片photo 

og:photo 图片列表 可为空 允许多个

og:width 图片宽度 可为空 允许多个

og:height 图片高度 可为空 允许多个

### 商品product 

og:price 产品价格 不可为空 需唯一

og:description 产品描述 不可为空 需唯一

og:nick 店铺名 不可为空 需唯一

og:postfee 运费 不可为空 需唯一

### Music

- Namespace URI: [`http://ogp.me/ns/music#`](http://ogp.me/ns/music)

`og:type` : 

[`music.song`](http://ogp.me/#type_music.song) 

- `music:duration` - [integer](http://ogp.me/#integer) >=1 - The song's length in seconds.
- `music:album` - [music.album](http://ogp.me/#type_music.album) [array](http://ogp.me/#array) - The album this song is from.
- `music:album:disc` - [integer](http://ogp.me/#integer) >=1 - Which disc of the album this song is on.
- `music:album:track` - [integer](http://ogp.me/#integer) >=1 - Which track this song is.
- `music:musician` - [profile](http://ogp.me/#type_profile) [array](http://ogp.me/#array) - The musician that made this song.

[`music.album`](http://ogp.me/#type_music.album)

- `music:song` - [music.song](http://ogp.me/#type_music.song) - The song on this album.
- `music:song:disc` - [integer](http://ogp.me/#integer) >=1 - The same as `music:album:disc` but in reverse.
- `music:song:track` - [integer](http://ogp.me/#integer) >=1 - The same as `music:album:track` but in reverse.
- `music:musician` - [profile](http://ogp.me/#type_profile) - The musician that made this song.
- `music:release_date` - [datetime](http://ogp.me/#datetime) - The date the album was released.

[`music.playlist`](http://ogp.me/#type_music.playlist)

- `music:song` - Identical to the ones on [music.album](http://ogp.me/#type_music.album)
- `music:song:disc`
- `music:song:track`
- `music:creator` - [profile](http://ogp.me/#type_profile) - The creator of this playlist.

[`music.radio_station`](http://ogp.me/#type_music.radio_station)

- `music:creator` - [profile](http://ogp.me/#type_profile) - The creator of this station.

### Video

- Namespace URI: [`http://ogp.me/ns/video#`](http://ogp.me/ns/video)

`og:type` values:

[`video.movie`](http://ogp.me/#type_video.movie)

- `video:actor` - [profile](http://ogp.me/#type_profile) [array](http://ogp.me/#array) - Actors in the movie.
- `video:actor:role` - [string](http://ogp.me/#string) - The role they played.
- `video:director` - [profile](http://ogp.me/#type_profile) [array](http://ogp.me/#array) - Directors of the movie.
- `video:writer` - [profile](http://ogp.me/#type_profile) [array](http://ogp.me/#array) - Writers of the movie.
- `video:duration` - [integer](http://ogp.me/#integer) >=1 - The movie's length in seconds.
- `video:release_date` - [datetime](http://ogp.me/#datetime) - The date the movie was released.
- `video:tag` - [string](http://ogp.me/#string) [array](http://ogp.me/#array) - Tag words associated with this movie.

[`video.episode`](http://ogp.me/#type_video.episode)

- `video:actor` - Identical to [video.movie](http://ogp.me/#type_video.movie)
- `video:actor:role`
- `video:director`
- `video:writer`
- `video:duration`
- `video:release_date`
- `video:tag`
- `video:series` - [video.tv_show](http://ogp.me/#type_video.tv_show) - Which series this episode belongs to.

[`video.tv_show`](http://ogp.me/#type_video.tv_show)

A multi-episode TV show. The metadata is identical to [video.movie](http://ogp.me/#type_video.movie).

[`video.other`](http://ogp.me/#type_video.other)

A video that doesn't belong in any other category. The metadata is identical to [video.movie](http://ogp.me/#type_video.movie).

### article

[`article`](http://ogp.me/#type_article) - Namespace URI: [`http://ogp.me/ns/article#`](http://ogp.me/ns/article)

- `article:published_time` - [datetime](http://ogp.me/#datetime) - When the article was first published.
- `article:modified_time` - [datetime](http://ogp.me/#datetime) - When the article was last changed.
- `article:expiration_time` - [datetime](http://ogp.me/#datetime) - When the article is out of date after.
- `article:author` - [profile](http://ogp.me/#type_profile) [array](http://ogp.me/#array) - Writers of the article.
- `article:section` - [string](http://ogp.me/#string) - A high-level section name. E.g. Technology
- `article:tag` - [string](http://ogp.me/#string) [array](http://ogp.me/#array) - Tag words associated with this article.

### book

[`book`](http://ogp.me/#type_book) - Namespace URI: [`http://ogp.me/ns/book#`](http://ogp.me/ns/book)

- `book:author` - [profile](http://ogp.me/#type_profile) [array](http://ogp.me/#array) - Who wrote this book.
- `book:isbn` - [string](http://ogp.me/#string) - The [ISBN](http://en.wikipedia.org/wiki/International_Standard_Book_Number)
- `book:release_date` - [datetime](http://ogp.me/#datetime) - The date the book was released.
- `book:tag` - [string](http://ogp.me/#string) [array](http://ogp.me/#array) - Tag words associated with this book.

### profile

[`profile`](http://ogp.me/#type_profile) - Namespace URI: [`http://ogp.me/ns/profile#`](http://ogp.me/ns/profile)

- `profile:first_name` - [string](http://ogp.me/#string) - A name normally given to an individual by a parent or self-chosen.
- `profile:last_name` - [string](http://ogp.me/#string) - A name inherited from a family or marriage and by which the individual is commonly known.
- `profile:username` - [string](http://ogp.me/#string) - A short unique string to identify them.
- `profile:gender` - [enum](http://ogp.me/#enum)(male, female) - Their gender.

### website

[`website`](http://ogp.me/#type_website) - Namespace URI: [`http://ogp.me/ns/website#`](http://ogp.me/ns/website)

## 其他可选

以下属性对于任何对象都是可选的，通常建议：

- `og:determiner` - 标题之前出现的单词。（a，an，“”，auto）等，默认是“”（空白）。
- `og:locale`- 这些标签所在的区域设置。格式`language_TERRITORY`。默认是`en_US`。
- `og:locale:alternate`- 此页面可用的其他语言环境数组。
- `og:site_name` - 如果网页是大网站的一部分，则应显示整个网站的名称。例如“IMDb”。

例如：

```
<meta property="og:audio" content="http://example.com/bond/theme.mp3" />
<meta property="og:description" 
  content="Sean Connery found fame and fortune as the
           suave, sophisticated British agent, James Bond." />
<meta property="og:determiner" content="the" />
<meta property="og:locale" content="en_GB" />
<meta property="og:locale:alternate" content="fr_FR" />
<meta property="og:locale:alternate" content="es_ES" />
<meta property="og:site_name" content="IMDb" />
<meta property="og:video" content="http://example.com/bond/trailer.swf" />
```

更详细的请参考下文的参考资料。

# 参考资料

* [The Open Graph protocol](http://ogp.me/) 