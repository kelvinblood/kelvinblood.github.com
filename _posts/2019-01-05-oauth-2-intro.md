---
layout: post
title: 猴子都能懂的 OAuth2.0 图解 - LaravelChina
category: tech
tags: 
---
![](https://cdn.kelu.org/blog/tags/analysis.jpg)

> 确实是猴子都能懂。原文:<https://laravel-china.org/courses/laravel-shop/5.7/module-division/2738>

#### 1.我们这里有一份用户的数据

[![file](https://cdn.kelu.org/blog/2019/01/KRpBtnsMLX.jpg)](https://cdn.kelu.org/blog/2019/01/KRpBtnsMLX.jpg)

#### 2.用户的数据我们保存在**资源服务器(Resource server)**里

[![file](https://cdn.kelu.org/blog/2019/01/fze9WaYp3A.jpg)](https://cdn.kelu.org/blog/2019/01/fze9WaYp3A.jpg)

#### 3.这时候有个 **第三方应用程序（Third-party application）**想要请求资源服务器要用户数据

[![file](https://cdn.kelu.org/blog/2019/01/mdZmTbzEXq.jpg)](https://cdn.kelu.org/blog/2019/01/mdZmTbzEXq.jpg)

#### 4.为了让用户数据和第三方程序程序良好的交互，资源服务器准备了一个API接口

[![file](https://cdn.kelu.org/blog/2019/01/Qt4ZBDTd7o.jpg)](https://cdn.kelu.org/blog/2019/01/Qt4ZBDTd7o.jpg)

#### 5.第三方应用程序向资源服务器请求用户的数据

[![file](https://cdn.kelu.org/blog/2019/01/05F3j94O87.jpg)](https://cdn.kelu.org/blog/2019/01/05F3j94O87.jpg)

#### 6.资源服务器表示好的给你了

[![file](https://cdn.kelu.org/blog/2019/01/zVOXLeDcUV.jpg)](https://cdn.kelu.org/blog/2019/01/zVOXLeDcUV.jpg)

#### 7.但如果这个第三方应用程序是恶意的第三方呢？那么就会有以下的场景出现

[![file](https://cdn.kelu.org/blog/2019/01/bf2LnSbcXf.jpg)](https://cdn.kelu.org/blog/2019/01/bf2LnSbcXf.jpg)

#### 8.所以我们需要一个机制来保护API接口，不能随随便便毫无安全可言的把用户的数据送出去

[![file](https://cdn.kelu.org/blog/2019/01/TGPLZmsyV8.jpg)](https://cdn.kelu.org/blog/2019/01/TGPLZmsyV8.jpg)

#### 9.这个最佳实践就事先在第三方程序里保存一个**令牌access_token**

[![file](https://cdn.kelu.org/blog/2019/01/Y2UmGuxQSj.jpg)](https://cdn.kelu.org/blog/2019/01/Y2UmGuxQSj.jpg)

#### 10.第三方应用程序在向资源服务器请求用户数据的时候会出示这个access_token

[![file](https://cdn.kelu.org/blog/2019/01/4pNqw5MIHk.jpg)](https://cdn.kelu.org/blog/2019/01/4pNqw5MIHk.jpg)

#### 11.然后资源服务器取出授权码并且验证是否有授权

[![file](https://cdn.kelu.org/blog/2019/01/rwl3r9wg0z.jpg)](https://cdn.kelu.org/blog/2019/01/rwl3r9wg0z.jpg)

#### 12.授权通过，资源服务器才会把用户数据传递给第三方应用程序

[![file](https://cdn.kelu.org/blog/2019/01/V5Lh5kIdFL.jpg)](https://cdn.kelu.org/blog/2019/01/V5Lh5kIdFL.jpg)

#### 13.但这种方案需要事先给第三方access_token

[![file](https://cdn.kelu.org/blog/2019/01/OrXuZI0jtj.jpg)](https://cdn.kelu.org/blog/2019/01/OrXuZI0jtj.jpg)

#### 14.所以我们需要一个东西用来发行这个access_token，这时候认证服务器 **（Authorization server）**登场了

[![file](https://cdn.kelu.org/blog/2019/01/HIURqPZ1GO.jpg)](https://cdn.kelu.org/blog/2019/01/HIURqPZ1GO.jpg)

#### 15.认证服务器负责生成并且发行access_token给第三方应用程序

[![file](https://cdn.kelu.org/blog/2019/01/FtmJSOtQPX.jpg)](https://cdn.kelu.org/blog/2019/01/FtmJSOtQPX.jpg)

#### 16.接下来我们看一下目前的登场的人物有

- 第三方应用程序

- 资源服务器

- 认证服务器

- access_token

- 用户数据

  > 资源服务器和认证服务器有时候是同一台服务器

[![file](https://cdn.kelu.org/blog/2019/01/fltJJrMq4k.jpg)](https://cdn.kelu.org/blog/2019/01/fltJJrMq4k.jpg)

#### 17.接下来我们来走一下流程 认证服务器生成access_token

[![file](https://cdn.kelu.org/blog/2019/01/Ex6H7Ih123.jpg)](https://cdn.kelu.org/blog/2019/01/Ex6H7Ih123.jpg)

#### 18.认证服务器发行access_token授权给第三方应用程序

[![file](https://cdn.kelu.org/blog/2019/01/oDCnodEpiv.jpg)](https://cdn.kelu.org/blog/2019/01/oDCnodEpiv.jpg)

#### 19.第三方应用程序拿着access_token去找资源服务器要用户数据

[![file](https://cdn.kelu.org/blog/2019/01/WLsKH2yy7t.jpg)](https://cdn.kelu.org/blog/2019/01/WLsKH2yy7t.jpg)

#### 20.资源服务器取出来access_token并验证

[![file](https://cdn.kelu.org/blog/2019/01/5g6pftC4aR.jpg)](https://cdn.kelu.org/blog/2019/01/5g6pftC4aR.jpg)

#### 21.验证通过 用户数据送出

[![file](https://cdn.kelu.org/blog/2019/01/pav3Vqm5ts.jpg)](https://cdn.kelu.org/blog/2019/01/pav3Vqm5ts.jpg)

#### 22. 问题点来了

> 到上面为止有个很大的问题就是，认证服务器生成access_token竟然没人管！那岂不是随便发行了，这不行，于是我们的**用户** （**Resource Owner：资源所有者**）出现了！

[![file](https://cdn.kelu.org/blog/2019/01/7IcnQFdFUt.jpg)](https://cdn.kelu.org/blog/2019/01/7IcnQFdFUt.jpg)

#### 23. 解决

> 认证服务器在发行access_token之前要先通过用户的同意

#### 24. 于是接下来就是

1. 第三方应用程序向认证服务器要access_token[![file](https://cdn.kelu.org/blog/2019/01/jmlfArxU97-1548563986164.jpg)](https://cdn.kelu.org/blog/2019/01/jmlfArxU97.jpg)

2. 认证服务器生成之前先问问用户能不能授权啊[![file](https://cdn.kelu.org/blog/2019/01/H6q33OXpjp.jpg)](https://cdn.kelu.org/blog/2019/01/H6q33OXpjp.jpg)

3. 用户说好的可以给[![file](https://cdn.kelu.org/blog/2019/01/OjIpgsDzyh.jpg)](https://cdn.kelu.org/blog/2019/01/OjIpgsDzyh.jpg)

4. 认证服务器生成access_token并且发行给第三方应用程序

   ![file](https://cdn.kelu.org/blog/2019/01/9Nqg3FeQxD.jpg)

   ​

   #### 25. oAuth2.0

   > 第三方应有程序和这个认证服务器之间围绕着access_token进行请求和响应的等等就是oAuth2.0
   >
   > [![file](https://cdn.kelu.org/blog/2019/01/fSeiZqvmoy.jpg)](https://cdn.kelu.org/blog/2019/01/fSeiZqvmoy.jpg)
   >
   > ​

 