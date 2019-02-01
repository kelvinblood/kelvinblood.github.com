---
layout: post
title:   简单的 v2ex 自动签到程序 —— 基于 Python Selenium
category: tech
tags: python selenium
---
![](https://cdn.kelu.org/blog/tags/python.jpg)

最近看了点 Selenium 的东西，随手写的一个demo，使用 Chrome 内核，模拟用户每日签到的动作，比较简单的。

	# -*- coding:utf-8 -*- 

	from selenium import webdriver
	import time
	import random
	from selenium.webdriver.common.by import By
	from selenium.webdriver.support.ui import WebDriverWait
	from selenium.webdriver.support import expected_conditions as EC
	from selenium.webdriver.common.action_chains import ActionChains
	
	username = "" 
	password = "" 
	driver = webdriver.Chrome()
	baseUrl = 'https://www.v2ex.com' 
	loginUrl = '/signin' 
	daliyUrl = '/mission/daily'   

	driver.get(baseUrl)
	print 'Enter ' + driver.title
	
	time.sleep(random.randint(4,9))
	driver.get(baseUrl + loginUrl)
	
	print 'Enter ' + driver.title
	
	tr_elems = driver.find_element_by_id('Main').find_element_by_tag_name('form').find_elements_by_tag_name('tr')
	
	for index, tr_elem in enumerate(tr_elems):
	    if index == 0:
	        td_elems = tr_elem.find_elements_by_tag_name('td')
	        td_name = td_elems[0]
	        td_input = td_elems[1].find_element_by_tag_name('input')
	        ActionChains(driver).move_to_element(td_input).perform()
	
	        print td_name.text
	        td_input.send_keys(username)
	    if index == 1:
	        td_elems = tr_elem.find_elements_by_tag_name('td')
	        td_name = td_elems[0]
	        td_input = td_elems[1].find_element_by_tag_name('input')
	        ActionChains(driver).move_to_element(td_input).perform()
	
	        print td_name.text
	        td_input.send_keys(password)
	    if index == 2:
	        td_elems = tr_elem.find_elements_by_tag_name('td')
	        td_input = td_elems[1].find_elements_by_tag_name('input')[1]
	        ActionChains(driver).move_to_element(td_input).perform()
	
	        td_input.click()
	
	# 登录成功就切到新页面 
	try:
	    mainPage = WebDriverWait(driver, 20).until(
	        EC.presence_of_element_located((By.ID, "Rightbar"))
	    )
	except:
	    print "login error" else:
	    print 'login ok. Enter ' + driver.title
	
	try:
	    dailyButton = WebDriverWait(driver, 1).until(
	        EC.presence_of_element_located((By.XPATH, "//a[contains(text(),'领取今日的登录奖励')]"))
	    )
	except:
	    print "no daily corn" else:
	    dailyButton = driver.find_element_by_xpath("//a[contains(text(),'领取今日的登录奖励')]")
	    ActionChains(driver).move_to_element(dailyButton).click(dailyButton).perform()
	
	time.sleep(random.randint(4,9))
	print 'Enter ' + driver.title
	
	try:
	    dailyButton = WebDriverWait(driver, 20).until(
	        EC.presence_of_element_located((By.XPATH, "//input[contains(@value,'领取')]"))
	    )
	except:
	    print "no daily corn"   
	else:
	    print "get daily corn"
	  	dailyButton = driver.find_element_by_xpath("//input[contains(@value,'领取')]")
	    ActionChains(driver).move_to_element(dailyButton).click(dailyButton).perform()

# 参考资料

* [selenium-python中文文档](http://python-selenium-zh.readthedocs.io/zh_CN/latest/)
* [又一个 Selenium-Python中文文档](http://selenium-python-zh.readthedocs.io/en/latest/index.html)
* [Python爬虫利器五之Selenium的用法](http://cuiqingcai.com/2599.html)
* [Python selenium —— 模拟鼠标键盘操作(ActionChains)](https://huilansame.github.io/huilansame.github.io/archivers/mouse-and-keyboard-actionchains)
* [让 Selenium 稳定运行的技巧](https://testerhome.com/topics/7359)
* [Get HTML Source of WebElement in Selenium WebDriver using Python](https://stackoverflow.com/questions/7263824/get-html-source-of-webelement-in-selenium-webdriver-using-python)
* [Python selenium —— 父子、兄弟、相邻节点定位方式详解](https://huilansame.github.io/huilansame.github.io/archivers/father-brother-locate)
* [webdriver实用指南python版本](https://www.gitbook.com/book/wangxiwei/webdriver-python/details)
* [灰蓝](https://huilansame.github.io/huilansame.github.io/)
