---
layout: post
title: Python Selenium 节点的相关操作
category: tech
tags:  python selenium
---
![](https://cdn.kelu.org/blog/tags/python.jpg)

# 获取 html

	element.get_attribute('innerHTML')
	element.get_attribute('outerHTML')

# 获取内容

	element.text

# 获取属性

	element.get_attribute('data-original-title') 


# 是否存在

```python
def isElementExist(self, element, node=''):
    flag = True
	if node == '':
		node = self.driver

    try:
        node.find_element_by_xpath(element)
        return flag
    except:
        flag = False
	
	return flag
```

# 模糊匹配属性

使用 XPath：

```
//a[contains(@prop,'Foo')]
```

# 参考资料
* [Get HTML Source of WebElement in Selenium WebDriver using Python](https://stackoverflow.com/questions/7263824/get-html-source-of-webelement-in-selenium-webdriver-using-python)
* [What is the correct XPath for choosing attributes that contain “foo”?](https://stackoverflow.com/questions/103325/what-is-the-correct-xpath-for-choosing-attributes-that-contain-foo)
