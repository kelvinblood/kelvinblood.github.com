---
layout: post
title:   Django 入门笔记
category: tech
tags:  python django
---
![](https://cdn.kelu.org/blog/tags/python.jpg)

记录一下步骤。我是按照网上的这个教程——[Django 博客教程](http://zmrenwu.com/category/django-blog-tutorial/) 进行学习的。对应的 github 地址戳[这里](https://github.com/zmrenwu/django-blog-tutorial)。

这一篇是精简后的备忘，中间夹杂一些个人的看法。

## 开发环境准备

我的开发环境是 MacOS Sierra，Python 2.7.13 （64 位），Django 1.10.6。

Virtualenv 会从系统的 Python 环境中克隆一个全新的 Python 环境出来，这个环境独立于原来的 Python 环境。

cd ~
pip install virtualenv

新建虚拟环境

	virtualenv vens
	
激活虚拟环境

	source vens/bin/activate

## 开始项目
	
	cd workspace
	django-admin startproject blogproject

生成项目的内部的文件结构如下：
	
	blogproject\
	    manage.py
	    blogproject\
	        __init__.py
	        settings.py
	        urls.py
	        wsgi.py

`blogproject/blogproject/settings.py` 把 `LANGUAGE_CODE` 的值改为 `zh-hans`，`TIME_ZONE` 的值改为 `Asia/Shanghai`：

	LANGUAGE_CODE = 'zh-hans'
	TIME_ZONE = 'Asia/Shanghai'

### 测试运行

	python manage.py runserver

	# 自定义端口和监听地址
	python manage.py runserver 0.0.0.0:12345

Django 的规范希望我们把自己编写的代码组织到应用（Application）里，一个应用只提供一种功能。所以在 blogproject 项目中我先生成一个 blog 的应用。

	cd blogproject
	python manage.py startapp blog

生成 app 的文件结构如下：

	blog\
	    __init__.py
	    admin.py
	    apps.py
	    migrations\
	        __init__.py
	    models.py
	    tests.py
	    views.py

### 新应用注册

然后在 setting 里注册新建的这个应用，找到 `INSTALLED_APPS` 设置项，将 blog 应用添加进去。

	INSTALLED_APPS = [
	    'django.contrib.admin',
	    'django.contrib.auth',
	    'django.contrib.contenttypes',
	    'django.contrib.sessions',
	    'django.contrib.messages',
	    'django.contrib.staticfiles',
	    'blog', # 注册 blog 应用
	]

## 模型 model

django 的 model.py 既包含数据库中的字段，也包含逻辑。同时会根据 model 字段自动生成 migration。

blog/models.py

	from django.db import models
	from django.contrib.auth.models import User
	
	class Category(models.Model):
	    name = models.CharField(max_length=100)
	
	class Tag(models.Model):
	    name = models.CharField(max_length=100)
	
	class Post(models.Model):
	    title = models.CharField(max_length=70)
	    body = models.TextField()
	    created_time = models.DateTimeField()
	    modified_time = models.DateTimeField()
	    excerpt = models.CharField(max_length=200, blank=True)
	    category = models.ForeignKey(Category)
	    tags = models.ManyToManyField(Tag, blank=True)
	    author = models.ForeignKey(User)

### 生成迁移

	python manage.py makemigrations
	python manage.py migrate

> 可以运行下面的命令看看 Django 究竟为我们做了什么：
>
>	python manage.py sqlmigrate blog 0001

### 直接添加数据

	python manage.py createsuperuser
	
	Username (leave blank to use 'xxx'):  admin
	Email address:  admin@example.com
	Warning: Password input may be echoed.
	Password:  ******
	Warning: Password input may be echoed.
	Password (again):  ******
	Superuser created successfully.

### 模型注册

blog/admin.py

	from django.contrib import admin
	from .models import Post, Category, Tag
	
	admin.site.register(Post)
	admin.site.register(Category)
	admin.site.register(Tag)


## 路由

blog/urls.py

	from django.conf.urls import url
	from . import views
	
	urlpatterns = [
		url(r'^$', views.index, name='index'),
	    url(r'^post/(?P<pk>[0-9]+)/$', views.detail, name='detail'),
	]

blogproject/urls.py
	
	from django.conf.urls import url, include
	from django.contrib import admin

	urlpatterns = [
	    url(r'^admin/', admin.site.urls),
		url(r'', include('blog.urls')),
	]

## 控制器

我感觉 Django 的 views.py 虽然明明是 view，但我更倾向于他是控制器，也就是 controller。

blog/views.py

	from django.http import HttpResponse
	from django.shortcuts import render, get_object_or_404
	from .models import Post
	
	def index(request):
		return render(request, 'blog/index.html', context={
		                      'title': '我的博客首页', 
		                      'welcome': '欢迎访问我的博客首页'
		                  })

	def detail(request, pk):
	    post = get_object_or_404(Post, pk=pk)
	    return render(request, 'blog/detail.html', context={'post': post})

## 视图/模板系统

模板存放在哪里是无关紧要，只要 Django 能够找到的就好。

在 settings.py 找到 `TEMPLATES` 选项，它的内容是这样的：

blogproject/settings.py

	TEMPLATES = [
	    {
	       'DIRS': [os.path.join(BASE_DIR, 'templates')],
	    },
	]

在根目录下新建文件夹 templates\blog，在里面新建 index.html 文件即可。
简单的模板文件如下：

{%raw%}
```
	<!DOCTYPE html>
	<html lang="en">
	<head>
	    <meta charset="UTF-8">
	    <title>{{ title }}</title>
	</head>
	<body>
	<h1>{{ welcome }}</h1>
	</body>
	</html>
```
{%endraw%}


{%raw%}
用 `{{ }}` 包裹起来的叫做模板变量，其作用是在最终渲染的模板里显示由视图函数传过来的变量值。用 ```{% %}``` 包裹起来的叫做模板标签，类似于函数。
{%endraw%}

下面是一个稍微复杂一点的模板文件片段

{%raw%}
```
	{% load staticfiles %}
	....
	<link rel="stylesheet" href="{% static加 'blog/css/pace.css' %}">
	...加
	{% for post in post_list %}
	  <article class="post post-{{ post.pk }}">
	    ...
	  </article>
	{% empty %}
	  <div class="no-post">暂时还没有发布的文章！</div>
	{% endfor %}
```
{%endraw%}

static 模板标签位于 staticfiles 模块中，只有通过 load 模板标签将该模块引入后，才能在模板中使用这个标签。
具体路径是settings.py 文件中通过 `STATIC_URL = '/static/' `指定的。

### 模板父模板：

templates/base.html

{%raw%}
```
	...
	<main class="col-md-8">
	    {% block main %}
	    {% endblock main %}
	</main>
	<aside class="col-md-4">
	  {% block toc %}
	  {% endblock toc %}
	  ...
	</aside>
	...	
```
{%endraw%}

### 子模板：

templates/blog/index.html

{%raw%}
```
	{% extends 'base.html' %}
	
	{% block main %}
	    {% for post in post_list %}
	        <article class="post post-1">
	          ...
	        </article>
	    {% empty %}
	        <div class="no-post">暂时还没有发布的文章！</div>
	    {% endfor %}
	    <div class="pagination">
	      ...
	    </div>
	{% endblock main %}
```
{%endraw%}

## 插件markdown

	pip install markdown

blog/views.py

{%raw%}
```
	import markdown
	from django.shortcuts import render, get_object_or_404
	from .models import Post
	
	def detail(request, pk):
	    post = get_object_or_404(Post, pk=pk)
	    post.body = markdown.markdown(post.body,
	                                  extensions=[
	                                     'markdown.extensions.extra',
	                                     'markdown.extensions.codehilite',
	                                     'markdown.extensions.toc',
	                                  ])
	    return render(request, 'blog/detail.html', context={'post': post})
```
{%endraw%}

### 插件Pygments

	pip install Pygments

引入样式 css

{%raw%}
	<link rel="stylesheet" href="{% static 'blog/css/high加lights/github.css' %}">
{%endraw%}

## 总结

简单的 Django 加就这么多了。基本上已经将它的结构理清楚了。剩下的就是熟悉更多的 Django 的方法和细节了。
