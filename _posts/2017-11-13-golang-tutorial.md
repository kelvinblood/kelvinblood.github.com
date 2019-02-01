---
layout: post
title: Go 初学者的一些琐碎问题
category: tech
tags:
  - go
style: summer
---
![](https://cdn.kelu.org/blog/tags/go.jpg)

写了一个 Go 语言的 hello world 来练手。可以在 github 上查看 <https://github.com/kelvinblood/ping-pong-go>

这个 hello world 主要是 server-client 形式的应用。 功能很简单， client 给 server 发送 ping/pong 的消息，server 回复 pong/ping 消息。

![](https://cdn.kelu.org/blog/2017/11/ping-pong-go.gif)

这篇文章记录一些写这个hello world 时遇到的小问题，初学者可以看一看。文末附上源代码。

# 单双引号

字符串由双引号包裹。单引号内只能有一个字符，例如'c'，输出会返回这个字符的ascii码

# 字符串相同却不相等

![](https://cdn.kelu.org/blog/2017/11/pingponggo1.jpg)

一开始特别奇怪，明明两个变量一摸一样，字符串判断时候却认为他们不一样。。。颇有真假孙悟空的感觉。

接下来就是寻找解决办法的过程

* 是不是类型不一样：

	* 使用 reflect 包的 reflect.TypeOf 方法，发现都是 string 类型
	* switch 下用Go的空接口：
			// 建一个函数t 设置参数i 的类型为空接口，空接口可以接受任何数据类型
			func t(i interface{}) {    //函数t 有一个参数i 
			    switch i.(type) {      //多选语句switch
			    case string:
			        //是字符时做的事情
			    case int:
			        //是整数时做的事情
			    }
			    return
			}
	
			// _i.(type)_ 只能在switch中使用

* 是不是像 c 一样数组还有 \n 的诡异操作：

	查看str的长度：
	![](https://cdn.kelu.org/blog/2017/11/pingponggo2.jpg)

	终于发现了问题所在。

所以解决的办法是只将前面一部分拿来比较：

	if strings.EqualFold(recieve[0:len(recieveDefault)],recieveDefault) {
		go send(conn,sendDefault)
  	}else if strings.EqualFold(recieve[0:len(sendDefault)],sendDefault) {
		go send(conn,recieveDefault)
  	}

这里有一篇对比 golang 的 string和[]byte 的区别，写的很好：[golang string和[]byte的对比](https://gocn.io/article/467)：

>既然string就是一系列字节，而[]byte也可以表达一系列字节，那么实际运用中应当如何取舍？
>*   string可以直接比较，而[]byte不可以，所以[]byte不可以当map的key值。
>*   因为无法修改string中的某个字符，需要粒度小到操作一个字符时，用[]byte。
>*   string值不可为nil，所以如果你想要通过返回nil表达额外的含义，就用[]byte。
>*   []byte切片这么灵活，想要用切片的特性就用[]byte。
>*   需要大量字符串处理的时候用[]byte，性能好很多。

# 用到的包

可以直接查看官方文档： <https://golang.org/pkg/>

* "fmt"
* "net"
* "strings"
* "time"
* "math/rand"
* "reflect"

一些参考资料：

[Go语言fmt包Printf方法详解](http://www.jianshu.com/p/8be8d36e779c)

# 附源代码
	
	package main
	
	import (
	    "fmt"
	    "net"
	    "strings"
	    "time"
	    "math/rand"
	//    "reflect"
	)
	
	func main(){
		_, isClient,err := clientPre()
		
	        if err != nil {
			server()
			return
		}
	
		if isClient {
			client()
			return
		}
	
		server()
	}
	
	func clientPre()(conn net.Conn, isClient bool, err error) {
	    //打开连接:
	    conn, err = net.Dial("tcp", "localhost:18080")
	    if err != nil {
		isClient = false
	        fmt.Println(err.Error())
	        return
	    }
	
	    isClient = true
	
	    conn.Close()
	    return
	}
	
	func client(){
		sendContent := [2]string{"ping","pong"}
	    conn, err := net.Dial("tcp", "localhost:18080")
	
	    fmt.Println("client: ",conn.LocalAddr(),"server: ",conn.RemoteAddr()," ",rand.Intn(100)," ",sendContent[rand.Intn(100)%2])
		
		_,err = send(conn,sendContent[rand.Intn(100)%2])
	
		if err != nil {
	        	fmt.Println(err.Error())
			return
		}
		
	    doServerStuff(conn)
	    return
	}
	
	func server() {
	    listener, err := net.Listen("tcp", "0.0.0.0:18080")
	    fmt.Println("server listen 18080")
	    if err != nil {
	        fmt.Println("开启端口错误，终止进程", err.Error())
	        return //终止程序
	    }
	    // 监听并接受来自客户端的连接
	    for {
	        conn, err := listener.Accept()
	        if err != nil {
	            fmt.Println("Error accepting", err.Error())
	            return // 终止程序
	        }
	
	        go doServerStuff(conn)
	    }
	}
	
	func doServerStuff(conn net.Conn) {
	    count := 0
	    recieveDefault := "ping"
	    sendDefault := "pong"
	
	    for {
		count += 1
		recieve,err := rev(conn)
	
	        if err != nil {
	            return 
	        }
	
	  	fmt.Printf("%d ", count)
	  	if strings.EqualFold(recieve[0:len(recieveDefault)],recieveDefault) {
			go send(conn,sendDefault)
	  	}else if strings.EqualFold(recieve[0:len(sendDefault)],sendDefault) {
			go send(conn,recieveDefault)
	  	}
	    }
	}
	
	func send(conn net.Conn, content string)(send string, err error){
		time.Sleep(100 * time.Millisecond)
	        _, err = conn.Write([]byte(content))
		if err != nil {
			fmt.Println("发送错误.", err.Error())
			return
		}
		send = content
	
		fmt.Println("send", send)
	
		return
	}
	
	func rev(conn net.Conn)(recieve string, err error){
	        buf := make([]byte, 512)
	        _, err = conn.Read(buf)
	        if err != nil {
		    fmt.Println("接收停止，原因：", err.Error())
	            return 
	        }
	
		recieve = string(buf)
	  	fmt.Printf("recieving: %v ", recieve) 
	
		return
	}

