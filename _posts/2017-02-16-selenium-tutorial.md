---
layout: post
title: selenium2 入门 - 基于php
category: tech
tags: selenium spider test php
---
![](https://cdn.kelu.org/blog/tags/selenium.jpg)

Selenium 用于自动化测试，它有助于自动化Web应用程序测试。本文介绍它的快速入门配置(php版本)与一个很简单的php爬虫应用。

# Composer 安装 Selenium：

    composer require facebook/webdriver



# 安装selenium

## 本机安装

* 下载Selenium Server并启动：

  下载`Selenium Standalone Server`:<http://www.seleniumhq.org/download/>

  安装java jdk后，运行如下命令：

  ```
  java -jar selenium-server-standalone-3.0.1.jar
  ```

* 下载浏览器插件

  selenium 支持多种浏览器，我目前使用的是chrome。<http://chromedriver.storage.googleapis.com/index.html?path=2.27/>

  下载解压，你会得到一个 chromedriver.exe 文件，放到 chrome 的安装目录下（我的：C:\Program Files (x86)\Google\Chrome\Application\）,然后在 path 环境变量中添加 chrome 的安装目录。   

## docker安装

```
docker run -d --name chrome --rm -p 4444:4444 -p 5900:5900 selenium/standalone-chrome-debug
```

上面这条命令的参数含义如下：

- -d, 表示不附着容器，即容器在后台运行
- --name 是给容器定义一个名称；
- --rm 容器运行结束后即删除，方便调试使用
- -p 4444:4444 暴露宿主机的4444端口到容器的4444端口，提供 webdriver 服务；
- -p 5900:5900 暴露宿主机的5900端口，提供 VNC 远程桌面服务，如果是在 Mac 上运行，有可能5900端口已使用，可以换为5901端口，写法是 -p 5901:5900

可以用 VNC viewer 观看浏览器运行的情况。



# 运行测试代码

打开命令提示符，运行后边的文件 `php bilibili.php` 命令，最后打印了哔哩哔哩顶部的8个视频。

![](https://cdn.kelu.org/blog/2017/02/20170216221036.jpg)


![](https://cdn.kelu.org/blog/2017/02/20170216221048.jpg)

    // bilibili.php
    <?php
    namespace Facebook\WebDriver;
    
    use Facebook\WebDriver\Remote\DesiredCapabilities;
    use Facebook\WebDriver\Remote\RemoteWebDriver;
    
    require_once('vendor/autoload.php');
    
    header("Content-Type: text/html; charset=UTF-8");
    $waitSeconds = 15;  //需等待加载的时间，一般加载时间在0-15秒，如果超过15秒，报错。
    $host = 'http://localhost:4444/wd/hub'; // this is the default
    $capabilities = DesiredCapabilities::chrome();
    $driver = RemoteWebDriver::create($host, $capabilities, 5000);
    $baseUrl = 'http://www.bilibili.com/';
    $driver->get($baseUrl);
    
    echo consoleText($driver->getTitle()) . "\n";    //cmd.exe中文乱码，所以需转码
    
    $topLists = $driver->findElement(WebDriverBy::className('container-top-wrapper'))->findElement(WebDriverBy::className('top-list-wrapper'))->findElements(WebDriverBy::tagName('li'));
    
    foreach ($topLists as $topLi) {
        $itemContent = $topLi->findElement(WebDriverBy::tagName('a'));
        echo consoleText($itemContent->getAttribute('title')) . ' : ' . consoleText($itemContent->getAttribute('href')) . "\n";
    }
    
    
    //关闭浏览器
    $driver->quit();
    
    function consoleText($text, $pageEncoding = '', $consoleEncoding = '')
    {
        // windows
        if (!$consoleEncoding) {
            if (stristr(php_uname('s'), 'win')) {
                $consoleEncoding = "GBK";
            } else {
                $consoleEncoding = 'UTF-8';
            }
        }
        return exchangeEncoding($text, $pageEncoding, $consoleEncoding);
    }
    
    function exchangeEncoding($text, $pageEncoding = '', $targetEncoding = 'UTF-8')
    {
        if (!$pageEncoding) {
            $pageEncoding = mb_detect_encoding($text, array("ASCII", 'UTF-8', "GB2312", "GBK", 'BIG5'));
        }
    
        if ($pageEncoding != $targetEncoding) {
            return mb_convert_encoding($text,$targetEncoding,$pageEncoding);
        }
    
        return $text;
    }
    
    //切换至最后一个window
    function switchToEndWindow($driver)
    {
    
        $arr = $driver->getWindowHandles();
        foreach ($arr as $k => $v) {
            if ($k == (count($arr) - 1)) {
                $driver->switchTo()->window($v);
            }
        }
    }
    
    ?>

# 参考资料

* [PHP Selenium使用教程](http://www.kancloud.cn/wangking/selenium/234575)
* [最好的语言PHP + 最好的前端测试框架Selenium = 最好的爬虫](https://my.oschina.net/ppmeng/blog/800806)
* [关于反爬虫，看这一篇就够了](http://wetest.qq.com/lab/view/111.html)
* <https://github.com/facebook/php-webdriver>
* <http://facebook.github.io/php-webdriver/namespaces/default.html>
* <https://github.com/chibimagic/WebDriver-PHP/>
* <https://code.google.com/archive/p/php-webdriver-bindings/>
* <https://github.com/Element-34/php-webdriver>
* <https://github.com/Nearsoft/php-selenium-client>
* <https://github.com/SeleniumHQ/selenium/>
