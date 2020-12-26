## 必需组件部署

### 1. 部署 CNI -- calico

请提前切换 iptables，请查看 [README.switch.iptables.md](README.switch.iptables.md)

```powershell
# $ kubectl apply -k addons/cni/calico-custom

$ kubectl apply -f addons/cni/calico-eBPF/kubernetes.yaml
$ kubectl apply -k addons/cni/calico-eBPF
```

> 若不能正确匹配网卡，请修改 [addons/cni/calico/basic.patch.json](../addons/cni/calico/basic.patch.json) 文件中 `IP_AUTODETECTION_METHOD` 变量的值

### 2. 部署 CoreDNS 等其他组件

> 等待 CNI 处于 `Running` 状态，再部署其他组件。
