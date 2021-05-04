#!/usr/bin/env bash

set -ex

env

_ca(){
  if [ -f $1-ca.pem ];then
    echo "$1-ca exists, skip"

    return
  fi

    echo '{
      "CN":"kubernetes",
      "key":{
        "algo":"ecdsa",
        "size": 384
      },
      "names": [
      {
        "C":"CN",
        "ST":"Beijing",
        "L":"Beijing",
        "O":"k8s",
        "OU":"khs1994.com"
      }],
      "ca": {
        "expiry": "876000h"
      }
    }' \
         | cfssl gencert -initca - | cfssljson -bare $1-ca -
}

main (){
  mkdir -p cert

# check ca
# ca 配置文件
  echo '{
  "signing": {
    "default": {
      "expiry": "87600h"
    },
    "profiles": {
      "kubernetes": {
        "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ],
        "expiry": "87600h"
      }
    }
  }
}' \
       > ca-config.json

  # signing：表示该证书可用于签名其它证书，生成的 ca.pem 证书中 CA=TRUE；
  # server auth：表示 client 可以用该该证书对 server 提供的证书进行验证；
  # client auth：表示 server 可以用该该证书对 client 提供的证书进行验证；

  if [ -f ca-key.pem ];then
    # CA 证书已存在，复用
    cp ca-key.pem ca.pem cert/
  else
    cd cert

