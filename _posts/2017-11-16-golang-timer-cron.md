---
layout: post
title: Go 定时器
category: tech
tags: go
---
![](https://cdn.kelu.org/blog/tags/go.jpg)

Go有一个package名字叫`time`，通过这个package可以很容易的实现与时间有关的操作。`time` package中有一个ticker结构，可以实现定时任务。

```
func main(){
    var ticker *time.Ticker = time.NewTicker(1 * time.Second)

    go func() {
        for t := range ticker.C {
            fmt.Println("Tick at", t)
        }
    }()

    time.Sleep(time.Second * 5)  
    ticker.Stop()     
    fmt.Println("Ticker stopped")
}
```

上面的打印方法会每隔一分钟把当前时间打印出来。修改间隔时间和要执行的函数，就能实现定时任务。
