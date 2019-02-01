---
layout: post
title:  Disqus后的评论系统—— 基于 LeanCloud 的 Valine
category: software
tags: tech
---
![](https://cdn.kelu.org/blog/tags/leancloud.jpg)

偶然看到这个评论系统，解决了disqus被墙后的评论系统问题，现在我也在用~

使用方法：

# 一、 Leancloud 设置

1.  [注册`Leancloud`](https://leancloud.cn/dashboard/login.html#/signup)
2.  [创建应用](https://leancloud.cn/dashboard/applist.html#/newapp)
3.  选择刚刚创建的`应用`>`设置`>选择`应用 Key`，然后你就能看到`APP ID`和`APP KEY`：
    ![](https://cdn.kelu.org/blog/2018/01/006qRazegy1fibactm2csj30x80f2dhn.jpg)
4.  填写`应用`>`设置`>`安全设置`中的`Web 安全域名`：
    ![](https://cdn.kelu.org/blog/2018/01/006qRazegy1fiba67warvj30re0k5abv.jpg)
# 二、添加js代码

在文件中的 `</body>` 前插入下方的代码即可：

    <!--载入js，在</body>之前插入即可-->
    <!--Leancloud 操作库:-->
    <script src="//cdn1.lncld.net/static/js/3.0.4/av-min.js"></script>
    <!--Valine 的核心代码库-->
    <script src="./dist/Valine.min.js"></script>
    <body>
        <div class="comment"></div>
        <script>
    	 new Valine({
    		 av: AV, 
    		 el: '.comment', // 
    		 app_id: 'Your APP ID', // 这里填写上面得到的APP ID
    		 app_key: 'Your APP KEY', // 这里填写上面得到的APP KEY
    		 placeholder: 'ヾﾉ≧∀≦)o来啊，快活啊!' // [v1.0.7 new]留言框占位提示文字
    	});
      </script>
    </body>

至此，评论系统ok了。
至此，评论系统ok了。

# 三、添加管理后台

1.[打开 LeanCloud 后台](https://leancloud.cn/dashboard/#/apps)，进入云引擎设置页。

*   填写代码库并保存：[https://github.com/panjunwen/Valine-Admin.git](https://github.com/panjunwen/Valine-Admin.git)

![](https://cdn.kelu.org/blog/2018/01/ping-mu-kuai-zhao-2017-11-12-xia-wu-2-45-11.jpg)

*   切换到部署标签页，分支使用master，点击部署即可：

![](https://cdn.kelu.org/blog/2018/01/ping-mu-kuai-zhao-2017-11-12-xia-wu-2-43-52.jpg)

2.此外，你需要设置云引擎的环境变量以提供必要的信息，如下示例：

![](https://cdn.kelu.org/blog/2018/01/ping-mu-kuai-zhao-2017-11-12-xia-wu-2-46-35.jpg)

3.设置二级域名后你可以访问评论管理后台。

![](https://cdn.kelu.org/blog/2018/01/ping-mu-kuai-zhao-2017-08-15-xia-wu-6-30-12.jpg)

后台管理需要登录，**使用云存储 _User 表中的用户登录即可**。特别提醒，为确保数据安全，请合理设置数据库权限。此外，请务必设置 Web 安全域名。

4.设置完成后重启一下云引擎 实例一切就正常工作啦！

# 四、disqus评论迁移

* 去 Disqus 导出所需数据(xml)

* [Disqus2LeanCloud](http://disqus.panjunwen.com/)
（点击提交按钮后跳转至博客首页，大约一两分钟会自动导入完成）

# 参考资料

* [Valine: 独立博客评论系统 - 来自作者](https://panjunwen.com/diy-a-comment-system)
* [Valine -- 一款极简的评论系统](https://ioliu.cn/2017/add-valine-comments-to-your-blog/)
