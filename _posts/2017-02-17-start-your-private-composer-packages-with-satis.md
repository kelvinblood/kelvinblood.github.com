---
layout: post
title: 使用 satis 搭建一个私有的 Composer 包仓库
category: tech
tags: php composer satis
---
![](https://cdn.kelu.org/blog/tags/composer.jpg)

在日常php开发中可能需要使用大量的composer包，大部份都可以直接使用，但公司内部有一些与业务相关的包，是不能公开的，这时候我们就需要搭建一个公司内部使用的composer仓库。

composer官方提供的工具有satis和toran proxy。 satis的搭建相对简单一些，于是我选用satis进行搭建。它的文档在[composer][getcomposer-satis] 以及 [github][github-satis]。

# 1. 建立项目

使用 Composer 自带的建项目功能，这个相当于 git clone + composer install + 运行 post-install 脚本。
    
    composer create-project composer/satis my-satis --stability=dev --keep-vcs
    
# 2. 建立配置文件

在 satis 项目目录下建立 satis.json 文件
    
    {
      "name": "仓库名称",
      "homepage": "http://satis仓库地址",
      "repositories": [
        { "type": "vcs", "url": "https://github.com/mycompany/privaterepo" },
        { "type": "vcs", "url": "http://svn.example.org/private/repo" },
        { "type": "vcs", "url": "https://github.com/mycompany/privaterepo2" }
      ],
      "require-all": true
    }
    
注意：仓库名称需要和仓库里 composer.json 的 name 定义一致，和路径没什么关系，不然就会找不到。

因为加入私有源的仓库本身可能也有依赖，require-all 会把这些依赖的信息也抓进来。如果不需要的话，可以指定某个仓库，甚至某个版本：
    
    {
      "name": "仓库名称",
      "homepage": "http://satis仓库地址/",
      "repositories": [
        { "type": "vcs", "url": "https://github.com/mycompany/privaterepo" },
        { "type": "vcs", "url": "http://svn.example.org/private/repo" },
        { "type": "vcs", "url": "https://github.com/mycompany/privaterepo2" }
      ],
      "require": {
        "company/package": "*",
        "company/package2": "*",
        "company/package3": "2.0.0"
      }
    }
    
# 3. 生成仓库列表
    
    php bin/satis build satis.json public/
    


    
# 4. 配置nginx

总之把访问地址的根目录放在public文件夹下。

# 5. 在其它项目中使用私有源

    只需要在项目的 composer.json 文件的根上添加
    
    {
      "repositories": [
        {
          "type": "composer",
          "url": "http://satis仓库地址/"
        }
      ],
      "require": {
        "company/package": "1.2.0",
        "company/package2": "1.5.2",
        "company/package3": "dev-master"
      }
    }
    
    然后执行composer update即可
    
注意：源里面只有“仓库列表”，并没有真的同步代码仓库过来，所以下载还要走托管代码的机器，比如 GitHub，内部 GitLab 等。

如果从 clone 速度太慢了，我们也可以缓存在我们的仓库中。

在satis.json中增加

    {
        "archive": {
            "directory": "dist",
            "format": "tar",
            "prefix-url": "http://packages.dev.com/",
            "skip-dev": true
        }
    }
    
    directory: 必需要的，表示生成的压缩包存放的目录，会在我们build时的目录中
    format: 压缩包格式, zip（默认） tar
    prefix-url: 下载链接的前缀的Url,默认会从homepage中取
    skip-dev: 默认为假，是否跳过开发分支
    absolute-directory: 绝对目录
    whitelist: 白名单，只下载哪些
    blacklist: 黑名单，不下载哪些
    checksum: 可选，是否验证sha1

再次生成

    php bin/satis build satis.json public/
    
会发现public目录多了一个dist目录，里面有很多tar的压缩包，这就是我们的package。 之后再执行composer update就会发现快了很多。
    
# 参考资料

* [使用 satis 搭建一个私有的 Composer 包仓库 - Composer](http://www.cnblogs.com/maxincai/p/5308284.html)
* [使用 Satis 搭建私有仓库 - segmentfault](https://segmentfault.com/a/1190000007729460#articleHeader0)
* [satis - composer][getcomposer-satis]
* [satis - github][github-satis]


[getcomposer-satis]: https://getcomposer.org/doc/articles/handling-private-packages-with-satis.md
[github-satis]: https://github.com/composer/satis

