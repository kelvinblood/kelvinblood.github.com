---
layout: post
title:  升级到 php7
category: tech
tags: php
---

![](https://cdn.kelu.org/blog/tags/php.jpg)

嗯，昨晚在浏览一个github项目：[微信小程序开发资源汇总](https://github.com/justjavac/awesome-wechat-weapp),不知道怎么抽筋了然后跑去升级php7了。(●ˇ∀ˇ●)。嘛，记录一下升级过程。

虽说是升级，但是我并没有破坏原来的php5.6的环境，如果需要切换环境的话，只要做少量修改就可以恢复为原来的环境了。

# 下载

    cd /tmp
    wget http://am1.php.net/distributions/php-7.1.5.tar.gz
    
# 安装
    
    tar -xzvf php-7.1.5.tar.gz
    cd php-7.1.5 
    ./configure --prefix /usr/share/php7 --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --with-pcre-regex --with-openssl=shared --with-kerberos --with-zlib=shared --enable-bcmath=shared --with-bz2=shared --enable-calendar=shared --with-curl=shared --enable-exif=shared --with-gd=shared --with-jpeg-dir=/usr/include/jpeg8 --with-png-dir=/usr/include/libpng12 --with-gettext=shared --with-gmp=shared --with-mhash=shared --enable-intl=shared --enable-mbstring=shared --with-mcrypt=shared --enable-opcache --with-pdo-pgsql=shared --with-pgsql=shared --enable-shmop=shared --enable-soap=shared --enable-sockets=shared --with-xsl=shared --enable-zip=shared
    make clean && make && make install
    make test
    
# 配置

保留以前链接

    cd /usr/local/bin
    ln -s /usr/share/php5.6/bin/php php5.6
    ln -s /usr/share/php5.6/sbin/php-fpm php-fpm5.6

    cp /usr/share/php5.6/lib/php.ini /usr/share/php7/lib/php.ini
    cp /usr/share/php5.6/etc/php-fpm.conf /usr/share/php7/etc/php-fpm.conf 
    cp /tmp/php-7.1.5/sapi/fpm/php-fpm /usr/share/php7/sbin/php-fpm
    cp -R /usr/share/php5.6/etc/pool /usr/share/php7/etc/pool
    
重建链接    
    
    rm php php-fpm
    ln -s /usr/share/php7/bin/php php
    ln -s /usr/share/php7/sbin/php-fpm php-fpm
    
完成后重启一下机器，重新启动php-fpm即可。