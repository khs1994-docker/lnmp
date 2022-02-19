## 创建 service

```bash
$ kubectl apply -k service
```

## 将 etcd 客户端证书放入 certs

* etcd-ca.pem
* etcd-client.pem
* etcd-client-key.pem

## 创建 prometheus-serviceMonitorEtcd

```bash
$ kubectl apply -k .
```

## Grafana

左边 `+` 点击 `Import` => `Grafana.com Dashboard` 输入 `3070` => 选择 prometheus 为 prometheus
