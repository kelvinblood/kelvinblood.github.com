---
layout: post
title: Laravel 插件 endroid/QrCode 实现二维码
category: tech
tags: php laravel composer
---

![](https://cdn.kelu.org/blog/tags/laravel.jpg)

这是一个用于生成图片二维码的 Laravel 插件。Github 地址: <https://github.com/endroid/QrCode>

## 安装

```
$ composer require endroid/qrcode
```

## 源码示例

这个方法输出可以访问的图片http链接地址。

    use Endroid\QrCode\QrCode as Qr;

    public function qrGenerate(){
        $text = 'http://kelu.org';
        $size = 300;
        $padding = 8;
        $format = 'png';
        $qr = new Qr();
        $qr->setText($text);
        $qr->setSize($size)->setPadding($padding);

        $tmpFilename = tempnam(sys_get_temp_dir(), 'qrcode');
        $qr->render($tmpFilename, $format);

        $filename = 'qrs/'.$this->uuid '.' . $format;

        rename($tmpFilename,base_path('public/res/'.$filename));

        return asset($filename);
    }
    
## 参考资料

* [endroid/QrCode - github](https://github.com/endroid/QrCode)
