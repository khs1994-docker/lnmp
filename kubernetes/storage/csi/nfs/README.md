# CSI NFS

* https://github.com/kubernetes-csi/csi-driver-nfs

## 部署

### 替换 kubelet 路径(--root-dir 参数的值)

替换 `deploy/csi-nodeplugin-nfsplugin.yaml` `deploy/configMap.yaml` 中的 `/var/lib/kubelet` 为你自己的路径,之后部署

```bash
$ kubectl apply -k deploy
```

## 安装依赖(重要)

```bash
$ sudo apt install -y nfs-common

$ sudo yum install -y nfs-utils
```

## 测试

替换 `tests/pod.yaml`

```yaml
    volumeAttributes:
      server: 192.168.199.100 # nfs server
      share: /kubernetes_csi       # nfs export path
```

```bash
$ kubectl apply -f tests
```

## 参考

* https://blog.csdn.net/zhonglinzhang/article/details/90645886
