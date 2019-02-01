---
layout: post
title: linux 判断图片格式
category: tech
tags: linux shell
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

# 背景

自己的blog有一些图片是转载的其他的blog的，有些blog的文章比较奇怪，没有后缀名！这种图片在电脑浏览器显示无压力，但是到了手机上往往无法显示。于是这一篇介绍linux下如何识别图片格式。下一篇介绍如何批量转换图片格式。



# 知识点

### 文件头

文件头是位于文件开头的一段承担一定任务的数据，一般都在开头的部分。

当文件都使用二进制流作为传输时，需要制定一套规范，用来区分该文件到底是什么类型的。 文件头有很多个，这里就介绍几个跟图片相关的文件头。



* JPEG (jpg)，文件头：FFD8FF
* PNG (png)，文件头：89504E47
* GIF (gif)，文件头：47494638
* RAR Archive (rar)，文件头：52617221
* WebP : 524946462A73010057454250 

# 写脚本

针对这些文件头，写了这个脚本进行判断：

```
#!/bin/bash

if [ $# != 1 ]; then
  echo "parameter error"
else
  len3=`xxd -p -l 3 $1`
  len4=`xxd -p -l 4 $1`

  if [ $len3 == "ffd8ff" ]; then
    echo "The type is jpg"
  elif [ $len4 == "89504e47" ]; then
    echo "The type is png"
  elif [ $len4 == "47494638" ]; then
    echo "The type is gif"
  elif [ $len4 == "52494646" ]; then
    echo "The type is webp"
  elif [ $len4 == "52617221" ]; then
    echo "The type is rar"
  else
    echo "The type is others"
    echo $len4
  fi

fi
```

运行后即可查看图片格式，例如：

```
./judgeImage.sh amadeus2.gif
The type is gif
```

