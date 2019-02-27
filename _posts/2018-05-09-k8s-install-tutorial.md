---
layout: post
title: kubernetes 安装入门(centos)
category: tech
tags: kubernetes docker
---
![](https://cdn.kelu.org/blog/tags/k8s.jpg)

这篇文章记录如何使用 kubeadm 安装 kubernetes。

目前官方推荐使用这种方法安装上测试环境，暂时不建议上生产环境。

# 环境配置

1. 安装docker

   ```
   curl -sSL https://get.docker.com/ | sh
   usermod -aG docker $USER
   systemctl enable docker
   systemctl start docker
   ```

2. 关闭系统防火墙

   ```
   systemctl stop firewalld && systemctl disable firewalld
   ```

3. 关闭SElinux

   ```
   $ setenforce 0 （临时关闭）
   $ vi /etc/selinux/config （长久关闭）
   SELINUX=disabled
   ```

4. 关闭系统交换区（出于k8s的性能考虑）

   不关闭临时分区的话参考后文，k8s初始化时修改配置文件即可。

   ```
   （临时）
   $ swapoff -a && sysctl -w vm.swappiness=0

   （长久）
   $ swapoff -a && cat >> /etc/sysctl.conf << EOF 
   vm.swappiness=0
   EOF

   $ sysctl -p
   ```

5. 配置系统内核参数使流过网桥的流量也进入iptables/netfilter框架中：

   ```
   $ cat >> /etc/sysctl.conf<< EOF
   net.ipv4.ip_forward= 1
   net.bridge.bridge-nf-call-ip6tables= 1
   net.bridge.bridge-nf-call-iptables= 1
   EOF

   $ sysctl -p
   ```

6. 重启docker和daemon

   ```
   systemctl daemon-reload
   systemctl restart docker
   ```

# 安装

1. 配置阿里K8S YUM源

    ```
    cat <<EOF > /etc/yum.repos.d/kubernetes.repo
    [kubernetes]
    name=Kubernetes
    baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
    enabled=1
    gpgcheck=0
    EOF

    yum -y install epel-release
    yum clean all
    yum makecache
    ```


2. 安装kubeadm和相关工具包

   ```
   yum -y install kubelet kubeadm kubectl kubernetes-cni
   ```

3. 修改 kubeadm.conf

   ```
   $ vi /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
   # 修改 "cgroup-driver"值 由systemd变为cgroupfs
   # 原因是 cgroup-driver参数要与docker的一致，否则就会出问题
   Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs"

   # 第九行增加swap-on=false
   Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"
   ```

4. 启动Docker与kubelet服务

   ```
   systemctl enable docker && systemctl start docker
   systemctl enable kubelet && systemctl start kubelet
   ```

5. 查看系统日志

   此时kubelet的服务运行状态是异常的，因为缺少主配置文件kubelet.conf。但可以暂不处理，因为在完成Master节点的初始化后才会生成这个配置文件。

   ```
   tail -f /var/log/messages
   ```

6. kubeadm初始化master节点

   目前最新版是1.10，也可以不用这个配置。

   ```
   kubeadm init --kubernetes-version=v1.10.0 --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors Swap
   ```

   最后一段的输出信息，类似于 

   ```
   kubeadm join ...
   ```

   需要保存一份，后续添加工作节点还要用到。

7. 配置kubectl认证信息

   ```
   # 对于非root用户
   mkdir -p $HOME/.kube
   sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
   sudo chown $(id -u):$(id -g) $HOME/.kube/config

   # 对于root用户
   export KUBECONFIG=/etc/kubernetes/admin.conf
   也可以直接放到~/.bash_profile
   echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/bash_profile
   echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/bashrc
   ```

8. 安装flannel网络

   ```
   mkdir -p /etc/cni/net.d/
   cat <<EOF> /etc/cni/net.d/10-flannel.conf
   {
   "name": "cbr0",
   "type": "flannel",
   "delegate": {
   "isDefaultGateway": true
   }
   }
   EOF

   mkdir /usr/share/oci-umount/oci-umount.d -p
   mkdir -p /run/flannel/

   cat <<EOF> /run/flannel/subnet.env
   FLANNEL_NETWORK=10.244.0.0/16
   FLANNEL_SUBNET=10.244.1.0/24
   FLANNEL_MTU=1450
   FLANNEL_IPMASQ=true
   EOF

   kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml
   ```

9. node加入集群(可选)

   将第6步中的最后那个命令在node节点上运行即可。如果需要可以在后边加上跳过swap检测。

   ```
   kubeadm join --token xxx --discovery-token-ca-cert-hash sha256:xxx 172.10.1.100:6443  --ignore-preflight-errors Swap

   kubeadm join 10.19.0.55:6443 --token yvcyj2.8sx9plzgg0x2pyui --discovery-token-ca-cert-hash sha256:39a0baf9d08046eecbd593049b4d71e47d47478c01b6761c911da9589aed1f73 --ignore-preflight-errors Swap
   ```

   如果忘记token，在master节点上运行：

   ```
   # 确认token是否有效
   kubeadm token list      

   kubeadm token create --print-join-command
   ```

   默认token的有效期为24小时，当过期之后，该token就不可用了。解决方法如下：

   ```
   # 重新生成新的token
   kubeadm token create
   kubeadm token list

   # 获取ca证书sha256编码hash值
   openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'

   # 节点加入集群
   kubeadm join --token xxx --discovery-token-ca-cert-hash sha256:xxx  172.10.1.100:6443  --ignore-preflight-errors Swap

   kubeadm join 10.19.0.55:6443 --token yvcyj2.8sx9plzgg0x2pyui --discovery-token-ca-cert-hash sha256:39a0baf9d08046eecbd593049b4d71e47d47478c01b6761c911da9589aed1f73 --ignore-preflight-errors Swap
   ```
   > 更新 2019年2月26日：
   >
   > 对于添加节点，如果出现这样的错误提示：` [ERROR CRI]: unable to check if the container runtime at "/var/run/dockershim.sock" is running: exit status 1`
   >
   > 有可能是crictl的原因，在节点上并不需要这个东西，删除即可：
   >
   > `rm /usr/bin/crictl`

10. 将 master 设置为node（可选)

   ```
   kubectl taint nodes --all node-role.kubernetes.io/master-
   ```

