# WSL2(systemd)

## 初始化（仅需执行一次）

### 1. 启用 systemd

* https://github.com/khs1994-docker/lnmp/blob/19.03/wsl2/README.systemd.md

```bash
$ cd ~/lnmp/wsl2/ubuntu-wsl2-systemd-script

$ wsl -d wsl-k8s

$ apt install sudo

$ bash ubuntu-wsl2-systemd-script.sh
```

### 2. 安装

```bash
$ wsl -d wsl-k8s

$ cp -a wsl2/certs/. systemd/certs

$ WSL2_SYSTEMD=1 ./lnmp-k8s _k8s_install_conf_cp
$ WSL2_SYSTEMD=1 ./lnmp-k8s _k8s_install_systemd
```

## 日常使用

```powershell
$ ./wsl2/bin/kube-check
```

> 脚本 **需要** 管理员权限(弹出窗口,点击确定)写入 wsl2hosts 到 `C:\Windows\System32\drivers\etc\hosts`

```powershell
$ ./wsl2/bin/wsl2host --write
```

**手动签署 CSR**

由于 WSL2 IP 不能固定, 每次重启时 **必须** 签署 kubelet 证书:

```powershell
# 获取 csr
$ ./wsl2/bin/kubectl-get-csr

NAME        AGE    SIGNERNAME                                    REQUESTOR           CONDITION
csr-9pvrm   23s    kubernetes.io/kubelet-serving                 system:node:wsl2    Pending
```

根据提示 **签署** 证书,一般为最后一个

**开始使用**

```powershell
$ kubectl CMD
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

$ Invoke-WSLK8S systemctl status cri-containerd@1.4
$ Invoke-WSLK8S systemctl status kubelet@cri-containerd

# 你也可以执行其他命令供调试
# $ Invoke-WSLK8S CMD
```
