---
layout: post
title: Python Selenium 中 Chrome 的一些设置参数
category: tech
tags:  python selenium
---
![](https://cdn.kelu.org/blog/tags/python.jpg)

# cookie

```
mport pickle
import selenium.webdriver 

driver = selenium.webdriver.Chrome()
driver.get("http://www.google.com")
pickle.dump( driver.get_cookies() , open("cookies.pkl","wb"))
```


```
import pickle
import selenium.webdriver 

driver = selenium.webdriver.Chrome()
driver.get("http://www.google.com")
cookies = pickle.load(open("cookies.pkl", "rb"))
for cookie in cookies:
    driver.add_cookie(cookie)
```

注意使用时要先访问目标的网址，再加载 cookie，否则可能会出现下面两个错误：

* failed to set the 'cookie' property on 'document' access is denied for this document
* Cookies are disabled inside 'data:' URLs

以下转载自[selenium 怎样设置请求头？](https://www.zhihu.com/question/35547395)

### 目录

*   一：selenium设置phantomjs请求头：
*   二：selenium设置chrome请求头：
*   三：selenium设置chrome--cookie：
*   四：selenium设置phantomjs-图片不加载：

### 一：selenium设置phantomjs请求头：

```text
# !/usr/bin/python
# -*- coding: utf-8 -*-

from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities

dcap = dict(DesiredCapabilities.PHANTOMJS)
dcap["phantomjs.page.settings.userAgent"] = (
"Mozilla/5.0 (Linux; Android 5.1.1; Nexus 6 Build/LYZ28E) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.23 Mobile Safari/537.36"
)
driver = webdriver.PhantomJS(desired_capabilities=dcap)
driver.get("https://httpbin.org/get?show_env=1")
driver.get_screenshot_as_file('01.png')
driver.quit()

```

### 二：selenium设置chrome请求头：

来源[selenium设置Chrome - TTyb - 博客园](https://link.zhihu.com/?target=http%3A//www.cnblogs.com/TTyb/p/6128323.html) 感恩原作者

如代码

```text
# !/usr/bin/python
# -*- coding: utf-8 -*-

from selenium import webdriver
# 进入浏览器设置
options = webdriver.ChromeOptions()
# 设置中文
options.add_argument('lang=zh_CN.UTF-8')
# 更换头部
options.add_argument('user-agent="Mozilla/5.0 (iPod; U; CPU iPhone OS 2_1 like Mac OS X; ja-jp) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5F137 Safari/525.20"')
browser = webdriver.Chrome(chrome_options=options)
url = "https://httpbin.org/get?show_env=1"
browser.get(url)
browser.quit()

```

### 三：selenium设置chrome--cookie：

cookie用于模拟登陆

```text
# !/usr/bin/python
# -*- coding: utf-8 -*-

from selenium import webdriver
browser = webdriver.Chrome()

url = "https://www.baidu.com/"
browser.get(url)
# 通过js新打开一个窗口
newwindow='window.open("https://www.baidu.com");'
# 删除原来的cookie
browser.delete_all_cookies()
# 携带cookie打开
browser.add_cookie({'name':'ABC','value':'DEF'})
# 通过js新打开一个窗口
browser.execute_script(newwindow)
input("查看效果")
browser.quit()

```

### 四：selenium设置phantomjs-图片不加载：

```text
from selenium import webdriver

options = webdriver.ChromeOptions()
prefs = {
    'profile.default_content_setting_values': {
        'images': 2
    }
}
options.add_experimental_option('prefs', prefs)
browser = webdriver.Chrome(chrome_options=options)

# browser = webdriver.Chrome()
url = "http://image.baidu.com/"
browser.get(url)
input("是否有图")
browser.quit()

```


# 参考资料

* [How to save and load cookies using python selenium webdriver](https://stackoverflow.com/questions/15058462/how-to-save-and-load-cookies-using-python-selenium-webdriver)

* [selenium 怎样设置请求头？](https://www.zhihu.com/question/35547395)

