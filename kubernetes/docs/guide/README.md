# 部署 Kubernetes

请查看 [GitHub](https://github.com/khs1994-docker/lnmp-k8s) README.md 文件。

## kubectl

复制 K8s 配置文件到 `~/.kube/config`

```bash
$ cp cert/kubectl.kubeconfig ~/.kube/config
```

若还有其他集群，请将生成的文件追加到 `~/.kube/config`

## 组件状态检查

确保 `$ systemctl status 组件名` 状态为 `Active: active (running)`

### etcd

第一步启动 `etcd` 集群。

```bash
$ systemctl status etcd-member

$ journalctl -u etcd-member

$ ETCDCTL_API=3 etcdctl \
    --endpoints=https://${node_ip:-192.168.57.110}:2379 \
    --cacert=/etc/kubernetes/pki/etcd-ca.pem \
    --cert=/etc/kubernetes/pki/etcd-client.pem \
    --key=/etc/kubernetes/pki/etcd-client-key.pem endpoint health
```

- **2379** 提供 HTTP(S) API 服务，供客户端交互
- **2380** 和集群中其他节点通信

### Docker

```bash
$ systemctl status docker

$ journalctl -u docker
```

* **2375** http
* **2376** TLS

## Master

### kube-apiserver

```bash
$ systemctl status kube-apiserver

$ journalctl -u kube-apiserver

# install kubectl

$ kubectl cluster-info

$ kubectl get all -A

$ kubectl get componentstatuses

$ sudo netstat -lnpt|grep kube-apiserve

tcp        0      0 192.168.199.100:6443    0.0.0.0:*               LISTEN      25691/kube-apiserve
```

- **6443** 接收 https 请求的安全端口，对所有请求做认证和授权

### kube-controller-manager

```bash
$ systemctl status kube-controller-manager

$ journalctl -u kube-controller-manager

$ sudo netstat -lnpt|grep kube-controll

tcp        0      0 127.0.0.1:10257         0.0.0.0:*               LISTEN      638/kube-controller

$ curl -s --cacert /etc/kubernetes/pki/ca.pem https://127.0.0.1:10257/metrics |head

$ kubectl get endpoints kube-controller-manager --namespace=kube-system  -o yaml
```

- **10252** http 端口 (本项目不监听)
- **10257** https 端口

### kube-scheduler

```bash
$ systemctl status kube-scheduler

$ journalctl -u kube-scheduler

$ sudo netstat -lnpt|grep kube-sche

tcp        0      0 192.168.199.100:10251   0.0.0.0:*               LISTEN      25873/kube-schedule
tcp        0      0 192.168.199.100:10259   0.0.0.0:*               LISTEN      25873/kube-schedule

$ curl -s http://127.0.0.1:10251/metrics |head

$ kubectl get endpoints kube-scheduler --namespace=kube-system  -o yaml
```

- **10251** http 端口
- **10259** https 端口

两个接口都对外提供 `/metrics` 和 `/healthz` 的访问

## Worker

### kube-proxy

```bash
$ sudo netstat -lnpt|grep kube-proxy

tcp        0      0 192.168.199.100:10249   0.0.0.0:*               LISTEN      26034/kube-proxy
tcp        0      0 192.168.199.100:10256   0.0.0.0:*               LISTEN      26034/kube-proxy
```

- **10249** http prometheus metrics port;
- **10256** http healthz port;

### kubelet

```bash
$ systemctl status kubelet

$ journalctl -u kubelet

$ sudo netstat -lnpt|grep kubelet

tcp        0      0 192.168.199.100:10248   0.0.0.0:*               LISTEN      26484/kubelet
tcp        0      0 192.168.199.100:10250   0.0.0.0:*               LISTEN      26484/kubelet
tcp        0      0 127.0.0.1:35843         0.0.0.0:*               LISTEN      26484/kubelet
```

- **10248** healthz http 服务
- **10250** https API 服务
- **10255** 只读端口 (本项目不监听)

#### 自动生成的证书

`kubelet` 与 `apiserver` 通讯所使用的证书为 `kubelet-client.crt` 剩下的 `kubelet.crt` 将会被用于 kubelet server(10250) 做鉴权使用

## Test k8s Cluster

务必保证各组件正常运行之后，再进行测试！

部署 [CoreDNS 插件](../addons/coredns.md) 进行测试。
