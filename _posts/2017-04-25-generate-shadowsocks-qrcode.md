---
layout: post
title: shadowsocks 生成二维码 URI
category: tech
tags: proxy
---

![](https://cdn.kelu.org/blog/tags/encoding.jpg)

假设我们的配置文件如下：

    {
        "server":"hostname",
        "server_port":8388,
        "local_port":1080,
        "password":"barfoo!",
        "timeout":600,
        "method":"aes-256-cfb"
    }
    
1. 编码前的 URI 格式：

        ss://method:password@hostname:port

    例如，在上边的配置文件中， URI 格式应该如下：

        ss://aes-256-cfb:barfoo!@hostname:8388
    
1. 经过base64编码后的 URI 格式：

        ss://BASE64-ENCODED-STRING-WITHOUT-PADDING

最后把这个URI转成 QR 二维码。

php 代码示例如下：

    public function qrUrl($host = '10.1.10.41')
    {
        $uri = "aes-256-cfb:" . $this->password . "@" . $host . ":" . $this->port;
        $base64 = base64_encode($uri);
        return 'ss://' . $base64;
    }

## 参考资料

* [shadowsocks.org](https://shadowsocks.org/en/config/quick-guide.html)
