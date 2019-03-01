---
layout: post
title: kubernetes 使用 dry-run或get manifest 查看 helm chart 的 template
category: tech
tags: docker kubernetes helm
---
![](https://cdn.kelu.org/blog/tags/helm.jpg)

今天打算在 kubernetes dashboard 中直接创建项目。想用某个chart内容来查看template信息。

第一反应是 ```helm inspect local/example``` 。实际上这个命令输出的内容是chart.yaml和values.yaml的信息，并不是我所期望的。

查阅资料之后找到两个方法可以获得。

# 从 chart 中查看

我本地有一个example的chart，通过如下命令查看template信息

```
helm install --debug --dry-run local/example
```

于是生成如下信息：

```
[debug] Created tunnel using local port: '11835'

[debug] SERVER: "127.0.0.1:11835"

[debug] Original chart version: ""
[debug] Fetched zzzk/example to /root/.helm/cache/archive/example-0.1.1.tgz

[debug] CHART PATH: /root/.helm/cache/archive/example-0.1.1.tgz

NAME:   deadly-umbrellabird
REVISION: 1
RELEASED: Mon Jun 25 22:51:49 2018
CHART: example-0.1.1
USER-SUPPLIED VALUES:
{}

COMPUTED VALUES:
affinity: {}
image:
  pullPolicy: IfNotPresent
  repository: nginx
  tag: stable
ingress:
  annotations: {}
  enabled: false
  hosts:
  - chart-example.local
  path: /
  tls: []
nodeSelector: {}
replicaCount: 1
resources: {}
service:
  port: 80
  type: ClusterIP
tolerations: []

HOOKS:
MANIFEST:

---
# Source: example/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: deadly-umbrellabird-example
  labels:
    app: example
    chart: example-0.1.1
    release: deadly-umbrellabird
    heritage: Tiller
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app: example
    release: deadly-umbrellabird
---
# Source: example/templates/deployment.yaml
apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: deadly-umbrellabird-example
  labels:
    app: example
    chart: example-0.1.1
    release: deadly-umbrellabird
    heritage: Tiller
spec:
  replicas: 1
  selector:
    matchLabels:
      app: example
      release: deadly-umbrellabird
  template:
    metadata:
      labels:
        app: example
        release: deadly-umbrellabird
    spec:
      containers:
        - name: example
          image: "nginx:stable"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /
              port: http
          readinessProbe:
            httpGet:
              path: /
              port: http
          resources:
            {}        
```

将两个source文件拷贝到 dashboard 的新建内容中即可。

# 从已运行的应用中查看

```
$ helm list
rewq ...

$ helm get manifest rewq

---
# Source: example/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: rewq-example
  labels:
    app: example
    chart: example-0.1.1
    release: rewq
    heritage: Tiller
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app: example
    release: rewq
---
# Source: example/templates/deployment.yaml
apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: rewq-example
  labels:
    app: example
    chart: example-0.1.1
    release: rewq
    heritage: Tiller
spec:
  replicas: 1
  selector:
    matchLabels:
      app: example
      release: rewq
  template:
    metadata:
      labels:
        app: example
        release: rewq
    spec:
      containers:
        - name: example
          image: "nginx:stable"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /
              port: http
          readinessProbe:
            httpGet:
              path: /
              port: http
          resources:
            {}

```



# 其它

另外，helm inspect 的输出如下：

```
[root@RqiDev08 dxrd]# helm inspect zzzk/example
apiVersion: v1
appVersion: "1.0"
description: A Helm chart for Kubernetes
name: example
version: 0.1.1

---
# Default values for example.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

replicaCount: 1

image:
  repository: nginx
  tag: stable
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: false
  annotations: {}
    # kubernetes.io/ingress.class: nginx
    # kubernetes.io/tls-acme: "true"
  path: /
  hosts:
    - chart-example.local
  tls: []
  #  - secretName: chart-example-tls
  #    hosts:
  #      - chart-example.local

resources: {}
  # We usually recommend not to specify default resources and to leave this as a conscious
  # choice for the user. This also increases chances charts run on environments with little
  # resources, such as Minikube. If you do want to specify resources, uncomment the following
  # lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  # limits:
  #  cpu: 100m
  #  memory: 128Mi
  # requests:
  #  cpu: 100m
  #  memory: 128Mi

nodeSelector: {}

tolerations: []

affinity: {}

---
#example 0.1.1
```



# 参考资料

* <https://docs.helm.sh/chart_template_guide/>
* <https://github.com/kubernetes/helm/blob/master/docs/helm/helm_inspect.md>
* ​