11. 验证

    ```
    # 查看节点状态
    kubectl get nodes
    # 查看pods状态
    kubectl get pods --all-namespaces
    # 查看K8S集群状态
    kubectl get cs
    ```

12. 重新安装(可选)

    ```
    kubeadm reset
    ```

13. 安装UI界面 dashboard

    在k8s中 dashboard可以有两种访问方式：kubeconfig（HTTPS）和token（http）。

    这里只介绍 Token 方式的访问。

    ```
    $ git clone https://github.com/gh-Devin/kubernetes-dashboard.git
    $ cd kubernetes-dashboard
    $ ls
    heapster-rbac.yaml  heapster.yaml  kubernetes-dashboard-admin.rbac.yaml  kubernetes-dashboard.yaml

    $ vi kubernetes-dashboard.yaml
    # 因为权限问题，要将serviceAccountName: kubernetes-dashboard
    # 改为serviceAccountName: kubernetes-dashboard-admin

    $ kubectl  -n kube-system create -f .
    ```

    查看pod，确定是否已正常running

    ```
    kubectl get svc,pod --all-namespaces | grep dashboard
    ```

# 简单使用

一些简单的命令行使用说明：

```
kubectl cluster-info  # 查看集群信息
kubectl get pods      # 查看当前的 Pod
kubectl get services  # 查看应用被映射到节点的哪个端口
kubectl get services,pods --all-namespaces # 查看所有namespaces的应用和pod

kubectl get deployment # 查看副本数
kubectl describe deployment
kubectl get replicaset
kubectl describe replicaset
```

简单的创建资源：

1. 用 kubectl 命令直接创建

   ```
   # 通过 kubectl 创建 Deployment。
   # Deployment 创建 ReplicaSet。
   # ReplicaSet 创建 Pod。
   kubectl run nginx-deployment --image=nginx:1.7.9 --replicas=2

   kubectl run kubernetes-bootcamp \
         --image=docker.io/jocatalin/kubernetes-bootcamp:v1 \
         --port=8080
   ```

2. 用yml配置文件创建

   `kubectl apply` 不但能够创建 Kubernetes 资源，也能对资源进行更新，非常方便。

   不过 Kubernets 还提供了几个类似的命令，例如 `kubectl create`、`kubectl replace`、`kubectl edit` 和 `kubectl patch`。

   ```
   kubectl apply -f nginx.yml
   ```

3. 更新配置

   ```
   # 将8080端口映射到主机的随机端口
   kubectl expose deployment/kubernetes-bootcamp \
         --type="NodePort" \
         --port 8080
         

   # 更新副本数
   kubectl scale deployments/kubernetes-bootcamp --replicas=3      

   # 滚动更新
   kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2

   # 回退
   kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2

   # 删除
   kubectl delete pvc mypvc1 --force
   kubectl delete pv mypv1 --force

   ```

   ​

   # 参考资料

   * [Kubernetes架构设计与核心原理](http://www.dockerinfo.net/1048.html)

