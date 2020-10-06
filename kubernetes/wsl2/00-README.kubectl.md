# kubectl

## 将 K8S 配置写入 Windows `~/.kube/config`

```powershell
$ ./wsl2/bin/kubectl-config-set-cluster
```

或者 **通过参数** 加载配置文件

```powershell
# $ kubectl --kubeconfig ./wsl2/certs/kubectl.kubeconfig

# 封装上边的命令
$ import-module ./wsl2/bin/WSL-K8S.psm1

$ invoke-kubectl
```

## 将 K8S 配置写入 WSL `~/.kube/config`

```bash
$ ./wsl2/bin/kubectl-config-sync
```
