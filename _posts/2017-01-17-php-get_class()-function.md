---
layout: post
title: PHP 获取类名、调用者类名方法名
category: tech
tags: php laravel
---

![](https://cdn.kelu.org/blog/tags/laravel.jpg)

先记一个案例。今天在写一个虚基类 AbstractUuidModel，因为要从 request 里批量将数据通过 Eloquent 保存至 model。而此时有很多 model 都需要这样一个操作，每个 model 都有20个以上的属性，一个一个赋值，真的是能把人写死。

为了提高效率，遂在虚基类中添加一个抽象度比较高的方法。

由 updateByConsole() 这个方法开始进入逻辑：

    public function updateByConsole()
    {
        $request = request();
        $flag = true;
        foreach ($request->all() as $key => $value) {
        	if(!$flag)continue;
            if(!$request->has($key))continue;
            if(is_string($value))$value = trim($value);
            $flag = $flag && $this->updateProperty($key,$value);
        }
        if($flag) $this->save();

        return $flag;
    }

将每一个 input 交给 updateProperty() 这个方法。于是接下来是核心代码：


    protected function updateProperty($key,$value){
        if(in_array($key,$this->keyExcept))return true;

        if($this->{$key} == $value) return true;

        $className = get_class($this);
        if(in_array($key,$this->keyUnion)){
            $count = $className::where($key,$value)->count();
            if($count>0)return false;
        }

        if(in_array($key,$this->keySpecific)){
            $this->specific($key,$value);
        }else{
            $this->{$key} = $value;
        }

        return true;
    }

可以看出核心逻辑是这样的：

* 是否有不需要存入的属性，有的话继续循环到一个属性
* 前后值是否相等，相等则继续循环到一个属性
* 该属性是否唯一，唯一则判断数据表中是否已有值，有的话继续循环到一个属性（通过 flag 变量做判断，最终的结果是跳过所有循环直到结束，然后上一个 updateByConsole() 方法不保存结果。
* 该属性是否是特殊属性，是的话子类自己实现 specific() 方法；否则赋值给 this， 然后下一个循环，直到遍历所有的 request。


# 类方法获取类名

在写上边案例时候印象比较深的就是 php 的这个 get_class() 方法。这个方法可以获得这个类的名字，一般写在 trait 或者 require 里用到。


# 类静态方法获取类名

虽然 `get_class` 好用，毕竟是类成员方法才可行。如果是静态方法，有两个办法：

* __CLASS__;
* get_called_class();


# 获取堆栈信息

以下是我在项目实战中的代码，用来打印方法调用关系。

主要是 stack_trace() +  stack_msg_assemble 方法，获得堆栈信息 + 堆栈偏移。

    function debug($message = null, array $context = [])
    {
        $stack = stack_trace(0);

        if (is_null($message)) {
            $message = '';
        }

        if (is_string($message)) {
            $message = stack_msg_assemble($stack) . "() " . $message;
        }
        return app('log')->debug($message, $context);
    }

参考资料：

* [get_class - php.net](http://php.net/manual/en/function.get-class.php)
* [PHP 静态方法中获取调用者的类名](https://github.com/wangming1993/issues/issues/3)
