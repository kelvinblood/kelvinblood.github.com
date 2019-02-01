---
layout: post
title: kubernetes 无法添加节点
category: tech
tags: docker kubernetes
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

今天在新增kubernetes节点时，发现无法新增节点，这篇文章记录下解决的情况。

# 新增节点

k8s新增节点时通过 token 验证，并带上ca证书的ha值。默认token的有效期为24小时。

```
# 重新生成新的token
kubeadm token create
kubeadm token list

# 获取ca证书sha256编码hash值
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'

# 节点加入集群
kubeadm join 172.10.1.100:6443 --token xxx --discovery-token-ca-cert-hash sha256:xxx --ignore-preflight-errors Swap
```

# 遇到问题

因为已经安装过好几次，只有这一次有问题，故而发现了本次安装不一样的地方：

在获取ca证书的hash值时，这次出现了这样的输出：

```
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der> /dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'

e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
writing RSA key
```

最后一行命令添加节点时输出如下：

```
[discovery] Trying to connect to API Server "10.128.0.4:6443"
[discovery] Created cluster-info discovery client, requesting info from "https://10.128.0.4:6443"
[discovery] Failed to connect to API Server "10.128.0.4:6443": cluster CA found in cluster-info configmap is invalid: public key sha256:9b263f52d90b62458a6a6c6.......02ddc34bf26e1ac not pinned
```

提示直接给出了另一个hash值。

# 解决问题

一个非常简单的方式解决：

将错误提示的hash值代替原先获得的hash值即可。

按常理来说，是不应该出现这样的问题的。显而易见是第二步获取hash值出了问题。对比以前使用的命令行，一下就找出了原因：

文档经过多次复制粘贴，命令行已经不完整了。参考官方文档<https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-join/>中的命令，重新运行得到正确的命令行：

```
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
```



# 参考资料

* [Unable to add Node](https://www.linux.com/forums/lfs258-class-forum/unable-add-node-lab-32)