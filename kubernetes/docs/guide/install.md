# 部署 Kubernetes

请查看 [GitHub](https://github.com/khs1994-docker/lnmp-k8s) README.md 文件。

## kubectl

复制 K8s 配置文件到 `~/.kube/config`

```bash
$ cp cert/kubectl.kubeconfig ~/.kube/config
```

若还有其他集群，请将生成的文件追加到 `~/.kube/config`

## Check

确保 `$ systemctl status 组件名` 状态为

```bash
Active: active (running) since Tue 2018-12-25 09:48:47 CST; 1h 4min ago
```

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
- **10252**

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
- **10259**

## Worker

### kube-proxy

```bash
tcp        0      0 192.168.199.100:10249   0.0.0.0:*               LISTEN      4108/kube-proxy
tcp        0      0 192.168.199.100:10256   0.0.0.0:*               LISTEN      4108/kube-proxy
tcp6       0      0 :::21943                :::*                    LISTEN      4108/kube-proxy
tcp6       0      0 :::8443                 :::*                    LISTEN      4108/kube-proxy
```

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
- **10250** https API 服务
- **10255** 只读端口
- **41563**

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

## 端口总览

```bash
# --healthz-port int32
# The port of the localhost healthz endpoint (set to 0 to disable) (default 10248) (DEPRECATED: This parameter should be set via the config file specified by the Kubelet's --config flag. See https://kubernetes.io/docs/tasks/administer-cluster/kubelet-config-file/ for more information.)
tcp        0      0 127.0.0.1:10248         0.0.0.0:*               LISTEN      4575/kubelet
# --port int3
# The port for the Kubelet to serve on. (default 10250) (DEPRECATED: This parameter should be set via the config file specified by the Kubelet's --config flag. See https://kubernetes.io/docs/tasks/administer-cluster/kubelet-config-file/ for more information.)
tcp        0      0 192.168.199.100:10250   0.0.0.0:*               LISTEN      4575/kubelet
tcp        0      0 127.0.0.1:41563         0.0.0.0:*               LISTEN      4575/kubelet

# --port int
# DEPRECATED: the port on which to serve HTTP insecurely without authentication and authorization. If 0, don't serve HTTPS at all. See --secure-port instead. (default 10251)
tcp        0      0 127.0.0.1:10251         0.0.0.0:*               LISTEN      3927/kube-scheduler
# --secure-port int
# The port on which to serve HTTPS with authentication and authorization.If 0, don't serve HTTPS at all. (default 10259)
tcp6       0      0 :::10259                :::*                    LISTEN      3927/kube-scheduler

# --secure-port int
# The port on which to serve HTTPS with authentication and authorization.It cannot be switched off with 0. (default 6443)
tcp        0      0 192.168.199.100:6443    0.0.0.0:*               LISTEN      3848/kube-apiserver
# --insecure-port int
# The port on which to serve unsecured, unauthenticated access. (default 8080) (DEPRECATED: This flag will be removed in a future version.)
tcp        0      0 127.0.0.1:8080          0.0.0.0:*               LISTEN      3848/kube-apiserver

# --secure-port int
# The port on which to serve HTTPS with authentication and authorization.If 0, don't serve HTTPS at all. (default 10257)
tcp        0      0 127.0.0.1:10257         0.0.0.0:*               LISTEN      3883/kube-controlle
tcp6       0      0 :::10252                :::*                    LISTEN      3883/kube-controlle

# --metrics-bind-address 0.0.0.0
# The IP address and port for the metrics server to serve on (set to 0.0.0.0 for all IPv4 interfaces and `::` for all IPv6 interfaces) (default 127.0.0.1:10249)
tcp        0      0 192.168.199.100:10249   0.0.0.0:*               LISTEN      4108/kube-proxy
# --healthz-port int32
# The port to bind the health check server. Use 0 to disable. (default 10256)
tcp        0      0 192.168.199.100:10256   0.0.0.0:*               LISTEN      4108/kube-proxy
```

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
