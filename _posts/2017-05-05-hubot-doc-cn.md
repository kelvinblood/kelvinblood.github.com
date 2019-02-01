---
layout: post
title:  Hubot 脚本与开发文档一 中文
category: tech
tags: linux
---

![](https://cdn.kelu.org/blog/tags/hubot.jpg)

每次看英文文档都有点头疼，做了一些简要的翻译给自己看。 
原文请看<https://hubot.github.com/docs/scripting/>

目录：

* 接收和回复
* 给指定群组或用户的消息
* 捕获数据
* 进行HTTP调用
* 随机
* Topic
* 进入和离开聊天室
* 自定义房间人员
* 环境变量
* 依赖
* HTTP监听器
* 事件
* 错误处理
* 记录脚本
* 持久化
* 脚本

    * 加载脚本
    * 共享脚本
 
* 中间件

    * 监听中间件
    * 接收中间件
    * 回复中间件
   
* 测试

正文：

安装好hubot后，根目录下会生成一个 scripts 目录，里面有个可用的 demo 文件`example.coffee`，大致如下：

    # Description:
    #   Example scripts for you to examine and try out.
    #
    # Notes:
    #   They are commented out by default, because most of them are pretty silly and
    #   wouldn't be useful and amusing enough for day to day huboting.
    #   Uncomment the ones you want to try and experiment with.
    #
    #   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

    module.exports = (robot) ->

     robot.hear /kelutest/i, (res) ->
       res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"
      #
      # robot.respond /open the (.*) doors/i, (res) ->
      #   doorType = res.match[1]
      #   if doorType is "pod bay"
      #     res.reply "I'm afraid I can't let you do that."
      #   else
      #     res.reply "Opening #{doorType} doors"

要使得你编写的script生效，需要满足一下三个条件：

* 在scripts文件夹中
* .coffee 或 .js 文件
* 导出一个方法

        module.exports = (robot) ->
          # your code here



# 接收和回复

    module.exports = (robot) ->
      robot.hear /badger/i, (res) ->
        res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"
    
      robot.respond /open the pod bay doors/i, (res) ->
        res.reply "I'm afraid I can't let you do that."
    
      robot.hear /I like pie/i, (res) ->
        res.emote "makes a freshly baked pie"

* hear 所有匹配信息
* send 发送消息
* respond 群组消息中只处理@自己的信息
* reply 群组消息中回复特定人的消息

# 给指定群组或用户的消息

可以使用messageRoom函数发送到指定的房间或用户，可以明确地指定用户名（对于管理员/管理员），或者使用响应对象将私人消息发送到原始发件人。

      robot.respond /I don't like Sam-I-am/i, (res) ->
        room =  'joemanager'
        robot.messageRoom room, "Someone does not like Dr. Seus"
        res.reply  "That Sam-I-am\nThat Sam-I-am\nI do not like\nthat Sam-I-am"

      robot.hear /Sam-I-am/i, (res) ->
        room =  res.envelope.user.name
        robot.messageRoom room, "That Sam-I-am\nThat Sam-I-am\nI do not like\nthat Sam-I-am"

# 捕获数据

res.match 存有 match 传入消息与正则表达式的结果。这是一个数组，索引起始是0。比如：

      robot.respond /open the (.*) doors/i, (res) ->
        doorType = res.match[1]
        if doorType is "pod bay"
          res.reply "I'm afraid I can't let you do that."
        else
          res.reply "Opening #{doorType} doors"
          
# 进行HTTP调用

Hubot可以集成使用第三方API。 通过 [node-scoped-http-client][1] 插件的robot.http,可以进行http调用。 最简单的情况如下：

get:

       robot.http("http://blog.kelu.org")
         .get() (err, res, body) ->
           # your code here
           
post:           

        data = JSON.stringify({
          foo: 'bar'
        })
        robot.http("http://blog.kelu.org")
          .header('Content-Type', 'application/json')
          .post(data) (err, res, body) ->
            # your code here     
            
处理错误：
            
      robot.http("https://midnight-train")
        .get() (err, res, body) ->
          if err
            res.send "Encountered an error :( #{err}"
            return
          # your code here, knowing it was successful            

如果需要处理返回头部信息，应该如下操作：

      robot.http("https://midnight-train")
        .get() (err, res, body) ->
          # pretend there's error checking code here

          if res.statusCode isnt 200
            res.send "Request didn't come back HTTP 200 :("
            return

          rateLimitRemaining = parseInt res.getHeader('X-RateLimit-Limit') if res.getHeader('X-RateLimit-Limit')
          if rateLimitRemaining and rateLimitRemaining < 1
            res.send "Rate Limit hit, stop believing for awhile"

          # rest of your code
          res.send "Got back #{body}"
      
### json

我们可以使用 json.parse 进行解析，有可能得到非JSON，为了安全起见，应该检查Content-Type ，并在解析时捕获错误。

      robot.http("https://midnight-train")
        .header('Accept', 'application/json')
        .get() (err, res, body) ->
          # err & response status checking code here

          if response.getHeader('Content-Type') isnt 'application/json'
            res.send "Didn't get back JSON :("
            return

          data = null
          try
            data = JSON.parse body
          catch error
           res.send "Ran into an error parsing JSON :("
           return

          # your code here

### xml 

比较麻烦，可以参考以下几个库：

* [xml2json](https://github.com/buglabs/node-xml2json) (使用简单，容易受限)
* [jsdom](https://github.com/tmpvar/jsdom)
* [xml2js](https://github.com/Leonidas-from-XIV/node-xml2js)

### 截图

参考以下库

* cheerio (familiar syntax and API to jQuery)
* jsdom (JavaScript implementation of the W3C DOM)

### 高级HTTP和HTTPS设置

如上所述，hubot使用 [node-scoped-http-client][1] 来提供一个简单的接口来进行HTTP和HTTPS请求。

如果需要更直接地控制http和https，则将第二个参数传递给robot.http ，该参数将被传递给节点robot.http -http-client，该参数将传递给http和https：

      options =
        # don't verify server certificate against a CA, SCARY!
        rejectUnauthorized: false
      robot.http("https://midnight-train", options)
      
如果 node-scoped-http-client 不满足需求，我们也可以直接使用http和https ，或者其他节点库（如[request/request](https://github.com/request/request)） 。

# 随机

    lulz = ['lol', 'rofl', 'lmao']

    res.send res.random lulz

# Topic
  
可以修改房间的主题
  
      module.exports = (robot) ->
        robot.topic (res) ->
          res.send "#{res.message.text}? That's a Paddlin'"

# 进入和离开聊天室

    enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
    leaveReplies = ['Are you still there?', 'Target lost', 'Searching']

    module.exports = (robot) ->
      robot.enter (res) ->
        res.send res.random enterReplies
      robot.leave (res) ->
        res.send res.random leaveReplies



[1]: https://github.com/technoweenie/node-scoped-http-client