---
layout: post
title: 恶意代码分析必备知识 - 简书
category: tech
tags: security
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

## 反病毒软件原理

- 反病毒软件一般由扫描器、病毒库和虚拟机组成，并由主程序将它们整合为一体
- 一般情况下，扫描器用于查杀病毒，是反病毒软件的核心。一个反病毒软件的效果好坏直接取决于扫描器的技术与算法是否先进
- 病毒库中存储着病毒所具有的独一无二的特征字符，我们称之为“特征码”，而病毒库存储特征码的存储形式则取决于扫描器采用哪种扫描技术
- 特征码可能存在于任何文件中，例如exe文件、dll文件、apk文件、php文件、甚至是TXT文件中，所以它们都有可能被查杀。
- 虚拟机，可以使病毒在一个反病毒软件构建的虚拟机环境中执行，这样就与现实的cpu、硬盘等物理设备完全隔离，从而可以更加深入的检测文件的安全性

## 常见的防病毒技术（基于文件扫描）

基于文件扫描的反病毒技术可以分为：
“第一代扫描技术”
“第二代扫描技术”
“算法扫描”
对于恶意代码分析师来说，非常有必要对每一种扫描技术有所了解

第一代扫描技术可以用“在文件中检索病毒特征序列”这句话高度概括，这一扫描技术直到现在也仍然被各大反病毒软件厂商使用着，其主要分为“字符串扫描技术”与“通配符扫描技术”两种。

第二代扫描技术的代表有

- 智能扫描法
- 近似精确识别法
- 骨架扫描法
- 精确识别法

### 智能扫描法

这种方法是在大量变异病毒出现后提出的。智能扫描法会忽略检测文件中像nop这种无意义的指令。而对于文本格式的脚本病毒或者宏病毒，则可以替换掉多余的格式字符，例如空格，换行符，制表符等。由于这一切替换动作往往是在扫描缓冲区中执行的，从而大大提高了扫描器的检测能力

### 近似精确识别法

#### 多套特征码

该方法采用两个或者更多的字符集来检测每一个病毒，如果扫描器检测到其中一个特征符合，那么就会警告发现变种，但不会执行下一步操作。如果多个特征码全部符合，则报警发现病毒，并执行下一步操作

#### 检验和

这个方法的思路是让每一个无毒的文件生成一个校验和，等待下次扫描时再进行简单的校验和对比。如果校验值有所变化，再做进一步的扫描，否则就说明这个文件没有被感染，这样有利于提升扫描器的效率。除此之外，某些安全产品还对病毒文件采取了分块校验的方式以提高准确性。

#### 骨架扫描法

此方法由卡巴斯基公司发明，在检测宏病毒时特别有用，它既不用特征码也不用校验和，而是通过逐行解析宏语句，并将非必要的字符丢弃，只剩下代码的骨架，通过对代码骨架的分析，从而提高了对变种病毒的检测能力。

#### 精确识别法

精确识别法是先进能够保证扫描器精确识别病毒变种的唯一方法，常与第一代扫描技术相结合。精确识别法也是利用校验技术，只不过应用的更广，更复杂。它甚至能通过对整个病毒进行校验和计算生成特征图

## 常见反病毒技术（基于内存扫描）

内存扫描反病毒技术是一种原理复杂的扫描技术，内存扫描器一般与实时监控扫描器协作

## 常见反病毒技术（基于行为监控）

基于行为监控的反病毒技术一般需要与虚拟机、主动防御等技术配合工作。其原理是主要针对病毒木马行为进行分析对比，如果某些程序在执行后会进行一些非常规的、可疑的操作，那么及时这不是一个新生病毒，也会被拥有这种技术的反病毒产品拦截。

## 开源杀毒软件ClamAV使用手册