# 证书签名请求文件
    # CN：Common Name，kube-apiserver 从证书中提取该字段作为请求的用户名 (User)，
    # 浏览器使用该字段验证网站是否合法；
    # O：Organization，kube-apiserver 从证书中提取该字段作为请求用户所属的组 (Group)；
    # kube-apiserver 将提取的 User、Group 作为 RBAC 授权的用户标识；

    echo '{
      "CN":"kubernetes",
      "key":{
        "algo":"ecdsa",
        "size": 384
      },
      "names": [
      {
        "C":"CN",
        "ST":"Beijing",
        "L":"Beijing",
        "O":"k8s",
        "OU":"khs1994.com"
      }],
      "ca": {
        "expiry": "876000h"
      }
    }' \
         | cfssl gencert -initca - | cfssljson -bare ca -
    # 生成 CA 证书（ca.pem）和私钥（ca-key.pem）
    # ca-key.pem ca.pem ca.csr
    cd ..
  fi

  # 使用已有的 CA
  cp etcd-ca* cert/ || true
  cp front-proxy-ca* cert/ || true
  cp sa.key sa.pub cert/ || true

  # 清理原有的证书文件
  rm -rf *.pem
  rm -rf *.csr

  # 恢复 CA
  cp cert/* .

# etcd ca
_ca etcd

# front-proxy-ca
_ca front-proxy

# docker (server) hosts 为节点所在 IP
  export CN_NAME=server

  echo '{
    "CN":"'$CN_NAME'",
    "hosts":[""],
    "key":{
      "algo":"ecdsa",
      "size": 384
    }
  }' \
    | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem -profile=kubernetes \
       -hostname="${LNMP_K8S_DOMAINS},127.0.0.1,localhost,${NODE_IPS}" - | cfssljson -bare docker-$CN_NAME

# docker (client) 无需提供 hosts
  export CN_NAME=client

    echo '{
      "CN":"'$CN_NAME'",
      "hosts":[""],
      "key":{
        "algo":"ecdsa",
        "size": 384
      }
    }' \
      | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem -profile=kubernetes \
      - | cfssljson -bare docker-$CN_NAME

# registry (server)
  # export CN_NAME=registry
  #
  # echo '{"CN":"'$CN_NAME'","hosts":[""],"key":{"algo":"ecdsa","size":384}}' \
  #      | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem  \
  #      -hostname="$registry_hosts" - | cfssljson -bare $CN_NAME

# /etcd-server               Generate the certificate for serving etcd
# etcd (server) hosts 为 Etcd 节点 IP
  export CN_NAME=etcd

  echo '{
    "CN":"'$CN_NAME'",
    "hosts":[""],
    "key":{
      "algo":"ecdsa",
      "size": 384
    },
    "names":[{
      "C":"CN",
      "ST":"Beijing",
      "L":"Beijing",
      "O":"k8s",
      "OU":"khs1994.com"
      }
    ]
}' \
       | cfssl gencert -ca=etcd-ca.pem -ca-key=etcd-ca-key.pem -config=ca-config.json \
      -profile=kubernetes -hostname="${LNMP_K8S_DOMAINS},127.0.0.1,localhost,${NODE_IPS}" - | cfssljson -bare $CN_NAME

# etcd (peer) hosts 为 Etcd 节点 IP
  export CN_NAME=etcd-peer

  echo '{
    "CN":"'$CN_NAME'",
    "hosts":[""],
    "key":{
      "algo":"ecdsa",
      "size": 384
    },
    "names":[{
      "C":"CN",
      "ST":"Beijing",
      "L":"Beijing",
      "O":"k8s",
      "OU":"khs1994.com"
      }
    ]
}' \
       | cfssl gencert -ca=etcd-ca.pem -ca-key=etcd-ca-key.pem -config=ca-config.json \
      -profile=kubernetes -hostname="${LNMP_K8S_DOMAINS},127.0.0.1,localhost,${NODE_IPS}" - | cfssljson -bare $CN_NAME

# etcd-client 连接 Etcd
  export CN_NAME=etcd-client

  echo '{"CN":"'$CN_NAME'",
  "hosts":[""],
  "key":{
    "algo":"ecdsa",
    "size": 384
  },
  "names":[{
    "C":"CN",
    "ST":"Beijing",
    "L":"Beijing",
    "O":"k8s",
    "OU":"khs1994.com"
  }]
}' \
       | cfssl gencert -config=ca-config.json -ca=etcd-ca.pem -ca-key=etcd-ca-key.pem \
       -profile=kubernetes - | cfssljson -bare $CN_NAME

# /apiserver-etcd-client
# Generate the certificate the apiserver uses to access etcd
# kube-apiserver (client) 连接 Etcd
  export CN_NAME=kube-apiserver-etcd-client
  export O=system:masters

  echo '{"CN":"'$CN_NAME'",
  "hosts":[""],
  "key":{
    "algo":"ecdsa",
    "size": 384
  },
  "names":[{
    "C":"CN",
    "ST":"Beijing",
    "L":"Beijing",
    "O":"'${O}'",
    "OU":"khs1994.com"
  }]
}' \
       | cfssl gencert -config=ca-config.json -ca=etcd-ca.pem -ca-key=etcd-ca-key.pem \
       -profile=kubernetes - | cfssljson -bare apiserver-etcd-client

# admin (client) 用于 kubectl
  # kubectl 与 apiserver https 安全端口通信，apiserver 对提供的证书进行认证和授权。
  # kubectl 作为集群的管理工具，需要被授予最高权限，这里创建具有最高权限的 admin 证书。

  export CN_NAME=admin
  export O="system:masters"

  # O 为 system:masters，kube-apiserver 收到该证书后将请求的 Group 设置为 system:masters
  # 预定义的 ClusterRoleBinding cluster-admin 将
  # Group system:masters 与 Role cluster-admin 绑定，该 Role 授予所有 API 的权限

  echo '{
    "CN":"'$CN_NAME'",
    "hosts":[""],
    "key":{
      "algo":"ecdsa",
      "size": 384
    },
    "names":[{
      "C":"CN",
      "ST":"Beijing",
      "L":"Beijing",
      "O":"'$O'",
      "OU":"khs1994.com"
    }]
    }' \
       | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem  \
       -profile=kubernetes - | cfssljson -bare $CN_NAME

# /apiserver                 Generate the certificate for serving the Kubernetes API
# kube-apiserver (server)
  export CN_NAME=kube-apiserver
  export k8s_hosts=kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.default.svc.cluster.local
  echo '{
    "CN":"'$CN_NAME'",
    "hosts":[""],
    "key":{
      "algo":"ecdsa",
      "size": 384
    },"names":[{
      "C":"CN",
      "ST":"Beijing",
      "L":"Beijing",
      "O":"k8s",
      "OU":"khs1994.com"
    }]
    }' \
       | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem \
       -profile=kubernetes -hostname="${LNMP_K8S_DOMAINS},127.0.0.1,localhost,${CLUSTER_KUBERNETES_SVC_IP},$k8s_hosts,${NODE_IPS}" - \
       | cfssljson -bare apiserver
# /apiserver-kubelet-client
# Generate the certificate for the API server to connect to kubelet
# kube-apiserver-kubelet-client (client)
  export CN_NAME=kube-apiserver-kubelet-client
  export O=system:masters

  echo '{
    "CN":"'$CN_NAME'",
    "hosts":[""],
    "key":{
      "algo":"ecdsa",
      "size": 384
    },"names":[{
      "C":"CN",
      "ST":"Beijing",
      "L":"Beijing",
      "O":"'${O}'",
      "OU":"khs1994.com"
    }]
    }' \
       | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem \
       -profile=kubernetes - | cfssljson -bare apiserver-kubelet-client

    cat > encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF

# 创建后续访问 metrics-server 使用的证书 (client)
  # CN 名称需要位于 kube-apiserver 的 --requestheader-allowed-names 参数中，
  # 否则后续访问 metrics 时会提示权限不足

  export CN="aggregator"

  echo '{
    "CN": "'${CN}'",
    "hosts": [],
    "key": {
      "algo": "ecdsa",
      "size": 384
    },
    "names": [
      {
        "C": "CN",
        "ST": "BeiJing",
        "L": "BeiJing",
        "O": "k8s",
        "OU": "khs1994"
      }
    ]
  }' |
     cfssl gencert -ca=front-proxy-ca.pem \
      -ca-key=front-proxy-ca-key.pem  \
      -config=ca-config.json  \
      -profile=kubernetes - | cfssljson -bare front-proxy-client

# system:kube-controller-manager (server + client)
  # 1. 与 kube-apiserver 的安全端口通信
  # 2. 在安全端口(https，10257) 输出 prometheus 格式的 metrics
  export CN_NAME=system:kube-controller-manager
  export O=system:kube-controller-manager

  # CN 和 O 均为 system:kube-controller-manager，
  # kubernetes 内置的 ClusterRoleBindings
  # system:kube-controller-manager 赋予 kube-controller-manager 工作所需的权限。
  echo '{
    "CN":"'$CN_NAME'",
    "hosts":[""],
    "key":{
      "algo":"ecdsa",
      "size": 384
    },
    "names":[{
      "C":"CN",
      "ST":"Beijing",
      "L":"Beijing",
      "O":"'$O'",
      "OU":"khs1994.com"
  }]
  }' \
  | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem -profile=kubernetes \
    -hostname="${LNMP_K8S_DOMAINS},127.0.0.1,localhost,${NODE_IPS}" - | cfssljson -bare kube-controller-manager

# system:kube-scheduler (server + client)
   # 1. 与 kube-apiserver 的安全端口通信
   # 2. 在安全端口(10259) 输出 prometheus 格式的 metrics
   export CN_NAME=system:kube-scheduler
   export O=system:kube-scheduler

   echo '{
     "CN":"'$CN_NAME'",
     "hosts":[""],
     "key":{
       "algo":"ecdsa",
       "size": 384
     },
     "names":[{
       "C":"CN",
       "ST":"Beijing",
       "L":"Beijing",
       "O":"'$O'",
       "OU":"khs1994.com"
     }]
   }' \
  | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem -profile=kubernetes \
        -hostname="${LNMP_K8S_DOMAINS},127.0.0.1,localhost,${NODE_IPS}" - | cfssljson -bare kube-scheduler

# system:kube-proxy 无需传输到节点 (client)
   # 不提供 server
   # 与 kube-apiserver 的安全端口通信，直接写入到 kubeconfig
   export CN_NAME=system:kube-proxy

   echo '{
     "CN":"'$CN_NAME'",
     "hosts":[""],
     "key":{
       "algo":"ecdsa",
       "size": 384
     },
     "names":[{
       "C":"CN",
       "ST":"Beijing",
       "L":"Beijing",
       "O":"k8s",
       "OU":"khs1994.com"
     }]
   }' \
        | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem \
            -profile=kubernetes - | cfssljson -bare kube-proxy

# docker tls cert
  mkdir -p docker
  mv docker-client-key.pem docker/key.pem
  mv docker-client.pem docker/cert.pem
  mv docker-server-key.pem docker/server-key.pem
  mv docker-server.pem docker/server-cert.pem

  rm -rf cert *.csr

  if ! [ -f sa.key ];then
    openssl genrsa -out sa.key 2048
    openssl rsa -in sa.key -pubout -out sa.pub
  fi

# kubectl.kubeconfig

  kubectl config set-cluster kubernetes \
  --certificate-authority=ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=kubectl.kubeconfig

  kubectl config set-credentials admin \
  --client-certificate=admin.pem \
  --client-key=admin-key.pem \
  --embed-certs=true \
  --kubeconfig=kubectl.kubeconfig

  kubectl config set-context kubernetes \
  --cluster=kubernetes \
  --user=admin \
  --kubeconfig=kubectl.kubeconfig

  kubectl config use-context kubernetes --kubeconfig=kubectl.kubeconfig

# kube-controller-manager.kubeconfig

  kubectl config set-cluster kubernetes \
  --certificate-authority=ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-credentials system:kube-controller-manager \
  --client-certificate=kube-controller-manager.pem \
  --client-key=kube-controller-manager-key.pem \
  --embed-certs=true \
  --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-context system:kube-controller-manager \
  --cluster=kubernetes \
  --user=system:kube-controller-manager \
  --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config use-context system:kube-controller-manager --kubeconfig=kube-controller-manager.kubeconfig

# kube-scheduler.kubeconfig

  kubectl config set-cluster kubernetes \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=${KUBE_APISERVER} \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-credentials system:kube-scheduler \
    --client-certificate=kube-scheduler.pem \
    --client-key=kube-scheduler-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-context system:kube-scheduler \
    --cluster=kubernetes \
    --user=system:kube-scheduler \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config use-context system:kube-scheduler --kubeconfig=kube-scheduler.kubeconfig

# kube-proxy.kubeconfig

  kubectl config set-cluster kubernetes \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=${KUBE_APISERVER} \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-credentials kube-proxy \
    --client-certificate=kube-proxy.pem \
    --client-key=kube-proxy-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes \
    --user=kube-proxy \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig

  cp /*.yaml .

  chmod 777 *
  chmod 777 docker/* || true
}

main
