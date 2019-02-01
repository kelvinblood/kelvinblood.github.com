---
layout: post
title: 使用 php 驱动 selenium 
category: tech
tags: selenium php test spider
---
![](https://cdn.kelu.org/blog/tags/selenium.jpg)

网上看到 selenium 的教程，大多是 python 或者 java 驱动的，搞得我这种 php 出身的人好尴尬。 虽然 java 和 python 都会，既然是开发，那还是挑自己拿手的先解决任务吧。于是就有了这篇文章。本文只涉及 selenium webdriver，基于 chrome 浏览器，分布式的就先不看了。

文章基本上是 [Selenium](http://www.seleniumhq.org/docs/03_webdriver.jsp) 和 [Facebook][facebook] 的文档简化后的翻译。

1. 介绍
1. Hello World
1. 参考手册
1. 窗口控制
1. 寻找元素
1. 等待
1. Ajax
1. 截图

# WebDriver介绍

Selenium 2 一个主要的新功能就是移植了 WebDriver 的 Api。

WebDriver 项目的出发点是提供一个简单快捷的编程接口，来代替 Selenium-RC 的 Api。同事，Selenium WebDriver 对动态网页的支持更好，而且它的接口是面向对象的api，对浏览器支持更加完善。

## WebDriver 与 Selenium-RC 驱动浏览器的区别

Selenium-Driver 直接调用浏览器底层支持，不同的浏览器有不同的方式。 而 Selenium-RC 在不同浏览器间的调用方式是一样的，都是以 javascript 驱动。

# 开始开发 - php版本

php 驱动 Selenium 可以参考以下三个项目的使用手册。

* [chibimagic/WebDriver-PHP](https://github.com/chibimagic/WebDriver-PHP)
* [php-webdriver-bindings](https://code.google.com/archive/p/php-webdriver-bindings/)
* [facebook/php-webdriver][facebook]

我使用的是 Facebook 版本的，所以直接看第三个。

在项目中使用 facebook/php-webdriver 很简单，在composer.json 的 require 中加入下面一行即可：
 
       "facebook/webdriver": "^1.3"
 
 hello world
 
    use Facebook\WebDriver\Remote\DesiredCapabilities;
    use Facebook\WebDriver\Remote\RemoteWebDriver;
    use Facebook\WebDriver\WebDriverBy;

    public function test(){
        $host = 'http://localhost:4444/wd/hub'; // this is the default
        $capabilities = DesiredCapabilities::chrome();
        $driver = RemoteWebDriver::create($host, $capabilities, 5000);
        $baseUrl = 'http://www.bilibili.com/';
        $driver->get($baseUrl);
    }





# 参考手册
    
## 元素操作    
    
1. 获得元素内容

        $result = $driver->findElement(WebDriverBy::id('signin'))->getText();
    
1. 触发鼠标划过事件    

        $element = $driver->findElement(WebDriverBy::id('some_id'));
        $driver->getMouse()->mouseMove( $element->getCoordinates() );
    
1. 点击元素(link, checkbox, etc.)

        $driver->findElement(WebDriverBy::id('signin'))->click();

1. 文字输入框写入文字

        $driver->findElement(WebDriverBy::id("element id"))->sendKeys("I want to send this");
    
1. 文字框清除文字

        $driver->findElement(WebDriverBy::id("element id"))->clear();
    
1. 查看元素是否可见

        $element = $driver->findElement(WebDriverBy::id('element id'));
        if ($element->isDisplayed()) {
            // do something...
        }

1. 刷新页面

        $driver->navigate()->refresh();
        
    或者使用js方法，具体看后文。

## 警告框、确认框和提示框操作

1. 警告框

        $driver->switchTo()->alert()->dismiss(); // dismiss
        $driver->switchTo()->alert()->getText(); // get alert text, works for confirmations and prompts
        
1. 确认框

        $driver->switchTo()->alert()->accept(); // accept
        $driver->switchTo()->alert()->dismiss(); // dismiss

1. 提示框

        $driver->switchTo()->alert()->sendKeys('Test'); // enter text
        $driver->switchTo()->alert()->accept(); // submit

        $driver->switchTo()->alert()->dismiss(); // dismiss

## 窗口

1. 最大化窗口

    $driver->manage()->window()->maximize();
    
## 运行js

1. 同步脚本

    js 脚本会完整地运行在闭包中。所以访问全局变量的时候必须把变量名打全，比如：`window.document`
    
        $sScriptResult = $session->executeScript('return window.document.location.hostname',array());
        $sScriptResult now holds the value of the current document hostname

1. 异步脚本

    必须告诉服务器需要等待的时长，否则服务器会抛出超时异常错误。
    
        // wait at most 5 seconds before giving up with a timeout exception
        $session->timeouts()->async_script(array('ms'=>5000));
        
    异步脚本也是运行在闭包中。
    
    * 简单的例子
    
            $sResult = $session->executeAsyncScript('arguments[arguments.length-1]("done");', array());

    * 复杂的例子

    In the example below, we poll the global window.MY_STUFF_DONE value at regular intervals, waiting for it to exist with a non-false value. Once we see it, we return back to the calling php-webdriver code with the value "done".

        // define the javascript code to execute. This just checks at a periodic
        // interval to see if your page created the window.MY_STUFF_DONE variable
        $sJavascript = <<<END_JAVASCRIPT

        var callback = arguments[arguments.length-1], // webdriver async script callback
            nIntervalId; // setInterval id to stop polling

        function checkDone() {
          if( window.MY_STUFF_DONE ) {
            window.clearInterval(nIntervalId); // stop polling
            callback("done"); // return "done" to PHP code
          }
        }

        nIntervalId = window.setInterval( checkDone, 50 ); // start polling
        END_JAVASCRIPT;

        $sResult = $session->executeAsyncScript($sJavascript,array());
        $sResult == "done"

# 窗口控制

1. 获得当前窗口句柄

        $handle = $session->getWindowHandle();

1. 获得所有窗口句柄array

        $handles = $session->getWindowHandles(); //now can iterate through array to get desired handle
    
1. 切换窗口

        $driver->switchTo()->window($handle);

1. 切换Frame

        //Find an iframe
        $iframe = $session->findElement(WebDriverBy::tagName('iframe'));

        //Get the iframe id
        $frameId = $iframe->getAttribute('id');

        //Switch the driver to the iframe
        $session->switchTo()->frame($frameId);

        <Do whatever you needed to do in the i-frame (click a link, for me)>

        //Go back to the main document
        $session->switchTo()->defaultContent(); 
        
# 寻找元素        

* Css选择器 - WebDriverBy::cssSelector('h1.foo > small')
* Xpath - WebDriverBy::xpath('(//hr)[1]/following-sibling::div[2]')
* Id - WebDriverBy::id('heading')
* Class - WebDriverBy::className('warning')
* input属性 - WebDriverBy::name('email')
* Tag - WebDriverBy::tagName('h1')
* 文字 - WebDriverBy::linkText('Sign in here')
* Partial link text - WebDriverBy::partialLinkText('Sign in')

在下面的例子中 $driver 是 RemoteWebDriver 的实例

单个元素

    $element = $driver->findElement(WebDriverBy::cssSelector('div.header'));
    // $element will be instance of RemoteWebElement

    $headerText = $element->getText();

多个元素

    $elements = $driver->findElements(WebDriverBy::cssSelector('ul.foo > li'));
    // $elements is now array - containing instances of RemoteWebElement (or empty, if no element is found)

    foreach ($elements as $element) {
        var_dump($element->getText());
    }
    
等待元素    

    $element = $driver->wait()->until(
        WebDriverExpectedCondition::presenceOfElementLocated(WebDriverBy::cssSelector('div.bar'))
    );

    $elements = $driver->wait()->until(
        WebDriverExpectedCondition::presenceOfAllElementsLocatedBy(WebDriverBy::cssSelector('ul > li'))
    );

这几个方法也有同样的效果 visibilityOfElementLocated, visibilityOf, stalenessOf, elementToBeClickable.    

# 等待
        
    // Wait for the page tile to be 'My Page'. 

    // Default wait (= 30 sec)
    $driver->wait()->until(
      WebDriverExpectedCondition::titleIs('My Page')
    );


    // Wait for at most 10s and retry every 500ms if it the title is not correct.
    $driver->wait(10, 500)->until(
      WebDriverExpectedCondition::titleIs('My Page')
    );

### title

    titleIs()
    titleContains()
    titleMatches()

### URL

    urlIs()
    urlContains()
    urlMatches()

### 元素

    presenceOfElementLocated()
    presenceOfAllElementsLocatedBy()
    elementTextIs()
    elementTextContains()
    elementTextMatches()
    textToBePresentInElementValue()

### 元素可见性

    visibilityOfElementLocated()
    visibilityOf()
    invisibilityOfElementLocated()
    invisibilityOfElementWithText()

### Frames, 窗口, 警告

    frameToBeAvailableAndSwitchToIt()
    elementToBeClickable()
    alertIsPresent()
    numberOfWindowsToBe()

### 其它

    stalenessOf()
    refreshed()
    not()
    elementToBeSelected()
    elementSelectionStateToBe()

### 自定义条件

until方法

    $driver->wait()->until(
        function () use ($driver) {
            $elements = $driver->findElements(WebDriverBy::cssSelector('li.foo'));

            return count($elements) > 5;
        },
        'Error locating more than five elements'
    );
    
### 确定的等待    

    $driver->manage()->timeouts()->implicitlyWait(10);
    
# Ajax
    
    $submitButton = $driver->findElement(WebDriverBy::id('Submit'));
    $submitButton->click();
    waitForAjax($driver); // Default is jquery same with waitForAjax($driver, 'jquery');
    //waitForAjax($driver, 'prototype');
    //waitForAjax($driver, 'dojo');
    $anotherButton = $driver->findElement(WebDriverBy::id('secondButton'));
    
关于 waitForAjax() 有两种实现，可以选择其中一张。

    function waitForAjax($driver, $framework='jquery')
    {
        // javascript framework
        switch($framework){
            case 'jquery':
                $code = "return jQuery.active;"; break;
            case 'prototype':
                $code = "return Ajax.activeRequestCount;"; break;
            case 'dojo':
                $code = "return dojo.io.XMLHTTPTransport.inFlight.length;"; break;
            default:
                throw new Exception('Not supported framework');
        }

        do {
            sleep(2);
        } while ($driver->executeScript($code));
    }

或
    
    function waitForAjax($driver, $framework='jquery')
    {
        // javascript framework
        switch($framework){
            case 'jquery':
                $code = "return jQuery.active;"; break;
            case 'prototype':
                $code = "return Ajax.activeRequestCount;"; break;
            case 'dojo':
                $code = "return dojo.io.XMLHTTPTransport.inFlight.length;"; break;
            default:
                throw new Exception('Not supported framework');
        }

        // wait for at most 30s, retry every 2000ms (2s)
        $driver->wait(30, 2000)->until(
            function ($driver, $code) {
                return !$driver->executeScript($code);
            }
        );
    }    
    
其他的实现方法看这里 <http://agilesoftwaretesting.com/?p=111>    

# 截图

使用

    $full_screenshot = TakeScreenshot();
    $screenshot_of_element = TakeScreenshot($this->driver->findElement(WebDriverBy::xpath("//img[@class='test']"));

实现

    public function TakeScreenshot($element=null) {
        // Change the Path to your own settings
        $screenshot = $this->TempDirectoryPath . time() . ".png";

        // Change the driver instance
        $this->driver->takeScreenshot($screenshot);
        if(!file_exists($screenshot)) {
            throw new Exception('Could not save screenshot');
        }
        
        if( ! (bool) $element) {
            return $screenshot;
        }
        
        $element_screenshot = $this->TempDirectoryPath . time() . ".png"; // Change the path here as well
        
        $element_width = $element->getSize()->getWidth();
        $element_height = $element->getSize()->getHeight();
        
        $element_src_x = $element->getLocation()->getX();
        $element_src_y = $element->getLocation()->getY();
        
        // Create image instances
        $src = imagecreatefrompng($screenshot);
        $dest = imagecreatetruecolor($element_width, $element_height);

        // Copy
        imagecopy($dest, $src, 0, 0, $element_src_x, $element_src_y, $element_width, $element_height);
        
        imagepng($dest, $element_screenshot);
        
        // unlink($screenshot); // unlink function might be restricted in mac os x.
        
        if( ! file_exists($element_screenshot)) {
            throw new Exception('Could not save element screenshot');
        }
        
        return $element_screenshot;
    }

# 参考资料

* [seleniumHQ document](http://www.seleniumhq.org/docs)
* [facebook/php-webdriver/wiki](https://github.com/facebook/php-webdriver/wiki)
* [Selenium 中文文档](https://wizardforcel.gitbooks.io/selenium-doc/content/official-site/selenium-web-driver.html)

[facebook]: https://github.com/facebook/php-webdriver
