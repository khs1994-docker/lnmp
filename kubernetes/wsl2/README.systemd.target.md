# WSL2(systemd)

## 启用 systemd

* https://github.com/khs1994-docker/lnmp/blob/19.03/wsl2/README.systemd.md

## 安装

```bash
$ wsl -d wsl-k8s

$ cp -a wsl2/certs/. systemd/certs

$ IS_SYSTEMD=1 ./lnmp-k8s _k8s_install_conf_cp
$ IS_SYSTEMD=1 ./lnmp-k8s _k8s_install_systemd
```

## 日常使用

```powershell
$ ./wsl2/bin/kube-check

$ ./wsl2/bin/wsl2host --write

$ ./wsl2/etcd

$ ./wsl2/kube-wsl2windows k8s
```

**注意事项**

* 不要 enable service (开机自启动)

```powershell
$ Import-Module ./wsl2/bin/WSL-K8S.psm1
$ Get-Command -m wsl-k8s

# 保证 ping 命令正常执行，按 ctrl + c 停止
$ Invoke-WSLK8S ping wsl2

$ Invoke-WSLK8S systemctl start kube-apiserver
$ Invoke-WSLK8S systemctl start kube-controller-manager
$ Invoke-WSLK8S systemctl start kube-scheduler

$ Invoke-WSLK8S systemctl start cri-containerd@1.4
$ Invoke-WSLK8S systemctl start kubelet@cri-containerd

# 你也可以执行其他命令供调试
# $ Invoke-WSLK8S CMD
```

**手动签署 CSR**

```powershell
$ ./wsl2/bin/kubectl-get-csr
# 根据提示手动签署 CSR
```