![img](https://cdn.kelu.org/blog/2018/09/5643568-9225b26e637729d5.webp.jpg)

clamav整个的检测流程

命令：

```
clamscan  扫描当前目录
clamscan -r -i C:\vir  扫描文件，递归扫描子目录
sigtool   查看和创建签名数据库
sigtool -i main.cvd
freshclam  病毒库更新工具
```

## 恶意软件特征规则编写工具-Yara

Yara 也是一个扫描工具， 但是提供了很好的特征规则，病毒分析师使用 Yara 可以更好的编写病毒的特征规则。

```
http://yara.readthedocs.io/en/v3.5.0/
http://yara.readthedocs.io/en/v3.5.0/writingrules.html#more-about-rules
中文翻译： http://www.freebuf.com/articles/system/26373.html
http://netsecurity.51cto.com/art/201402/430005.htm
```

## 分析一个未知样本

- 从客户机提取样本
- 分析可疑文件
- 提取特征
- 编写Yara规则

### 从客户机提取样本

#### 分析可疑进程

工具：PCHunter or ProcessExplorer or 火绒剑
刻板印象：一般来说伪装成一下进程比较多:Explorer.exe  svchost.exe

![img](https://cdn.kelu.org/blog/2018/09/5643568-313807b06274a8d9.webp.jpg)

扫描进程

发现有两个 explorer.exe 进程，其中一个很可疑

![img](https://cdn.kelu.org/blog/2018/09/5643568-8a2e7ae0a3eeeb30.webp.jpg)

可疑文件

#### 获得可疑文件

explorer.exe 隐藏文件
将文件打包压缩，密码： 15pb

### 分析样本

删除 explorer.exe 以及一些桌面快捷方式，重启电脑。 发现程序又回来了！
继续分析， 发现文件夹都是都隐藏的

![img](https://cdn.kelu.org/blog/2018/09/5643568-c6bd0494398781f5.webp.jpg)

Paste_Image.png

![img](https://cdn.kelu.org/blog/2018/09/5643568-b7e108b51f883281.webp.jpg)

Paste_Image.png

![img](https://cdn.kelu.org/blog/2018/09/5643568-8ebd033a337874aa.webp.jpg)

Paste_Image.png

![img](https://cdn.kelu.org/blog/2018/09/5643568-86e59c9659d95bab.webp.jpg)

Paste_Image.png

分析主程序，先查壳，有壳 UPX，脱壳

![img](https://cdn.kelu.org/blog/2018/09/5643568-2205542087ebf128.webp.jpg)

Paste_Image.png

![img](https://cdn.kelu.org/blog/2018/09/5643568-14fb8c1d88f273d1.webp.jpg)

Paste_Image.png

再使用 PE 工具，查看导入信息。

![img](https://cdn.kelu.org/blog/2018/09/5643568-6109cd4daf77493f.webp.jpg)

Paste_Image.png

![img](https://cdn.kelu.org/blog/2018/09/5643568-320394edfca62e1e.webp.jpg)

Paste_Image.png

![img](https://cdn.kelu.org/blog/2018/09/5643568-f4729a6e1129c7c6.webp.jpg)

Paste_Image.png

### 提取特征

字符串： q6789.com
字符串： C:\TSTP\winlogon.exe

### 编写 Yara 规则

```
rule vir4
{
strings:
$my_text_string = "C:\\TSTP\\winlogon.exe"
condition:
$my_text_string
}
```

### 使用 Python 中的 Yara 模块

```
import yara
def mycallback(data):
if data['strings']:
print data['strings'] #输出 匹配到的特征
yara.CALLBACK_CONTINUE
# 编译规则文件
rules = yara.compile('C:/rules.txt')
# 扫描指定的文件，匹配规则
matches = rules.match('C:/test/Lab01-01.dll', callback=mycallback)
```

### 杀毒引擎-虚拟机

虚拟机就是模拟执行程序，在内存中展开程序，就像在内存中扫描这个程序一样扫描展开的程序。

模拟的过程：
(1) 构建一个虚拟的环境， 虚拟的 CPU， 栈， 内存
(2) 解释执行将要执行的指令。

举例：
① mov eax,1，执行这条指令， eax 放入虚拟的 CPU 中
② push ebp，执行这条指令， 修改堆栈，修改的虚拟的栈空间
③ mov [401000],1 执行这条指令，写的是事先准备好的内存空间，内存是重定位过
的。
④ Call MessageBoxW 执行这条指令， 自己模拟一个 MessageBoxW， 将参数保存到日
志， 然后正确返回即可  。
以下就是 TAV 引擎模拟的模块。
虚拟机只是模拟的执行指令，并没有在真实的物理机上运行

### 杀毒分析-沙箱

#### 百度百科

> 沙箱是一种按照安全策略限制程序行为的执行环境。早期主要用于测试可疑软件等，比如黑客们为了试用某种病毒或者不安全产品，往往可以将它们在沙箱环境中运行。经典的沙箱系统的实现途径一般是通过拦截系统调用，监视程序行为，然后依据用户定义的策略来控制和限制程序对计算机资源的使用，比如改写注册表，读写磁盘等。

#### 典型的沙箱(沙盘)： Sandboxie [https://www.sandboxie.com/](https://link.jianshu.com?t=https://www.sandboxie.com/)

主要作用：如果你不信任某个软件，那么右键在沙盘中运行!
程序会运行，但是不会修改真实的磁盘文件和注册表文件
此外，有些杀毒软件也内置沙箱，原理和 Sandboxie 一样的。 比如卡巴斯基、 avast 等。
自动化分析沙箱： cuckoo [https://cuckoosandbox.org/](https://link.jianshu.com?t=https://cuckoosandbox.org/)

### 历史上常见的病毒行为

```
(1) 利用系统机制，自动运行病毒
在 xp 系统上， 每个文件夹下都会有一个 autorun.inf 的配置文件，可以指定打开文件夹的
时候默认执行的文件，病毒会利用这一点执行程序。
(2) 利用系统机制， 劫持一些小的 DLL，运行病毒
在 xp 系统上，系统的模块中有两个 DLL 是比较小的， usp10.dll 和 lpk.dll。
dll 执行的规则是如果当前目录有这个 DLL，那么就执行当前目录的， 如果当前目录没有，
再执行系统目录的。
病毒会释放伪装的 lpk.dll 或者 usp10.dll 到所有的文件夹下，以及 zip 或者是 rar 压缩
包中。
放入压缩包中是因为以前 rar 有命令行版的，可以执行命令批量修改压缩包。
```

# 参考资料

* [创新沙盒 | StackRox容器安全防护平台](http://blog.nsfocus.net/rsa2018-stackrox/)
* [从镜像历史记录逆向分析出Dockerfile](https://andyyoung01.github.io/2016/08/23/从镜像历史记录逆向分析出Dockerfile)
* [安全防护工具之：ClamAV](https://blog.csdn.net/liumiaocn/article/details/76577867)
* [检索 特征序列](https://www.google.co.jp/search?newwindow=1&ei=5Fz2W73DDorUvATBuJXQAQ&q=%E6%A3%80%E7%B4%A2+%E7%89%B9%E5%BE%81%E5%BA%8F%E5%88%97&oq=%E6%A3%80%E7%B4%A2+%E7%89%B9%E5%BE%81%E5%BA%8F%E5%88%97)
* [中国军民融合平台](http://www.sooip.com.cn)