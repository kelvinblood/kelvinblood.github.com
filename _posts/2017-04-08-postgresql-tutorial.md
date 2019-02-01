---
layout: post
title: PostgreSQL入门
category: tech
tags: postgresql
---

![](https://cdn.kelu.org/blog/tags/postgresql.jpg)

新建了一个节点服务器，打算将主业务迁移到这边。涉及到一些 Shell 命令行的数据库操作。在这里做一个简单的记录。

# 简介

PostgreSQL是完全由社区驱动的开源项目，由全世界超过1000名贡献者所维护。它提供了单个完整功能的版本，而不像MySQL那样提供了多个不同的社区版、商业版与企业版。PostgreSQL基于自由的BSD/MIT许可，组织可以使用、复制、修改和重新分发代码，只需要提供一个版权声明即可。

以下 PostgreSQL 简称为 pg 。

# 与 Mysql 的区别

MySQL与pg都是免费、开源、强大、且功能丰富的数据库。他们二者都在某些任务上具有很快的速度。

MySQL通常被认为是针对网站与应用的快速数据库后端，能够进行快速的读取和大量的查询操作，不过在复杂特性与数据完整性检查方面不太尽如人意。MySQL不同存储引擎的行为有较大差别。

pg是针对事务型企业应用的严肃、功能完善的数据库，只有单一存储引擎的完全集成的数据库。你可以通过调整postgresql.conf文件的参数来改进性能，也可以调整查询与事务。

# 安装

参照我在开源项目 [KeluLinuxKit ][1] 上的 pg 安装过程。目前为止 Debian 自带的 pg 版本还比较老。在这里我添加了 pg 官方维护的源进行安装。

    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    apt-get -y install wget ca-certificates
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    apt-get update
    apt-get -y upgrade
    apt-get -y install postgresql-9.4 pgadmin3

安装完成后系统会生成 postgres 用户。默认密码也是 postgres。

# 添加用户和数据库

登录PostgreSQL控制台:

    sudo su - postgres
    psql

一些操作:    
    
    # 为postgres用户设置一个密码。
    \password postgres 
    
    # 创建用户
    CREATE USER dbuser WITH PASSWORD 'password';
    
    创建数据库
    CREATE DATABASE exampledb OWNER dbuser;
    
    赋予权限
    GRANT ALL PRIVILEGES ON DATABASE exampledb to dbuser;
    
    退出控制台
    \q

# 控制台命令

    - \h：查看SQL命令的解释，比如\h select。
    - \?：查看psql命令列表。
    - \l：列出所有数据库。
    - \c [database_name]：连接其他数据库。
    - \d：列出当前数据库的所有表格。
    - \d [table_name]：列出某一张表格的结构。
    - \du：列出所有用户。
    - \e：打开文本编辑器。
    - \conninfo：列出当前数据库和连接的信息

# 数据库操作

基本的数据库操作，就是使用一般的SQL语言。

    # 创建新表 
    CREATE TABLE user_tbl(name VARCHAR(20), signup_date DATE);
    # 插入数据 
    INSERT INTO user_tbl(name, signup_date) VALUES('张三', '2013-12-22');
    # 选择记录 
    SELECT * FROM user_tbl;
    # 更新数据 
    UPDATE user_tbl set name = '李四' WHERE name = '张三';
    # 删除记录 
    DELETE FROM user_tbl WHERE name = '李四' ;
    # 添加栏位 
    ALTER TABLE user_tbl ADD email VARCHAR(40);
    # 更新结构 
    ALTER TABLE user_tbl ALTER COLUMN signup_date SET NOT NULL;
    # 更名栏位 
    ALTER TABLE user_tbl RENAME COLUMN signup_date TO signup;
    # 删除栏位 
    ALTER TABLE user_tbl DROP COLUMN email;
    # 表格更名 
    ALTER TABLE user_tbl RENAME TO backup_tbl;
    # 删除表格 
    DROP TABLE IF EXISTS backup_tbl;

# 数据库备份还原 pg_dump

备份是维护不可或缺的一部分。 pg_dump 是一个用于备份 PostgreSQL 数据库的工具。它甚至可以在数据库正在并发使用的时候进行完整一致的备份。 pg_dump 不阻塞其它用户对数据库的访问（读或者写）。

可以查看官方文档：<http://www.postgresql.org/docs/9.4/static/app-pgdump.html>

命令示例：

    dt=$(date +%Y%m%d%H%M)
    pg_dump -s -F c -Z 9 -d db1 > /var/local/pg_dump/db1.$dt.dump // 导出结构
    pg_dump -a -F c -Z 9 -d db1 > /var/local/pg_dump/db1.$dt.dump // 只备份数据
    pg_dump -F c -Z 9 -d db2 > /var/local/pg_dump/db2.all.dump // 全部备份

pg_restore 是用于恢复由 pg_dump 创建的任何非纯文本输出格式中的 PostgreSQL 数据库的工具。 它将发出必要的命令来重新构造数据库，以便于把它恢复成保存它的时候的样子。 归档（备份）文件还允许pg_restore 有选择地进行恢复， 甚至在恢复前重新排列条目的顺序。归档的文件设计成可以在不同的硬件体系之间移植。
pg_restore 可以以两种模式操作。如果声明了数据库名字， 那么归档是直接恢复到数据库里。 否则，先创建一个包含重建数据库所必须的 SQL 命令的脚本，并且写入到一个文件或者标准输出。 等效于 pg_dump 输出纯文本格式的时候创建的那种脚本。 

命令示例：

    pg_restore -d db_dst db_src.dump

用法:  pg_dump [选项]... [数据库名字]
用法:  pg_dump [选项]... [数据库名字]

    一般选项:
      -f, --file=FILENAME         output file or directory name
      -F, --format=c|d|t|p        output file format (custom, directory, tar, plain text)
      -v, --verbose            详细模式
      -Z, --compress=0-9       被压缩格式的压缩级别
    --lock-wait-timeout=TIMEOUT 在等待表锁超时后操作失败
      --help                       显示此帮助信息, 然后退出
      --versoin                    输出版本信息, 然后退出
      
    控制输出内容选项:
      -a, --data-only          只转储数据,不包括模式
      -b, --blobs              在转储中包括大对象
      -c, --clean              在重新创建之前，先清除（删除）数据库对象
      -C, --create             在转储中包括命令,以便创建数据库
      -E, --encoding=ENCODING     转储以ENCODING形式编码的数据
      -n, --schema=SCHEMA      只转储指定名称的模式
     -N, --exclude-schema=SCHEMA     不转储已命名的模式
      -o, --oids               在转储中包括 OID
      -O, --no-owner           在明文格式中, 忽略恢复对象所属者
      -s, --schema-only        只转储模式, 不包括数据
      -S, --superuser=NAME     在转储中, 指定的超级用户名
      -t, --table=TABLE        只转储指定名称的表
      -T, --exclude-table=TABLE       只转储指定名称的表
      -x, --no-privileges      不要转储权限 (grant/revoke)
      --binary-upgrade         只能由升级工具使用
      --column-inserts          以带有列名的INSERT命令形式转储数据
      --disable-dollar-quoting     取消美元 (符号) 引号, 使用 SQL 标准引号
      --disable-triggers         在只恢复数据的过程中禁用触发器
      --inserts                 以INSERT命令，而不是COPY命令的形式转储数据
      --no-security-labels        do not dump security label assignments
      --no-tablespaces           不转储表空间分配信息
      --no-unlogged-table-data    do not dump unlogged table data
      --quote-all-identifiers     quote all identifiers, even if not key words
      --serializable-deferrable   wait until the dump can run without anomalies
     --use-set-session-authorization
       使用 SESSION AUTHORIZATION 命令代替ALTER OWNER 命令来设置所有权

pg_restore [option...]

    参数：
    filename
        声明要恢复的备份文件的位置。如果没有声明，则使用标准输入。 
    -a
    --data-only
        只恢复数据，而不恢复表模式（数据定义）。 
    -c
    --clean
        创建数据库对象前先清理（删除）它们。 
    -C
    --create
        在恢复数据库之前先创建它。（如果出现了这个选项，和 -d 在一起的数据库名只是用于发出最初的CREATE DATABASE命令。 所有数据都恢复到名字出现在归档中的数据库中去。）
    -d dbname
    --dbname=dbname
        与数据库 dbname 联接并且直接恢复到该数据库中。 
    -e
    --exit-on-error
        如果在向数据库发送 SQL 命令的时候碰到错误，则退出。 缺省是继续执行并且在恢复结束时显示一个错误计数。 
        
    -f filename
    --file=filename
        声明生成的脚本的输出文件，或者出现-l 选项时用于列表的文件，缺省是标准输出。 
        
    -F format
    --format=format
        声明备份文件的格式。因为pg_restore 会自动判断格式，所以如果声明了，它可以是下面之一：
        t 备份是一个 tar 归档。 使用这个格式允许在恢复数据库的时候重新排序和/或把表模式元素排除出去。 同时还可能在恢复的时候限制装载的数据。 
        c 备份的格式是来自pg_dump的客户化格式。 这是最灵活的格式，因为它允许重新对数据排序，也允许重载表模式元素。 缺省时这个格式是压缩的。 
    
    -i
    --ignore-version
        忽略数据库版本检查。 
        
    -I index
    --index=index
        只恢复命名的索引。 
        
    -l
    --list
        列出备份的内容。这个操作的输出可以用 -L 选项限制和重排所恢复的项目。 
        
    -L list-file
    --use-list=list-file
        只恢复在 list-file 里面的元素，以它们在文件中出现的顺序。 你可以移动各个行并且也可以通过在行开头放 ';' 的方式注释。（见下文获取例子。） 
        
    -n namespace
    --schema=schema
        只恢复指定名字的模式里面的定义和/或数据。不要和 -s 选项混淆。 这个选项可以和 -t 选项一起使用。 
        
    -O
    --no-owner
        不要输出设置对象的权限，以便与最初的数据库匹配的命令。 缺省时，pg_restore 发出 ALTER OWNER 或 SET SESSION AUTHORIZATION 语句设置创建出来的模式元素的所有者权限。 
        如果最初的数据库连接不是由超级用户（或者是拥有所有创建出来的对象的同一个用户）发起的，那么这些语句将失败。 使用 -O，那么任何用户都可以用于初始的连接，并且这个用户将拥有所有创建出来的对象。 
        
    -P function-name(argtype [, ...])
    --function=function-name(argtype [, ...])
        只恢复指定的命名函数。请注意仔细拼写函数名及其参数，应该和转储的内容列表中的完全一样。 
        
    -R
    --no-reconnect
        这个选项已经废弃了，但是为了保持向下兼容仍然接受。 
        
    -s
    --schema-only
        只恢复表结构（数据定义）。不恢复数据，序列值将重置。 
        
    -S username
    --superuser=username
        设置关闭触发器时声明超级用户的用户名。 只有在设置了 --disable-triggers 的时候才有用。 
        
    -t table
    --table=table
        只恢复表指定的表的定义和/或数据。 
        
    -T trigger
    --trigger=trigger
        只恢复指定的触发器。 
        
    -v
    --verbose
        声明冗余模式。 
        
    -x
    --no-privileges
    --no-acl
        避免 ACL 的恢复（grant/revoke 命令）。 
        
    -X use-set-session-authorization
    --use-set-session-authorization
        输出 SQL 标准的 SET SESSION AUTHORIZATION 命令，而不是 OWNER TO 命令。 这样令转储与标准兼容的更好，但是根据转储中对象的历史，这个转储可能不能恰当地恢复。 
        
    -X disable-triggers
    --disable-triggers
        这个选项只有在执行仅恢复数据的时候才相关。它告诉 pg_restore 在装载数据的时候执行一些命令临时关闭在目标表上的触发器。 如果你在表上有完整性检查或者其它触发器， 而你又不希望在装载数据的时候激活它们，那么可以使用这个选项。
        目前，为 --disable-triggers 发出的命令必须以超级用户发出。 因此，你应该也要用 -S 声明一个超级用户名，或者更好是设置 --use-set-session-authorization 并且以 PostgreSQL 超级用户身份运行 pg_restore。 

# 查看版本

1. 查看客户端版本

   ```
   psql --version
   ```

   ​

2. 查看服务器版本

   ```
   select version();
   SELECT current_setting('server_version_num');
   ```



# 参考资料

* [PostgreSQL教程][2]

[1]: https://github.com/kelvinblood/KeluLinuxKit
[2]: http://www.yiibai.com/plus/view.php?aid=34