# kubectl

copy k8s config file to `~/.kube/config`

```bash
$ cp cert/kubectl.kubeconfig ~/.kube/config
```

若还有其他集群，请将生成的文件追加到 `~/.kube/config`

## Check

### etcd

第一步启动 `etcd` 集群。

```bash
$ systemctl status etcd-member

$ journalctl -u etcd-member

$ ETCDCTL_API=3 etcdctl \
    --endpoints=https://${node_ip:-192.168.57.110}:2379 \
    --cacert=/etc/kubernetes/certs/ca.pem \
    --cert=/etc/kubernetes/certs/etcd.pem \
    --key=/etc/kubernetes/certs/etcd-key.pem endpoint health
```

### flannel

第二步启动 `flannel` 配置 Docker 网段

```bash
$ systemctl status flanneld

$ journalctl -u flanneld

core@coreos1 ~ $ cat /run/flannel/flannel_docker_opts.env


DOCKER_OPT_BIP="--bip=172.30.27.1/24"
DOCKER_OPT_IPMASQ="--ip-masq=false"
DOCKER_OPT_MTU="--mtu=1450"
```

```bash
$ systemctl status docker

$ journalctl -u docker
```

## Master

### kube-apiserver

```bash
$ systemctl status kube-apiserver

$ journalctl -u kube-apiserver

# install kubectl

$ kubectl cluster-info

$ kubectl get all --all-namespaces

$ kubectl get componentstatuses

$ sudo netstat -lnpt|grep kube-apiserver

tcp        0      0 192.168.57.110:6443     0.0.0.0:*               LISTEN      847/kube-apiserver  
tcp        0      0 127.0.0.1:8080          0.0.0.0:*               LISTEN      847/kube-apiserver
```

- **6443** 接收 https 请求的安全端口，对所有请求做认证和授权

### kube-controller-manager

```bash
$ systemctl status kube-controller-manager

$ journalctl -u kube-controller-manager

$ sudo netstat -lnpt|grep kube-controll

tcp        0      0 127.0.0.1:10257         0.0.0.0:*               LISTEN      638/kube-controller

$ curl -s --cacert /etc/kubernetes/certs/ca.pem https://127.0.0.1:10257/metrics |head

$ kubectl get endpoints kube-controller-manager --namespace=kube-system  -o yaml
```

- **10257** 监听 10257 端口，接收 https 请求

### kube-scheduler

```bash
$ systemctl status kube-scheduler

$ journalctl -u kube-scheduler

$ sudo netstat -lnpt|grep kube-sche

tcp        0      0 127.0.0.1:10251         0.0.0.0:*               LISTEN      636/kube-scheduler

$ curl -s http://127.0.0.1:10251/metrics |head

$ kubectl get endpoints kube-scheduler --namespace=kube-system  -o yaml
```

- **10251** 接收 http 请求

## Worker

### kubelet

```bash
$ systemctl status kubelet

$ journalctl -u kubelet

$ sudo netstat -lnpt|grep kubelet

tcp        0      0 127.0.0.1:10248         0.0.0.0:*               LISTEN      29531/kubelet       
tcp        0      0 192.168.57.111:10250    0.0.0.0:*               LISTEN      29531/kubelet       
tcp        0      0 127.0.0.1:41039         0.0.0.0:*               LISTEN      29531/kubelet
```

- **4194** cadvisor http 服务
- **10248** healthz http 服务
- **10250** https API 服务 注意：未开启只读端口 10255

#### approve kubelet CSR 请求

```bash

$ kubectl get csr

$ kubectl get nodes

No resources found.

$ kubectl apply -f disk/system/csr-crb.yaml

$ kubectl get csr

$ kubectl get nodes
```

#### 自动生成的证书

而 kubelet 与 apiserver 通讯所使用的证书为 `kubelet-client.crt` 剩下的 `kubelet.crt` 将会被用于 kubelet server(10250) 做鉴权使用

### kube-proxy

```bash
$ systemctl status kube-proxy

$ journalctl -u kube-proxy

$ sudo netstat -lnpt|grep kube-proxy

tcp        0      0 192.168.57.111:10249    0.0.0.0:*               LISTEN      656/kube-proxy
tcp        0      0 192.168.57.111:10256    0.0.0.0:*               LISTEN      656/kube-proxy
tcp6       0      0 :::8588                 :::*                    LISTEN      656/kube-proxy
```

- **10249** http prometheus metrics port
- **10256** http healthz port;

## Test k8s Cluster

务必保证各组件正常运行之后，再进行测试！（$ sudo systemctl status XXX）

```bash
$ cd ~/lnmp/kubernetes

$ cd deployment/demo/

$ kubectl create -f lnmp-ds.yaml

$ kubectl get pods  -o wide|grep nginx-ds

nginx-ds-dxc8j   1/1       Running   0          12s       172.30.100.2   coreos1

$ kubectl get service |grep nginx-ds

nginx-ds     NodePort    10.254.199.71   <none>        80:8448/TCP   3m
```

open browser `node_ip:8448`

## Cleanup test resource

```bash
$ kubectl delete service -l test="true"

$ kubectl delete deployment -l test="true"

$ kubectl delete pod -l test="true"

$ kubectl delete daemonset -l test="true"
```
