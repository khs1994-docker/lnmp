kube-controller-manager 启用了 TLS 验证

## 创建 service

```bash
$ kubectl apply -k service
```

## 将证书放入 certs

* ca.pem
* cert.pem
* key.pem

## 修改 prometheus-serviceMonitorKubeControllerManager

```bash
$ kubectl apply -k .
```
