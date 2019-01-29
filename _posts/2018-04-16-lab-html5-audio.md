---
layout: post
title: HTML5 audio 实验 - tommy351
category: tech
tags: frontend
---
![](https://cdn.kelu.org/blog/tags/frontend.jpg)

> 这是一篇，很古老的文章。。。。。然而这又是一篇和我blog有着一些联系的文章。。。我blog右边的播放器，其实就是来源于此文。
>
> 鉴于互联网上消失的人越来越多，为了给自己留个纪念，把他这篇文章转载过来做个留念。
>
> 作者现在仍然活跃在前端开发的技术栈中，可以参考他的github[@tommy351](https://github.com/tommy351)

寒假即将结束，不巧膝盖突然中了一箭，便决定实验 HTML5 audio标签的效果，虽然已有 jPlayer 这款轻便好用的播放器，但不折腾一下就没办法消磨时间了，所以本次的实验品完全由我操刀。

## 开始之前

首先必须了解 audio 标签的使用方式：

```
<audio controls>
  <source src="music.mp3">
  <source src="music.ogg">
</audio>
```

输入以上代码后，便可在网页中看到浏览器内建的播放器。每种浏览器支援的播放类型不一，最保险的方法是备妥mp3、ogg。

为了浪费时间，当然不可能用浏览器的预设介面，所以删除controls属性，透过 JavaScript 操作：

```
var audio = document.getElementsByTagName('audio')[0];
// 播放
audio.play();
// 暫停
audio.pause();
```

只需要懂这两个函数，就可製作最基础的播放器了，其他複杂的指令可参阅文末的参考出处。

## 介面

写网页时，比起最重要的 JavaScript，我习惯先写 CSS，最初的参考范本是 Mac 的 CoverFlow。

经过一连串绞尽脑汁，写了一堆乱七八糟的 CSS 之后，成品如下。

无论是倒影、中间的圆圈进度表都与 CoverFlow 非常相像，但这种样式实在 太麻烦了 不便使用者操作，所以从 Premium Pixels 偷点子过来，稍微加油添醋一下，完成了播放器介面 Ver. 2。

Ver.2 与 Ver.1 完全不像？这种事情不重要啦！

##核心

介面完成自爽一下之后，就得面对麻烦的 JavaScript 了，播放、暂停非常简单，按钮按下去执行乡对应的动作即可，然而音量调整与进度条该如何处理呢？

虽然本次的重点是消磨时间，但再去造一个轮子实在他妈的太累了，于是 聪明如我 请到了 jQuery UI，Slider 功能压缩后需要约 20KB 的空间，有点庞大不过方便就好。

时间的控制方式如下，单位为秒数，例如跳至第 100 秒的位置：

```
audio.currentTime = 100;
```

音量的控制方式如下，范围为 0~1，例如将音量调整至一半大小：

```
audio.volume = 0.5;
```

audio可绑定play, pause, ended, progress, canplay, timeupdate等事件。play与pause如字面上意思，分别为播放、暂停后生效。

```
audio.addEventListener('play', function(){
  play.title = 'pause';
}, false);

audio.addEventListener('pause', function(){
  play.title = 'play';
}, false);
```

ended为结束后生效，当音乐结束后，可透过此事件让时间归零。

```
audio.addEventListener('ended', function(){
  this.currentTime = 0;
}, false);
```

当音乐档桉开始载入后，便会启动progress事件，可透过此事件监测下载进度。Firefox 可能会发生问题，建议搭配durationchange事件使用。

```
audio.addEventListener('progress', function(){
  var endVal = this.seekable && this.seekable.length ? this.seekable.end(0) : 0;
  buffer.style.width = (100 / (this.duration || 1) * endVal) + '%';
}, false);
```

当音乐下载到一定程度后，canplay事件便会生效，一般会透过此事件初始化播放器。相同类型的事件还有很多，依照启动顺序分别为：loadstart, durationchange, loadeddata, progress, canplay, canplaythrough。

timeupdate会在音乐播放时不断生效，可透过此事件更新时间。

```
audio.addEventListener('timeupdate', function(){
  progress.style.width = (this.currentTime / this.duration) * 100 + '%';
}, false);
```

##播放列表

一个播放器的基础功能就此完成，能够播放、暂停、调整音量、调整时间。但这显然还不够，播放列表对于播放器而言相当重要。（大概啦）

不要吐槽为啥播放列表裡全是动漫歌，林北就是宅啦...

与自己的逻辑奋战大约一晚后，有播放列表、随机播放、重複播放（单首、全部）功能的播放器于焉完成。只需要 214 行、约 6KB 的代码（未压缩）即可完成，应该能算是轻便简易了。

##后记

播放列表的製作过程有点髒，中途还重构了几次，所以直接看范例应该会比较快，若对于范例内的程式码感到疑惑，可在下方留言。

范例内已设定了一些参数，可在js/script.js内更改。第 5 行的continous参数为连续播放，第6行的autoplay参数为自动播放，第7行的playlist阵列请自行设定，压缩档内不会附带范例内的音乐档桉。playlist阵列的格式如下：

```
var playlist = [
  {
    title: 'Tell Your World',
    artist: 'livetune feat.初音ミク',
    album: 'Tell Your World',
    cover: 'cover/tell_your_world.jpg',
    mp3: 'music/tell_your_world.mp3',
    ogg: 'music/tell_your_world.ogg'
  }
];
```

title为标题，artist为演出者，album为专辑名称，cover为专辑封面的路径，mp3、ogg分别为音乐档桉的路径，建议备妥两种格式的档桉，要不然 Firefox 和 Opera 不就只能去死了吗？

因为做到最后头脑快爆炸了，懒得做 Flash fallback，IE 请去死一死吧。

[下载](https://cdn.kelu.org/blog/2018/04/example.zip)

##参考出处

- [jPlayer](http://jplayer.org/)
- [小試HTML 5 audio - 黑暗執行緒](http://blog.darkthread.net/post-2011-05-15-html5-audio.aspx)
- [Using HTML5 audio and video - MDN](https://developer.mozilla.org/en/Using_HTML5_audio_and_video)
- [HTML5 Audio and Video: What you Must Know | Nettuts+](http://net.tutsplus.com/tutorials/html-css-techniques/html5-audio-and-video-what-you-must-know/)
- [Free PSD: Compact Music Player | Premium Pixels](http://www.premiumpixels.com/freebies/compact-music-player-psd/)

