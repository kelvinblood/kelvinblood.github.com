---
layout: post
title: linux 批量将 webp 转换为 jpg
category: tech
tags: linux shell
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

# 背景

自己的blog有一些图片是转载的其他的blog的，有些blog的文章比较奇怪，没有后缀名！通过上一篇的方式，我找出了这种图格式是 webp。这一篇在之前的基础上，我完成了一个脚本将webp批量转换为 jpg 图片格式。

# WebP是什么

目前对于JPEG、PNG、GIF等常用图片格式的优化已几乎达到极致，因此Google于2010年提出了一种新的图片压缩格式 — WebP，给图片的优化提供了新的可能。

WebP为网络图片提供了无损和有损压缩能力，同时在有损条件下支持透明通道。据官方实验显示：无损WebP相比PNG减少26%大小；有损WebP在相同的SSIM（Structural Similarity Index，结构相似性）下相比JPEG减少25%~34%的大小；有损WebP也支持透明通道，大小通常约为对应PNG的1/3。

同时，谷歌于2014年提出了动态WebP，拓展WebP使其支持动图能力。动态WebP相比GIF支持更丰富的色彩，并且也占用更小空间，更适应移动网络的动图播放。

WebP 的优势体现在它具有更优的图像数据压缩算法，能带来更小的图片体积，而且拥有肉眼识别无差异的图像质量；同时具备了无损和有损的压缩模式、Alpha 透明以及动画的特性，在 JPEG 和 PNG 上的转化效果都相当优秀、稳定和统一。

# 转换

参考文档：[Linux: How to Convert WEBP to JPG](http://xahlee.info/img/convert_webp_to_jpg.html)

>  By Xah Lee. Date: 2016-10-11.

### 安装

```
# debian install webp
sudo apt-get install webp
```

安装后得到如下命令工具：

- `cwebp` → WebP encoder tool
- `dwebp` → WebP decoder tool
- `vwebp` → WebP file viewer
- `webpmux` → WebP muxing tool
- `gif2webp` → Tool for converting GIF images to WebP

### WebP -> JPG

先使用 dwebp 将 webp 转化为png格式。

```
dwebp mycat.webp -o mycat.png
```

使用 imagemagic 将 png 转化为 jpg.

```
# convert from png to jpg by imagemagic
convert mycat.png mycat.jpg
```

参考 [ImageMagick Tutorial](http://xahlee.info/img/imagemagic.html)

### JPG -> WebP

```
cwebp filename -o filename
```

# 批量脚本

针对webp格式的文件，我写了这个脚本进行判断：

```
# webp2jpg.sh

#!/bin/bash
for file in `ls`
do
  len=`xxd -p -l 4 $file`

  if [ $len == "52494646" ]; then
    echo "$file is webp"
    if [ ! -e $file.jpg ]; then
      echo "===== convert $file ====="
      dwebp $file -o $file.png
      convert "$file.png" "$file.jpg"
      rm $file.png
    fi
  fi
done
```

运行后即可将文件夹下webp格式的转为jpg格式，例如：

```
./webp2jpg.sh
```

# 参考资料

* [Linux: How to Convert WEBP to JPG](http://xahlee.info/img/convert_webp_to_jpg.html)
* [Linux shell编程 5 ---- 利用shell脚本遍历某个目录下的所有文件](https://blog.csdn.net/chenguolinblog/article/details/12655961)