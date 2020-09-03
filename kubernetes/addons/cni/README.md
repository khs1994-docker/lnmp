**calico** 适用于 kubeadm 创建的集群

**calico-custom** 适用于自定义了 CNI 插件目录等情况

* https://docs.projectcalico.org/manifests/calico.yaml

**dual-stack**

* https://docs.projectcalico.org/networking/dual-stack

**环境变量**

* https://docs.projectcalico.org/reference/felix/configuration

## eBPF

* https://docs.projectcalico.org/maintenance/enabling-bpf
* https://www.projectcalico.org/introducing-the-calico-ebpf-dataplane/

```bash
$ sudo mount bpffs /sys/fs/bpf -t bpf
```

```bash
# 修改 calico-eBPF/kubernetes.yaml 并部署
$ kubectl apply -f calico-eBPF/kubernetes.yaml
```
