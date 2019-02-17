---
layout: post
title: Slack/Hubot
category: tech
tags: slack hubot github devops nodejs npm tutorial
---

想拥有一个自己的hubot也有一段时间了。

虽然很早就开始用slack，都是用来配合ifttt耍的，还不知道这么一个大杀器。Slack 是聊天群组 + 大规模工具集成 + 文件整合 + 统一搜索。截至2014年底，Slack 已经整合了电子邮件、短信、Google Drives、Twitter、Trello、Asana、GitHub 等 65 种工具和服务，把可以把各种碎片化的企业沟通和协作集中到一起。

后来订阅了湾区日报。看了一些文章后才发现的，确实是个好东西。工作忙里偷闲，按照slack API里 [Slack Developer Kit for Hubot][slack-hubot-api] 的内容一步一步走来。目前对里面的一些产品插件都还不了解，先记录下来，以后再慢慢补充了。

Hubot是由Github开发的开源聊天机器人，基于Node.js采用CoffeeScript编写。 

* Hubot <https://hubot.github.com/>
* Hubot Scripts <https://github.com/hubot-scripts>
* Hubot Control <https://github.com/spajus/hubot-control> 

可以借助Hubot开发Chatbot来自动化的完成想要一切自动化任务，比如： 

* 运维自动化（编译部署代码、重启机器，监控服务器运行情况，自动修复Bug等） 
* 外部服务交互（管理Redmine、集成Jenkins、监视Zabbix等） 
* 定时获取天气预报 
* 随机订餐 
* 聊天机器人等等。 

# 1.安装node和npm环境

