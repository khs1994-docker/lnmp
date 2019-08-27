#!/usr/bin/env bash

# https://coreos.com/os/docs/latest/generate-self-signed-certificates.html

set -ex

env

main (){
  mkdir -p cert

  # check ca

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

  if [ -f ca-key.pem ];then
    cp ca-key.pem ca.pem registry-ca.pem cert/
  else
    cd cert
    echo '{
      "CN":"kubernetes",
      "key":{
        "algo":"rsa",
        "size":2048
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
    # ca-key.pem ca.pem ca.csr
    cd ..
  fi

  rm -rf *.pem
  rm -rf *.csr

  cp cert/* .

  # server
  export CN_NAME=server

  echo '{
    "CN":"'$CN_NAME'",
    "hosts":[""],
    "key":{
      "algo":"rsa",
      "size":2048
    }
  }' \
    | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem -profile=kubernetes \
       -hostname="127.0.0.1,localhost,${NODE_IPS}" - | cfssljson -bare $CN_NAME

  # client
  export CN_NAME=client

    echo '{
      "CN":"'$CN_NAME'",
      "hosts":[""],
      "key":{
        "algo":"rsa",
        "size":2048
      }
    }' \
      | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem -profile=kubernetes \
      - | cfssljson -bare $CN_NAME

  # registry
  # export CN_NAME=registry
  #
  # echo '{"CN":"'$CN_NAME'","hosts":[""],"key":{"algo":"rsa","size":2048}}' \
  #      | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem  \
  #      -hostname="$registry_hosts" - | cfssljson -bare $CN_NAME

  # etcd
  export CN_NAME=etcd

  echo '{
    "CN":"'$CN_NAME'",
    "hosts":[""],
    "key":{
      "algo":"rsa",
      "size":2048
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
       | cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json \
      -profile=kubernetes -hostname="127.0.0.1,localhost,${NODE_IPS}" - | cfssljson -bare $CN_NAME

  # flanneld (client)
  export CN_NAME=flanneld

  echo '{"CN":"'$CN_NAME'",
  "hosts":[""],
  "key":{
    "algo":"rsa",
    "size":2048
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
       -profile=kubernetes - | cfssljson -bare $CN_NAME

  # admin (client)
  # kubectl 作为集群的管理工具，需要被授予最高权限，这里创建具有最高权限的 admin 证书。
  export CN_NAME=admin

  echo '{
    "CN":"'$CN_NAME'",
    "hosts":[""],
    "key":{
      "algo":"rsa",
      "size":2048
    },
    "names":[{
      "C":"CN",
      "ST":"Beijing",
      "L":"Beijing",
      "O":"system:masters",
      "OU":"khs1994.com"
    }]
    }' \
       | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem  \
       -profile=kubernetes - | cfssljson -bare $CN_NAME

  # kubernetes master
  export CN_NAME=kubernetes
  export k8s_hosts=kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.default.svc.cluster.local
  echo '{
    "CN":"'$CN_NAME'",
    "hosts":[""],
    "key":{
      "algo":"rsa",
      "size":2048
    },"names":[{
      "C":"CN",
      "ST":"Beijing",
      "L":"Beijing",
      "O":"k8s",
      "OU":"khs1994.com"
    }]
    }' \
       | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem \
       -profile=kubernetes -hostname="127.0.0.1,localhost,${CLUSTER_KUBERNETES_SVC_IP},$k8s_hosts,${NODE_IPS}" - | cfssljson -bare $CN_NAME

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

  echo '{
    "CN": "aggregator",
    "hosts": [],
    "key": {
      "algo": "rsa",
      "size": 2048
    },
    "names": [
      {
        "C": "CN",
        "ST": "BeiJing",
        "L": "BeiJing",
        "O": "k8s",
        "OU": "4Paradigm"
      }
    ]
  }' |
     cfssl gencert -ca=ca.pem \
      -ca-key=ca-key.pem  \
      -config=ca-config.json  \
      -profile=kubernetes - | cfssljson -bare proxy-client

  # system:kube-controller-manager master
  export CN_NAME=system:kube-controller-manager

  echo '{
    "CN":"'$CN_NAME'",
    "hosts":[""],
    "key":{
      "algo":"rsa",
      "size":2048
    },
    "names":[{
      "C":"CN",
      "ST":"Beijing",
      "L":"Beijing",
      "O":"system:kube-controller-manager",
      "OU":"khs1994.com"
  }]
  }' \
  | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem -profile=kubernetes \
    -hostname="127.0.0.1,localhost,${NODE_IPS}" - | cfssljson -bare kube-controller-manager

   # system:kube-scheduler master 无需传输到节点
   export CN_NAME=system:kube-scheduler

   echo '{
     "CN":"'$CN_NAME'",
     "hosts":[""],
     "key":{
       "algo":"rsa",
       "size":2048
     },
     "names":[{
       "C":"CN",
       "ST":"Beijing",
       "L":"Beijing",
       "O":"system:kube-scheduler",
       "OU":"khs1994.com"
     }]
   }' \
  | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem -profile=kubernetes \
        -hostname="127.0.0.1,localhost,${NODE_IPS}" - | cfssljson -bare kube-scheduler

   # system:kube-proxy worker 无需传输到节点
   export CN_NAME=system:kube-proxy

   echo '{
     "CN":"'$CN_NAME'",
     "hosts":[""],
     "key":{
       "algo":"rsa",
       "size":2048
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
  mv client-key.pem key.pem
  mv client.pem cert.pem
  mv server.pem server-cert.pem
  rm -rf cert *.csr

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

  # kube-controller-manager.kubeconfig master

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

  # kube-scheduler.kubeconfig master

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

  # kube-proxy.kubeconfig worker

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
}

main
