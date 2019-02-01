---
layout: post
title: Linux 命令之basename、dirname
category: tech
tags: linux linux-command
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

basename命令用于去掉文件名的目录和后缀，dirname命令用于截取目录

|path|dirname|basename|
|---|---|---|
|"/usr/lib"|"/usr"|"lib"|
|"/usr/"|"/"|"usr"|
|"usr"|"."|"usr"|
|"/"|"/"|"/"|
|"."|"."|"."|
|".."|"."|".."|

# 语法

    basename String [ Suffix ]
    dirname [ Option ] Name
    
    basename 命令读取 String 参数，删除以 /(斜杠) 结尾的前缀以及任何指定的 Suffix 参数，并将剩余的基本文件名称写至标准输出。dirname则相反。
    

       

# 代码实例

    #!/bin/sh  
      
    # 跳转到脚本所在目录  
    cd $(dirname "$0") || exit 1  
    // cd `dirname $0`

# man文档

### basename

    NAME
           basename - strip directory and suffix from filenames

    SYNOPSIS
           basename NAME [SUFFIX]
           basename OPTION... NAME...

    DESCRIPTION
           Print NAME with any leading directory components removed.  If specified, also remove a trailing SUFFIX.

           Mandatory arguments to long options are mandatory for short options too.

           -a, --multiple
                  support multiple arguments and treat each as a NAME

           -s, --suffix=SUFFIX
                  remove a trailing SUFFIX; implies -a

           -z, --zero
                  end each output line with NUL, not newline

           --help display this help and exit

           --version
                  output version information and exit

    EXAMPLES
           basename /usr/bin/sort
                  -> "sort"

           basename include/stdio.h .h
                  -> "stdio"

           basename -s .h include/stdio.h
                  -> "stdio"

           basename -a any/str1 any/str2
                  -> "str1" followed by "str2"


### dirname

    NAME
           dirname - strip last component from file name

    SYNOPSIS
           dirname [OPTION] NAME...

    DESCRIPTION
           Output each NAME with its last non-slash component and trailing slashes removed; if NAME contains no /'s, output '.' (meaning the current directory).

           -z, --zero
                  end each output line with NUL, not newline

           --help display this help and exit

           --version
                  output version information and exit

    EXAMPLES
           dirname /usr/bin/
                  -> "/usr"

           dirname dir1/str dir2/str
                  -> "dir1" followed by "dir2"

           dirname stdio.h
                  -> "."
