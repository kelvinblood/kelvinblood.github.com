---
layout: post
title: Python 中的 if __name__ == '__main__'
category: tech
tags:  python
---
![](https://cdn.kelu.org/blog/tags/python.jpg)

 if __name__ == '__main__' 是一个Python 初学者摸不着头脑的东西。例如下面一个简单的文件：

```python
PI = 3.14

def main():
    print "PI:", PI

if __name__ == "__main__":
    main()
```
引用[知乎](https://www.zhihu.com/question/49136398)上的这个非常简约的答案：

『__name__ 是当前模块名，当模块被直接运行时模块名为 __main__ 。这句话的意思就是，当模块被直接运行时，以下代码块将被运行，当模块是被导入时，代码块不被运行。』

下面循序渐进做一些解释。

首先先普及Python 的一个基础概念——模块。

	Python 模块(Module)，是一个 Python 文件，以 .py 结尾，包含了 Python 对象定义和Python语句。
	模块让你能够有逻辑地组织你的 Python 代码段。
	把相关的代码分配到一个模块里能让你的代码更好用，更易懂。
	模块能定义函数，类和变量，模块里也能包含可执行的代码。

所有的模块都有一个内置属性 __name__。一个模块的 __name__ 的值取决于您如何应用模块。

如果 import 一个模块，那么模块__name__ 的值通常为模块文件名，不带路径或者文件扩展名。但是您也可以像一个标准的程序样直接运行模块，在这 种情况下, __name__ 的值将是一个特别缺省"__main__"。

# 解释型语言和编译型语言

首先我们平时所使用的程序语言都是高级程序语言，分为解释型语言和编译型语言。

对于编译型语言——C，C++，以及完全面向对象的编程语言 Java，C# 等，他们都是先将程序编译成二进制再运行，都需要有一个 main 函数来作为程序的入口。

而解释型语言（比如 Python）则不同，它是动态的逐行解释运行。也就是从脚本第一行开始运行，没有统一的入口。

一个 Python 源码文件除了可以被直接运行外，还可以作为模块（也就是库）被导入。不管是导入还是直接运行，最顶层的代码都会被运行（Python 用缩进来区分代码层次）。

# __name__

`__name__` 是内置变量，用于表示当前模块的名字，同时还能反映一个包的结构。

如果一个模块被直接运行，则其没有包结构，其 `__name__` 值为 `__main__`。比如我们新建一个文件 `test.py`

	# -*- coding:utf-8 -*-
	print __name__

运行 `python test.py` 输出结果为

	__main__

如果是以导入的方式运行的，比如我们再新建一个文件 `testMain.py`，仅仅导入不做任何事：

	# -*- coding:utf-8 -*-
	import test

运行 `python testMain.py` 输出结果为

	test

我们也可以直接以模块的方式运行 `test.py`文件——`python -m test.py`，结果如下：

	test
	xxxx : No module named test.py

到这里，我们基本上就完全知道了 `__name__` 是什么了。

# 参考资料

* [Python 中的 if __name__ == '__main__' 该如何理解](http://blog.konghy.cn/2017/04/24/python-entry-program/)
