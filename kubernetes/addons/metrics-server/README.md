# Metrics Server

> 本文基于 0.4.x 版本。

* https://github.com/kubernetes-sigs/metrics-server/tree/master/manifests/base

```bash
$ kubectl apply -k addons/metrics-server
```

```bash
$ kubectl top node

$ kubectl top pod -A
```

## 错误排查

无法解析节点的主机名，是 metrics-server 这个容器不能通过 CoreDNS 解析各 Node 的主机名，metrics-server 连节点时默认是连接节点的主机名，需要加个参数，让它连接节点的IP，同时因为 10250 是https端口，连接它时需要提供证书，所以加上 --kubelet-insecure-tls，表示不验证客户端证书，此前的版本中使用 --source= 这个参数来指定不验证客户端证书。

* https://blog.csdn.net/zyl290760647/article/details/83041991
* https://www.cnblogs.com/both/p/10078316.html

## kubeadm

报如下错误：

```bash
unable to fully collect metrics: unable to fully scrape metrics from source kubelet_summary:node1: unable to fetch metrics from Kubelet node1 (192.168.199.100): Get https://192.168.199.100:10250/stats/summary?only_cpu_and_memory=true: x509: cannot validate certificate for 192.168.199.100 because it doesn't contain any IP SANs
```

修改 `addons/metrics-server/metrics-server-deployment.yaml`,增加 `- --kubelet-insecure-tls`。

```bash
$ kubectl edit -n kube-system deployment/metrics-server
```