可以访问我的[gist](https://gist.github.com/kelvinblood/fef5a31e69b099c3a0225a12481923d7)下载。

	chmod a+x NodejsInstall.sh

然后就要经过漫长的等待（我的机器性能一般，大概是1个小时）。
安装完成后，node就安装好了。在安装node的同时，npm也安装到了你的服务器上。通过下面的命令查看node和npm的版本号信息。

	node -v
	npm -v

由于npm更新的速度会比node更快一些，所以运行下面的命令可以保证你的npm保持最新。

	npm install npm@latest -g

# 2.安装slack/Hubot kit

使用下面的命令快速安装[Yeoman][Yeoman] 和 [hubot][hubot] 。Yeoman可以辅助我们快速安装hubot。

	npm install -g yo generator-hubot

安装好环境后，在我们感兴趣的目录下，可以开始新建我们的hubot项目了。

如果你是以root用户安装的话，记得要给相关的文件夹赋权限。 要不然就会像下面这样。

    EACCES: permission denied, open '/root/.config/configstore/insight-yo.json'
    You don't have access to this file.

赋予配置文件权限，新建项目:

    chmod g+rwx /root /root/.config /root/.config/configstore /root/.npm
    
    mkdir my-awesome-hubot
    chmod 777 my-awesome-hubot 
    cd my-awesome-hubot
    yo hubot --adapter=slack

同时你还需要去hubot页面生成你的机器人[API Token][Integration_setting]。在获得api token之后，你可以运行以下命令跑起来了。

    HUBOT_SLACK_TOKEN=xoxb-YOUR-TOKEN-HERE ./bin/hubot --adapter slack

​    
# 3. 让 hubot 执行 shell 脚本    

    npm install hubot-script-shellcmd
    cp -R node_modules/hubot-script-shellcmd/bash ./

修改一下external-scripts.json，添加上以下模块：hubot-script-shellcmd。如果到此为止，你操作的步骤和我基本一样的话，你的external-scripts.json应该长的像这个样子：

    [
      "hubot-diagnostics",
      "hubot-help",
      "hubot-google-images",
      "hubot-google-translate",
      "hubot-pugme",
      "hubot-maps",
      "hubot-rules",
      "hubot-shipit",
      "hubot-script-shellcmd"
    ]

接下来：

    cd bash/handlers

这里面的 helloworld 就是个例子，可以改成自己的脚本。运行的话，如果在群组内，需要@xxx（xxx为机器人的名字，例如hubot）

    hubot shellcmd helloworld

如果是私人会话，可以直接回复

   shellcmd helloworld

我们可以完成任意想要的脚本，例如下面的脚本将计算CPU的使用率。

    #!/bin/bash
    top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.1f%%\n", prefix, 100 - v }'
    
    exit 0

将文件命名成cpu，只要运行`shellcmd cpu`,就可以了。

# 4. 高级配置   

# 5. 其他开发

参考 [hubot][hubot_doc] 的两个文档 scripting 和 patterns，写的非常详细。下面是个简单的例子，将收到的信息转发到网站。
    
    module.exports = (robot) ->
        robot.listen(
            (message) ->
                message.user.name is "你的Slack用户名" #这里限制只对我的回复做响应
                robot.brain.set 'message', message.rawText
            (response) ->
                req = "data=" + JSON.stringify({
                    message: robot.brain.get('message'),
                })  
                robot.http("http://test.com/api") # 改为你自己的接口地址
                    .header('Content-Type: application/x-www-form-urlencoded;charset=utf-8')
                    .post(req) (err, res, body) ->
                        if err 
                            response.reply "请求接口失败" 
                            robot.emit 'error', err, res 
                            return
                        if res.statusCode isnt 200 
                            response.reply "接口返回非200"
                            return
                        response.send body
        )    

# 参考资料
# 参考资料

* [node.js](https://nodejs.org/en/download/)
* [Slack/Hubot - 简书](http://www.jianshu.com/p/e5015327f900)
* [湾区日报的第一个“员工”：Slack/Hubot - 湾区日报](https://wanqu.co/b/8/2015-08-19-slack-hubot.html)
* [slackapi/hubot-slack - github](https://github.com/slackapi/hubot-slack)
* [hubot.github.com - hubot][hubot]
* [github/hubot-scripts - hubot](https://github.com/github/hubot-scripts/tree/master/src/scripts)
* [Slack Developer Kit for Hubot - SlackAPI][slack-hubot-api]
* [Start automating your business tasks with Slack - howdy.ai](https://blog.howdy.ai/what-will-the-automated-workplace-look-like-495f9d1e87da#.d7jn5l8x9)
* [The New York Times built a Slack bot to help decide which stories to post to social media - niemanlab](http://www.niemanlab.org/2015/08/the-new-york-times-built-a-slack-bot-to-help-decide-which-stories-to-post-to-social-media/)
* [How 7 news organizations are using Slack to work better and differently - niemanlab](http://www.niemanlab.org/2015/07/how-7-news-organizations-are-using-slack-to-work-better-and-differently/)
* [The Most Important Startup’s Hardest Worker Isn’t a Person - wired.com](https://www.wired.com/2015/10/the-most-important-startups-hardest-worker-isnt-a-person/)
* [Slack Is Overrun With Bots. Friendly, Wonderful Bots - wired.com](https://www.wired.com/2015/08/slack-overrun-bots-friendly-wonderful-bots/)
* [zhihubot 搭建 - Hello, SA](http://blog.hellosa.org/2012/02/22/zhihubot.html)
* [开发Hubot聊天机器人](http://rensanning.iteye.com/blog/2329278)
* [用slack和hubot搭建你自己的运维机器人 - segmentfault](https://segmentfault.com/a/1190000006681056)
* [使用Slack和Hubot搭建自己的机器人](https://www.liudon.org/1329.html)
* [eaccess permission denied when trying to use yo - github issue](https://github.com/yeoman/yeoman.github.io/issues/282)


[Yeoman]: http://yeoman.io/
[hubot]: https://hubot.github.com/
[hubot_doc]: https://hubot.github.com/docs/patterns/
[Integration_setting]: https://my.slack.com/apps/A0F7YS25R-bots
[slack-hubot-api]: https://slackapi.github.io/hubot-slack/
