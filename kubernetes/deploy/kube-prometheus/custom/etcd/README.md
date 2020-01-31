## 创建 secret

进入 certs 目录，创建 secret

```yaml
namespace: monitoring
secretGenerator:
- name: etcd-certs
  files:
  - ca.cert=ca.pem
  - healthcheck-client.cert=flanneld-etcd-client.pem
  - healthcheck-client.key=flanneld-etcd-client-key.pem
generatorOptions:
  disableNameSuffixHash: true
```

其他步骤参考 `kube-controller-manager`

## Grafana

左边 `+` 点击 `Import` => `Grafana.com Dashboard` 输入 `3070` => 选择 prometheus 为 prometheus
