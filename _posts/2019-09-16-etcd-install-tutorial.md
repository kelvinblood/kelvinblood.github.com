---
layout: post
title: etcd 集群安装记录
category: tech
tags: etcd
---
![](https://cdn.kelu.org/blog/tags/etcd.jpg)

这篇文章记录下我安装etcd集群的步骤。

假设我们要在一下三台机器安装etcd集群：

* 10.10.10.1
* 10.10.10.2
* 10.10.10.3

# 1. 时间同步

在每台机器上运行如下命令：

```
apt-get install ntpdate -y
ntpdate time.windows.com
```

# 2. 生成证书

使用cfssl生成etcd集群的证书，生成的证书位于`/etc/etcd/ssl`目录下：

```
#!/usr/bin/env bash

set -e
cdir="$(cd "$(dirname "$0")" && pwd)"

mkdir -p /var/lib/etcd
mkdir -p /etc/etcd/ssl

echo "下载 cfssl"
curl -o /usr/bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
curl -o /usr/bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x /usr/bin/cfssl*

echo "CA 证书 配置: ca-config.json ca-csr.json"
cd /etc/etcd/ssl
cat >ca-config.json <<EOF
{
    "signing": {
        "default": {
            "expiry": "87600h"
        },
        "profiles": {
            "server": {
                "expiry": "87600h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ]
            },
            "client": {
                "expiry": "87600h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "client auth"
                ]
            },
            "peer": {
                "expiry": "87600h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ]
            }
        }
    }
}
EOF

cat >ca-csr.json <<EOF
{
    "CN": "etcd",
    "key": {
        "algo": "rsa",
        "size": 2048
    }
}
EOF

echo "生成 CA 证书:  ca.csr ca-key.pem ca.pem"
cfssl gencert -initca ca-csr.json | cfssljson -bare ca -

echo "服务器端证书配置： config.json"
cat >config.json <<EOF
{
    "CN": "etcd-0",
    "hosts": [
        "localhost",
        "10.10.10.1",
        "0.0.0.0",
        "10.10.10.2",
        "10.10.10.3"
    ],
    "key": {
        "algo": "ecdsa",
        "size": 256
    },
    "names": [
        {
            "C": "US",
            "L": "CA",
            "ST": "San Francisco"
        }
    ]
}
EOF
 
echo "生成服务器端证书 server.csr server.pem server-key.pem"
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=server config.json | cfssljson -bare server
echo "生成peer端证书 peer.csr peer.pem peer-key.pem"
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=peer config.json | cfssljson -bare peer

```

# 3. etcd 默认配置文件

新建一个 etcd.conf 文件如下：

```
ETCD_NAME=node01
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="https://0.0.0.0:2380"
ETCD_LISTEN_CLIENT_URLS="https://0.0.0.0:2379"

#[cluster]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://etcd-0:2380"
ETCD_INITIAL_CLUSTER="node01=https://node01:2380,node02=https://node02:2380,node03=https://node03:2380"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="nodecluster"
ETCD_ADVERTISE_CLIENT_URLS="https://node01:2379"
#ETCD_DISCOVERY=""
#ETCD_DISCOVERY_SRV=""
#ETCD_DISCOVERY_FALLBACK="proxy"
#ETCD_DISCOVERY_PROXY=""
#ETCD_STRICT_RECONFIG_CHECK="false"
#ETCD_AUTO_COMPACTION_RETENTION="0"
#
#[proxy]
#ETCD_PROXY="off"
#ETCD_PROXY_FAILURE_WAIT="5000"
#ETCD_PROXY_REFRESH_INTERVAL="30000"
#ETCD_PROXY_DIAL_TIMEOUT="1000"
#ETCD_PROXY_WRITE_TIMEOUT="5000"
#ETCD_PROXY_READ_TIMEOUT="0"
#
#[security]
ETCD_CERT_FILE="/app/kelu/etcd/ssl/server.pem"
ETCD_KEY_FILE="/app/kelu/etcd/ssl/server-key.pem"
ETCD_CLIENT_CERT_AUTH="true"
ETCD_TRUSTED_CA_FILE="/app/kelu/etcd/ssl/ca.pem"
ETCD_AUTO_TLS="true"
ETCD_PEER_CERT_FILE="/app/kelu/etcd/ssl/peer.pem"
ETCD_PEER_KEY_FILE="/app/kelu/etcd/ssl/peer-key.pem"
#ETCD_PEER_CLIENT_CERT_AUTH="false"
ETCD_PEER_TRUSTED_CA_FILE="/app/kelu/etcd/ssl/ca.pem"
ETCD_PEER_AUTO_TLS="true"
#
#[logging]
#ETCD_DEBUG="false"
# examples for -log-package-levels etcdserver=WARNING,security=DEBUG
#ETCD_LOG_PACKAGE_LEVELS=""
#[profiling]
#ETCD_ENABLE_PPROF="false"
#ETCD_METRICS="basic"
```

文件中包含了很多配置，实际上很多配置我们会在启动时将他们覆盖，所以这个文件中我们只要保持原样即可，不需要修改。

# 4. etcd 系统服务

手动新建/编辑文件 `/etc/systemd/system/etcd.service` :

```
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target
Documentation=https://github.com/coreos

[Service]
Type=notify
WorkingDirectory=/app/kelu/etcddata/
EnvironmentFile=/app/kelu/etcd/etcd.conf
User=root
ExecStart=/usr/bin/etcd \
  --name node01  \
  --cert-file=/app/kelu/etcd/ssl/server.pem  \
  --key-file=/app/kelu/etcd/ssl/server-key.pem  \
  --peer-cert-file=/app/kelu/etcd/ssl/peer.pem  \
  --peer-key-file=/app/kelu/etcd/ssl/peer-key.pem  \
  --trusted-ca-file=/app/kelu/etcd/ssl/ca.pem  \
  --peer-trusted-ca-file=/app/kelu/etcd/ssl/ca.pem  \
  --initial-advertise-peer-urls https://10.10.10.1:2380  \
  --listen-peer-urls https://0.0.0.0:2380  \
  --listen-client-urls https://0.0.0.0:2379  \
  --advertise-client-urls https://10.10.10.1:2379  \
  --initial-cluster-token etcd-cluster-0  \
  --initial-cluster node01=https://10.10.10.1:2380,node02=https://10.10.10.2:2380,node03=https://10.10.10.3:2380  \
  --heartbeat-interval=1000 \
  --election-timeout=5000 \
  --initial-cluster-state new  \
  --data-dir=/app/kelu/etcddata
Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
```

上边是10.10.10.1上的例子。对于另外两台机器，将 initial-advertise-peer-urls 和 listen-client-urls 改为机器IP即可。同时可以针对性地修改 heartbeat-interval 和 election-timeout 的配置，修改心跳监测时间和超时重新选举时间。

# 5. etcd 安装

准备材料都准备好了，使用下面脚本，在三台机器上依次运行：

```
#!/usr/bin/env bash

set -e

rm -rf /app/kelu/etcd /app/kelu/etcddata
mkdir -p /app/kelu/etcddata /app/kelu/etcd 

cp etcd.conf /app/kelu/etcd 
cp -R /etc/etcd/ssl /app/kelu/etcd

if [ ! -e etcd-v3.1.18-linux-amd64.tar.gz ]; then
  wget https://github.com/coreos/etcd/releases/download/v3.1.18/etcd-v3.1.18-linux-amd64.tar.gz
fi

tar -zxvf etcd-v3.1.18-linux-amd64.tar.gz > /dev/null

mv etcd-v3.1.18-linux-amd64 /app/kelu/etcd

rm -rf /usr/bin/etcd /usr/bin/etcdctl /etc/systemd/system/etcd.service
ln -s /app/kelu/etcd/etcd-v3.1.18-linux-amd64/etcd /usr/bin/etcd
ln -s /app/kelu/etcd/etcd-v3.1.18-linux-amd64/etcdctl /usr/bin/etcdctl

cp -f cfg/etcd.service.$1 /etc/systemd/system/etcd.service

systemctl daemon-reload
systemctl enable etcd
systemctl start etcd
systemctl status etcd
```

# 6. etcd 检查

安装完成后通过下面的命令进行验证：

```
etcdctl \
  --ca-file=/app/kelu/etcd/ssl/ca.pem \
  --cert-file=/app/kelu/etcd/ssl/peer.pem \
  --key-file=/app/kelu/etcd/ssl/peer-key.pem \
  --endpoints=https://10.10.10.1:2379,https://10.10.10.2:2379,https://10.10.10.3:2379  \
  cluster-health
```

如果正常运行，将会有healthy等输出显示。