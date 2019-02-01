---
layout: post
title: Docker pull 出现的 TLS handshake timeout
category: tech
tags: docker gfw
---
![](https://cdn.kelu.org/blog/tags/daocloud.jpg)

一直以来都是使用国外的服务器，因而对 docker 速度慢并没有特别的感觉。然而在本地做测试，还是需要docker，于是就出现了这个问题了。

    docker pull voduytuan/jenkins-php-docker

    ... ...
    error pulling image configuration: Get https://dseasb33srnrn.cloudfront.net/registry-v2/docker/registry/v2/blobs/sha256/f7/f7fbb8679343e6cbf232ca1ecbe4fd019748a50046cc391411719c52c865bf5a/data?Expires=1488249661&Signature=DgwydePkO~fs0pg3CPbf3GCtC05-n--9-1kO0XRpqKZLAobNcEWnTTEnSD8SSk1QevOQPk6jMFda4YEMJOQGXSrf4AxwAOt~VzgwWSLXKfq9u4gu0gxghsiOzsQ4MNBS3Kk9ZXJWuW3iqcs9G1LkGhW7-yHmhlu0-yEEKD9DeUE_&Key-Pair-Id=APKAJECH5M7VWIS5YZ6Q: net/http: TLS handshake timeout
好在 DaoCloud 发布了国内的镜像仓库，解决了这个问题。

    $ echo "DOCKER_OPTS=\"\$DOCKER_OPTS --registry-mirror=http://f2d6cb40.m.daocloud.io\"" | sudo tee -a /etc/default/docker
    $ sudo service docker restart
    
重启docker服务后，再次push，就完全ok了。

做到这一步已经够用了。如果想使用daocloud的升级版，还可以安装[DaoCloud Toolbox][daocloud]，速度更是飞起来。

![](https://cdn.kelu.org/blog/2017/02/demo-optimized.gif)

更新：

docker 官方已经也做了国内的镜像源地址，具体修改方式参考这里：[CentOS 源与 Docker 源加速的设置](https://blog.kelu.org/tech/2017/10/01/centos-yum-source-and-docker-source-china.html)

# 参考资料

* [DaoCloud Toolbox 正式发布，全面提升国内用户 Docker 使用体验][daocloud]
* [解决 Docker pull 出现的net/http: TLS handshake timeout 的一个办法](http://www.cnblogs.com/wozixiaoyao/p/6059780.html)

[daocloud]: http://blog.daocloud.io/toolbox
