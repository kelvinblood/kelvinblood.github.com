---
layout: post
title:  Laravel 使用 Union 进行表连结
category: tech
tags: php laravel sql
---

![](https://cdn.kelu.org/blog/tags/laravel.jpg)

在[官方文档](http://d.laravel-china.org/docs/5.1/queries#unions)上可以看到这么描述 Unions 的：

>
查询语句构造器也提供了一个快捷的方法来「合并」两个查找。例如，你可以先创建一个初始查找，然后使用 union 方法将它与第二个查找进行合并：
>
    $first = DB::table('users')
                ->whereNull('first_name');
>
    $users = DB::table('users')
                ->whereNull('last_name')
                ->union($first)
                ->get();
>
也可使用 unionAll 方法，它和 union 有着相同的方法签名。

今天在实现这样一个需求，将两个类似的表打乱然后显示出来。参考了一份非常、非常、非常难看的原生 SQL 语句，唏嘘~~

![](https://cdn.kelu.org/blog/2017/06/20170609211431.jpg)

原本呢，直接使用 Eloquent 进行 Union ，使用 Get 获取也是可以的，然而因为我需要进行 paginate 分页，直接使用 Eloquent 就报错了，所以还是需要使用原生 SQL 。

不得不说，我对 SQL 语句非常不擅长。于是原生 SQL 可以通过 Laravel Eloquent ORM 自带的 toSql 方法获得。

以下是示例：

    private function resumeRelateSqlGetPaginate(Job $job, $resumeStatus)
    {
        $sql = '(select * from "resume_as" where "job_uuid" = \'' . $job->uuid . '\' union all select * from "resume_bs" where "job_uuid" = \'' . $job->uuid . '\') as t';

        $builder = DB::table(DB::raw($sql));

        if ($resumeStatus == '99') {
            $sqlMid = '"status" in (22,32,42,43,52) ';
            $builder = $builder->whereRaw($sqlMid);
        } elseif ($resumeStatus == '0') {
            $sqlMid = '';
        } else {
            $sqlMid = '"status" = ' . $resumeStatus;
            $builder = $builder->whereRaw($sqlMid);
        }

        return $builder->paginate($this->resumePaginate);
    }
