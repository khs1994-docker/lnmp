# WSL2 systemd+k8s

## 首次使用必须进行初始化（仅需执行一次）

具体请查看 [00-README.systemd.init.md](00-README.systemd.init.md)

## 日常使用

**1. 挂载 `/wsl/wsl-k8s-data`**

```powershell
$ ./wsl2/bin/kube-check
```

**2. 配置 hosts**

> 脚本 **需要** 管理员权限(弹出窗口,点击确定)写入 wsl2hosts 到 `C:\Windows\System32\drivers\etc\hosts`

```powershell
$ ./wsl2/bin/wsl2host --write
```

**3. 手动签署 CSR**

由于 WSL2 IP 不能固定, 每次重启时 **必须** 签署 kubelet 证书:

```powershell
# 获取 csr
$ ./wsl2/bin/kubectl-get-csr

NAME        AGE    SIGNERNAME                                    REQUESTOR           CONDITION
csr-9pvrm   23s    kubernetes.io/kubelet-serving                 system:node:wsl2    Pending
```

根据提示 **签署** 证书,一般为最后一个

**4. 开始使用**

```powershell
$ kubectl CMD
```

## 关闭

```bash
$ wsl --shutdown
```

## 调试

正常情况下 k8s 各组件会自动启动，你可以执行如下命令进行调试。

```powershell
$ Import-Module ./wsl2/bin/WSL-K8S.psm1
$ Get-Command -m wsl-k8s

# 保证 ping 命令正常执行，按 ctrl + c 停止
$ Invoke-WSLK8S ping wsl2

$ Invoke-WSLK8S systemctl status etcd
$ Invoke-WSLK8S systemctl status kube-apiserver
$ Invoke-WSLK8S systemctl status kube-controller-manager
$ Invoke-WSLK8S systemctl status kube-scheduler

$ Invoke-WSLK8S systemctl status cri-containerd@1.5
$ Invoke-WSLK8S systemctl status kubelet@cri-containerd

# 你也可以执行其他命令供调试
# $ Invoke-WSLK8S CMD
```
