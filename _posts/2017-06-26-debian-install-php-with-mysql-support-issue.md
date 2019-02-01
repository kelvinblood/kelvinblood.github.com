---
layout: post
title:  Debian 下 PHP7 编译安装和 MySQL支持
category: tech
tags: linux php mysql
---
![](https://cdn.kelu.org/blog/tags/php.jpg)

在 php7 环境中，编译和支持MySQL这一块把我折腾的蛮辛苦的，相信不少人也同样遇到，记录一下这个坑。

不知道从哪一版本开始，PHP不在希望使用mysql的库来支持mysql的连接，启用了mysqlnd来支持，编译都没有了--with-mysql参数，只支持--with-mysqli和--with-pdo-mysql，可以通过查看configure的参数来知道：

    ./configure -help | grep mysql

      --with-mysqli=FILE      Include MySQLi support.  FILE is the path
                              to mysql_config.  If no value or mysqlnd is passed
      --enable-embedded-mysqli
      --with-mysql-sock=SOCKPATH
      --with-pdo-mysql=DIR    PDO: MySQL support. DIR is the MySQL base directory
                              If no value or mysqlnd is passed as DIR, the
      --enable-mysqlnd        Enable mysqlnd explicitly, will be done implicitly
      --disable-mysqlnd-compression-support
                              Disable support for the MySQL compressed protocol in mysqlnd
      --with-zlib-dir=DIR     mysqlnd: Set the path to libz install prefix
      

可以看到，PHP希望使用mysqlnd来支持MySQL，所以参数可以这样写：

> --enable-mysqlnd

> --with-mysqli=mysqlnd

> --with-pdo-mysql=mysqlnd


列一下我的 config 参数：


    ./configure --prefix /usr/share/php7  \
        --enable-fpm  \
        --enable-mysqlnd  \
        --enable-gd-native-ttf \
        --enable-mbstring \
        --enable-zip \
        --enable-calendar \
        --enable-bcmath \
        --enable-exif \
        --enable-intl \
        --enable-opcache  \
        --enable-shmop \
        --enable-soap \
        --enable-sockets \
        --with-fpm-user=www-data  \
        --with-fpm-group=www-data  \
        --with-pcre-regex \
        --with-kerberos  \
        --with-openssl \
        --with-mcrypt \
        --with-zlib \
        --with-bz2 \
        --with-curl \
        --with-gd \
        --with-jpeg-dir=/usr/include/jpeg8  \
        --with-png-dir=/usr/include/libpng12  \
        --with-gettext \
        --with-gmp \
        --with-mhash \
        --with-pgsql \
        --with-pdo-pgsql \
        --with-mysqli \
        --with-pdo-mysql=mysqlnd \
        --with-xsl

### 参考资料

* [onlyfu/Blog - github](https://github.com/onlyfu/Blog/blob/master/Php/CentOS下PHP7的编译安装，MySQL的支持和一些问题的解决.md)
* [Remove `--with-mysql` from default_configure_options - github](https://github.com/php-build/php-build/issues/348)
