---
layout: post
title: php is_a 函数
category: tech
tags: laravel php
---

![](https://cdn.kelu.org/blog/tags/laravel.jpg)

这几天写了个测试用例，发现一个点记录下。Eloquent 在取出一系列数据后是个集合collection。所以在判断的时候应该判断是否为collection，而不是数组。即：

     is_a($item, 'Illuminate\Database\Eloquent\Collection')

先前没有考虑清楚，使用is_array判断。然而collection是个object而非array。

具体代码如下：

    /**
     * 删除所有子关系最后删除自己
     *
     * @return bool
     * @throws \Exception
     */
    public function del()
    {
        $className = get_class($this);
        foreach ($className::$hasModels as $relate) {
            $relateModel = $this->$relate;
            if (is_array($relateModel) || is_a($relateModel, 'Illuminate\Database\Eloquent\Collection')) {
                foreach ($this->$relate as $item) {
                    $item->delete();
                }
            } else {
                $relateModel->delete();
            }
        }

        $this->delete();
        return true;
    }

事实上 instanceof 也可以实现这样的效果：

    if($relateModel instanceof 'Illuminate\Database\Eloquent\Collection') {

    }
    
# 参考资料

* [Laravel: find out if variable is collection][1]


[1]: http://stackoverflow.com/questions/34619145/laravel-find-out-if-variable-is-collection

