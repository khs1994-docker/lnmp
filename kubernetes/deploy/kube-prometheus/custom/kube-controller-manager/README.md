kube-controller-manager 启用了 TLS 验证

## 创建 secret

进入 certs 目录，创建 secret

```yaml
namespace: monitoring
secretGenerator:
- name: kube-controller-manager-certs
  files:
  - ca.cert=ca.pem
  - healthcheck-client.cert=admin.pem
  - healthcheck-client.key=admin-key.pem
generatorOptions:
  disableNameSuffixHash: true
```

## 修改 prometheus，新增 secrets

修改 `base/patch.yaml`

```diff
+  secrets:
+  - kube-controller-manager-certs
```

```bash
$ kubectl apply -k base
```

## 创建 service

```bash
$ kubectl apply -k service
```

## 修改 prometheus-serviceMonitorKubeControllerManager

```bash
$ kubectl apply -k .
```
